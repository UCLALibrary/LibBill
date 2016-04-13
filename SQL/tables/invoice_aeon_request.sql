create table invoice_aeon_request (
  aeon_request_id int not null
, invoice_number char(8) not null
, constraint invoice_aeon_request_pk primary key (aeon_request_id)
, constraint invoice_aeon_request_inv_fk foreign key (invoice_number)
    references invoice(invoice_number)
)
;
