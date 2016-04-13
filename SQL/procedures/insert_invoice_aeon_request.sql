create or replace procedure insert_invoice_aeon_request (
  p_aeon_request_id in invoice_aeon_request.aeon_request_id%type
, p_invoice_number in invoice.invoice_number%type
) as
 THIS_PROC_NAME constant varchar2(30) := 'insert_invoice_aeon_request';
begin
  insert into invoice_aeon_request (aeon_request_id, invoice_number)
  values (p_aeon_request_id, p_invoice_number)
  ;

end insert_invoice_aeon_request;
/

exec allow_access('invoice_service', 'insert_invoice_aeon_request', 'execute');


/*
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
*/
