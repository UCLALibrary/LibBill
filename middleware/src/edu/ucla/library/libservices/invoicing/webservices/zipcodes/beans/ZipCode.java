package edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType( name = "zipCode" )
@XmlAccessorType( XmlAccessType.FIELD )
public class ZipCode
{
  @XmlElement( name = "code" )
  private String code;
  @XmlElement( name = "taxRateName" )
  private String taxRateName;
  @XmlElement( name = "createdBy", required=false )
  private String createdBy;

  public ZipCode()
  {
    super();
  }

  public void setCode( String code )
  {
    this.code = code;
  }

  public String getCode()
  {
    return code;
  }

  public void setCreatedBy( String createdBy )
  {
    this.createdBy = createdBy;
  }

  public String getCreatedBy()
  {
    return createdBy;
  }

  public void setTaxRateName( String taxRateName )
  {
    this.taxRateName = taxRateName;
  }

  public String getTaxRateName()
  {
    return taxRateName;
  }
}
  /*@XmlElement( name = "laCountyTaxable" )
  private boolean laCountyTaxable;
  @XmlElement( name = "californiaTaxable" )
  private boolean californiaTaxable;*/
  /*public void setLaCountyTaxable( boolean laCountyTaxable )
  {
    this.laCountyTaxable = laCountyTaxable;
  }

  public boolean isLaCountyTaxable()
  {
    return laCountyTaxable;
  }

  public void setCaliforniaTaxable( boolean californiaTaxable )
  {
    this.californiaTaxable = californiaTaxable;
  }

  public boolean isCaliforniaTaxable()
  {
    return californiaTaxable;
  }

  public String toString()
  {
    return getCode().concat( 
      ( isLaCountyTaxable() ? " is LA taxable;": " is not LA taxable;" ) )
      .concat( ( isCaliforniaTaxable() ? " is California taxable;": 
               " is not California taxable;" ) );
  }*/
  //import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
