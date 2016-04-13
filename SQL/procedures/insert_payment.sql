create or replace procedure insert_payment (
  p_invoice_number in payment.invoice_number%type
, p_amount in payment.amount%type
, p_payment_type_id in payment_type.payment_type_id%type
, p_user_name in staff_user.user_name%type
, p_check_note in payment.check_note%type := null
) as
  v_new_payment_number payment.payment_number%type;
  THIS_PROC_NAME constant varchar2(30) := 'insert_payment';
begin
  if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Determine next payment number for this invoice
  select coalesce(max(payment_number), 0) + 1 into v_new_payment_number
    from payment
    where invoice_number = p_invoice_number;

  insert into payment (invoice_number, payment_number, amount, payment_type_id, created_by, check_note)
    values (p_invoice_number, v_new_payment_number, p_amount, p_payment_type_id, p_user_name, p_check_note);

/*  
  insert_message (p_user_name, 'DEBUG', 0, 'insert_payment: ' || p_invoice_number || ' ' || p_amount);

exception
  when others then
    rollback;
    insert_message (p_user_name, 'ERROR', SQLCODE, SQLERRM || ' in insert_payment: ' || p_invoice_number || ' ' || p_amount);
*/
end insert_payment;
/
