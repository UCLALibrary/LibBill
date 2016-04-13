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
