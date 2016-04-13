/***********************************************************  
* Change script to upgrade LibBill database from 1.4 to 1.4.1 (DEV)
* Ticket 20661: Improve LibBill user management
* 2011-08-10 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.4';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 20661: Improve LibBill user management
*
***********************************************************/

/********************
staff_user table
* Change nullability of first/last name columns
********************/
-- Add first/last names to generic user/test accounts to remove NULL values
-- Procedure must be run by an admin user (crt)
exec update_staff_user('voy_auth', 'crt', 'Voyager', 'Authenticator');
exec update_staff_user('test_inv_prep', 'crt', 'Test', 'Invoice Preparer');
exec update_staff_user('test_inv_appr', 'crt', 'Test', 'Invoice Approver');
exec update_staff_user('test_pay_proc', 'crt', 'Test', 'Payment Processor');
exec update_staff_user('test_pay_appr', 'crt', 'Test', 'Payment Approver');
exec update_staff_user('test_admin', 'crt', 'Test', 'Admin');
commit;
-- Make first/last names mandatory
alter table staff_user modify first_name not null;
alter table staff_user modify last_name not null;

/********************
insert_staff_user procedure
* Change nullability of first/last name columns
* Change parameter order to move optional parameter(s) to end
********************/
create or replace procedure insert_staff_user (
  p_user_name in staff_user.user_name%type
, p_user_uid in staff_user.user_uid%type
, p_user_acting in staff_user.user_name%type
, p_first_name in staff_user.first_name%type
, p_last_name in staff_user.last_name%type
, p_user_role in staff_user.user_role%type := null
) as
  v_id_key staff_user.id_key%type;
  v_crypto_key staff_user.crypto_key%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_staff_user';
begin
  if user_has_privilege(p_user_acting, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_acting || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;
  v_id_key := dbms_crypto.randombytes(5);
  v_crypto_key := dbms_crypto.randombytes(10);

  insert into staff_user (user_name, first_name, last_name, user_uid, id_key, crypto_key)
    values (p_user_name, p_first_name, p_last_name, p_user_uid, v_id_key, v_crypto_key);

  if p_user_role is not null then
    assign_role_to_user(p_user_name, p_user_role, p_user_acting);
  end if;
end insert_staff_user;
/

/********************
update_staff_user procedure
* Allow update of user_uid
* Remove updating of id/crypto keys
********************/
create or replace procedure update_staff_user (
  p_user_name in staff_user.user_name%type
, p_user_acting in staff_user.user_name%type
, p_first_name in staff_user.first_name%type := null
, p_last_name in staff_user.last_name%type := null
, p_user_uid in staff_user.user_uid%type := null
) as
  v_id_key staff_user.id_key%type;
  v_crypto_key staff_user.crypto_key%type;
  THIS_PROC_NAME constant varchar2(30) := 'update_staff_user';
begin
  if user_has_privilege(p_user_acting, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_acting || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update staff_user
    set first_name = coalesce(p_first_name, first_name)
    ,   last_name = coalesce(p_last_name, last_name)
    ,   user_uid = coalesce(p_user_uid, user_uid)
    where user_name = p_user_name;    
end update_staff_user;
/

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.4.1'
  where setting_name = 'version'
;
commit;

/***** END *****/
