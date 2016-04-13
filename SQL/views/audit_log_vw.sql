create or replace view audit_log_vw as
select 
  invoice_number
, 'Line item' as audit_type
, total_price as amount
, created_by
, created_date
, service_name as info_1
, subtype_name as info_2
from invoice_line_vw
union all
select
  invoice_number
, 'Line adjustment' as audit_type
, adjustment_amount as amount
, created_by
, created_date
, adjustment_type as info_1
, adjustment_reason as info_2
from invoice_line_adjustment_vw
union all
select
  invoice_number
, 'Invoice adjustment' as audit_type
, adjustment_amount as amount
, created_by
, created_date
, adjustment_type as info_1
, adjustment_reason as info_2
from invoice_adjustment_vw
union all
select
  invoice_number
, 'Payment' as audit_type
, amount
, created_by
, payment_date as created_date
, payment_type as info_1
, '' as info_2
from payment_vw
;
/
