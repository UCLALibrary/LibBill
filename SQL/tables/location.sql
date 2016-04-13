create table location (
  location_id int not null
, location_code char(2) not null
, location_name varchar2(40) not null
, department_number char(4) not null
, phone_number varchar2(20) not null
, constraint location_pk primary key (location_id)
, constraint location_code_uk unique (location_code)
);

