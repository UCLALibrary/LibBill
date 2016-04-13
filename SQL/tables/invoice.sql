create table invoice (
  invoice_number char(8) not null
, invoice_date date not null
, status varchar2(20) not null
, total_amount number(10, 2) default 0 not null
, la_county_tax number(10,2) default 0 not null
, california_tax number(10,2) default 0 not null
, line_item_total number(10,2) default 0 not null
, taxable_total number(10,2) default 0 not null
, nontaxable_total number(10,2) default 0 not null
, created_by varchar2(20) not null
, created_date date default sysdate not null
, patron_id int not null
, patron_on_premises char(1) not null check (patron_on_premises in ('N', 'Y'))
, location_id int not null
, constraint invoice_pk primary key (invoice_number)
, constraint invoice_status_fk foreign key (status)
    references invoice_status (status)
, constraint invoice_created_by_fk foreign key (created_by)
    references staff_user (user_name)
, constraint invoice_location_id foreign key (location_id) 
    references location (location_id)
);
