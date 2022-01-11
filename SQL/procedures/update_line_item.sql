create or replace procedure update_line_item (
  p_invoice_number in line_item.invoice_number%type
, p_line_number in line_item.line_number%type
, p_location_service_id in line_item.location_service_id%type
, p_quantity in line_item.quantity%type
, p_user_name in staff_user.user_name%type
, p_unit_price in line_item.unit_price%type := 0
, p_is_uc_member in char
) as
  rows_updated int := 0;
  v_require_custom_price location_service.require_custom_price%type;
  v_total_price line_item.total_price%type;
  v_unit_price line_item.unit_price%type;
  THIS_PROC_NAME constant varchar2(30) := 'update_line_item';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Determine whether this service's price can be set/overridden by the client
  select require_custom_price into v_require_custom_price
    from location_service
    where location_service_id = p_location_service_id;

  if v_require_custom_price = 'Y' then
    -- Must have price from client
    if p_unit_price = 0 then
      raise_application_error(application_errors.INVALID_DATA, 'Price must be non-zero');
    else
      v_unit_price :=  p_unit_price;
    end if;
  else
    -- Use what's in the location_service table; client should not provide price
    if p_unit_price != 0 then
      raise_application_error(application_errors.INVALID_DATA, 'Client should not provide price');
    else
      v_unit_price := get_price_for_service(p_invoice_number, p_location_service_id, p_is_uc_member);
    end if;
  end if;

  v_total_price := p_quantity * v_unit_price;
  
  update line_item set
    quantity = p_quantity
  , location_service_id = p_location_service_id
  , unit_price = v_unit_price
  , total_price = v_total_price
  where invoice_number = p_invoice_number
  and line_number = p_line_number;

  rows_updated := sql%rowcount;
  if rows_updated = 0 then
    raise NO_DATA_FOUND;
  end if;

  -- TODO: commit here?
  --commit;
  -- Now update the invoice amounts to include info for the whole invoice
  update_invoice_amounts(p_invoice_number);
exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Could not find invoice / line number: ' || p_invoice_number || ' / ' || p_line_number);
end update_line_item;
/
