/*  Store info about db-level grants in table, to make it
    easier to generate dev and test/prod environments
*/
set serveroutput on;

create or replace procedure allow_access (
  p_grantee in user_tab_privs_made.grantee%type
, p_object_name in user_tab_privs_made.table_name%type
, p_privilege in user_tab_privs_made.privilege%type
) as
  m_sql varchar2(200);
  m_grantor user_tab_privs_made.grantor%type;
  m_grantee user_tab_privs_made.grantee%type;
begin
  insert into db_grants (grantee, object_name, privilege) values (p_grantee, p_object_name, p_privilege);
  commit;
  
  -- Production/test: invoice_owner, invoice_service
  -- Development: invoice_owner_dev, invoice_service_dev
  select lower(sys_context('userenv', 'current_schema'))
    into m_grantor
    from dual;
  
  if m_grantor = 'invoice_owner_dev' then
    m_grantee := 'invoice_service_dev';
  else
    m_grantee := p_grantee;
  end if;
  
  -- Do the actual grant, via dynamic SQL
  m_sql := 'grant ' || p_privilege || ' on ' || p_object_name || ' to ' || m_grantee;
  --dbms_output.put_line(m_sql);
	execute immediate m_sql;
  
  -- For every grant, create a synonym so client doesn't need to specify schema
  m_sql := 'create or replace synonym ' || m_grantee || '.' || p_object_name || ' for ' || m_grantor || '.' || p_object_name;
  --dbms_output.put_line(m_sql);
  execute immediate m_sql;
end allow_access;
/
