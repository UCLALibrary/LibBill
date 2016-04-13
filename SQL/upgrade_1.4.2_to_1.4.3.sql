/***********************************************************  
* Change script to upgrade LibBill database from 1.4.2 to 1.4.3 (DEV)
* Ticket 20699: Create LibBill admin services for tax rates
* 2011-08-10 akohler.
*
***********************************************************/

whenever sqlerror exit rollback;

/***********************************************************  
* Check current version and exit if not right.
***********************************************************/
declare
  required_version application_setting.setting_value%type := '1.4.2';
begin
  if get_application_setting('version') != required_version then
    raise_application_error(application_errors.INVALID_VERSION, 'Not at required version ' || required_version);
  end if;
end;
/

/***********************************************************  
*
* Ticket 20699: Create LibBill admin services for tax rates
*
***********************************************************/

/********************
tax_rate_type table
********************/
-- New lookup table to enforce constraint on tax_rate.rate_name
create table tax_rate_type (
  rate_name varchar2(20) not null
, constraint tax_rate_type_pk primary key (rate_name)
);
-- Add existing data
insert into tax_rate_type values ('california');
insert into tax_rate_type values ('la_county');
commit;

/********************
tax_rate_seq sequence
********************/
-- New sequence for artificial key in tax_rate
create sequence tax_rate_seq
  minvalue 1
  maxvalue 99999999 
  increment by 1
  start with 1
  nocache
  noorder
  nocycle
;

/********************
tax_rate_type table
* Drop and redefine table
* Add foreign key constraint to tax_rate_type.rate_name
* Add sequence-based column for better row identification, since PK of rate_name + start_date *could* change
********************/
drop table tax_rate purge;
create table tax_rate (
  rate_id int not null
, rate_name varchar2(20) not null
, rate number(10, 4) not null
, start_date date not null
, end_date date null
, constraint tax_rate_pk primary key (rate_id)
, constraint tax_rate_uk unique (rate_name, start_date)
, constraint tax_rate_type_fk foreign key (rate_name) references tax_rate_type (rate_name)
)
;

/********************
insert_tax_rate procedure
********************/
create or replace procedure insert_tax_rate (
  p_rate_name in tax_rate.rate_name%type
, p_rate in tax_rate.rate%type
, p_start_date in tax_rate.start_date%type
, p_end_date in tax_rate.end_date%type
, p_user_name in staff_user.user_name%type
) as
  v_rate_id tax_rate.rate_id%type;
  v_start_date tax_rate.start_date%type;
  v_end_date tax_rate.end_date%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_tax_rate';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  select tax_rate_seq.nextval into v_rate_id from dual;
  
  -- Force start_date to have time = 000000 (start of day)
  v_start_date := trunc(p_start_date);
  -- Force end_date to have time = 235959 (end of day)
  if p_end_date is not null then
    v_end_date := trunc(p_end_date) + interval '1' DAY - interval '1' SECOND;
  else
    v_end_date := null;
  end if;
  
  insert into tax_rate (rate_id, rate_name, rate, start_date, end_date)
    values (v_rate_id, p_rate_name, p_rate, v_start_date, v_end_date);
  commit;
end insert_tax_rate;
/

/********************
update_tax_rate procedure
********************/
create or replace procedure update_tax_rate (
  p_rate_id in tax_rate.rate_id%type
, p_user_name in staff_user.user_name%type
, p_rate_name in tax_rate.rate_name%type := null
, p_rate in tax_rate.rate%type := null
, p_start_date in tax_rate.start_date%type := null
, p_end_date in tax_rate.end_date%type := null
) as
  v_start_date tax_rate.start_date%type;
  v_end_date tax_rate.end_date%type;
  THIS_PROC_NAME constant varchar2(30) := 'update_tax_rate';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Force start_date to have time = 000000 (start of day)
  if p_start_date is not null then
    v_start_date := trunc(p_start_date);
  else
    v_start_date := null;
  end if;
  -- Force end_date to have time = 235959 (end of day)
  if p_end_date is not null then
    v_end_date := trunc(p_end_date) + interval '1' DAY - interval '1' SECOND;
  else
    v_end_date := null;
  end if;

  update tax_rate
    set rate_name = coalesce(p_rate_name, rate_name)
    ,   rate = coalesce(p_rate, rate)
    ,   start_date = coalesce(v_start_date, start_date)
    ,   end_date = coalesce(v_end_date, end_date)
  where rate_id = p_rate_id;
  commit;
end update_tax_rate;
/

/********************
tax_rate_type_vw view
********************/
create or replace view tax_rate_type_vw as
select
  rate_name
from tax_rate_type
;
/

/********************
tax_rate_vw view
********************/
create or replace view tax_rate_vw as
select
  rate_id
, rate_name
, rate
, start_date
, end_date
from tax_rate
;
/

-- Add new privileges and assign to roles
insert into invoice_privilege values ('insert_tax_rate');
insert into invoice_privilege values ('update_tax_rate');

insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'insert_tax_rate', null);
insert into role_privilege_status (role_name, privilege_name, status) values ('admin', 'update_tax_rate', null);

exec allow_access('invoice_service', 'insert_tax_rate', 'execute');
exec allow_access('invoice_service', 'update_tax_rate', 'execute');
exec allow_access('invoice_service', 'tax_rate_type_vw', 'select');
exec allow_access('invoice_service', 'tax_rate_vw', 'select');
commit;

-- Use new procedure to add current tax rates
exec insert_tax_rate('california', 0.0825, to_date('20090701 000000', 'YYYYMMDD HH24MISS'), to_date('20110630 235959', 'YYYYMMDD HH24MISS'), 'crt');
exec insert_tax_rate('california', 0.0725, to_date('20110701 000000', 'YYYYMMDD HH24MISS'), null, 'crt');
exec insert_tax_rate('la_county',  0.0150, to_date('20090701 000000', 'YYYYMMDD HH24MISS'), null, 'crt');
commit;

-- END of Ticket 20699: Create LibBill admin services for tax rates

/***********************************************************  
* Update version setting
***********************************************************/
update application_setting 
  set setting_value = '1.4.3'
  where setting_name = 'version'
;
commit;

/***** END *****/
