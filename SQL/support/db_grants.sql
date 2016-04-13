/*  Store info about db-level grants in table, to make it
    easier to generate dev and test/prod environments
*/
create table db_grants (
  grantee varchar2(30) not null
, object_name varchar2(30) not null
, privilege varchar2(40) not null
, constraint db_grants_pk primary key (grantee, object_name, privilege)
);
