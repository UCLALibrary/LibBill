create or replace procedure insert_taxable_zip_code (
  p_zip_code in taxable_zip_code.zip_code%type
, p_tax_rate_name in taxable_zip_code.tax_rate_name%type
, p_user_name in staff_user.user_name%type
) as
  THIS_PROC_NAME constant varchar2(30) := 'insert_taxable_zip_code';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  insert into taxable_zip_code (zip_code, tax_rate_name)
    values (p_zip_code, p_tax_rate_name);
end insert_taxable_zip_code;
/
