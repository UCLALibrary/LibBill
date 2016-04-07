package edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.UpdateZipCode;
import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.ZipCode;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class UpdateTaxableZipCodeProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private UpdateZipCode data;

  public UpdateTaxableZipCodeProcedure( JdbcTemplate jdbcTemplate,
                                        String string )
  {
    super( jdbcTemplate, string );
  }

  public UpdateTaxableZipCodeProcedure( DataSource dataSource,
                                        String string )
  {
    super( dataSource, string );
  }

  public UpdateTaxableZipCodeProcedure()
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

  public void setData( UpdateZipCode data )
  {
    this.data = data;
  }

  private UpdateZipCode getData()
  {
    return data;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void editZip()
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
    setSql( "update_taxable_zip_code" );
    declareParameter( new SqlParameter( "p_zip_code", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_old_tax_rate_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_new_tax_rate_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_zip_code", getData().getCode() );
    input.put( "p_old_tax_rate_name", getData().getOldName() );
    input.put( "p_new_tax_rate_name", getData().getNewName() );
    input.put( "p_user_name", getData().getCreatedBy() );

    out = execute( input );

    return out;
  }
}
    //setSql( "invoice_owner.update_taxable_zip_code" );
    //declareParameter( new SqlParameter( "p_la_county_taxable", Types.CHAR ) );
    //declareParameter( new SqlParameter( "p_california_taxable", Types.CHAR ) );
    //input.put( "p_la_county_taxable", ( getData().isLaCountyTaxable() ? "Y": "N" ) );
    //input.put( "p_california_taxable", ( getData().isCaliforniaTaxable() ? "Y": "N" ) );
