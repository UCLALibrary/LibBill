create or replace procedure delete_invoice_note (
  p_invoice_number in invoice_note.invoice_number%type
, p_sequence_number in invoice_note.sequence_number%type
, p_user_name in staff_user.user_name%type
) as
  rows_deleted int := 0;
  THIS_PROC_NAME constant varchar2(30) := 'delete_invoice_note';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  delete from invoice_note
    where invoice_number = p_invoice_number
    and sequence_number = p_sequence_number;
  
  rows_deleted := sql%rowcount;
  if rows_deleted = 0 then
    raise NO_DATA_FOUND;
  end if;

  -- TODO: commit here?
  --commit;
exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Could not find invoice / sequence number: ' || p_invoice_number || ' / ' || p_sequence_number);
    
end delete_invoice_note;
/
