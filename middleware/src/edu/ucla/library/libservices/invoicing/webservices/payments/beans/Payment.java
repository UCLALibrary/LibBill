package edu.ucla.library.libservices.invoicing.webservices.payments.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType( name = "payment" )
@XmlAccessorType( XmlAccessType.FIELD )
public class Payment
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "amount" )
  private double amount;
  @XmlElement( name = "paymentDate", required = false )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date paymentDate;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "paymentType", required = false )
  private String paymentType;
  @XmlElement( name = "paymentTypeID" )
  private int paymentTypeID;
  @XmlElement( name = "checkNote", required = false )
  private String checkNote;

  public Payment()
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

  public void setAmount( double amount )
  {
    this.amount = amount;
  }

  public double getAmount()
  {
    return amount;
  }

  public void setPaymentDate( Date paymentDate )
  {
    this.paymentDate = paymentDate;
  }

  public Date getPaymentDate()
  {
    return paymentDate;
  }

  public void setCreatedBy( String createdBy )
  {
    this.createdBy = createdBy;
  }

  public String getCreatedBy()
  {
    return createdBy;
  }

  public void setPaymentType( String paymentType )
  {
    this.paymentType = paymentType;
  }

  public String getPaymentType()
  {
    return paymentType;
  }

  public void setPaymentTypeID( int paymentTypeID )
  {
    this.paymentTypeID = paymentTypeID;
  }

  public int getPaymentTypeID()
  {
    return paymentTypeID;
  }

  public String toString()
  {
    return "invoice = " + getInvoiceNumber() + "\ttype = " +
      getPaymentType() + "\tamount = " + getAmount();
  }

  public void setCheckNote( String checkNote )
  {
    this.checkNote = checkNote;
  }

  public String getCheckNote()
  {
    return checkNote;
  }
}
