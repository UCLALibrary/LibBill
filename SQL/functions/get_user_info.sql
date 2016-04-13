create or replace function get_user_info (
  p_uid in staff_user.user_uid%type
) return varchar2 as
  v_info varchar2(80);
  v_delimiter char(1) := ':';
begin
  select user_name || v_delimiter || id_key || v_delimiter || crypto_key || v_delimiter || user_role into v_info
    from staff_user
    where user_uid = p_uid;
  return v_info;
end get_user_info;
/
