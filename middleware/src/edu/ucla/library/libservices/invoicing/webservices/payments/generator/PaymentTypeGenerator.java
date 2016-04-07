package edu.ucla.library.libservices.invoicing.webservices.payments.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.PaymentType;

import edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers.PaymentTypeMapper;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "paymentTypes" )
public class PaymentTypeGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  @XmlElement(name = "paymentType")
  private List<PaymentType> types;
  private static final String TYPES_QUERY =
    //"SELECT * FROM invoice_owner.payment_type_vw ORDER BY payment_type";
    "SELECT * FROM payment_type_vw ORDER BY payment_type";

  public PaymentTypeGenerator()
  {
    super();
  }

  public void populateTypes()
  {
    makeConnection();

    types =
        new JdbcTemplate( ds ).query( TYPES_QUERY, new PaymentTypeMapper() );
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

  public List<PaymentType> getTypes()
  {
    return types;
  }
}
