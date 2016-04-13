create or replace function patron_needs_stub (
  p_patron_id in invoice.patron_id%type
) return boolean as
  v_patron_has_stub int;
  v_patron_needs_stub boolean;
begin
  v_patron_needs_stub := FALSE;
  -- Only check for UCLA patrons, who have patron_id values < 10,000,000
  if p_patron_id < 10000000 then
    
    select count(*) into v_patron_has_stub
      from patron_stub
      where patron_id = p_patron_id;
    
    if v_patron_has_stub = 0 then
      v_patron_needs_stub := TRUE;
    end if;
  end if;
  
  return v_patron_needs_stub;
end patron_needs_stub;
/
