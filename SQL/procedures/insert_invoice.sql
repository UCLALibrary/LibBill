create or replace procedure insert_invoice (
  p_location_code in location.location_code%type
, p_invoice_date in invoice.invoice_date%type
, p_status in invoice.status%type := 'Pending'
, p_user_name in staff_user.user_name%type
, p_patron_id in invoice.patron_id%type
, p_patron_on_premises in invoice.patron_on_premises%type
, p_new_invoice_number out invoice.invoice_number%type
) as
  -- To work around JDBC-related problem storing CHAR(10) in passed-in output parameter
  v_new_invoice_number invoice.invoice_number%type;
  v_location_id invoice.location_id%type;
  v_patron_exists int;
  THIS_PROC_NAME constant varchar2(30) := 'insert_invoice';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Could throw NO_DATA_FOUND, caught below
  select location_id into v_location_id
    from location
    where location_code = p_location_code;

  -- Capture minimal patron data, if we don't already have it, in case patron is later deleted from ucladb
  if patron_needs_stub(p_patron_id) = TRUE then
    insert into patron_stub (patron_id, normal_last_name, normal_first_name)
      -- Could be multiple rows in patron_vw (multiple groups, addresses)
      select distinct patron_id, normal_last_name, normal_first_name
      from patron_vw
      where patron_id = p_patron_id;
  end if;
    
  -- Get next invoice number and add the invoice
  v_new_invoice_number := get_next_invoice_number(p_location_code);
  insert into invoice (
    invoice_number
  , invoice_date
  , status
  , created_by
  , patron_id
  , patron_on_premises
  , location_id
  , tax_rate_id
  ) values (
    v_new_invoice_number
  , p_invoice_date
  , p_status
  , p_user_name
  , p_patron_id
  , p_patron_on_premises
  , v_location_id
  , get_tax_rate_id(p_patron_id, p_patron_on_premises, p_invoice_date)
  );
  
  -- For output to caller, if all went well
  p_new_invoice_number := v_new_invoice_number;

exception
  when NO_DATA_FOUND then
    raise_application_error(application_errors.INVALID_DATA, 
      'Invalid location code: ' || p_location_code);
end insert_invoice;
/
