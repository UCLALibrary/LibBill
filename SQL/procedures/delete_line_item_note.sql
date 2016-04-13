create or replace procedure delete_line_item_note (
  p_invoice_number in line_item_note.invoice_number%type
, p_line_number in line_item_note.line_number%type  
, p_sequence_number in line_item_note.sequence_number%type
, p_user_name in staff_user.user_name%type
) as
  rows_deleted int := 0;
  THIS_PROC_NAME constant varchar2(30) := 'delete_line_item_note';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  delete from line_item_note
    where invoice_number = p_invoice_number
    and line_number = p_line_number
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
      'Could not find invoice / line / sequence number: ' || p_invoice_number || ' / ' || p_line_number || ' / ' || p_sequence_number);
    
end delete_line_item_note;
/
