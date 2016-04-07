package edu.ucla.library.libservices.invoicing.webservices.taxes.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType(name = "taxRate")
@XmlAccessorType( XmlAccessType.FIELD )
public class TaxRate
{
  @XmlElement( name = "rateID" )
  private int rateID;
  @XmlElement( name = "rateName" )
  private String rateName;
  @XmlElement( name = "rate" )
  private double rate;
  @XmlElement( name = "startDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date startDate;
  @XmlElement( name = "endDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date endDate;
  @XmlElement( name = "whoBy" )
  private String whoBy;

  public TaxRate()
  {
    super();
  }

  public void setRateID( int rateID )
  {
    this.rateID = rateID;
  }

  public int getRateID()
  {
    return rateID;
  }

  public void setRateName( String rateName )
  {
    this.rateName = rateName;
  }

  public String getRateName()
  {
    return rateName;
  }

  public void setRate( double rate )
  {
    this.rate = rate;
  }

  public double getRate()
  {
    return rate;
  }

  public void setStartDate( Date startDate )
  {
    this.startDate = startDate;
  }

  public Date getStartDate()
  {
    return startDate;
  }

  public void setEndDate( Date endDate )
  {
    this.endDate = endDate;
  }

  public Date getEndDate()
  {
    return endDate;
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
