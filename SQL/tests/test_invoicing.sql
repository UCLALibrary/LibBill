/*  Tests various invoicing functions.
    Run as invoice_service to make sure this user has necessary rights to views and procedures.
*/

-- For dbms_output
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
  
  -- Add line item 1: 3 special collections photocopies (id 88) (taxable): total should be 3.00
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 88
  , p_user_name => 'test_inv_prep'
  , p_quantity => 3
  );
  
  -- Add line item 2: 1 special collections research fee (id 89) (nontaxable): total should be 53.00
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 89
  , p_user_name => 'test_inv_prep'
  , p_quantity => 1
  );

  commit;

  dbms_output.put_line('New invoice: ' || v_invoice_number);

  -- Get data for new invoice for testing
  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;

  -- Before adjustments:
  -- Invoice total should be 56.00 + 0.25 (state tax on 3.00) + 0.05 (county tax on 3.00) = 56.30
  assertEquals(56.30, invoice_record.total_amount, 'Invoice total');
  assertEquals(53.00, invoice_record.nontaxable_total, 'Nontaxable total');
  assertEquals(3.00, invoice_record.taxable_total, 'Taxable total');
  assertEquals(0.05, invoice_record.la_county_tax, 'County tax');
  assertEquals(0.25, invoice_record.california_tax, 'State tax');

  -- Change invoice status to Unpaid
  -- 20110510: Changing status to Unpaid causes assertion errors after adjustments (fp:19234)
  --    ERROR: Invoice total after line item adjustments expected 50.2, actual 56.3
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Unpaid'
  , p_user_name => 'test_inv_appr'
  );
  commit;
  
  -- Make adjustments to line items
  insert_line_item_adjustment (
    p_invoice_number => v_invoice_number
  , p_line_number => 1
  , p_user_name => 'test_inv_appr'
  , p_amount => -1.00
  , p_adjustment_type => 'CORRECTION'
  , p_adjustment_reason => 'Billed for 3 copies, should be 2'
  );

  insert_line_item_adjustment (
    p_invoice_number => v_invoice_number
  , p_line_number => 2
  , p_user_name => 'test_inv_appr'
  , p_amount => -5.00
  , p_adjustment_type => 'DISCOUNT'
  , p_adjustment_reason => 'Reduced research fee'
  );

  commit;

  -- After adjustments:
  -- Taxable: 2.00 + state tax = 0.17; la tax = 0.03; total = 2.20
  -- Nontaxable: 53 - 5 = 48

  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;

  assertEquals(50.20, invoice_record.total_amount, 'Invoice total after line item adjustments');
  assertEquals(48.00, invoice_record.nontaxable_total, 'Nontaxable total after line item adjustments');
  assertEquals(2.00, invoice_record.taxable_total, 'Taxable total after line item adjustments');
  assertEquals(0.03, invoice_record.la_county_tax, 'County tax after line item adjustments');
  assertEquals(0.17, invoice_record.california_tax, 'State tax after line item adjustments');

/*
  -- Cancel the invoice tax
  -- Reduces the nontaxable amount by the total tax: 48.00 - 0.20 - 47.80
  cancel_invoice_tax(v_invoice_number, 'akohler');

  select * into invoice_record from invoice_vw where invoice_number = v_invoice_number;

  assertEquals(50.00, invoice_record.total_amount, 'Invoice total after canceling tax');
  assertEquals(47.80, invoice_record.nontaxable_total, 'Nontaxable total after canceling tax');
  assertEquals(2.00, invoice_record.taxable_total, 'Taxable total after canceling tax');
  assertEquals(0.03, invoice_record.la_county_tax, 'County tax after canceling tax');
  assertEquals(0.17, invoice_record.california_tax, 'State tax after canceling tax');
*/
end;
/
