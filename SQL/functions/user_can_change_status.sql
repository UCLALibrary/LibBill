create or replace function user_can_change_status (
  p_user_name in staff_user.user_name%type
, p_from_status in invoice_status_change.from_status%type
, p_to_status in invoice_status_change.to_status%type
) return char as
  v_user_role staff_user.user_role%type;
  v_has_privilege char(1) := 'N';
begin
  select user_role into v_user_role
    from staff_user
    where user_name = p_user_name;
    
  select 
    case count(*) when 1 then 'Y' else 'N' end into v_has_privilege
    from invoice_status_change
    where role_name = v_user_role
    and from_status = p_from_status
    and to_status = p_to_status;
  
  return v_has_privilege;
end user_can_change_status;
/
