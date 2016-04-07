package edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
//import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class AddInvoiceAdjustmentProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private InvoiceAdjustment data;
  private String dbName;

  public AddInvoiceAdjustmentProcedure( JdbcTemplate jdbcTemplate,
                                        String string )
  {
    super( jdbcTemplate, string );
  }

  public AddInvoiceAdjustmentProcedure( DataSource dataSource,
                                        String string )
  {
    super( dataSource, string );
  }

  public AddInvoiceAdjustmentProcedure()
  {
    super();
  }

  public void setData( InvoiceAdjustment data )
  {
    this.data = data;
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

  public void addAdjustment()
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
    //setSql( "invoice_owner_dev.insert_invoice_adjustment" );
    setSql( "insert_invoice_adjustment" );
    declareParameter( new SqlParameter( "p_invoice_number",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_adjustment_type", Types.VARCHAR ) );
    //if ( ! ContentTests.isEmpty( data.getAdjustmentReason() ) )
      declareParameter( new SqlParameter( "p_adjustment_reason", Types.VARCHAR ) );
    //if ( ! ContentTests.isEmpty( data.getAdjustmentAmount() ) )
      declareParameter( new SqlParameter( "p_amount", Types.NUMERIC ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", data.getInvoiceNumber() );
    input.put( "p_user_name", data.getCreatedBy() );
    input.put( "p_adjustment_type", data.getAdjustmentType() );
    //if ( ! ContentTests.isEmpty( data.getAdjustmentReason() ) )
      input.put( "p_adjustment_reason", data.getAdjustmentReason() );
    //if ( ! ContentTests.isEmpty( data.getAdjustmentAmount() ) )
      input.put( "p_amount", data.getAdjustmentAmount() );

    out = execute( input );

    return out;
  }
}
