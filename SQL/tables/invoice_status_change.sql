create table invoice_status_change (
  from_status varchar2(20) not null
, to_status varchar2(20) not null
, role_name varchar2(20) not null
, constraint invoice_status_change_pk primary key (from_status, to_status, role_name)
, constraint status_change_from_fk foreign key (from_status) references invoice_status (status)
, constraint status_change_to_fk foreign key (to_status) references invoice_status (status)
, constraint status_change_role_fk foreign key (role_name) references invoice_role (role_name)
);
