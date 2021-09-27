package edu.ucla.library.libservices.invoicing.webservices.payments.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.ReceiptInfo;

import edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers.ReceiptInfoMapper;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class ReceiptInfoGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String invoiceNumber;
  private ReceiptInfo info;

  private static final String BASE_QUERY =
    "SELECT ivw.status, up.normal_first_name || ' ' || up.normal_last_name AS" +
    " user_name, up.patron_id AS institution_id, ivw.patron_id FROM invoice_vw ivw INNER JOIN " +
    "patron_vw up ON ivw.patron_id = up.patron_id WHERE ivw.invoice_number = ?";
  private static final String UNPAID_QUERY =
    "SELECT COUNT(invoice_number) FROM invoice_vw WHERE patron_id = ? AND " 
    + "invoice_number <> ? AND status IN ('Partially Paid','Unpaid','Deposit Due','Final Payment Due')";

  public ReceiptInfoGenerator()
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

  public ReceiptInfo getInfo()
  {
    makeConnection();

    info =
        ( ReceiptInfo ) new JdbcTemplate( ds ).queryForObject( BASE_QUERY,
                                                               new Object[]
          { getInvoiceNumber() }, new ReceiptInfoMapper() );
    info.setUnpaid( new JdbcTemplate( ds ).queryForInt( 
      UNPAID_QUERY, new Object[]{info.getPatronID(), getInvoiceNumber()} ) );
    return info;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }
}
