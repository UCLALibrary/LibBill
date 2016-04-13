create or replace view invoice_status_change_vw as
select
  from_status
, to_status
, role_name
from invoice_status_change;
/
