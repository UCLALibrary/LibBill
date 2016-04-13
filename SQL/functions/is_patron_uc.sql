create or replace function is_patron_uc (
  p_patron_id in invoice.patron_id%type
) return patron_vw.uc_community%type as
  -- 1 (true) or 0 (false)
  v_uc_community patron_vw.uc_community%type;
begin
  -- Some patrons have multiple groups; return 1 (true) if any are true, else 0 (false)
  select max(uc_community) into v_uc_community
    from patron_vw
    where patron_id = p_patron_id;
  
  return v_uc_community;
end is_patron_uc;
/
