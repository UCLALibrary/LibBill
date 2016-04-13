create table invoice_adjustment (
  invoice_number char(8) not null
, created_by varchar2(20) not null
, created_date date default sysdate not null
, adjustment_amount number(10,2) not null
, adjustment_type varchar2(20) not null
, adjustment_reason varchar2(200)
-- 2011-05-04: PK allows one of each type of adjustment (currently 'CANCEL TAX' and 'REFUND')
, constraint invoice_adjustment_pk primary key (invoice_number, adjustment_type)
, constraint invoice_adj_amount_ck check (adjustment_amount != 0)
, constraint invoice_fk foreign key (invoice_number)
    references invoice (invoice_number)
, constraint invoice_adj_created_by_fk foreign key (created_by)
    references staff_user (user_name)
, constraint invoice_adj_type_fk foreign key (adjustment_type)
    references invoice_adjustment_type (adjustment_type)
);
