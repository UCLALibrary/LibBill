package edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class CancelTaxProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private String userName;

  public CancelTaxProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public CancelTaxProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public CancelTaxProcedure()
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

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  private String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  public void setUserName( String userName )
  {
    this.userName = userName;
  }

  private String getUserName()
  {
    return userName;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void cancelTax()
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
    setSql( "cancel_invoice_tax" );
    //setSql( "invoice_owner.cancel_invoice_tax" );
    declareParameter( new SqlParameter( "p_invoice_number",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", getInvoiceNumber() );
    input.put( "p_user_name", getUserName() );

    out = execute( input );

    return out;
  }
}
