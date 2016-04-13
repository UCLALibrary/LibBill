create or replace function get_price_for_service (
  p_invoice_number in line_item.invoice_number%type
, p_location_service_id in line_item.location_service_id%type
) return location_service.uc_price%type as
  v_patron_id invoice.patron_id%type;
  v_price location_service.uc_price%type;
begin
  -- Get the patron for this invoice
  select patron_id into v_patron_id
    from invoice
    where invoice_number = p_invoice_number;

  -- Get the UC or non-UC price for this service, based on patron id
  select 
    case is_patron_uc(v_patron_id)
      when 1 then uc_price 
      else non_uc_price 
    end into v_price
  from location_service
  where location_service_id = p_location_service_id;
  
  return v_price;
end get_price_for_service;
/
