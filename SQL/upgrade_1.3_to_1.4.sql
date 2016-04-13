/***********************************************************  
* Change script to upgrade LibBill database from 1.3 to 1.4.
* Ticket 20560: Update unit title for Biomed SC
* 2011-08-02 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.3';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
* Ticket 20560: Update unit title for Biomed SC
***********************************************************/
-- Increase column size from 25 to 40
alter table location modify location_name varchar2(40);

-- Change location name for Biomed SC
set define off;
update location set location_name = 'Hist & SC for the Sciences' where location_id = 8;
commit;

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.4'
  where setting_name = 'version'
;
commit;

/***** END *****/

