package edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.ZipCode;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class InsertTaxableZipCodeProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private ZipCode data;

  public InsertTaxableZipCodeProcedure( JdbcTemplate jdbcTemplate,
                                        String string )
  {
    super( jdbcTemplate, string );
  }

  public InsertTaxableZipCodeProcedure( DataSource dataSource,
                                        String string )
  {
    super( dataSource, string );
  }

  public InsertTaxableZipCodeProcedure()
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

  public void addZip()
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
    setSql( "insert_taxable_zip_code" );
    declareParameter( new SqlParameter( "p_zip_code", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_tax_rate_name", Types.VARCHAR ) );
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
    input.put( "p_tax_rate_name", getData().getTaxRateName() );
    input.put( "p_user_name", getData().getCreatedBy() );

    out = execute( input );

    return out;
  }

  public void setData( ZipCode data )
  {
    this.data = data;
  }

  private ZipCode getData()
  {
    return data;
  }
}
    //setSql( "invoice_owner.insert_taxable_zip_code" );
    //declareParameter( new SqlParameter( "p_la_county_taxable", Types.CHAR ) );
    //declareParameter( new SqlParameter( "p_california_taxable", Types.CHAR ) );
    //input.put( "p_la_county_taxable", ( getData().isLaCountyTaxable() ? "Y": "N" ) );
    //input.put( "p_california_taxable", ( getData().isCaliforniaTaxable() ? "Y": "N" ) );
