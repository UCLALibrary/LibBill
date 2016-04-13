create or replace view invoice_adjustment_vw as
select 
  invoice_number
, created_by
, created_date
, adjustment_amount
, adjustment_type
, adjustment_reason
from invoice_adjustment
;
/
