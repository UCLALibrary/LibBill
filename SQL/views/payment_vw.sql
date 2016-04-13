create or replace view payment_vw as
select
  p.invoice_number
, p.amount
, p.payment_date
, p.created_by
, p.check_note
, p.payment_type_id
, pt.payment_type
from payment p
inner join payment_type pt on p.payment_type_id = pt.payment_type_id
;
/
