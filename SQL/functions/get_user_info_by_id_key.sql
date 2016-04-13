create or replace function get_user_info_by_id_key (
  p_id_key in staff_user.id_key%type
) return varchar2 as
  v_info varchar2(80);
  v_delimiter char(1) := ':';
  v_uid staff_user.user_uid%type;
begin
  select user_uid into v_uid
    from staff_user
    where id_key = p_id_key;
  
  return get_user_info(v_uid);
end get_user_info_by_id_key;
/
