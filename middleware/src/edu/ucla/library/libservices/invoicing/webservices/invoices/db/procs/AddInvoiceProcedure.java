package edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InsertHeaderBean;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class AddInvoiceProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private InsertHeaderBean data;
  private String dbName;

  public AddInvoiceProcedure()
  {
    super();
  }

  public AddInvoiceProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public AddInvoiceProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public void setData( InsertHeaderBean data )
  {
    this.data = data;
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

  public String addInvoice()
  {
    Map results;

    makeConnection();
    prepProc();
    results = execute();
    
    return results.get( "p_new_invoice_number" ).toString().trim();
  }

  private void prepProc()
  {
    setDataSource( ds );
    setFunction( false );
    //setSql( "invoice_owner.insert_invoice" );
    setSql( "insert_invoice" );
    declareParameter( new SqlParameter( "p_location_code", Types.CHAR ) );
    declareParameter( new SqlParameter( "p_invoice_date", Types.DATE ) );
    declareParameter( new SqlParameter( "p_status", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.CHAR ) );
    declareParameter( new SqlParameter( "p_patron_id", Types.INTEGER ) );
    declareParameter( new SqlParameter( "p_patron_on_premises", Types.CHAR ) );
    declareParameter( new SqlOutParameter( "p_new_invoice_number",
                                        Types.CHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;
    String invoiceNumber;
    
    out = null;
    invoiceNumber = null;
    input = new HashMap();

    input.put( "p_location_code", data.getBranchCode() );
    input.put( "p_invoice_date", data.getInvoiceDate() );
    input.put( "p_status", data.getStatus() );
    input.put( "p_user_name", data.getCreatedBy() );
    input.put( "p_patron_id", data.getPatronID() );
    input.put( "p_patron_on_premises", data.getOnPremises() );
    input.put( "p_new_invoice_number", invoiceNumber );

    out = execute( input );

    return out;
  }
}
