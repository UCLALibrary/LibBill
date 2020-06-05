/***********************************************************
* Change script to upgrade LibBill database from 2.0.8 to 2.1.0
* Adds objects for AEON integration
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.8';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************
*
* WS-334: Add various objects for patron integration
*
***********************************************************/
create sequence patron_aeon_seq
  minvalue 10000001
  maxvalue 19999999
  increment by 1
  start with 10000001
  nocache
  noorder
  nocycle
;
/

create table patron_aeon (
  patron_id int not null
, username varchar2(50) not null
, last_name varchar2(50)
, first_name varchar2(50)
, aeon_id  varchar2(50)
, email varchar2(100)
, phone_number varchar2(50)
, perm_address1 varchar2(50)
, perm_address2 varchar2(50)
, perm_city varchar2(50)
, perm_state varchar2(50)
, perm_zip varchar2(50)
, perm_country varchar2(50)
, billing_category varchar2(50)
, temp_address1 varchar2(50)
, temp_address2 varchar2(50)
, temp_city varchar2(50)
, temp_state varchar2(50)
, temp_zip varchar2(50)
, temp_country varchar2(50)
, constraint patron_aeon_pk primary key (username)
)
;
/

create or replace procedure insert_patron_aeon (
  p_username in patron_aeon.username%type
, p_last_name in patron_aeon.last_name%type := null
, p_first_name in patron_aeon.first_name%type := null
, p_aeon_id in patron_aeon.aeon_id%type := null
, p_email in patron_aeon.email%type := null
, p_phone_number in patron_aeon.phone_number%type := null
, p_perm_address1 in patron_aeon.perm_address1%type := null
, p_perm_address2 in patron_aeon.perm_address2%type := null
, p_perm_city in patron_aeon.perm_city%type := null
, p_perm_state in patron_aeon.perm_state%type := null
, p_perm_zip in patron_aeon.perm_zip%type := null
, p_perm_country in patron_aeon.perm_country%type := null
, p_billing_category in patron_aeon.billing_category%type := null
, p_temp_address1 in patron_aeon.temp_address1%type := null
, p_temp_address2 in patron_aeon.temp_address2%type := null
, p_temp_city in patron_aeon.temp_city%type := null
, p_temp_state in patron_aeon.temp_state%type := null
, p_temp_zip in patron_aeon.temp_zip%type := null
, p_temp_country in patron_aeon.temp_country%type := null
, p_patron_id out patron_aeon.patron_id%type
) as
 v_patron_id patron_aeon.patron_id%type;
 THIS_PROC_NAME constant varchar2(30) := 'insert_patron_aeon';
begin
  select patron_aeon_seq.nextval into v_patron_id from dual;

  insert into patron_aeon (patron_id, username, last_name, first_name, aeon_id, email, phone_number, perm_address1, perm_address2
    , perm_city, perm_state, perm_zip, perm_country, billing_category, temp_address1, temp_address2
    , temp_city, temp_state, temp_zip, temp_country)
  values (v_patron_id, p_username, p_last_name, p_first_name, p_aeon_id, p_email, p_phone_number, p_perm_address1, p_perm_address2
    , p_perm_city, p_perm_state, p_perm_zip, p_perm_country, p_billing_category, p_temp_address1, p_temp_address2
    , p_temp_city, p_temp_state, p_temp_zip, p_temp_country)
  ;

   -- For output to caller, if all went well
  p_patron_id := v_patron_id;

end insert_patron_aeon;
/

exec allow_access('invoice_service', 'insert_patron_aeon', 'execute');

-- Include stub info in patron view
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
*
* WS-335: Fix patron stub handling
*
***********************************************************/
create or replace function patron_needs_stub (
  p_patron_id in invoice.patron_id%type
) return boolean as
  v_patron_has_stub int;
  v_patron_needs_stub boolean;
begin
  v_patron_needs_stub := FALSE;
  -- Only check for UCLA patrons, who have patron_id values < 10,000,000
  if p_patron_id < 10000000 then

    select count(*) into v_patron_has_stub
      from patron_stub
      where patron_id = p_patron_id;

    if v_patron_has_stub = 0 then
      v_patron_needs_stub := TRUE;
    end if;
  end if;

  return v_patron_needs_stub;
end patron_needs_stub;
/

create or replace procedure insert_invoice (
  p_location_code in location.location_code%type
, p_invoice_date in invoice.invoice_date%type
, p_status in invoice.status%type := 'Pending'
, p_user_name in staff_user.user_name%type
, p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_new_invoice_number out invoice.invoice_number%type
) as
  -- To work around JDBC-related problem storing CHAR(10) in passed-in output parameter
  v_new_invoice_number invoice.invoice_number%type;
  v_location_id invoice.location_id%type;
  v_patron_exists int;
  THIS_PROC_NAME constant varchar2(30) := 'insert_invoice';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Could throw NO_DATA_FOUND, caught below
  select location_id into v_location_id
    from location
    where location_code = p_location_code;

  -- Capture minimal patron data, if we don't already have it, in case patron is later deleted from ucladb
  if patron_needs_stub(p_patron_id) = TRUE then
    insert into patron_stub (patron_id, normal_last_name, normal_first_name)
      -- Could be multiple rows in patron_vw (multiple groups, addresses)
      select distinct patron_id, normal_last_name, normal_first_name
      from patron_vw
      where patron_id = p_patron_id;
  end if;

  -- Get next invoice number and add the invoice
  v_new_invoice_number := get_next_invoice_number(p_location_code);
  insert into invoice (
    invoice_number
  , invoice_date
  , status
  , created_by
  , patron_id
  , patron_on_premises
  , location_id
  , tax_rate_id
  ) values (
    v_new_invoice_number
  , p_invoice_date
  , p_status
  , p_user_name
  , p_patron_id
  , p_patron_on_premises
  , v_location_id
  , get_tax_rate_id(p_patron_id, p_patron_on_premises, p_invoice_date)
  );

  -- For output to caller, if all went well
  p_new_invoice_number := v_new_invoice_number;

exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA,
      'Invalid location code: ' || p_location_code);
end insert_invoice;
/

/***********************************************************
*
* WS-340: Integrate AEON requests into LibBill
*
***********************************************************/
create table invoice_aeon_request (
  aeon_request_id int not null
, invoice_number char(8) not null
, constraint invoice_aeon_request_pk primary key (aeon_request_id)
, constraint invoice_aeon_request_inv_fk foreign key (invoice_number)
    references invoice(invoice_number)
)
;
/

create or replace procedure insert_invoice_aeon_request (
  p_aeon_request_id in invoice_aeon_request.aeon_request_id%type
, p_invoice_number in invoice.invoice_number%type
) as
 THIS_PROC_NAME constant varchar2(30) := 'insert_invoice_aeon_request';
begin
  insert into invoice_aeon_request (aeon_request_id, invoice_number)
  values (p_aeon_request_id, p_invoice_number)
  ;

end insert_invoice_aeon_request;
/

exec allow_access('invoice_service', 'insert_invoice_aeon_request', 'execute');

create or replace view invoice_aeon_request_vw as
select
  aeon_request_id
, invoice_number
from invoice_aeon_request
;
/

exec allow_access('invoice_service', 'invoice_aeon_request_vw', 'select');

/***********************************************************
* Update version setting
***********************************************************/
update application_setting
  set setting_value = '2.1.0'
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
