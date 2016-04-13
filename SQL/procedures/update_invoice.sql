create or replace procedure update_invoice (
  p_invoice_number in invoice.invoice_number%type
, p_status in invoice.status%type
, p_user_name in staff_user.user_name%type
) as
  v_from_status invoice.status%type;
  THIS_PROC_NAME constant varchar2(30) := 'update_invoice';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  select status into v_from_status
    from invoice
    where invoice_number = p_invoice_number;
    
  if user_can_change_status(p_user_name, v_from_status, p_status) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot change status from ' || v_from_status || ' to ' || p_status);
  end if;
  
  update invoice
    set status = p_status
    where invoice_number = p_invoice_number;
end update_invoice;
/
