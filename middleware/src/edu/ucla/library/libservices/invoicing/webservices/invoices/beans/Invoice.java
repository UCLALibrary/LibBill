package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.LineItemAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement( name = "singleInvoice" )
@XmlAccessorType( XmlAccessType.FIELD )
public class Invoice
{
  @XmlElement
  private InvoiceHeaderBean header;
  @XmlElement(name = "lineItem")
  private List<DisplayLineItem> lineItems;
  @XmlElement
  private PatronBean patron;
  @XmlElement(name = "payment")
  private List<Payment> payments;
  @XmlElement(name = "lineAdjustment")
  private List<LineItemAdjustment> lineAdjustments;
  @XmlElement(name = "invoiceNote")
  private List<InvoiceNote> invoiceNotes;
  @XmlElement(name = "lineNote")
  private List<LineItemNote> lineNotes;
  @XmlElement(name = "invoiceAdjustment")
  private List<InvoiceAdjustment> invoiceAdjustments;
  
  public Invoice()
  {
    super();
  }

  public void setHeader( InvoiceHeaderBean header )
  {
    this.header = header;
  }

  public InvoiceHeaderBean getHeader()
  {
    return header;
  }

  public void setLineItems( List<DisplayLineItem> lineItems )
  {
    this.lineItems = lineItems;
  }

  public List<DisplayLineItem> getLineItems()
  {
    return lineItems;
  }

  public void setPatron( PatronBean patron )
  {
    this.patron = patron;
  }

  public PatronBean getPatron()
  {
    return patron;
  }

  public void setPayments( List<Payment> payments )
  {
    this.payments = payments;
  }

  public List<Payment> getPayments()
  {
    return payments;
  }

  public void setLineAdjustments( List<LineItemAdjustment> lineAdjustments )
  {
    this.lineAdjustments = lineAdjustments;
  }

  public List<LineItemAdjustment> getLineAdjustments()
  {
    return lineAdjustments;
  }

  public void setInvoiceNotes( List<InvoiceNote> invoiceNotes )
  {
    this.invoiceNotes = invoiceNotes;
  }

  public List<InvoiceNote> getInvoiceNotes()
  {
    return invoiceNotes;
  }

  public void setLineNotes( List<LineItemNote> lineNotes )
  {
    this.lineNotes = lineNotes;
  }

  public List<LineItemNote> getLineNotes()
  {
    return lineNotes;
  }

  public void setInvoiceAdjustments( List<InvoiceAdjustment> invoiceAdjustments )
  {
    this.invoiceAdjustments = invoiceAdjustments;
  }

  public List<InvoiceAdjustment> getInvoiceAdjustments()
  {
    return invoiceAdjustments;
  }
}
