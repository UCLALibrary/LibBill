create or replace procedure cancel_invoice_tax (
  p_invoice_number in invoice.invoice_number%type
, p_user_name in staff_user.user_name%type
, p_adjustment_reason invoice_adjustment.adjustment_reason%type := 'Canceled sales tax'
) as
  v_amount invoice_adjustment.adjustment_amount%type;
  v_adjustment_type invoice_adjustment.adjustment_type%type := 'CANCEL TAX';
  THIS_PROC_NAME constant varchar2(30) := 'cancel_invoice_tax';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  select total_tax into v_amount
    from invoice_vw
    where invoice_number = p_invoice_number;

  -- Removing tax: adjustment amount is the negative of the taxes
  v_amount := 0 - v_amount;
  
  if v_amount != 0 then
    insert into invoice_adjustment (
      invoice_number, created_by, adjustment_amount, adjustment_type, adjustment_reason)
      values (p_invoice_number, p_user_name, v_amount, v_adjustment_type, p_adjustment_reason)
    ;
    -- Now update the invoice amounts to include info for the whole invoice
    update_invoice_amounts(p_invoice_number);
  end if;

end cancel_invoice_tax;
/

-- Internal procedure: not directly accessed by web services
