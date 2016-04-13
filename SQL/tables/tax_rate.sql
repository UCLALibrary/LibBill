create table tax_rate (
  rate_id int not null
, rate_name varchar2(20) not null
, rate number(10, 4) not null
, start_date date not null
, end_date date null
, constraint tax_rate_pk primary key (rate_id)
, constraint tax_rate_uk unique (rate_name, start_date)
, constraint tax_rate_type_fk foreign key (rate_name) references tax_rate_type (rate_name)
)
;
