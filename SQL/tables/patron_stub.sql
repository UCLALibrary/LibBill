create table patron_stub (
  patron_id int not null
, normal_last_name varchar2(30)
, normal_first_name varchar2(30)
, constraint patron_stub_pk primary key (patron_id)
);
