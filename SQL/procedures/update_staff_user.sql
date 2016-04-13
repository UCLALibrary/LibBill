create or replace procedure update_staff_user (
  p_user_name in staff_user.user_name%type
, p_user_acting in staff_user.user_name%type
, p_first_name in staff_user.first_name%type := null
, p_last_name in staff_user.last_name%type := null
, p_user_uid in staff_user.user_uid%type := null
) as
  v_id_key staff_user.id_key%type;
  v_crypto_key staff_user.crypto_key%type;
  THIS_PROC_NAME constant varchar2(30) := 'update_staff_user';
begin
  if user_has_privilege(p_user_acting, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_acting || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update staff_user
    set first_name = coalesce(p_first_name, first_name)
    ,   last_name = coalesce(p_last_name, last_name)
    ,   user_uid = coalesce(p_user_uid, user_uid)
    where user_name = p_user_name;    
end update_staff_user;
/
