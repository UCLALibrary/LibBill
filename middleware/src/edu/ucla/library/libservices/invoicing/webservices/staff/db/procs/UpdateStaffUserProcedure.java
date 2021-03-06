package edu.ucla.library.libservices.invoicing.webservices.staff.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.UserRole;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class UpdateStaffUserProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private UserRole data;
  
  public UpdateStaffUserProcedure( JdbcTemplate jdbcTemplate,
                                   String string )
  {
    super( jdbcTemplate, string );
  }

  public UpdateStaffUserProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public UpdateStaffUserProcedure()
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

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void editUser()
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
    //setSql( "invoice_owner.update_staff_user" );
    setSql( "update_staff_user" );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_acting", Types.VARCHAR ) );
    //if ( !ContentTests.isEmpty( getData().getFirstName() ) )
      declareParameter( new SqlParameter( "p_first_name", Types.VARCHAR ) );
    //if ( !ContentTests.isEmpty( getData().getLastName() ) )
      declareParameter( new SqlParameter( "p_last_name", Types.VARCHAR ) );
    //if ( !ContentTests.isEmpty( getData().getUserUid() ) )
      declareParameter( new SqlParameter( "p_user_uid", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_user_name", getData().getUserName() );
    input.put( "p_user_acting", getData().getWhoBy() );
    //if ( !ContentTests.isEmpty( getData().getFirstName() ) )
      input.put( "p_first_name", getData().getFirstName() );
    //if ( !ContentTests.isEmpty( getData().getLastName() ) )
      input.put( "p_last_name", getData().getLastName() );
    //if ( !ContentTests.isEmpty( getData().getUserUid() ) )
      input.put( "p_user_uid", getData().getUserUid() );

    out = execute( input );

    return out;
  }

  public void setData( UserRole data )
  {
    this.data = data;
  }

  private UserRole getData()
  {
    return data;
  }
}
  //private String userName;
  //private String whoBy;
  /*public void setWhoBy( String whoBy )
  {
    this.whoBy = whoBy;
  }

  private String getWhoBy()
  {
    return whoBy;
  }*/
  /*public void setUserName( String userName )
  {
    this.userName = userName;
  }

  private String getUserName()
  {
    return userName;
  }*/

