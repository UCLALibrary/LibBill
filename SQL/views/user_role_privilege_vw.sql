create or replace view user_role_privilege_vw as
select distinct
  su.user_name
, su.first_name
, su.last_name
, su.user_role
, su.user_uid
, urps.privilege_name
from staff_user su
inner join user_role_privilege_status_vw urps on su.user_role = urps.role_name
;
/
