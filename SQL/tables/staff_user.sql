create table staff_user (
  user_name varchar2(20) not null
, first_name varchar2(30) not null
, last_name varchar2(30) not null
, user_uid char(9) not null
, id_key char(10) not null
, crypto_key char(20) not null
, create_date date default sysdate not null
, user_role varchar2(20) -- can be null, users may not have roles
, constraint staff_user_pk primary key (user_name)
, constraint staff_user_crypto_key_uq unique (crypto_key)
, constraint staff_user_id_key_uq unique (id_key)
, constraint staff_user_role_fk foreign key (user_role) references invoice_role (role_name)
)
;
