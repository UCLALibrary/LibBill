/***********************************************************  
* Change script to upgrade LibBill database from 1.4.4 to 1.5 
* Ticket 20894: Problem with is_patron_uc function
* 2011-09-08 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.4.4';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 20894: Problem with is_patron_uc function
*
***********************************************************/

/********************
is_patron_uc function
* Correctly handle cases where patrons have multiple groups
********************/
create or replace function is_patron_uc (
  p_patron_id in invoice.patron_id%type
) return vger_support.ucladb_patrons.uc_community%type as
  -- 1 (true) or 0 (false)
  v_uc_community vger_support.ucladb_patrons.uc_community%type;
begin
  -- Some patrons have multiple groups; return 1 (true) if any are true, else 0 (false)
  select max(uc_community) into v_uc_community
    from vger_support.ucladb_patrons
    where patron_id = p_patron_id;
  
  return v_uc_community;
end is_patron_uc;
/

-- END of Ticket 20894: Problem with is_patron_uc function

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.5'
  where setting_name = 'version'
;
commit;

/***** END *****/
