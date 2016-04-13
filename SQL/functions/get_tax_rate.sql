create or replace function get_tax_rate (
  p_tax_rate_id in tax_rate.rate_id%type
) return number as
  v_tax_rate tax_rate.rate%type := 0;
begin
  select rate 
    into v_tax_rate
    from tax_rate
    where rate_id = p_tax_rate_id;
 
  return v_tax_rate;
  
-- if select ... into found no rows this "silent" exception is thrown, so return default of 0 here
exception
  when no_data_found then
    return v_tax_rate;
  
end get_tax_rate;
/

