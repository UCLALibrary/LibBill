create table role_privilege_status (
  role_name varchar2(20) not null
, privilege_name varchar2(30) not null
, status varchar2(20) -- allow null, for actions which don't require invoice status
-- unique instead of primary key, since status is nullable and no other PK makes sense
, constraint role_privilege_status_uk unique (role_name, privilege_name, status)
, constraint rps_role_name_fk foreign key (role_name) references invoice_role (role_name)
, constraint rps_privilege_name_fk foreign key (privilege_name) references invoice_privilege (privilege_name)
, constraint rps_status_fk foreign key (status) references invoice_status (status)
);
