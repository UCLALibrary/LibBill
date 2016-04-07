package edu.ucla.library.libservices.invoicing.webservices.staff.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class AssignUserRoleProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String userName;
  private String userRole;
  private String whoBy;

  public AssignUserRoleProcedure( JdbcTemplate jdbcTemplate,
                                  String string )
  {
    super( jdbcTemplate, string );
  }

  public AssignUserRoleProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public AssignUserRoleProcedure()
  {
    super();
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setUserName( String userName )
  {
    this.userName = userName;
  }

  private String getUserName()
  {
    return userName;
  }

  public void setUserRole( String userRole )
  {
    this.userRole = userRole;
  }

  private String getUserRole()
  {
    return userRole;
  }

  public void setWhoBy( String whoBy )
  {
    this.whoBy = whoBy;
  }

  private String getWhoBy()
  {
    return whoBy;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void setRole()
  {
    Map results;

    makeConnection();
    prepProc();
    results = execute();
  }

  private void prepProc()
  {
    setDataSource( ds );
    setFunction( false );
    //setSql( "invoice_owner.assign_role_to_user" );
    setSql( "assign_role_to_user" );
    declareParameter( new SqlParameter( "p_user_name",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_role", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_acting", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_user_name", getUserName() );
    input.put( "p_user_role", getUserRole() );
    input.put( "p_user_acting", getWhoBy() );

    out = execute( input );

    return out;
  }
}
