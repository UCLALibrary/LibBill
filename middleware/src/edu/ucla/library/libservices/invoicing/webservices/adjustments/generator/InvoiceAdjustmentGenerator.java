package edu.ucla.library.libservices.invoicing.webservices.adjustments.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers.InvoiceAdjustmentMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class InvoiceAdjustmentGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private List<InvoiceAdjustment> adjustments;
  private static final String ADJUSTMENTS_BY_INVOICE =
    //"SELECT * FROM invoice_owner.invoice_adjustment_vw WHERE " 
    "SELECT * FROM invoice_adjustment_vw WHERE " 
    + "lower(invoice_number) = ?";
  
  public InvoiceAdjustmentGenerator()
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

  public void setAdjustments( List<InvoiceAdjustment> adjustments )
  {
    this.adjustments = adjustments;
  }

  public List<InvoiceAdjustment> getAdjustments()
  {
    makeConnection();
    adjustments =
        new JdbcTemplate( ds ).query( ADJUSTMENTS_BY_INVOICE, new Object[]
          { getInvoiceNumber().toLowerCase() }, new InvoiceAdjustmentMapper() );
    return adjustments;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }
}
