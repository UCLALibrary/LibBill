package edu.ucla.library.libservices.invoicing.webservices.status.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.status.beans.InvoiceStatus;
import edu.ucla.library.libservices.invoicing.webservices.status.db.mappers.InvoiceStatusMapper;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "invoiceStatusList" )
public class InvoiceStatusGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private static final String STATUS_QUERY =
    //"SELECT * FROM invoice_owner.invoice_status_vw order by status";
    "SELECT * FROM invoice_status_vw order by status";
  @XmlElement(name = "invoiceStatus")
  private List<InvoiceStatus> statuses;

  public InvoiceStatusGenerator()
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

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void populateStatuses()
  {
    makeConnection();

    statuses =
        new JdbcTemplate( ds ).query( STATUS_QUERY, new InvoiceStatusMapper() );
  }

  public List<InvoiceStatus> getStatuses()
  {
    return statuses;
  }
}
