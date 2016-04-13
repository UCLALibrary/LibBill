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
