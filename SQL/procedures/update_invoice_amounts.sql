create or replace procedure update_invoice_amounts (
  p_invoice_number in invoice.invoice_number%type
) as
begin
  update_invoice_taxes(p_invoice_number);

  -- Invoice total should only be updated for certain invoice statuses
  if invoice_total_is_updateable(p_invoice_number) = 'Y' then
    update_invoice_total(p_invoice_number);
  end if;

end update_invoice_amounts;
/
