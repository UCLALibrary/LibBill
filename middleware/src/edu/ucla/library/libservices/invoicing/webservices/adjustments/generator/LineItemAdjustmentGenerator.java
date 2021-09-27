package edu.ucla.library.libservices.invoicing.webservices.adjustments.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.LineItemAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers.LineItemAdjustmentMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class LineItemAdjustmentGenerator
{
  private List<LineItemAdjustment> lineAdjustments;
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private int lineNumber;
  private static final String ADJUSTMENTS_BY_INVOICE =
    //"SELECT * FROM invoice_owner.invoice_line_adjustment_vw WHERE " 
    "SELECT * FROM invoice_line_adjustment_vw WHERE " 
    + "lower(invoice_number) = ? ORDER BY line_number"; //, created_date";


  public LineItemAdjustmentGenerator()
  {
    super();
  }

  public List<LineItemAdjustment> getLineAdjustments()
  {
    makeConnection();
    lineAdjustments =
        new JdbcTemplate( ds ).query( ADJUSTMENTS_BY_INVOICE, new Object[]
          { getInvoiceNumber().toLowerCase() }, new LineItemAdjustmentMapper() );
    return lineAdjustments;
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
    //ds = DataSourceFactory.createDataSource( getDbName() );
    ds = DataSourceFactory.createBillSource();
  }

}
