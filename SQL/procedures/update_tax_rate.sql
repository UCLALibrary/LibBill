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
