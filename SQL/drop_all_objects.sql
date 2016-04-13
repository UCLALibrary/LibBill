/*** MAKE SURE YOU'RE IN THE RIGHT DATABASE! ***/

/*  Drops all objects owned by current user.
    Naive: intended for use in LibBill db by invoice_owner / invoice_owner_dev, which currently has only the following object types:
      * FUNCTION
      * INDEX
      * PACKAGE
      * PROCEDURE
      * SEQUENCE
      * TABLE
    Does not drop objects owned by invoice_service / invoice_service_dev, which owns SYNONYMs to many of invoice_owner's objects.
*/

set serveroutput on;

declare
  sql_string varchar2(150);
  cursor cur is 
    select * from user_objects
    where object_type not in ('INDEX');
begin
  for obj in cur loop
    begin
      sql_string := 'DROP ' || obj.object_type || ' ' || obj.object_name;
      if obj.object_type = 'TABLE' then
        -- Work around foreign key constraints
        sql_string := sql_string || ' CASCADE CONSTRAINTS';
      end if;
      -- Resulting sql_string does not have trailing semicolon; adding one to the string makes EXECUTE IMMEDIATE unhappy
      dbms_output.put_line(sql_string);
      execute immediate sql_string;
    end;
  end loop;
end;
/

purge recyclebin;

select * from user_objects;