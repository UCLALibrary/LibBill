package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlRootElement( name = "lineItem" )
@XmlAccessorType( XmlAccessType.FIELD )
public class LineItemBean
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "branchServiceID" )
  private int branchServiceID;
  @XmlElement( name = "quantity" )
  private double quantity;
  @XmlElement( name = "unitPrice", required = false )
  private double unitPrice;
  @XmlElement( name = "lineNumber", required = false )
  private int lineNumber;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "createdDate", required = false )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;

  public LineItemBean()
  {
    super();
  }

  public void setQuantity( double quantity )
  {
    this.quantity = quantity;
  }

  public double getQuantity()
  {
    return quantity;
  }

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  public String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  public void setUnitPrice( double unitPrice )
  {
    this.unitPrice = unitPrice;
  }

  public double getUnitPrice()
  {
    return unitPrice;
  }

  public void setBranchServiceID( int branchServiceID )
  {
    this.branchServiceID = branchServiceID;
  }

  public int getBranchServiceID()
  {
    return branchServiceID;
  }

  public void setLineNumber( int lineNumber )
  {
    this.lineNumber = lineNumber;
  }

  public int getLineNumber()
  {
    return lineNumber;
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
}
