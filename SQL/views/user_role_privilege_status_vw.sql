create or replace view user_role_privilege_status_vw as
select
  su.user_name
, rps.role_name
, rps.privilege_name
, rps.status
from staff_user su
inner join role_privilege_status rps on su.user_role = rps.role_name
;
/

-- used internally by user_has_privilege()