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
/
