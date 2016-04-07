package edu.ucla.library.libservices.invoicing.webservices.locations.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import edu.ucla.library.libservices.invoicing.webservices.locations.beans.Location;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class EditLocationProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private Location data;

  public EditLocationProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public EditLocationProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public EditLocationProcedure()
  {
    super();
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setData( Location data )
  {
    this.data = data;
  }

  private Location getData()
  {
    return data;
  }

  public void editBranch()
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
    setSql( "update_location" );
    declareParameter( new SqlParameter( "p_location_id",
                                        Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_location_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_department_number", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_phone_number", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_location_id", getData().getId() );
    input.put( "p_user_name", getData().getWhoBy() );
    input.put( "p_location_name", getData().getName() );
    input.put( "p_department_number", getData().getDepartment() );
    input.put( "p_phone_number", getData().getPhone() );

    out = execute( input );

    return out;
  }
}
