package edu.ucla.library.libservices.invoicing.webservices.status.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType
@XmlAccessorType( XmlAccessType.FIELD )
public class InvoiceStatus
{
  @XmlElement( name = "status" )
  private String status;

  public InvoiceStatus()
  {
    super();
  }

  public void setStatus( String status )
  {
    this.status = status;
  }

  public String getStatus()
  {
    return status;
  }
  
  public String toString()
  {
    return "status = " + getStatus();
  }
}
