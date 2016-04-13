create table message_log (
  user_name varchar2(20) not null
, message_date date default sysdate not null
, message_type varchar2(10) not null
, error_code integer default 0 not null
, message varchar2(400) not null
, constraint message_type_ck check (message_type in ('ERROR', 'WARNING', 'DEBUG'))
, constraint message_user_name_fk foreign key (user_name)
    references staff_user (user_name)
)
;

