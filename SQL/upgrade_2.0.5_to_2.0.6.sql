/***********************************************************  
* Change script to upgrade LibBill database from 2.0.5 to 2.0.6
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.5';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* WS-619: Add location_service_id to invoice_line_full_vw to support linking to location_service_vw
*
***********************************************************/
create or replace view invoice_line_full_vw as
select
  invoice_number
, line_number
, location_service_id
, service_name
, subtype_name
, quantity
, unit_price
, unit_measure
, total_price
, null as adjustment_type
, null as adjustment_reason
, null as note
, 1 as line_type
from invoice_line_vw
union all
select
  ila.invoice_number
, ila.line_number
, il.location_service_id
, il.service_name
, il.subtype_name
, null as quantity
, null as unit_price
, null as unit_measure
, adjustment_amount as total_price
, adjustment_type
, adjustment_reason
, null as note
, 2 as line_type
from invoice_line_adjustment_vw ila
inner join invoice_line_vw il 
  on ila.invoice_number = il.invoice_number 
  and ila.line_number = il.line_number
union all
select
  lin.invoice_number
, lin.line_number
, il.location_service_id
, il.service_name
, il.subtype_name
, null as quantity
, null as unit_price
, null as unit_measure
, null as total_price
, null as adjustment_type
, null as adjustment_reason
, lin.note
, 3 as line_type
from line_item_note_vw lin
inner join invoice_line_vw il 
  on lin.invoice_number = il.invoice_number 
  and lin.line_number = il.line_number
where lin.internal = 'N'
;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.6'
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
