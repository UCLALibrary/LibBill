create table line_item_adjustment (
  invoice_number char(8) not null
, line_number int not null
, created_by varchar2(20) not null
, created_date date default sysdate not null
, adjustment_amount number(10,2) not null
, adjustment_type varchar2(10) not null
, adjustment_reason varchar2(200) -- free text - allow nulls?
, constraint line_item_adj_amount_ck check (adjustment_amount < 0)
, constraint line_item_adjustment_pk primary key (invoice_number, line_number, created_date)
, constraint line_item_fk foreign key (invoice_number, line_number)
    references line_item(invoice_number, line_number)
, constraint line_item_adj_created_by_fk foreign key (created_by)
    references staff_user (user_name)
, constraint line_item_adj_type_fk foreign key (adjustment_type)
    references line_item_adjustment_type (adjustment_type)

);
