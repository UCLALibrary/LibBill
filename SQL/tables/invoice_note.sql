create table invoice_note (
  invoice_number char(8) not null
, sequence_number int not null
, note nvarchar2(1000) not null
, internal char(1) default 'N' not null check(internal in ('N', 'Y'))
, created_by varchar2(20) not null
, created_date date default sysdate not null
, constraint invoice_note_pk primary key (invoice_number, sequence_number)
, constraint invoice_note_invoice_fk foreign key (invoice_number)
    references invoice(invoice_number)
, constraint invoice_note_created_by_fk foreign key (created_by)
    references staff_user (user_name)
);
