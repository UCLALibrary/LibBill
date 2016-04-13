create or replace procedure insert_cashnet_log (
  p_ucla_ref_no in cashnet_log.ucla_ref_no%type
, p_result_code in cashnet_log.result_code%type
, p_cn_trans_no in cashnet_log.cn_trans_no%type
, p_cn_batch_no in cashnet_log.cn_batch_no%type
, p_pmt_code in cashnet_log.pmt_code%type
, p_eff_date in cashnet_log.eff_date%type
, p_cn_details in cashnet_log.cn_details%type
, p_user_name in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'insert_cashnet_log';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  insert into cashnet_log (ucla_ref_no, result_code, cn_trans_no, cn_batch_no, pmt_code, eff_date, cn_details)
    values (p_ucla_ref_no, p_result_code, p_cn_trans_no, p_cn_batch_no, p_pmt_code, p_eff_date, p_cn_details);

end insert_cashnet_log;
/

/*
-- move to appropriate other scripts
-- Create grants: data/load_allow_access.sql
exec allow_access('invoice_service', 'insert_cashnet_log', 'execute');

-- Define role: data/load_invoice_role.sql
insert into invoice_role values ('e-commerce');
-- Define privilege for this procedure: data/load_invoice_privilege.sql
insert into invoice_privilege values ('insert_cashnet_log');
-- Associated this procedure with its role(s): data/load_role_privilege_status.sql
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'insert_cashnet_log', null);
-- Create an internal user for this role
exec insert_staff_user('ecommerce', 'ecommerce', 'crt', 'E-Commerce', 'Internal User', 'e-commerce');
commit;
*/

/*
delete from staff_user where user_name = 'ecommerce';
delete from role_privilege_status where role_name = 'e-commerce';
delete from invoice_privilege where privilege_name = 'insert_cashnet_log';
delete from invoice_role where role_name = 'e-commerce';
drop procedure insert_cashnet_log;
drop view cashnet_log_vw;
drop table cashnet_log purge;
commit;
*/
