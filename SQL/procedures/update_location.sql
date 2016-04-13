create or replace procedure update_location (
  p_location_id in location.location_id%type
, p_user_name in staff_user.user_name%type
  -- Not sure location_code should be mutable... but if not, why not make it primary key?
--, p_location_code in location.location_code%type
, p_location_name in location.location_name%type := null
, p_department_number in location.department_number%type := null
, p_phone_number in location.phone_number%type := null
) as
  THIS_PROC_NAME constant varchar2(30) := 'update_location';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  
  update location 
    set location_name = coalesce(p_location_name, location_name)
    ,   department_number = coalesce(p_department_number, department_number)
    ,   phone_number = coalesce(p_phone_number, phone_number)
  where location_id = p_location_id;
  commit;
end update_location;
/
