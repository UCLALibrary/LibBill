create or replace function invoice_total_is_updateable (
  p_invoice_number in invoice.invoice_number%type
) return char as
  v_invoice_status invoice.status%type;
  v_updateable char(1) := 'N';
begin
  v_invoice_status := get_invoice_status(p_invoice_number);
  
  if v_invoice_status in ('Pending', 'Deposit Paid') then
    v_updateable := 'Y';
  end if;
  
  return v_updateable;
end invoice_total_is_updateable;
/
