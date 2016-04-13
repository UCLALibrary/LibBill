create or replace procedure assign_role_to_user (
  p_user_name in staff_user.user_name%type
, p_user_role in staff_user.user_role%type
, p_user_acting in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'assign_role_to_user';
begin
  if user_has_privilege(p_user_acting, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_acting || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update staff_user
    set user_role = p_user_role
    where user_name = p_user_name;    
end assign_role_to_user;
/
