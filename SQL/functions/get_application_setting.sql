create or replace function get_application_setting (
  p_setting_name in application_setting.setting_name%type
) return varchar2 as
  setting_value application_setting.setting_value%type;
begin
  select setting_value into setting_value
    from application_setting
    where setting_name = p_setting_name;
  
  return setting_value;
end get_application_setting;
/

