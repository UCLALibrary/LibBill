package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType(name = "lineItem")
@XmlAccessorType( XmlAccessType.FIELD )
public class DisplayLineItem
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "branchServiceID" )
  private int branchServiceID;
  @XmlElement( name = "quantity" )
  private double quantity;
  @XmlElement( name = "unitPrice" )
  private double unitPrice;
  @XmlElement( name = "lineNumber" )
  private int lineNumber;
  @XmlElement( name = "branchName" )
  private String branchName;
  @XmlElement( name = "serviceSubtype" )
  private String serviceSubtype;
  @XmlElement( name = "service" )
  private String service;
  @XmlElement( name = "totalPrice" )
  private double totalPrice;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "createdDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;
  @XmlElement( name = "unitMeasure" )
  private String unitMeasure;
  @XmlElement( name = "requireCustomPrice" )
  private boolean requireCustomPrice;
  @XmlElement( name = "itemCode" )
  private String itemCode;
  @XmlElement( name = "ucMinimum" )
  private double ucMinimum;
  @XmlElement( name = "nonUcMinimum" )
  private double nonUcMinimum;

  public DisplayLineItem()
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

  public void setBranchServiceID( int branchServiceID )
  {
    this.branchServiceID = branchServiceID;
  }

  public int getBranchServiceID()
  {
    return branchServiceID;
  }

  public void setQuantity( double quantity )
  {
    this.quantity = quantity;
  }

  public double getQuantity()
  {
    return quantity;
  }

  public void setUnitPrice( double unitPrice )
  {
    this.unitPrice = unitPrice;
  }

  public double getUnitPrice()
  {
    return unitPrice;
  }

  public void setLineNumber( int lineNumber )
  {
    this.lineNumber = lineNumber;
  }

  public int getLineNumber()
  {
    return lineNumber;
  }

  public void setBranchName( String branchName )
  {
    this.branchName = branchName;
  }

  public String getBranchName()
  {
    return branchName;
  }

  public void setServiceSubtype( String serviceSubtype )
  {
    this.serviceSubtype = serviceSubtype;
  }

  public String getServiceSubtype()
  {
    return serviceSubtype;
  }

  public void setService( String service )
  {
    this.service = service;
  }

  public String getService()
  {
    return service;
  }

  public void setTotalPrice( double totalPrice )
  {
    this.totalPrice = totalPrice;
  }

  public double getTotalPrice()
  {
    return totalPrice;
  }

  public void setCreatedBy( String createdBy )
  {
    this.createdBy = createdBy;
  }

  public String getCreatedBy()
  {
    return createdBy;
  }

  public void setCreatedDate( Date createdDate )
  {
    this.createdDate = createdDate;
  }

  public Date getCreatedDate()
  {
    return createdDate;
  }

  public void setUnitMeasure( String unitMeasure )
  {
    this.unitMeasure = unitMeasure;
  }

  public String getUnitMeasure()
  {
    return unitMeasure;
  }

  public void setRequireCustomPrice( boolean requireCustomPrice )
  {
    this.requireCustomPrice = requireCustomPrice;
  }

  public boolean getRequireCustomPrice()
  {
    return requireCustomPrice;
  }

  public void setItemCode( String itemCode )
  {
    this.itemCode = itemCode;
  }

  public String getItemCode()
  {
    return itemCode;
  }

  public void setUcMinimum( double ucMinimum )
  {
    this.ucMinimum = ucMinimum;
  }

  public double getUcMinimum()
  {
    return ucMinimum;
  }

  public void setNonUcMinimum( double nonUcMinimum )
  {
    this.nonUcMinimum = nonUcMinimum;
  }

  public double getNonUcMinimum()
  {
    return nonUcMinimum;
  }
}
