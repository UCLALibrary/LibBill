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
