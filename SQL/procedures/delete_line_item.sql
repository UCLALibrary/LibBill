create or replace procedure delete_line_item (
  p_invoice_number in line_item.invoice_number%type
, p_line_number in line_item.line_number%type
, p_user_name in staff_user.user_name%type
) as
  rows_deleted int := 0;
  THIS_PROC_NAME constant varchar2(30) := 'delete_line_item';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  if get_invoice_status(p_invoice_number) = 'Pending' then
    -- TODO: handle adjustments and other children of line_item
    delete from line_item
      where invoice_number = p_invoice_number
      and line_number = p_line_number;
    rows_deleted := sql%rowcount;
    if rows_deleted = 0 then
      raise NO_DATA_FOUND;
    end if;
  else
    raise_application_error(application_errors.INVALID_INVOICE_STATUS, 'Invalid invoice status');
  end if;

  -- TODO: commit here?
  --commit;
  -- Now update the invoice amounts to include info for the whole invoice
  update_invoice_amounts(p_invoice_number);

exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Could not find invoice / line number: ' || p_invoice_number || ' / ' || p_line_number);
end delete_line_item;
/
