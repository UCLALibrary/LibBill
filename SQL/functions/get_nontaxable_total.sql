create or replace function get_nontaxable_total (
  p_invoice_number in invoice.invoice_number%type
) return number as
  line_item_total invoice_line_vw.total_price%type;
begin
  select coalesce(sum(total_price), 0) into line_item_total
    from invoice_line_vw
    where invoice_number = p_invoice_number
    and taxable = 'N';
  
  return line_item_total;
end get_nontaxable_total;
/
