create or replace function get_tax_rate_id (
  p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_invoice_date in invoice.invoice_date%type
, p_patron_zip_code in taxable_zip_code.zip_code%type
) return number as
  v_patron_zip_code taxable_zip_code.zip_code%type;
  v_tax_rate_name tax_rate.rate_name%type;
  v_tax_rate_id tax_rate.rate_id%type;
begin
  -- If patron is on premises, we use the UCLA zip code to determine tax rate
  -- Otherwise, get the patron's zip code from his Voyager patron record
  if (p_patron_on_premises = 'Y') then
    v_patron_zip_code := get_application_setting('ucla_zip_code');
  else
    v_patron_zip_code := substr(p_patron_zip_code, 1, 5);
  end if;

  -- Get the tax rate associated with the zip code
  select tax_rate_name 
    into v_tax_rate_name
    from taxable_zip_code
    where zip_code = v_patron_zip_code;
    
  -- Get the tax rate id for this rate, effective as of this invoice date
  select rate_id
    into v_tax_rate_id
    from tax_rate
    where rate_name = v_tax_rate_name
    and start_date <= p_invoice_date
    and (end_date >= p_invoice_date or end_date is null);
  
  return v_tax_rate_id;
  
-- if select ... into found no rows this "silent" exception is thrown, so return default of null (no rate) here
exception
  when no_data_found then
    return v_tax_rate_id;
  
end get_tax_rate_id;
/

/*
with d as (
  select 6201 as patron_id, 'Y' as on_premises, sysdate as inv_date from dual -- la_county rate
  union all
  select 6201, 'N', sysdate from dual -- invalid zip, no tax rate
  union all
  select 6201, 'Y', to_date('2010-01-01', 'YYYY-MM-DD') from dual -- la county rate, older rate
  union all
  select 152875, 'N', sysdate from dual -- california rate
  union all
  select 228885, 'N', sysdate from dual -- santa monica city rate
)
select d.*, tr.*
from d
left outer join tax_rate tr on get_tax_rate_id(patron_id, on_premises, inv_date) = tr.rate_id
;
*/
