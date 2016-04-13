set serveroutput on;

declare 
  v_actual_amount invoice_vw.total_amount%type;
  v_expected_amount invoice_vw.total_amount%type;
  v_invoice_number invoice_vw.invoice_number%type;
  invoice_record invoice_vw%rowtype;
  -- nested procedure to provide xUnit-like assertEquals
  procedure assertEquals (
      p_expected in number
    , p_actual in number
    , p_message in varchar2
    ) as
  begin
    if p_expected != p_actual then
      dbms_output.put_line('ERROR: ' || p_message || ' expected ' || p_expected || ', actual ' || p_actual);
    --else
      --dbms_output.put_line(p_message || ' passed');
    end if;
  end assertEquals;
  
begin 
  -- Create invoice for UC patron, on premises
  insert_invoice (
    p_location_code => 'BS'
  , p_invoice_date => sysdate
  , p_status => 'Pending'
  , p_user_name => 'test_inv_prep'
  , p_patron_id => 6201
  , p_patron_on_premises => 'Y'
  , p_new_invoice_number => v_invoice_number
  );
  
  -- Add line item 1: 30 special collections photocopies (id 108) (taxable): total should be 30.00
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 108
  , p_user_name => 'test_inv_prep'
  , p_quantity => 30
  );
  
  commit;

  dbms_output.put_line('New invoice: ' || v_invoice_number);

  -- Get data for new invoice for testing
  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;

  -- Before adjustments:
  -- Invoice total should be 30.00 + 2.48 (state tax on 30.00) + 0.45 (county tax on 30.00) = 32.93
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  -- Pending invoices have $0 balance due, until status changes
  assertEquals(0.00, invoice_record.balance_due, 'Balance due');

  -- Change invoice status to Unpaid
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Unpaid'
  , p_user_name => 'test_inv_appr'
  );
  commit;

  -- Check data again now that invoice status is Unpaid
  -- No changes from above except Balance due should now be calculated
  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(32.93, invoice_record.balance_due, 'Balance due');

  -- Apply a payment of $30 (line items, but not tax)
  insert_payment (
    p_invoice_number => v_invoice_number
  , p_amount => 30.00
  , p_payment_type_id => 1
  , p_user_name => 'test_pay_proc'
  );
  commit;

  -- Change invoice status to Partially Paid
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Partially Paid'
  , p_user_name => 'test_pay_proc'
  );
  commit;
  
  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  dbms_output.put_line('After first payment');
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(2.93, invoice_record.balance_due, 'Balance due');

  -- Apply a second payment of $1 (error, in Clark's scenario; will be refunded later)
  insert_payment (
    p_invoice_number => v_invoice_number
  , p_amount => 1.00
  , p_payment_type_id => 1
  , p_user_name => 'test_pay_proc'
  );
  commit;
  
  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  dbms_output.put_line('After second payment');
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(1.93, invoice_record.balance_due, 'Balance due');

  -- Apply a third payment, which we'll reverse immediately
  insert_payment (
    p_invoice_number => v_invoice_number
  , p_amount => 5.00
  , p_payment_type_id => 1
  , p_user_name => 'test_pay_proc'
  );
  commit;
  
  -- Reverse the third payment
  insert_invoice_adjustment (
    p_invoice_number => v_invoice_number
  , p_user_name => 'test_pay_proc'
  , p_adjustment_type => 'NULLIFY PAYMENT'
  , p_adjustment_reason => 'Reversal of accidental $5 payment'
  , p_amount => 5.00
  );
  commit;

  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  dbms_output.put_line('After third payment');
  -- Amounts should be same as after second payment, since we reversed the third
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(1.93, invoice_record.balance_due, 'Balance due');
  
  -- Cancel taxes
  insert_invoice_adjustment (
    p_invoice_number => v_invoice_number
  , p_user_name => 'test_pay_appr'
  , p_adjustment_type => 'CANCEL TAX'
  );
  commit;

  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  dbms_output.put_line('After cancel tax');
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(-1.00, invoice_record.balance_due, 'Balance due');

  -- Apply refund for the extra dollar
  insert_invoice_adjustment (
    p_invoice_number => v_invoice_number
  , p_user_name => 'test_pay_appr'
  , p_adjustment_type => 'REFUND'
  );
  commit;

  -- Change invoice status to Paid
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Paid'
  , p_user_name => 'test_pay_proc'
  );
  commit;

  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;
  dbms_output.put_line('After refund');
  assertEquals(32.93, invoice_record.total_amount, 'Invoice total');
  assertEquals(0.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(30.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.45, invoice_record.la_county_tax, 'County tax');
  assertEquals(2.48, invoice_record.california_tax, 'State tax');
  assertEquals(0.00, invoice_record.balance_due, 'Balance due');

end;
/
