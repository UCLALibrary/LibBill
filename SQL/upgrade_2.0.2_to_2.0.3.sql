/***********************************************************  
* Change script to upgrade LibBill database from 2.0.2 to 2.0.3
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.2';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 35124: Permission changes requested by LBS / Clark Thompson
*
***********************************************************/
insert into invoice_status_change (from_status, to_status, role_name) values ('Partially Paid', 'Deposit Paid', 'payment_approver');

commit;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.3'
  where setting_name = 'version'
;
commit;
