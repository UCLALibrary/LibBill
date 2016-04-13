create or replace procedure update_invoice_taxes (
  p_invoice_number in invoice.invoice_number%type
) as
  v_tax_rate_id invoice.tax_rate_id%type;
  v_nontaxable_amount invoice.nontaxable_total%type := 0;
  v_taxable_amount invoice.taxable_total%type := 0;
  v_total_tax_amount invoice.total_tax%type := 0;
begin
  select tax_rate_id
    into v_tax_rate_id
    from invoice
    where invoice_number = p_invoice_number;
  
  v_nontaxable_amount := get_nontaxable_total(p_invoice_number);
  v_taxable_amount := get_taxable_total(p_invoice_number);
  v_total_tax_amount := v_taxable_amount * get_tax_rate(v_tax_rate_id);
  
  update invoice set
    total_tax = v_total_tax_amount
  , nontaxable_total = v_nontaxable_amount
  , taxable_total = v_taxable_amount
  where invoice_number = p_invoice_number;
  commit;
  
end update_invoice_taxes;
/
