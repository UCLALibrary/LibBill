/*  So: the new procedure should receive an invoice number, a payment type ID, and a user name; 
    the procedure will retrieve/calculate the balance due on the invoice 
    and execute INSERT_PAYMENT with that amount and the received user/invoice/payment type.  
    The new procedure should then execute UPDATE_INVOICE with status = Paid and the received user/invoice.
 
The new staff_user needs the following privileges:
  insert payment privilege
  update invoice (start status in Partially Paid,Unpaid) privilege
  change status (Partially Paid|Unpaid ==> Paid) privilege
  execute the "full payment" procedure privilege
*/
create or replace procedure apply_full_payment (
  p_invoice_number in payment.invoice_number%type
, p_payment_type_id in payment_type.payment_type_id%type
, p_user_name in staff_user.user_name%type
) as
  v_balance_due invoice_vw.balance_due%type;
  v_old_invoice_status invoice_vw.status%type;
  v_new_invoice_status invoice_vw.status%type;
  THIS_PROC_NAME constant varchar2(30) := 'apply_full_payment';
begin
  --if user_has_privilege(p_user_name, THIS_PROC_NAME, get_invoice_status(p_invoice_number)) = 'N' then
  if user_has_privilege(p_user_name, THIS_PROC_NAME) = 'N' then
    raise_application_error(application_errors.NOT_ALLOWED, p_user_name || ' cannot run procedure ' || THIS_PROC_NAME);
  end if;

  -- Get balance due as payment will be for this amount
  select balance_due, status into v_balance_due, v_old_invoice_status
    from invoice_vw
    where invoice_number = p_invoice_number
  ;
  
  -- Make the payment
  insert_payment(p_invoice_number, v_balance_due, p_payment_type_id, p_user_name);
  
  -- Change invoice status to Paid or Deposit Paid, depending on starting status
  if v_old_invoice_status = 'Deposit Due' then
    v_new_invoice_status := 'Deposit Paid';
  else
    v_new_invoice_status := 'Paid';
  end if;
  update_invoice(p_invoice_number, v_new_invoice_status, p_user_name);
  
end apply_full_payment;
/

/*
-- move to appropriate other scripts
-- Create grants: data/load_allow_access.sql
exec allow_access('invoice_service', 'apply_full_payment', 'execute');
-- Define privilege for this procedure: data/load_invoice_privilege.sql
insert into invoice_privilege values ('apply_full_payment');
-- Associate this procedure with its role(s): data/load_role_privilege_status.sql
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'apply_full_payment', null);
-- Associate procedures called by this one with role: data/load_role_privilege_status.sql
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'insert_payment', 'Unpaid');
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'insert_payment', 'Partially Paid');
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'update_invoice', 'Unpaid');
insert into role_privilege_status (role_name, privilege_name, status) values ('e-commerce', 'update_invoice', 'Partially Paid');
insert into invoice_status_change values ('Partially Paid', 'Paid', 'e-commerce');
insert into invoice_status_change values ('Unpaid', 'Paid', 'e-commerce');
commit;
*/
