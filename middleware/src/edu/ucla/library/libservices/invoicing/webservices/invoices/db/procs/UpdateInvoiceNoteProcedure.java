package edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class UpdateInvoiceNoteProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private InvoiceNote data;
  private String dbName;

  public UpdateInvoiceNoteProcedure( JdbcTemplate jdbcTemplate,
                                     String string )
  {
    super( jdbcTemplate, string );
  }

  public UpdateInvoiceNoteProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public UpdateInvoiceNoteProcedure()
  {
    super();
  }

  public void setData( InvoiceNote data )
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

  public void editNote()
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
    //setSql( "invoice_owner.update_invoice_note" );
    setSql( "update_invoice_note" );
    declareParameter( new SqlParameter( "p_invoice_number", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_sequence_number", Types.INTEGER ) );
    declareParameter( new SqlParameter( "p_internal", Types.CHAR ) );
    declareParameter( new SqlParameter( "p_note", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;
    
    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", data.getInvoiceNumber() );
    input.put( "p_sequence_number", data.getSequenceNumber() );
    input.put( "p_internal", ( data.isInternal() ? "Y" : "N" ) );
    input.put( "p_note", data.getNote() );
    input.put( "p_user_name", data.getCreatedBy() );

    out = execute( input );

    return out;
  }
}
