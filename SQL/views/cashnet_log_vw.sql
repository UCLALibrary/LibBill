create or replace view cashnet_log_vw as
select
  ucla_ref_no
, result_code
, cn_trans_no
, cn_batch_no
, pmt_code
, eff_date
, cn_details
from cashnet_log
;
/

-- move to appropriate other scripts
-- data/load_allow_access.sql
exec allow_access('invoice_service', 'cashnet_log_vw', 'select');
-- for reporting, done via cursor in support/grant_reporting rights.sql
grant select on cashnet_log_vw to ucla_preaddb;
-- https://docs.library.ucla.edu/x/jYUMAg


