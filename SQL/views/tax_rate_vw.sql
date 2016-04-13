create or replace view tax_rate_vw as
select
  rate_id
, rate_name
, rate
, start_date
, end_date
from tax_rate
;
/
