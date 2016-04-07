package edu.ucla.library.libservices.invoicing.webservices.taxes.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.taxes.beans.TaxRate;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class EditTaxRateProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private TaxRate data;

  public EditTaxRateProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public EditTaxRateProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public EditTaxRateProcedure()
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

  public void setData( TaxRate data )
  {
    this.data = data;
  }

  private TaxRate getData()
  {
    return data;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void editTax()
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
    setSql( "update_tax_rate" );
    declareParameter( new SqlParameter( "p_rate_id", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_rate_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_rate", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_start_date", Types.DATE ) );
    declareParameter( new SqlParameter( "p_end_date", Types.DATE ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();


    input.put( "p_rate_id", getData().getRateID() );
    input.put( "p_user_name", getData().getWhoBy() );
    input.put( "p_rate_name", getData().getRateName() );
    input.put( "p_rate", getData().getRate() );
    input.put( "p_start_date", getData().getStartDate() );
    input.put( "p_end_date", getData().getEndDate() );

    out = execute( input );

    return out;
  }
}
