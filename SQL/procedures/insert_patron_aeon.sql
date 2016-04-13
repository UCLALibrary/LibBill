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

/*
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
*/
