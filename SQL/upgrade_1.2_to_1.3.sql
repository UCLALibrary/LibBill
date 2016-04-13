/***********************************************************  
* Change script to upgrade LibBill database from 1.2 to 1.3.
* No fixes: upgrade version number only.
* 2011-07-14 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.2';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.3'
  where setting_name = 'version'
;
commit;

/***** END *****/
