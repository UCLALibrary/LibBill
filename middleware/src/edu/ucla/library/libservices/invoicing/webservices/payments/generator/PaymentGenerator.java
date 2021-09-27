package edu.ucla.library.libservices.invoicing.webservices.payments.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;

import edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers.PaymentMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class PaymentGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private List<Payment> payments;
  private static final String PAYMENTS_BY_INVOICE =
    //"SELECT * FROM invoice_owner.payment_vw WHERE lower(invoice_number) = ? " 
    "SELECT * FROM payment_vw WHERE lower(invoice_number) = ? " 
    + "ORDER BY payment_date";

  public PaymentGenerator()
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

  public List<Payment> getPayments()
  {
    makeConnection();

    payments =
        new JdbcTemplate( ds ).query( PAYMENTS_BY_INVOICE, new Object[]
          { getInvoiceNumber().toLowerCase() }, new PaymentMapper() );
    return payments;
  }

  private void makeConnection()
  {
    //ds = DataSourceFactory.createDataSource( getDbName() );
    ds = DataSourceFactory.createBillSource();
  }

}
