create or replace procedure delete_location_service (
  p_location_service_id in location_service.location_service_id%type
, p_user_name in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'delete_location_service';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  
  delete from location_service where location_service_id = p_location_service_id;  
  commit;
end delete_location_service;
/
