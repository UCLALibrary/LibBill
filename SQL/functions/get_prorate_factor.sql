create or replace function get_prorate_factor (
  p_invoice_number in invoice_vw.invoice_number%type
) return number as
  v_factor number;
begin
  select
    case
      when status = 'Deposit Due' then to_number(get_application_setting('quote_percentage_due'))
      when total_amount = 0 then 1
      else (balance_due / total_amount)
    end into v_factor
  from invoice_vw
  where invoice_number = p_invoice_number;
  
  return v_factor;
end get_prorate_factor;
/
