create or replace view location_service_vw as
select
  ls.location_service_id
, l.location_code
, l.location_name
, ls.service_name
, ls.subtype_name
, ls.taxable
, ls.require_custom_price
, ls.uc_price
, ls.non_uc_price
, ls.uc_minimum_amount
, ls.non_uc_minimum_amount
, ls.unit_measure
, ls.item_code
, ls.fau
from location_service ls
inner join location l on l.location_id = ls.location_id
;
/
