create or replace procedure insert_staff_user (
  p_user_name in staff_user.user_name%type
, p_user_uid in staff_user.user_uid%type
, p_user_acting in staff_user.user_name%type
, p_first_name in staff_user.first_name%type
, p_last_name in staff_user.last_name%type
, p_user_role in staff_user.user_role%type := null
) as
  v_id_key staff_user.id_key%type;
  v_crypto_key staff_user.crypto_key%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_staff_user';
begin
  if user_has_privilege(p_user_acting, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_acting || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  v_id_key := dbms_crypto.randombytes(5);
  v_crypto_key := dbms_crypto.randombytes(10);

  insert into staff_user (user_name, first_name, last_name, user_uid, id_key, crypto_key)
    values (p_user_name, p_first_name, p_last_name, p_user_uid, v_id_key, v_crypto_key);

  if p_user_role is not null then
    assign_role_to_user(p_user_name, p_user_role, p_user_acting);
  end if;
end insert_staff_user;
/
