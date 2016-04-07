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
public class InsertHeaderBean
{
  @XmlElement( name = "branchCode" )
  private String branchCode;
  @XmlElement( name = "invoiceDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date invoiceDate;
  @XmlElement( name = "status" )
  private String status;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "patronID" )
  private int patronID;
  @XmlElement( name = "onPremises" )
  private String onPremises;

  public InsertHeaderBean()
  {
    super();
  }

  public void setBranchCode( String locationCode )
  {
    this.branchCode = locationCode;
  }

  public String getBranchCode()
  {
    return branchCode;
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

  public void setOnPremises( String onPremises )
  {
    this.onPremises = onPremises;
  }

  public String getOnPremises()
  {
    return onPremises;
  }
}
