/***********************************************************  
* Change script to upgrade LibBill database from 2.1.1 to 2.1.2
* Updates patron_vw to include Aeon data, which was missed in the 2.0.7-2.1.0 upgrade.
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.1.1';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* WS-334(?): Include Aeon data in patron_vw
*
***********************************************************/
create or replace view patron_vw as
-- Combination of LibBill patrons (patron_stub) and ucladb patrons
with patrons as (
  select patron_id, normal_last_name, normal_first_name from patron_stub p
  where not exists (
    select * from ucladb.patron where patron_id = p.patron_id
  )
  union
  select patron_id, normal_last_name, normal_first_name from ucladb.patron
)
select distinct -- work around bad Voyager data
  p.patron_id
, pb.patron_barcode
-- Need to handle Aeon username - map to patron_barcode, or add new column?
, p.normal_last_name
, p.normal_first_name
-- Not in patron_stub so must explicitly fetch from ucladb.patron
, (select institution_id from ucladb.patron where patron_id = p.patron_id) as institution_id
, coalesce(pa_p.address_line1, 'Voyager patron record deleted') as perm_address1
, pa_p.address_line2 as perm_address2
, pa_p.address_line3 as perm_address3
, pa_p.address_line4 as perm_address4
, pa_p.address_line5 as perm_address5
, pa_p.city as perm_city
, pa_p.state_province as perm_state
, pa_p.zip_postal as perm_zip
, pa_p.country as perm_country
, pa_t.address_line1 as temp_address1
, pa_t.address_line2 as temp_address2
, pa_t.address_line3 as temp_address3
, pa_t.address_line4 as temp_address4
, pa_t.address_line5 as temp_address5
, pa_t.city as temp_city
, pa_t.state_province as temp_state
, pa_t.zip_postal as temp_zip
, pa_t.country as temp_country
, pa_t.effect_date as temp_effect_date
, pa_t.expire_date as temp_expire_date
, pa_e.address_line1 as email
, pp.phone_number
, pg.patron_group_display
, case               
    when pb.patron_group_id in (1,3,4,6,7,8,9,10,12,13,14,15,16,18,19,26,30,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,54) then 1
    else 0
  end as uc_community
from 
    patrons p
    -- Remaining data comes from UCLADB
    left outer join ucladb.patron_barcode pb on p.patron_id = pb.patron_id and pb.barcode_status = 1      
    left outer join ucladb.patron_group pg on pb.patron_group_id = pg.patron_group_id
    left outer join ucladb.patron_address pa_p on p.patron_id = pa_p.patron_id and pa_p.address_type = 1 --Permanent
    left outer join ucladb.patron_address pa_t on p.patron_id = pa_t.patron_id and pa_t.address_type = 2 --Temporary
    left outer join ucladb.patron_address pa_e on p.patron_id = pa_e.patron_id and pa_e.address_type = 3 --EMail
    left outer join ucladb.patron_phone pp on pa_p.address_id = pp.address_id and pp.phone_type = 1 --Primary
-- Now... take all the above, and add Aeon patron data
union all
select
  patron_id
, username as patron_barcode
, upper(last_name) as normal_last_name
, upper(first_name) as normal_first_name
, aeon_id as institution_id
, perm_address1
, perm_address2
, null as perm_address3
, null as perm_address4
, null as perm_address5
, perm_city
, perm_state
, perm_zip
, perm_country
, null as temp_address1
, null as temp_address2
, null as temp_address3
, null as temp_address4
, null as temp_address5
, null as temp_city
, null as temp_state
, null as temp_zip
, null as temp_country
, null as temp_effect_date
, null as temp_expire_date
, email
, phone_number
, 'Aeon patron' as patron_group_display
, case
    when billing_category = 'UCAffiliate' then 1
    else 0
  end as uc_community
from patron_aeon
;
/

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.1.2'
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
