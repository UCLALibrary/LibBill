create or replace function calculate_balance_due (
  p_invoice_number in varchar2
) return number as
  v_balance_due number := 0;
  v_total_amount number := 0;
  v_total_tax number := 0;
  v_total_payments number := 0;
  v_invoice_adjustments number := 0;
  v_line_adjustments number := 0;
  v_total_adjustments number := 0;
  v_invoice_status invoice.status%type;
  v_quote_percentage number := 100;
begin
  select total_amount, total_tax into v_total_amount, v_total_tax
    from invoice
    where invoice_number = p_invoice_number;

  select nvl(sum(amount), 0) into v_total_payments
    from payment
    where invoice_number = p_invoice_number;

  select nvl(sum(adjustment_amount), 0) into v_invoice_adjustments
    from invoice_adjustment
    where invoice_number = p_invoice_number;

  select nvl(sum(adjustment_amount), 0) into v_line_adjustments
    from line_item_adjustment
    where invoice_number = p_invoice_number;

  v_total_adjustments := v_invoice_adjustments + v_line_adjustments;
  
  -- Start with default calculation which applies to most statuses
  v_balance_due := v_total_amount + v_total_adjustments - v_total_payments;

  -- Different rules based on invoice status
  v_invoice_status := get_invoice_status(p_invoice_number);

  -- Pending invoices should not have balance due
  if v_invoice_status = 'Pending' then
    v_balance_due := 0;
  end if;

  -- Deposit Due invoices have a fixed percentage of balance due
  -- Taxes are *not* included in the total for these invoices
  if v_invoice_status = 'Deposit Due' then
    v_quote_percentage := get_application_setting('quote_percentage_due');
    v_balance_due := round( ((v_balance_due - v_total_tax) * v_quote_percentage), 2);
  end if;
  
  return v_balance_due;
end calculate_balance_due;
/
