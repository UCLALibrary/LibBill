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
