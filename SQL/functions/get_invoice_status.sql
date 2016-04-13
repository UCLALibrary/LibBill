create or replace function get_invoice_status (
  p_invoice_number in line_item.invoice_number%type
) return invoice_status.status%type as
  v_invoice_status invoice_status.status%type;
begin
  select status into v_invoice_status
    from invoice
    where invoice_number = p_invoice_number;
  
  return v_invoice_status;
end get_invoice_status;
/
