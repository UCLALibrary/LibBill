/*
* Invoice preparer creates invoice with one line, totaling $100.00
* Invoice approver changes invoice status to Deposit Due
* Customer makes payment of $50.00
* Payment approver changes invoice status to Deposit Paid. Amount Due now equals $50.00; Total = 100
* Invoice preparer updates line item to $90. Amount Due now equals $40; Total = 90.
* Invoice preparer adds new line item for $20. Amount Due now equals $60; Total = 110.
* Invoice approver changes invoice status to Final Payment Due. Amount Due now equals $60; Total = 110.

(I suppose it would be okay if Amount Due and Total didn’t change when Invoice preparer adds or edits line items in the Deposit Paid state, 
as long as they did so when it changed to Final Payment Due.)

------------
C:\Projects\CyberPay\SQL\procedures>grep Pending *.sql
delete_line_item.sql:  if get_invoice_status(p_invoice_number) = 'Pending' then
insert_invoice.sql:, p_status in invoice.status%type := 'Pending'
insert_line_item.sql:  if get_invoice_status(p_invoice_number) != 'Pending' then
update_invoice_amounts.sql:  -- Invoice total should only be updated for Pending invoices
update_invoice_amounts.sql:  if get_invoice_status(p_invoice_number) = 'Pending' then
update_line_item.sql:  if get_invoice_status(p_invoice_number) != 'Pending' then

C:\Projects\CyberPay\SQL\functions>grep Pending *.sql
calculate_balance_due.sql:  -- Pending invoices should not have balance due
calculate_balance_due.sql:  if get_invoice_status(p_invoice_number) = 'Pending' then
------------
*/

set serveroutput on;

declare 
  v_invoice_number invoice_vw.invoice_number%type;
begin 
  -- OK: Create invoice for UC patron, on premises
  insert_invoice (
    p_location_code => 'BS'
  , p_invoice_date => sysdate
  , p_status => 'Pending'
  , p_user_name => 'test_inv_prep'
  , p_patron_id => 6201
  , p_patron_on_premises => 'Y'
  , p_new_invoice_number => v_invoice_number
  );
  
  -- OK: Invoice preparer creates invoice with one line, totaling $100.00
  -- Add line item 1: Appraisal fee of $100, non-taxable
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 96
  , p_user_name => 'test_inv_prep'
  , p_quantity => 1
  , p_unit_price => 100
  );

  -- Add line item 2: Materials to Protect charge of $100, taxable
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 98
  , p_user_name => 'test_inv_prep'
  , p_quantity => 1
  , p_unit_price => 100
  );
  
  commit;

  dbms_output.put_line('New invoice: ' || v_invoice_number);

  -- OK: Invoice approver changes invoice status to Deposit Due
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Deposit Due'
  , p_user_name => 'test_inv_appr'
  );
  commit;

  -- OK: Customer makes payment of $50.00
  insert_payment (
    p_invoice_number => v_invoice_number
  , p_amount => 50.00
  , p_payment_type_id => 1
  , p_user_name => 'ecommerce'
  );
  commit;
  
  -- OK: Payment approver [processor] changes invoice status to Deposit Paid. Amount Due now equals $50.00; Total = 100
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Deposit Paid'
  , p_user_name => 'test_pay_proc'
  );
  commit;
  
  -- OK: Invoice preparer updates line item to $90. Amount Due now equals $40; Total = 90.
  update_line_item (
    p_invoice_number => v_invoice_number
  , p_line_number => 1
  , p_location_service_id => 96
  , p_quantity => 1
  , p_user_name => 'test_inv_prep'
  , p_unit_price => 90
  );
  commit;

  -- OK: Invoice preparer adds new line item for $20. Amount Due now equals $60; Total = 110.
  -- Add line item 2: Appraisal fee of $20, non-taxable
  insert_line_item (
    p_invoice_number => v_invoice_number
  , p_location_service_id => 96
  , p_user_name => 'test_inv_prep'
  , p_quantity => 1
  , p_unit_price => 20
  );
  commit;
  
  -- Invoice approver changes invoice status to Final Payment Due. Amount Due now equals $60; Total = 110.
  update_invoice (
    p_invoice_number => v_invoice_number
  , p_status => 'Final Payment Due'
  , p_user_name => 'test_inv_appr'
  );
  commit;

end;
/

select * from invoice_vw where invoice_number = 'BS000145';