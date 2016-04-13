/***********************************************************  
* Change script to upgrade LibBill database from 2.0.3 to 2.0.4
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.3';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* GHR-415 and GHR-515: New do-nothing roles requested by LBS / Clark Thompson
*
***********************************************************/
insert into invoice_role values ('inactive');
insert into invoice_role values ('view_only');

insert into invoice_privilege (privilege_name) values ('NONE'); -- needed by views to find inactive users who exist (history maintained) but no longer have rights
insert into invoice_privilege (privilege_name) values ('view_only'); -- 

insert into role_privilege_status (role_name, privilege_name, status) values ('inactive', 'NONE', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('view_only', 'view_only', null);

commit;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.4'
  where setting_name = 'version'
;
commit;
