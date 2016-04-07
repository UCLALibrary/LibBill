package edu.ucla.library.libservices.invoicing.webservices.staff.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class GetStaffUserFunction
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String userUid;
  private String idKey;
  private String dbName;
  private boolean byUid;

  public GetStaffUserFunction( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public GetStaffUserFunction( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public GetStaffUserFunction()
  {
    super();
  }

  public void setUserUid( String userUid )
  {
    this.userUid = userUid;
  }

  public String getUserUid()
  {
    return userUid;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setIdKey( String idKey )
  {
    this.idKey = idKey;
  }

  private String getIdKey()
  {
    return idKey;
  }

  public void setByUid( boolean byUid )
  {
    this.byUid = byUid;
  }

  private boolean isByUid()
  {
    return byUid;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public String getUser()
  {
    Map results;

    makeConnection();
    prepProc();
    results = execute();

    return results.get( "userinfo" ).toString().trim();
  }

  private void prepProc()
  {
    setDataSource( ds );
    setFunction( true );
    if ( isByUid() )
      //setSql( "invoice_owner.get_user_info" );
      setSql( "get_user_info" );
    else
      //setSql( "invoice_owner.get_user_info_by_id_key" );
      setSql( "get_user_info_by_id_key" );
    declareParameter( new SqlOutParameter( "userinfo", Types.VARCHAR ) );
    if ( isByUid() )
      declareParameter( new SqlParameter( "p_uid", Types.VARCHAR ) );
    else
      declareParameter( new SqlParameter( "p_id_key", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;
    String userInfo;

    out = null;
    input = new HashMap();
    userInfo = null;

    input.put( "userinfo", userInfo );
    if ( isByUid() )
    {
      input.put( "p_uid", getUserUid() );
    }
    else
    {
      input.put( "p_id_key", getIdKey() );
    }

    out = execute( input );

    return out;
  }
}
