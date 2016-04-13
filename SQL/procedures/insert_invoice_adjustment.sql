create or replace procedure insert_invoice_adjustment (
  p_invoice_number in invoice_adjustment.invoice_number%type
, p_user_name in staff_user.user_name%type
, p_adjustment_type in invoice_adjustment.adjustment_type%type
, p_adjustment_reason in invoice_adjustment.adjustment_reason%type := NULL
, p_amount in invoice_adjustment.adjustment_amount%type := 0
) as
  THIS_PROC_NAME constant varchar2(30) := 'insert_invoice_adjustment';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  
  -- Some adjustments handled by separate procedures
  if p_adjustment_type = 'CANCEL TAX' then
    cancel_invoice_tax(p_invoice_number, p_user_name, p_adjustment_reason);
  elsif p_adjustment_type = 'REFUND' then
    apply_refund_adjustment(p_invoice_number, p_user_name, p_adjustment_reason);
  -- Generic handler
  elsif p_amount != 0 then
    insert into invoice_adjustment (
      invoice_number, created_by, adjustment_amount, adjustment_type, adjustment_reason)
      values (p_invoice_number, p_user_name, p_amount, p_adjustment_type, p_adjustment_reason)
    ;
    -- Now update the invoice amounts to include info for the whole invoice
    update_invoice_amounts(p_invoice_number);
  -- 
  else 
    raise_application_error(application_errors.INVALID_DATA, 
      'Invalid adjustment_type (' || p_adjustment_type || ')'
      || ' or amount (' || p_amount || ')'
    );
  end if;
  
end insert_invoice_adjustment;
/

