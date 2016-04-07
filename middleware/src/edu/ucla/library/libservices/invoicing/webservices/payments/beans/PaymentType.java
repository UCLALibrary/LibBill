package edu.ucla.library.libservices.invoicing.webservices.payments.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType
@XmlAccessorType( XmlAccessType.FIELD )
public class PaymentType
{
  @XmlElement( name = "paymentTypeID" )
  private int paymentTypeID;
  @XmlElement( name = "paymentTypeName" )
  private String paymentType;

  public PaymentType()
  {
    super();
  }

  public void setPaymentTypeID( int paymentTypeID )
  {
    this.paymentTypeID = paymentTypeID;
  }

  public int getPaymentTypeID()
  {
    return paymentTypeID;
  }

  public void setPaymentType( String paymentType )
  {
    this.paymentType = paymentType;
  }

  public String getPaymentType()
  {
    return paymentType;
  }
}
