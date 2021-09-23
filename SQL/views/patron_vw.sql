create or replace view patron_vw as
select
  patron_id
, normal_last_name
, normal_first_name
, uc_community
from patron_stub
;
/
