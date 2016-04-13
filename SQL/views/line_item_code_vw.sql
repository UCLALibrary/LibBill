create or replace view line_item_code_vw as
select
  li.invoice_number
, ls.item_code
, sum(li.total_price) * get_prorate_factor(li.invoice_number) as total_price
from line_item li
inner join location_service ls on li.location_service_id = ls.location_service_id
group by li.invoice_number, ls.item_code
union all
select
  i.invoice_number
, trt.item_code
, total_tax * get_prorate_factor(i.invoice_number) as total_price
from invoice i
inner join tax_rate tr on i.tax_rate_id = tr.rate_id
inner join tax_rate_type trt on tr.rate_name = trt.rate_name
-- Taxes are not included for Deposit Due invoices
where i.status != 'Deposit Due'
;
/

-- move to appropriate other scripts
-- data/load_allow_access.sql
--exec allow_access('invoice_service', 'line_item_code_vw', 'select');
-- for reporting, done via cursor in support/grant_reporting rights.sql
--grant select on line_item_code_vw to ucla_preaddb;
-- https://docs.library.ucla.edu/x/jYUMAg
