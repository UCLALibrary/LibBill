create or replace procedure update_invoice_total (
  p_invoice_number in varchar2
) as
  new_invoice_total number := 0;
begin
  select taxable_total + nontaxable_total + total_tax
    into new_invoice_total
    from invoice
    where invoice_number = p_invoice_number;
  
  update invoice
    set total_amount = new_invoice_total
  , line_item_total = taxable_total + nontaxable_total
    where invoice_number = p_invoice_number;
  commit;
end update_invoice_total;
/
