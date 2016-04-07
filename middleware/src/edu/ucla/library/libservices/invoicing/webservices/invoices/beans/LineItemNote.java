package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;

import java.util.Date;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType(name = "lineNote")
@XmlAccessorType( XmlAccessType.FIELD )
public class LineItemNote
{
  @XmlElement( name = "invoiceNumber" )
  private String invoiceNumber;
  @XmlElement( name = "lineNumber" )
  private int lineNumber;
  @XmlElement( name = "sequenceNumber", required = false )
  private int sequenceNumber;
  @XmlElement( name = "internal" )
  private boolean internal;
  @XmlElement( name = "createdBy" )
  private String createdBy;
  @XmlElement( name = "createdDate", required = false )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date createdDate;
  @XmlElement( name = "note" )
  private String note;

  public LineItemNote()
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

  public void setSequenceNumber( int sequenceNumber )
  {
    this.sequenceNumber = sequenceNumber;
  }

  public int getSequenceNumber()
  {
    return sequenceNumber;
  }

  public void setInternal( boolean internal )
  {
    this.internal = internal;
  }

  public boolean isInternal()
  {
    return internal;
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

  public void setNote( String note )
  {
    this.note = note;
  }

  public String getNote()
  {
    return note;
  }
}
