create or replace procedure update_invoice_note (
  p_invoice_number in invoice_note.invoice_number%type
, p_sequence_number in invoice_note.sequence_number%type
, p_internal in invoice_note.internal%type
, p_note in invoice_note.note%type
, p_user_name in staff_user.user_name%type
) as
  rows_updated int;
  THIS_PROC_NAME constant varchar2(30) := 'update_invoice_note';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update invoice_note set
    internal = p_internal
  , note = p_note
  where invoice_number = p_invoice_number
  and sequence_number = p_sequence_number;

  rows_updated := sql%rowcount;

  if rows_updated = 0 then
    raise NO_DATA_FOUND;
  end if;

  -- TODO: commit here?
  --commit;
exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Could not find invoice / sequence number: ' || p_invoice_number || ' / ' || p_sequence_number);
end update_invoice_note;
/
