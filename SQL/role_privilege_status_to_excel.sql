select distinct
  role_name
, privilege_name
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status is null)
    then 'X' else null end as None
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Pending')
    then 'X' else null end as Pending
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Unpaid')
    then 'X' else null end as Unpaid
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Partially Paid')
    then 'X' else null end as Partially_Paid
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Paid')
    then 'X' else null end as Paid
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Canceled')
    then 'X' else null end as Canceled
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Never Issued')
    then 'X' else null end as Never_Issued
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Deposit Due')
    then 'X' else null end as Deposit_Due
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Deposit Paid')
    then 'X' else null end as Deposit_Paid
, case when exists (select * from role_privilege_status where role_name = rps.role_name and privilege_name = rps.privilege_name and status = 'Final Payment Due')
    then 'X' else null end as Final_Payment_Due
from role_privilege_status rps
order by role_name, privilege_name
;