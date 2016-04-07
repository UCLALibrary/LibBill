package edu.ucla.library.libservices.invoicing.webservices.payments.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class AddPaymentProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private Payment data;
  private String dbName;

  public AddPaymentProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public AddPaymentProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public AddPaymentProcedure()
  {
    super();
  }

  public void setData( Payment data )
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

  public void addPayment()
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
    //setSql( "invoice_owner.insert_payment" );
    setSql( "insert_payment" );
    declareParameter( new SqlParameter( "p_invoice_number",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_amount",
                                        Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_payment_type_id", Types.INTEGER ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    if ( ! ContentTests.isEmpty( data.getCheckNote() ) )
      declareParameter( new SqlParameter( "p_check_note", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", data.getInvoiceNumber() );
    input.put( "p_amount", data.getAmount() );
    input.put( "p_payment_type_id", data.getPaymentTypeID() );
    input.put( "p_user_name", data.getCreatedBy() );
    if ( ! ContentTests.isEmpty( data.getCheckNote() ) )
      input.put( "p_check_note", data.getCheckNote() );

    out = execute( input );

    return out;
  }
}
