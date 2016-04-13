create table line_item_note (
  invoice_number char(8) not null
, line_number int not null
, sequence_number int not null
, note nvarchar2(1000) not null
, internal char(1) default 'N' not null check(internal in ('N', 'Y'))
, created_by varchar2(20) not null
, created_date date default sysdate not null
, constraint line_item_note_pk primary key (invoice_number, line_number, sequence_number)
, constraint line_item_note_fk foreign key (invoice_number, line_number)
    references line_item(invoice_number, line_number)
, constraint line_item_note_created_by_fk foreign key (created_by)
    references staff_user (user_name)
);

