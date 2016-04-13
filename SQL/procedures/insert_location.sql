create or replace procedure insert_location (
  p_location_code in location.location_code%type
, p_location_name in location.location_name%type
, p_department_number in location.department_number%type
, p_phone_number in location.phone_number%type
, p_user_name in staff_user.user_name%type
) as
  v_location_id location.location_id%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_location';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  select location_seq.nextval into v_location_id from dual;
  
  insert into location (location_id, location_code, location_name, department_number, phone_number)
    values (v_location_id, p_location_code, p_location_name, p_department_number, p_phone_number);
  commit;
end insert_location;
/
