/***********************************************************  
* Change script to upgrade LibBill database from 2.0 to 2.0.1
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 28963: Permission changes requested by LBS / Clark Thompson
*
***********************************************************/
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Deposit Paid' and to_status = 'Canceled';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Final Payment Due' and to_status = 'Canceled';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Paid' and to_status = 'Canceled';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Paid' and to_status = 'Partially Paid';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Paid' and to_status = 'Unpaid';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Partially Paid' and to_status = 'Canceled';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Partially Paid' and to_status = 'Unpaid';
delete from invoice_status_change where role_name = 'payment_processor' and from_status = 'Unpaid' and to_status = 'Canceled';

insert into invoice_status_change (from_status, to_status, role_name) values ('Deposit Due', 'Deposit Paid', 'payment_approver');
insert into invoice_status_change (from_status, to_status, role_name) values ('Final Payment Due', 'Paid', 'payment_approver');
insert into invoice_status_change (from_status, to_status, role_name) values ('Final Payment Due', 'Partially Paid', 'payment_approver');
insert into invoice_status_change (from_status, to_status, role_name) values ('Partially Paid', 'Paid', 'payment_approver');
insert into invoice_status_change (from_status, to_status, role_name) values ('Unpaid', 'Paid', 'payment_approver');
insert into invoice_status_change (from_status, to_status, role_name) values ('Unpaid', 'Partially Paid', 'payment_approver');

commit;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.1'
  where setting_name = 'version'
;
commit;
