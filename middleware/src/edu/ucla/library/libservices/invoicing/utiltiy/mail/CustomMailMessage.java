package edu.ucla.library.libservices.invoicing.utiltiy.mail;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
//import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "mailMessage")
@XmlAccessorType( XmlAccessType.FIELD )
public class CustomMailMessage
{
  @XmlElement( name = "invoiceNo" )
  private String invoiceNo;
  @XmlElement( name = "message" )
  private String message;
  
  public CustomMailMessage()
  {
    super();
  }

  public void setMessage( String message )
  {
    this.message = message;
  }

  public String getMessage()
  {
    return message;
  }

  public void setInvoiceNo( String invoiceNo )
  {
    this.invoiceNo = invoiceNo;
  }

  public String getInvoiceNo()
  {
    return invoiceNo;
  }
}
