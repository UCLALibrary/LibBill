create or replace view invoice_line_adjustment_vw as
select
  ia.invoice_number
, ia.line_number
, ia.adjustment_amount
, ia.adjustment_type
, ia.adjustment_reason
, ia.created_by
, ia.created_date
, il.taxable
from invoice_line_vw il
inner join line_item_adjustment ia
  on il.invoice_number = ia.invoice_number
  and il.line_number = ia.line_number
;
