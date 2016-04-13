/*  This script grants extra rights, beyond what the invoicing application requires,
    to views used for reporting.
*/
set serveroutput on

declare
  m_view_name user_views.view_name%type;
	m_sql varchar2(200);

	cursor objects is
		select view_name
		from user_views
		order by view_name
		;
begin

	open objects;
	loop
		fetch objects into m_view_name;
		exit when objects%notfound;
		m_sql := 'grant select on ' || m_view_name || ' to ucla_preaddb';
		dbms_output.put_line(m_sql);
		execute immediate m_sql;
	end loop;
	close objects;
end;
/
