/***********************************************************  
* Change script to upgrade LibBill database from 1.4.3 to 1.4.4 (DEV)
* Ticket 20788: Create LibBill admin services for services
* 2011-08-12 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.4.3';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 20788: Create LibBill admin services for services
*
***********************************************************/

/********************
location_service_seq sequence
* Start with 117, since current max(location_service.location_service_id) = 116
********************/
-- New sequence for artificial key in location_service
create sequence location_service_seq
  minvalue 1
  maxvalue 99999999 
  increment by 1
  start with 117 -- for upgrade
  nocache
  noorder
  nocycle
;

/********************
delete_location_service procedure
********************/
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

/********************
insert_location_service procedure
********************/
create or replace procedure insert_location_service (
  p_location_id in location_service.location_id%type
, p_service_name in location_service.service_name%type
, p_subtype_name in location_service.subtype_name%type
, p_unit_measure in location_service.unit_measure%type
, p_item_code in location_service.item_code%type
, p_fau in location_service.fau%type
, p_taxable in location_service.taxable%type
, p_require_custom_price in location_service.require_custom_price%type
, p_user_name in staff_user.user_name%type
, p_uc_price in location_service.uc_price%type := null
, p_non_uc_price in location_service.non_uc_price%type := null
, p_uc_minimum_amount in location_service.uc_minimum_amount%type := null
, p_non_uc_minimum_amount in location_service.non_uc_minimum_amount%type := null
) as
  v_location_service_id location_service.location_service_id%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_location_service';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  select location_service_seq.nextval into v_location_service_id from dual;

  insert into location_service (
    location_service_id, location_id, service_name, subtype_name, unit_measure
  , item_code, fau, taxable, require_custom_price
  , uc_price, non_uc_price, uc_minimum_amount, non_uc_minimum_amount
  ) values (
    v_location_service_id, p_location_id, p_service_name, p_subtype_name, p_unit_measure
  , p_item_code, p_fau, p_taxable, p_require_custom_price
  , p_uc_price, p_non_uc_price, p_uc_minimum_amount, p_non_uc_minimum_amount
  );  
  commit;
end insert_location_service;
/

/********************
update_location_service procedure
********************/
create or replace procedure update_location_service (
  p_location_service_id in location_service.location_service_id%type
, p_user_name in staff_user.user_name%type
, p_location_id in location_service.location_id%type := null
, p_service_name in location_service.service_name%type := null
, p_subtype_name in location_service.subtype_name%type := null
, p_unit_measure in location_service.unit_measure%type := null
, p_item_code in location_service.item_code%type := null
, p_fau in location_service.fau%type := null
, p_taxable in location_service.taxable%type := null
, p_require_custom_price in location_service.require_custom_price%type := null
, p_uc_price in location_service.uc_price%type := null
, p_non_uc_price in location_service.non_uc_price%type := null
, p_uc_minimum_amount in location_service.uc_minimum_amount%type := null
, p_non_uc_minimum_amount in location_service.non_uc_minimum_amount%type := null
) as
  THIS_PROC_NAME constant varchar2(30) := 'update_location_service';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update location_service 
    set location_id = coalesce(p_location_id, location_id)
    ,   service_name = coalesce(p_service_name, service_name)
    ,   subtype_name = coalesce(p_subtype_name, subtype_name)
    ,   unit_measure = coalesce(p_unit_measure, unit_measure)
    ,   item_code = coalesce(p_item_code, item_code)
    ,   fau = coalesce(p_fau, fau)
    ,   taxable = coalesce(p_taxable, taxable)
    ,   require_custom_price = coalesce(p_require_custom_price, require_custom_price)
    ,   uc_price = coalesce(p_uc_price, uc_price)
    ,   non_uc_price = coalesce(p_non_uc_price, non_uc_price)
    ,   uc_minimum_amount = coalesce(p_uc_minimum_amount, uc_minimum_amount)
    ,   non_uc_minimum_amount = coalesce(p_non_uc_minimum_amount, non_uc_minimum_amount)
  where location_service_id = p_location_service_id;  
  commit;
end update_location_service;
/

-- Add new privileges and assign to roles
insert into invoice_privilege values ('delete_location_service');
insert into invoice_privilege values ('insert_location_service');
insert into invoice_privilege values ('update_location_service');
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'delete_location_service', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'insert_location_service', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'update_location_service', null);
exec allow_access('invoice_service', 'delete_location_service', 'execute');
exec allow_access('invoice_service', 'insert_location_service', 'execute');
exec allow_access('invoice_service', 'update_location_service', 'execute');
commit;


-- END of Ticket 20788: Create LibBill admin services for services

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.4.4'
  where setting_name = 'version'
;
commit;

/***** END *****/
