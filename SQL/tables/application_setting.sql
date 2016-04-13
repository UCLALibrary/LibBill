create table application_setting (
  setting_name varchar2(20) not null
, setting_value varchar2(20) not null
, constraint application_setting_pk primary key (setting_name)
)
;
