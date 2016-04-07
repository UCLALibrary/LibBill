package edu.ucla.library.libservices.invoicing.webservices.locations.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
//import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

//@XmlRootElement( name = "branchServices" )
@XmlType( name = "branchService" )
@XmlAccessorType( XmlAccessType.FIELD )
public class LocationServiceBean
{
  @XmlElement( name = "locSvcKey", required = false )
  private int locSvcKey;
  @XmlElement( name = "locationName", required = false )
  private String locationName;
  @XmlElement( name = "serviceName" )
  private String serviceName;
  @XmlElement( name = "subtypeName" )
  private String subtypeName;
  @XmlElement( name = "locationCode", required = false )
  private String locationCode;
  @XmlElement( name = "taxable" )
  private boolean taxable;
  @XmlElement( name = "ucPrice", required = false )
  private double ucPrice;
  @XmlElement( name = "nonUCPrice", required = false )
  private double nonUCPrice;
  @XmlElement( name = "ucMinimum", required = false )
  private double ucMinimum;
  @XmlElement( name = "nonUCMinimum", required = false )
  private double nonUCMinimum;
  @XmlElement( name = "price", required = false )
  private double price;
  @XmlElement( name = "minimumPrice", required = false )
  private double minimumPrice;
  @XmlElement( name = "requireCustomPrice" )
  private boolean requireCustomPrice;
  @XmlElement( name = "unitMeasure" )
  private String unitMeasure;
  @XmlElement( name = "itemCode" )
  private String itemCode;
  @XmlElement( name = "fau" )
  private String fau;
  @XmlElement( name = "locationID", required = false )
  private int locationID;
  @XmlElement( name = "whoBy", required = false )
  private String whoBy;

  public LocationServiceBean()
  {
    super();
    setLocSvcKey( -1 );
    setUcPrice(-1D);
    setNonUCPrice(-1D);
    setUcMinimum(-1D);
    setNonUCMinimum(-1D);
    setLocationID(-1);
  }

  public void setLocSvcKey( int locSvcKey )
  {
    this.locSvcKey = locSvcKey;
  }

  public int getLocSvcKey()
  {
    return locSvcKey;
  }

  public void setLocationName( String locationName )
  {
    this.locationName = locationName;
  }

  public String getLocationName()
  {
    return locationName;
  }

  public void setServiceName( String serviceName )
  {
    this.serviceName = serviceName;
  }

  public String getServiceName()
  {
    return serviceName;
  }

  public void setSubtypeName( String subtypeName )
  {
    this.subtypeName = subtypeName;
  }

  public String getSubtypeName()
  {
    return subtypeName;
  }

  public void setLocationCode( String locationCode )
  {
    this.locationCode = locationCode;
  }

  public String getLocationCode()
  {
    return locationCode;
  }

  public void setTaxable( boolean taxable )
  {
    this.taxable = taxable;
  }

  public boolean isTaxable()
  {
    return taxable;
  }

  public void setUcPrice( double ucPrice )
  {
    this.ucPrice = ucPrice;
  }

  public double getUcPrice()
  {
    return ucPrice;
  }

  public void setNonUCPrice( double nonUCPrice )
  {
    this.nonUCPrice = nonUCPrice;
  }

  public double getNonUCPrice()
  {
    return nonUCPrice;
  }

  public void setUcMinimum( double ucMinimum )
  {
    this.ucMinimum = ucMinimum;
  }

  public double getUcMinimum()
  {
    return ucMinimum;
  }

  public void setNonUCMinimum( double nonUCMinimum )
  {
    this.nonUCMinimum = nonUCMinimum;
  }

  public double getNonUCMinimum()
  {
    return nonUCMinimum;
  }

  public void setPrice( double price )
  {
    this.price = price;
  }

  public double getPrice()
  {
    return price;
  }

  public void setMinimumPrice( double minimumPrice )
  {
    this.minimumPrice = minimumPrice;
  }

  public double getMinimumPrice()
  {
    return minimumPrice;
  }

  public void setRequireCustomPrice( boolean allowPriceOverride )
  {
    this.requireCustomPrice = allowPriceOverride;
  }

  public boolean isRequireCustomPrice()
  {
    return requireCustomPrice;
  }

  public void setUnitMeasure( String unitMeasure )
  {
    this.unitMeasure = unitMeasure;
  }

  public String getUnitMeasure()
  {
    return unitMeasure;
  }

  public void setItemCode( String itemCode )
  {
    this.itemCode = itemCode;
  }

  public String getItemCode()
  {
    return itemCode;
  }

  public void setFau( String fau )
  {
    this.fau = fau;
  }

  public String getFau()
  {
    return fau;
  }

  public void setLocationID( int locationID )
  {
    this.locationID = locationID;
  }

  public int getLocationID()
  {
    return locationID;
  }

  public void setWhoBy( String whoBy )
  {
    this.whoBy = whoBy;
  }

  public String getWhoBy()
  {
    return whoBy;
  }
}
