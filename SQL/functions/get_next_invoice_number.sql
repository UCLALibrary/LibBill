create or replace function get_next_invoice_number (
  p_location_code in location.location_code%type
) return invoice.invoice_number%type as
  invoice_number invoice.invoice_number%type;
  location_exists int;
  next_number int;
  BAD_LOCATION_ERROR exception;
begin
  -- Verify that p_location_code is valid
  select count(*) into location_exists from location
    where location_code = p_location_code;
  if location_exists > 0 then
    select invoice_seq.nextval into next_number from dual;
    -- Format numerical portion as 6 digits, left-padded with 0, and append to location code
    invoice_number := p_location_code || to_char(next_number, 'FM000000');
    return invoice_number;
  else
    raise BAD_LOCATION_ERROR;
  end if;
end get_next_invoice_number;
/

