create or replace view invoice_vw as
select 
  i.invoice_number
, i.invoice_date
, i.status
, i.total_amount
, i.total_tax
, i.line_item_total
, i.taxable_total
, i.nontaxable_total
, calculate_balance_due(i.invoice_number) as balance_due
, i.created_by
, i.created_date
, i.patron_id
, i.patron_on_premises
, l.department_number
, l.location_name
, l.phone_number
from invoice i
inner join location l on i.location_id = l.location_id
;
