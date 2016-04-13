create or replace function user_has_privilege (
  p_user_name in staff_user.user_name%type
, p_privilege in role_privilege_status.privilege_name%type
, p_status in role_privilege_status.status%type := null
) return char as
  v_has_privilege char(1) := 'N';
begin
  select 
    case count(*) when 1 then 'Y' else 'N' end into v_has_privilege
    from user_role_privilege_status_vw
    where user_name = p_user_name
    and privilege_name = p_privilege
    and (status = p_status or status is null)
    ;
  
  return v_has_privilege;
end user_has_privilege;
/
