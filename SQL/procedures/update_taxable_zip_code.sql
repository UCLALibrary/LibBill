create or replace procedure update_taxable_zip_code (
  p_zip_code in taxable_zip_code.zip_code%type
, p_old_tax_rate_name in taxable_zip_code.tax_rate_name%type
, p_new_tax_rate_name in taxable_zip_code.tax_rate_name%type
, p_user_name in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'update_taxable_zip_code';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  update taxable_zip_code set
    tax_rate_name = p_new_tax_rate_name
  where zip_code = p_zip_code
  and tax_rate_name = p_old_tax_rate_name;
end update_taxable_zip_code;
/
