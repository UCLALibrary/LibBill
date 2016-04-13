/***********************************************************  
* Change script to upgrade LibBill database from 1.4.1 to 1.4.2 (DEV)
* Ticket 20679: Create LibBill admin services for locations
* 2011-08-10 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.4.1';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 20679: Create LibBill admin services for locations
*
***********************************************************/

/********************
location_seq sequence
* Start with 11, since current max(location.location_id) = 10
********************/
create sequence location_seq
  minvalue 1
  maxvalue 99999999 
  increment by 1
  start with 11
  nocache
  noorder
  nocycle
;

/********************
delete_location procedure
********************/
create or replace procedure delete_location (
  p_location_id in location.location_id%type
, p_user_name in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'delete_location';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  
  delete from location
  where location_id = p_location_id;
  commit;
end delete_location;
/

/********************
insert_location procedure
********************/
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

/********************
update_location procedure
********************/
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

/********************
location_vw view
********************/
create or replace view location_vw as
select 
  location_id
, location_code
, location_name
, department_number
, phone_number
from location
;
/

-- Add new privileges and assign to roles
insert into invoice_privilege values ('delete_location');
insert into invoice_privilege values ('insert_location');
insert into invoice_privilege values ('update_location');

insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'delete_location', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'insert_location', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'update_location', null);

exec allow_access('invoice_service', 'delete_location', 'execute');
exec allow_access('invoice_service', 'insert_location', 'execute');
exec allow_access('invoice_service', 'update_location', 'execute');
exec allow_access('invoice_service', 'location_vw', 'select');
commit;

-- END of Ticket 20679: Create LibBill admin services for locations

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.4.2'
  where setting_name = 'version'
;
commit;

/***** END *****/
