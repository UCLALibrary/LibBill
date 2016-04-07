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

public class GetUserKeyFunction
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String idKey;
  private String dbName;

  public GetUserKeyFunction( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public GetUserKeyFunction( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public GetUserKeyFunction()
  {
    super();
  }

  public void setIdKey( String idKey )
  {
    this.idKey = idKey;
  }

  private String getIdKey()
  {
    return idKey;
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
    //setSql( "invoice_owner.get_crypto_key" );
    setSql( "get_crypto_key" );
    declareParameter( new SqlOutParameter( "userinfo", Types.VARCHAR ) );
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
    input.put( "p_id_key", getIdKey() );
    out = execute( input );

    return out;
  }
}
