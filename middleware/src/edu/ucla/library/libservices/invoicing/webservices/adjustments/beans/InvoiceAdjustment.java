package edu.ucla.library.libservices.invoicing.webservices.adjustments.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType(name = "invoiceAdjustment")
@XmlAccessorType( XmlAccessType.FIELD )
public class InvoiceAdjustment
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "createdDate", required = false )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;
  @XmlElement( name = "adjustmentAmount", required = false )
  private double adjustmentAmount;
  @XmlElement( name = "adjustmentType" )
  private String adjustmentType;
  @XmlElement( name = "adjustmentReason", required = false )
  private String adjustmentReason;

  public InvoiceAdjustment()
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

  public void setAdjustmentAmount( double adjustmentAmount )
  {
    this.adjustmentAmount = adjustmentAmount;
  }

  public double getAdjustmentAmount()
  {
    return adjustmentAmount;
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
}
