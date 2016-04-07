package edu.ucla.library.libservices.invoicing.webservices.adjustments.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType(name = "lineItemAdjustment")
@XmlAccessorType( XmlAccessType.FIELD )
public class LineItemAdjustment
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "lineNumber" )
  private int lineNumber;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "createdDate", required = false )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;
  @XmlElement( name = "amount" )
  private double amount;
  @XmlElement( name = "adjustmentType" )
  private String adjustmentType;
  @XmlElement( name = "adjustmentReason" )
  private String adjustmentReason;
  @XmlElement( name = "taxable", required = false )
  private boolean taxable;

  public LineItemAdjustment()
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

  public void setAmount( double amount )
  {
    this.amount = amount;
  }

  public double getAmount()
  {
    return amount;
  }

  public void setAdjustmentType( String adjustmentType )
  {
    this.adjustmentType = adjustmentType;
  }

  public String getAdjustmentType()
  {
    return adjustmentType;
  }

  public void setAdjustmentReason( String adjustmentReason )
  {
    this.adjustmentReason = adjustmentReason;
  }

  public String getAdjustmentReason()
  {
    return adjustmentReason;
  }

  public void setTaxable( boolean taxable )
  {
    this.taxable = taxable;
  }

  public boolean isTaxable()
  {
    return taxable;
  }
}
