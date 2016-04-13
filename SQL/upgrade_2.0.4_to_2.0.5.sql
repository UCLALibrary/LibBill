/***********************************************************  
* Change script to upgrade LibBill database from 2.0.4 to 2.0.5
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.4';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* WS-425: Add uc_minimum_amount and non_uc_minimum_amount columns to invoice_line_vw.
*
***********************************************************/
create or replace view invoice_line_vw as
select
  li.invoice_number
, li.location_service_id
, li.line_number
, li.quantity
, li.unit_price
, li.total_price
, li.created_by
, li.created_date
, ls.taxable
, ls.location_name
, ls.service_name
, ls.subtype_name
, ls.unit_measure
, ls.require_custom_price
, ls.uc_minimum_amount
, ls.non_uc_minimum_amount
from line_item li 
inner join location_service_vw ls on li.location_service_id = ls.location_service_id 
;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.5'
  where setting_name = 'version'
;
commit;

/***********************************************************  
* Recompile schema and report on errors & invalid objects
***********************************************************/
begin 
  dbms_utility.compile_schema(
    schema        => user,
    compile_all   => TRUE,
    reuse_settings => TRUE
  );
end;
/

select * from user_errors;
select * from user_objects where status != 'VALID';

/***** END *****/
