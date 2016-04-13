create or replace procedure insert_invoice_note (
  p_invoice_number in invoice_note.invoice_number%type
, p_internal in invoice_note.internal%type
, p_user_name in staff_user.user_name%type
, p_note in invoice_note.note%type
) as
  v_new_sequence_number int := 0;
  THIS_PROC_NAME constant varchar2(30) := 'insert_invoice_note';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Determine next sequence number for this invoice
  select coalesce(max(sequence_number), 0) + 1 into v_new_sequence_number
    from invoice_note
    where invoice_number = p_invoice_number;

  insert into invoice_note (invoice_number, sequence_number, internal, created_by, note)
    values (p_invoice_number, v_new_sequence_number, p_internal, p_user_name, p_note);
    
end insert_invoice_note;
/
