create or replace procedure insert_line_item_adjustment (
  p_invoice_number in line_item_adjustment.invoice_number%type
, p_line_number in line_item_adjustment.line_number%type
, p_user_name in staff_user.user_name%type
, p_amount in line_item_adjustment.adjustment_amount%type
, p_adjustment_type in line_item_adjustment.adjustment_type%type
, p_adjustment_reason in line_item_adjustment.adjustment_reason%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'insert_line_item_adjustment';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  insert into line_item_adjustment (
    invoice_number, line_number, created_by, adjustment_amount, adjustment_type, adjustment_reason)
    values (p_invoice_number, p_line_number, p_user_name, p_amount, p_adjustment_type, p_adjustment_reason)
  ;
  
  -- Now update the invoice amounts to include info for the whole invoice
  update_invoice_amounts(p_invoice_number);
end insert_line_item_adjustment;
/
