package edu.ucla.library.libservices.invoicing.webservices.locations.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.Location;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.mappers.LocationMapper;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "units" )
public class LocationGenerator
{
  private static final String UNITS_QUERY =
    "SELECT location_id,location_code,location_name,department_number," 
    + "phone_number FROM location_vw ORDER BY location_name";

  //private DriverManagerDataSource ds;
  private DataSource ds;
  @XmlElement( name = "unit" )
  private List<Location> units;
  private String dbName;

  public LocationGenerator()
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

  public void popUnits()
  {
    makeConnection();

    units =
        new JdbcTemplate( ds ).query( UNITS_QUERY, new LocationMapper() );
  }
}
