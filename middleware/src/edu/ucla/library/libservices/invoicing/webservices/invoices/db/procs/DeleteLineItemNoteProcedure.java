package edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class DeleteLineItemNoteProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private String userName;
  private int lineNumber;
  private int sequenceNumber;  

  public DeleteLineItemNoteProcedure( JdbcTemplate jdbcTemplate,
                                      String string )
  {
    super( jdbcTemplate, string );
  }

  public DeleteLineItemNoteProcedure( DataSource dataSource,
                                      String string )
  {
    super( dataSource, string );
  }

  public DeleteLineItemNoteProcedure()
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

  public void setLineNumber( int lineNumber )
  {
    this.lineNumber = lineNumber;
  }

  private int getLineNumber()
  {
    return lineNumber;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }


  public void deleteNote()
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
    //setSql( "invoice_owner.delete_line_item_note" );
    setSql( "delete_line_item_note" );
    declareParameter( new SqlParameter( "p_invoice_number", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_line_number", Types.INTEGER ) );
    declareParameter( new SqlParameter( "p_sequence_number", Types.INTEGER ) );
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
    input.put( "p_line_number", getLineNumber() );
    input.put( "p_sequence_number", getSequenceNumber() );
    input.put( "p_user_name", getUserName() );

    out = execute( input );

    return out;
  }

  public void setSequenceNumber( int sequenceNumber )
  {
    this.sequenceNumber = sequenceNumber;
  }

  private int getSequenceNumber()
  {
    return sequenceNumber;
  }

  public void setUserName( String userName )
  {
    this.userName = userName;
  }

  private String getUserName()
  {
    return userName;
  }
}
