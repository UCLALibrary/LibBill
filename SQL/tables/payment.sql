create table payment (
  invoice_number char(8) not null
, payment_number int not null  
, amount number(10, 2) not null
, payment_type_id int not null
, payment_date date default sysdate not null
, created_by varchar2(20) not null
, check_note nvarchar2(1000)
, constraint payment_amount_ck check (amount != 0)
, constraint payment_pk primary key (invoice_number, payment_number)
, constraint payment_invoice_fk foreign key (invoice_number)
    references invoice (invoice_number)
, constraint payment_created_by_fk foreign key (created_by)
    references staff_user (user_name)
, constraint payment_type_id_fk foreign key (payment_type_id)
    references payment_type (payment_type_id)
)
;
