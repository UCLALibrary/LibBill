create or replace view location_vw as
select 
  location_id
, location_code
, location_name
, department_number
, phone_number
from location
;
/
