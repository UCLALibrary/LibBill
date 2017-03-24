/***********************************************************  
* Change script to upgrade LibBill database from 2.1.0 to 2.1.1
* Modifies tax rate calculation to limit to California addresses.
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.1.0';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* WS-919: Modify tax rate calculation to limit to California addresses.
*
***********************************************************/
create or replace function get_tax_rate_id (
  p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_invoice_date in invoice.invoice_date%type
) return number as
  v_patron_zip_code patron_vw.perm_zip%type;
  v_tax_rate_name tax_rate.rate_name%type;
  v_tax_rate_id tax_rate.rate_id%type;
begin
  -- If patron is on premises, we use the UCLA zip code to determine tax rate
  -- Otherwise, get the patron's zip code from his Voyager patron record
  if (p_patron_on_premises = 'Y') then
    v_patron_zip_code := get_application_setting('ucla_zip_code');
  else
    -- TODO: just checking perm zip for now, probably need to check temp_zip first
    -- Naive: grab the first 5 characters of zip code, no checking for validity yet
    --  This regexp seems correct for US zips: '^[0-9]{5}[-]{0,1}([0-9]{4}){0,1}$'
    -- Max() in case of multiple rows (bad data...)
    select max(substr(perm_zip, 1, 5))
      into v_patron_zip_code
      from patron_vw
      where patron_id = p_patron_id
      and perm_state in ('CA', 'CAMPUS');
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
