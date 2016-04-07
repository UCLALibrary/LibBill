package edu.ucla.library.libservices.invoicing.webservices.locations.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.LocationServiceBean;

import edu.ucla.library.libservices.invoicing.webservices.locations.db.mappers.FilteredLocationServiceMapper;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.mappers.LocationServiceMapper;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "branchServices" )
public class LocationServiceGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  @XmlElement( name = "service" )
  private List<LocationServiceBean> services;
  private String branchCode;
  private String branchName;
  private String itemCode;
  private String dbName;
  private boolean forUC;
  private static final String SERVICES_BY_LOCATION =
    //"SELECT * FROM invoice_owner.location_service_vw WHERE lower(location_name) = ?" 
    "SELECT * FROM location_service_vw WHERE lower(location_name) = ?" 
    + " ORDER BY service_name, subtype_name";
  private static final String UC_SERVICES_BY_LOCATION =
    "SELECT location_service_id,location_code,location_name,service_name," 
    + "subtype_name,taxable,uc_price AS price,uc_minimum_amount AS " 
    //+ "minimum_price,require_custom_price FROM invoice_owner.location_service_vw WHERE " 
    + "minimum_price,require_custom_price,unit_measure,item_code,fau" 
    + " FROM location_service_vw WHERE lower(location_code) = ? ORDER BY service_name, subtype_name";
  private static final String UC_SERVICES_BY_LOCALE_CODE =
    "SELECT location_service_id,location_code,location_name,service_name," 
    + "subtype_name,taxable,uc_price AS price,uc_minimum_amount AS " 
    //+ "minimum_price,require_custom_price FROM invoice_owner.location_service_vw WHERE " 
    + "minimum_price,require_custom_price,unit_measure,item_code,fau" 
    + " FROM location_service_vw WHERE lower(location_code) = ? AND trim(lower(item_code)) = ? ORDER BY service_name, subtype_name";
  private static final String NONUC_SERVICES_BY_LOCATION =
    "SELECT location_service_id,location_code,location_name,service_name," 
    + "subtype_name,taxable,non_uc_price AS price,non_uc_minimum_amount AS " 
    //+ "minimum_price,require_custom_price FROM invoice_owner.location_service_vw WHERE " 
    + "minimum_price,require_custom_price,unit_measure,item_code,fau" 
    + " FROM location_service_vw WHERE lower(location_code) = ? ORDER BY service_name, subtype_name";
  private static final String NONUC_SERVICES_BY_LOCALE_CODE =
    "SELECT location_service_id,location_code,location_name,service_name," 
    + "subtype_name,taxable,non_uc_price AS price,non_uc_minimum_amount AS " 
    //+ "minimum_price,require_custom_price FROM invoice_owner.location_service_vw WHERE " 
    + "minimum_price,require_custom_price,unit_measure,item_code,fau" 
    + " FROM location_service_vw WHERE lower(location_code) = ? AND trim(lower(item_code)) = ? ORDER BY service_name, subtype_name";

  public LocationServiceGenerator()
  {
    super();
  }

  public void setBranchName( String branchName )
  {
    this.branchName = branchName;
  }

  private String getBranchName()
  {
    return branchName;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setForUC( boolean isUC )
  {
    this.forUC = isUC;
  }

  private boolean isForUC()
  {
    return forUC;
  }

  public void setBranchCode( String branchCode )
  {
    this.branchCode = branchCode;
  }

  private String getBranchCode()
  {
    return branchCode;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void getServicesByLocation()
  {
    makeConnection();

    services =
        new JdbcTemplate( ds ).query( SERVICES_BY_LOCATION, new Object[]
          { getBranchName().toLowerCase() }, new LocationServiceMapper() );
  }

  public void getFilteredServicesByLocation()
  {
    makeConnection();
    
    if ( isForUC() && isForAll() )
    {
      System.out.println( "doing query " +  UC_SERVICES_BY_LOCATION);
      services = new JdbcTemplate( ds ).query( 
        UC_SERVICES_BY_LOCATION, 
        new Object[] { getBranchCode().toLowerCase() }, 
        new FilteredLocationServiceMapper() );
    }
    if ( isForUC() && !isForAll() )
    {
      System.out.println( "doing query " +  UC_SERVICES_BY_LOCALE_CODE);
      services = new JdbcTemplate( ds ).query( 
        UC_SERVICES_BY_LOCALE_CODE, 
        new Object[] { getBranchCode().toLowerCase(), getItemCode().toLowerCase() }, 
        new FilteredLocationServiceMapper() );
    }
    if ( !isForUC() && isForAll() )
    {
      System.out.println( "doing query " +  NONUC_SERVICES_BY_LOCATION);
      services = new JdbcTemplate( ds ).query( 
        NONUC_SERVICES_BY_LOCATION, 
        new Object[] { getBranchCode().toLowerCase() }, 
        new FilteredLocationServiceMapper() );
    }
    if ( !isForUC() && !isForAll() )
    {
      System.out.println( "doing query " +  NONUC_SERVICES_BY_LOCALE_CODE);
      services = new JdbcTemplate( ds ).query( 
        NONUC_SERVICES_BY_LOCALE_CODE, 
        new Object[] { getBranchCode().toLowerCase(), getItemCode().toLowerCase() }, 
        new FilteredLocationServiceMapper() );
    }
  }

  private boolean isForAll()
  {
    if ( !ContentTests.isEmpty( getItemCode() ) )
      return getItemCode().equalsIgnoreCase( "all" );
    else
      return true;
  }

  public void setItemCode( String itemCode )
  {
    this.itemCode = itemCode;
  }

  private String getItemCode()
  {
    return itemCode;
  }

  public List<LocationServiceBean> getServices()
  {
    return services;
  }
}
