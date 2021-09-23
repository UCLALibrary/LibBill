create or replace function patron_needs_stub (
  p_patron_id in invoice.patron_id%type
) return boolean as
  v_patron_has_stub int;
  v_patron_needs_stub boolean;
begin
  v_patron_needs_stub := FALSE;
  select count(*) into v_patron_has_stub
    from patron_stub
    where patron_id = p_patron_id;
  
  if v_patron_has_stub = 0 then
    v_patron_needs_stub := TRUE;
  end if;
  
  return v_patron_needs_stub;
end patron_needs_stub;
/
