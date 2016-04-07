package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlRootElement( name = "invoice" )
@XmlAccessorType( XmlAccessType.FIELD )
public class InvoiceHeaderBean
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "invoiceDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date invoiceDate;
  @XmlElement( name = "status", required = false )
  private String status;
  @XmlElement( name = "totalAmount", required = false )
  private double totalAmount;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "patronID" )
  private int patronID;
  @XmlElement( name = "balanceDue" )
  private double balanceDue;
  @XmlElement( name = "onPremises" )
  private String onPremises;
  @XmlElement( name = "totalTax", required = false )
  private double totalTax;
  @XmlElement( name = "lineItemTotal", required = false )
  private double lineItemTotal;
  @XmlElement( name = "taxableTotal", required = false )
  private double taxableTotal;
  @XmlElement( name = "nontaxableTotal", required = false )
  private double nontaxableTotal;
  @XmlElement( name = "createdDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;
  @XmlElement( name = "departmentNumber" )
  private String departmentNumber;
  @XmlElement( name = "locationName" )
  private String locationName;
  @XmlElement( name = "phoneNumber" )
  private String phoneNumber;

  public InvoiceHeaderBean()
  {
    super();
  }

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  public String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  public void setInvoiceDate( Date invoiceDate )
  {
    this.invoiceDate = invoiceDate;
  }

  public Date getInvoiceDate()
  {
    return invoiceDate;
  }

  public void setStatus( String status )
  {
    this.status = status;
  }

  public String getStatus()
  {
    return status;
  }

  public void setTotalAmount( double totalAmount )
  {
    this.totalAmount = totalAmount;
  }

  public double getTotalAmount()
  {
    return totalAmount;
  }

  public void setCreatedBy( String createdBy )
  {
    this.createdBy = createdBy;
  }

  public String getCreatedBy()
  {
    return createdBy;
  }

  public void setPatronID( int patronID )
  {
    this.patronID = patronID;
  }

  public int getPatronID()
  {
    return patronID;
  }

  public void setBalanceDue( double balanceDue )
  {
    this.balanceDue = balanceDue;
  }

  public double getBalanceDue()
  {
    return balanceDue;
  }

  public void setOnPremises( String onPremises )
  {
    this.onPremises = onPremises;
  }

  public String getOnPremises()
  {
    return onPremises;
  }

  public void setLineItemTotal( double lineItemTotal )
  {
    this.lineItemTotal = lineItemTotal;
  }

  public double getLineItemTotal()
  {
    return lineItemTotal;
  }

  public void setTaxableTotal( double taxableTotal )
  {
    this.taxableTotal = taxableTotal;
  }

  public double getTaxableTotal()
  {
    return taxableTotal;
  }

  public void setNontaxableTotal( double nontaxableTotal )
  {
    this.nontaxableTotal = nontaxableTotal;
  }

  public double getNontaxableTotal()
  {
    return nontaxableTotal;
  }

  public void setCreatedDate( Date created_date )
  {
    this.createdDate = created_date;
  }

  public Date getCreatedDate()
  {
    return createdDate;
  }

  public void setDepartmentNumber( String departmentNumber )
  {
    this.departmentNumber = departmentNumber;
  }

  public String getDepartmentNumber()
  {
    return departmentNumber;
  }

  public void setLocationName( String locationName )
  {
    this.locationName = locationName;
  }

  public String getLocationName()
  {
    return locationName;
  }

  public void setPhoneNumber( String phoneNumber )
  {
    this.phoneNumber = phoneNumber;
  }

  public String getPhoneNumber()
  {
    return phoneNumber;
  }

  public void setTotalTax( double totalTax )
  {
    this.totalTax = totalTax;
  }

  public double getTotalTax()
  {
    return totalTax;
  }
}
  /*@XmlElement( name = "cityTax", required = false )
  private double cityTax;
  @XmlElement( name = "countyTax", required = false )
  private double countyTax;
  @XmlElement( name = "stateTax", required = false )
  private double stateTax;

  public void setCityTax( double cityTax )
  {
    this.cityTax = cityTax;
  }

  public double getCityTax()
  {
    return cityTax;
  }

  public void setCountyTax( double countyTax )
  {
    this.countyTax = countyTax;
  }

  public double getCountyTax()
  {
    return countyTax;
  }

  public void setStateTax( double stateTax )
  {
    this.stateTax = stateTax;
  }

  public double getStateTax()
  {
    return stateTax;
  }
*/
