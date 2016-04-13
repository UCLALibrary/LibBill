create table line_item (
  invoice_number char(8) not null
, location_service_id int not null
, line_number int not null
, quantity number(10,2) not null -- fractional quantities are allowed, like 0.25
, unit_price number(10,2) not null
, total_price number(10,2) not null
, created_by varchar2(20) not null
, created_date date default sysdate not null
, constraint line_item_quantity_ck check (quantity > 0)
, constraint line_item_unit_price_ck check (unit_price > 0)
, constraint line_item_total_price_ck check (total_price > 0)
, constraint transaction_pk primary key (invoice_number, line_number)
, constraint line_item_xref_fk foreign key (location_service_id)
    references location_service (location_service_id)
, constraint line_item_invoice_fk foreign key (invoice_number)
    references invoice(invoice_number)
, constraint line_item_created_by_fk foreign key (created_by)
    references staff_user (user_name)
);
