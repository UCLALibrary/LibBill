create table patron_aeon (
  patron_id int not null
, username varchar2(50) not null
, last_name varchar2(50)
, first_name varchar2(50)
, aeon_id  varchar2(50)
, email varchar2(100)
, phone_number varchar2(50)
, perm_address1 varchar2(50)
, perm_address2 varchar2(50)
, perm_city varchar2(50)
, perm_state varchar2(50)
, perm_zip varchar2(50)
, perm_country varchar2(50)
, billing_category varchar2(50)
, temp_address1 varchar2(50)
, temp_address2 varchar2(50)
, temp_city varchar2(50)
, temp_state varchar2(50)
, temp_zip varchar2(50)
, temp_country varchar2(50)
, constraint patron_aeon_pk primary key (username)
)
;
