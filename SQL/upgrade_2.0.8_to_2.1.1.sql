/***********************************************************
* Change script to upgrade LibBill database from 2.0.8 to 2.1.1
* This pretends the 2.0.8 -> 2.1.0 (Aeon) update never existed,
* as we never did that update in production.
* Updates LibBill to function without Voyager database, now we're on Alma.
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
* SYS-592: Update various objects to support Alma's primary identifier
* (migrated from Voyager patron institution_id) instead of the 
* Voyager-only patron_id.
* Also removes all dependencies on Voyager database.
*
***********************************************************/

/*** patron_stub ***/
-- Can't change type of patron_id in place, so add new temporary column
alter table patron_stub
  add (institution_id varchar2(255))
;
-- Add institution_id from Voyager when it exists
update patron_stub
set institution_id = (
  select institution_id from ucladb.patron
  where patron_id = patron_stub.patron_id
)
;
-- About half of these have no institution_id
-- They migrated to Voyager with 'ID' + patron_id as the primary id, so use that
update patron_stub
set institution_id = 'ID' || patron_id
where institution_id is null
;
commit;

-- Add uc_community column to permanently capture what was previously derived real-time from Voyager patron groups
-- Historically this used 1 (Yes, member of UC community) and 0 (No, not a member).
alter table patron_stub
  add (uc_community int)
;
-- Populate patron_stub.uc_community from Voyager patron group
update patron_stub
set uc_community = (
  with uc as (
    select distinct
      ps.patron_id
      , case               
        when pb.patron_group_id in (1,3,4,6,7,8,9,10,12,13,14,15,16,18,19,26,30,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,54) then 1
        else 0
      end as uc_community
    from patron_stub ps
    left outer join ucladb.patron_barcode pb on ps.patron_id = pb.patron_id and pb.barcode_status = 1
  )
  select max(uc.uc_community)
  from uc
  where patron_id = patron_stub.patron_id
)
;
commit;

/*** invoice ***/
-- Can't change type of patron_id in place, so add new temporary column
alter table invoice
  add (institution_id varchar2(255))
;
-- Populate invoice.institution_id from patron_stub
update invoice
set institution_id = (
  select institution_id from patron_stub
  where patron_id = invoice.patron_id
)
;
-- 26 invoices have Voyager patron_id which no longer exists - maybe before patron_stub was created
-- Use 'voy_deleted:' + patron_id for these
update invoice
set institution_id = 'voy_deleted:' || patron_id
where institution_id is null
;
commit;

-- invoice.patron_id is not a foreign key so can be dropped
alter table invoice
drop column patron_id
;
-- Rename invoice.institution_id to invoice.patron_id
alter table invoice
rename column institution_id to patron_id
;

/*** patron_stub (cleanup after invoice table was updated) ***/
-- Remove patron_stub.patron_id
alter table patron_stub
drop column patron_id
;
-- Rename patron_stub.institution_id to patron_stub.patron_id
alter table patron_stub
rename column institution_id to patron_id
;
-- Recreate primary key on patron_stub.patron_id
alter table patron_stub
add constraint patron_stub_pk primary key (patron_id)
;

-- For the 26 invoices with unknown (deleted) patrons, add placeholders to patron_stub
-- There are 21 of these patrons
insert into patron_stub (patron_id, normal_first_name, normal_last_name)
select distinct patron_id, 'UNKNOWN', 'DELETED FROM VOYAGER'
from invoice
where patron_id like 'voy_deleted:%'
;
commit;

/*** patron_vw ***/
-- Recreate patron_vw without all the extra Voyager columns which will no longer be available
create or replace view patron_vw as
select
  patron_id
, normal_last_name
, normal_first_name
, uc_community
from patron_stub
;
/

/*** get_tax_rate_id ***/
-- Update get_tax_rate_id to require patron zip code as an input parameter, since no longer in patron_vw
create or replace function get_tax_rate_id (
  p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_invoice_date in invoice.invoice_date%type
, p_patron_zip_code in taxable_zip_code.zip_code%type
) return number as
  v_patron_zip_code taxable_zip_code.zip_code%type;
  v_tax_rate_name tax_rate.rate_name%type;
  v_tax_rate_id tax_rate.rate_id%type;
begin
  -- If patron is on premises, we use the UCLA zip code to determine tax rate
  -- Otherwise, get the patron's zip code from his Voyager patron record
  if (p_patron_on_premises = 'Y') then
    v_patron_zip_code := get_application_setting('ucla_zip_code');
  else
    v_patron_zip_code := substr(p_patron_zip_code, 1, 5);
  end if;

  -- Get the tax rate associated with the zip code
  select tax_rate_name 
    into v_tax_rate_name
    from taxable_zip_code
    where zip_code = v_patron_zip_code;
    
  -- Get the tax rate id for this rate, effective as of this invoice date
  select rate_id
    into v_tax_rate_id
    from tax_rate
    where rate_name = v_tax_rate_name
    and start_date <= p_invoice_date
    and (end_date >= p_invoice_date or end_date is null);
  
  return v_tax_rate_id;
  
-- if select ... into found no rows this "silent" exception is thrown, so return default of null (no rate) here
exception
  when no_data_found then
    return v_tax_rate_id;
  
end get_tax_rate_id;
/

/*** patron_needs_stub ***/
-- Update patron_needs_stub to remove never-used Aeon check
create or replace function patron_needs_stub (
  p_patron_id in invoice.patron_id%type
) return boolean as
  v_patron_has_stub int;
  v_patron_needs_stub boolean;
begin
  v_patron_needs_stub := FALSE;
  select count(*) into v_patron_has_stub
    from patron_stub
    where patron_id = p_patron_id;
  
  if v_patron_has_stub = 0 then
    v_patron_needs_stub := TRUE;
  end if;
  
  return v_patron_needs_stub;
end patron_needs_stub;
/

/*** insert_invoice ***/
-- Update insert_invoice to require patron zip code as input parameter
-- Also disable patron_needs_stub call and update, which probably needs to be done via web service for Alma
create or replace procedure insert_invoice (
  p_location_code in location.location_code%type
, p_invoice_date in invoice.invoice_date%type
, p_status in invoice.status%type := 'Pending'
, p_user_name in staff_user.user_name%type
, p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_patron_zip_code in taxable_zip_code.zip_code%type
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
  -- 20210922 During Voyager->Alma transition, disable this - data must come from Alma
/*
  if patron_needs_stub(p_patron_id) = TRUE then
    insert into patron_stub (patron_id, normal_last_name, normal_first_name)
      -- Could be multiple rows in patron_vw (multiple groups, addresses)
      select distinct patron_id, normal_last_name, normal_first_name
      from patron_vw
      where patron_id = p_patron_id;
  end if;
*/  
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
  , get_tax_rate_id(p_patron_id, p_patron_on_premises, p_invoice_date, p_patron_zip_code)
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
* Update version setting
***********************************************************/
update application_setting
  set setting_value = '2.1.1'
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
