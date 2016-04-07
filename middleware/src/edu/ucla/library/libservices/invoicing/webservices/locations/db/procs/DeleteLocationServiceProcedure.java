package edu.ucla.library.libservices.invoicing.webservices.locations.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class DeleteLocationServiceProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private int locSvcKey;
  private String whoBy;

  public DeleteLocationServiceProcedure( JdbcTemplate jdbcTemplate,
                                         String string )
  {
    super( jdbcTemplate, string );
  }

  public DeleteLocationServiceProcedure( DataSource dataSource,
                                         String string )
  {
    super( dataSource, string );
  }

  public DeleteLocationServiceProcedure()
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

  public void setLocSvcKey( int locSvcKey )
  {
    this.locSvcKey = locSvcKey;
  }

  private int getLocSvcKey()
  {
    return locSvcKey;
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

  public void deleteService()
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
    setSql( "delete_location_service" );
    declareParameter( new SqlParameter( "p_location_service_id", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_location_service_id", getLocSvcKey() );
    input.put( "p_user_name", getWhoBy() );

    out = execute( input );

    return out;
  }
}
