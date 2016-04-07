package edu.ucla.library.libservices.invoicing.webservices.locations.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.LocationServiceBean;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class AddLocationServiceProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private LocationServiceBean data;

  public AddLocationServiceProcedure( JdbcTemplate jdbcTemplate,
                                      String string )
  {
    super( jdbcTemplate, string );
  }

  public AddLocationServiceProcedure( DataSource dataSource,
                                      String string )
  {
    super( dataSource, string );
  }

  public AddLocationServiceProcedure()
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

  public void setData( LocationServiceBean data )
  {
    this.data = data;
  }

  private LocationServiceBean getData()
  {
    return data;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void addService()
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
    setSql( "insert_location_service" );
    declareParameter( new SqlParameter( "p_location_id", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_service_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_subtype_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_unit_measure", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_item_code", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_fau", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_taxable", Types.CHAR ) );
    declareParameter( new SqlParameter( "p_require_custom_price", Types.CHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_uc_price", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_non_uc_price", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_uc_minimum_amount", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_non_uc_minimum_amount", Types.NUMERIC ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_location_id", getData().getLocationID() );
    input.put( "p_service_name", getData().getServiceName() );
    input.put( "p_subtype_name", getData().getSubtypeName() );
    input.put( "p_unit_measure", getData().getUnitMeasure() );
    input.put( "p_item_code", getData().getItemCode() );
    input.put( "p_fau", getData().getFau() );
    input.put( "p_taxable", ( getData().isTaxable() ? "Y" : "N" ) );
    input.put( "p_require_custom_price", ( getData().isRequireCustomPrice() ? "Y" : "N" ) );
    input.put( "p_user_name", getData().getWhoBy() );
    if ( getData().getUcPrice() != -1D )
      input.put( "p_uc_price", getData().getUcPrice() );
    else
      input.put( "p_uc_price", null );
    if ( getData().getNonUCPrice() != -1D )
      input.put( "p_non_uc_price", getData().getNonUCPrice() );
    else
      input.put( "p_non_uc_price", null );
    if ( getData().getUcMinimum() != -1D )
      input.put( "p_uc_minimum_amount", getData().getUcMinimum() );
    else
      input.put( "p_uc_minimum_amount", null );
    if ( getData().getNonUCMinimum() != -1D )
      input.put( "p_non_uc_minimum_amount", getData().getNonUCMinimum() );
    else
      input.put( "p_non_uc_minimum_amount", null );

    out = execute( input );

    return out;
  }
}
