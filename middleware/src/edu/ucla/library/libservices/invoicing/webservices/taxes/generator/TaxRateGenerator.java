package edu.ucla.library.libservices.invoicing.webservices.taxes.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.taxes.beans.TaxRate;

import edu.ucla.library.libservices.invoicing.webservices.taxes.db.mappers.TaxRateMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement( name = "taxRateList" )
public class TaxRateGenerator
{
  private static final String RATE_QUERY =
    "SELECT * FROM tax_rate_vw WHERE end_date >= sysdate OR end_date IS NULL ORDER BY rate_name";
  
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  @XmlElement( name = "rate" )
  private List<TaxRate> rates;

  public TaxRateGenerator()
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

  public void populateRates()
  {
    makeConnection();

    rates = new JdbcTemplate( ds ).query( RATE_QUERY, new TaxRateMapper() );
  }
  public List<TaxRate> getRates()
  {
    return rates;
  }
}
