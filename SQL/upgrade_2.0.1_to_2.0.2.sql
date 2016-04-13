/***********************************************************  
* Change script to upgrade LibBill database from 2.0.1 to 2.0.2
***********************************************************/

-- If a problem occurs, roll back what we can and exit the script
whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '2.0.1';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 31683: Patron names longer than 30 characters cause errors
*
***********************************************************/
alter table patron_stub
  modify (normal_last_name varchar2(50), normal_first_name varchar2(50))
;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '2.0.2'
  where setting_name = 'version'
;
commit;
