package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;

import java.util.List;

public class PdfInvoice
{
  private InvoiceHeaderBean header;
  private PatronBean patron;
  private List<Payment> payments;
  private List<InvoiceNote> invoiceNotes;
  private List<InvoiceAdjustment> invoiceAdjustments;
  private List<InvoiceEntry> lines;
  
  public PdfInvoice()
  {
    super();
    header = null;
    patron = null;
    payments = null;
    invoiceNotes = null;
    invoiceAdjustments = null;
    lines = null;
  }

  public void setHeader( InvoiceHeaderBean header )
  {
    this.header = header;
  }

  public InvoiceHeaderBean getHeader()
  {
    return header;
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

  public void setInvoiceNotes( List<InvoiceNote> invoiceNotes )
  {
    this.invoiceNotes = invoiceNotes;
  }

  public List<InvoiceNote> getInvoiceNotes()
  {
    return invoiceNotes;
  }

  public void setInvoiceAdjustments( List<InvoiceAdjustment> invoiceAdjustments )
  {
    this.invoiceAdjustments = invoiceAdjustments;
  }

  public List<InvoiceAdjustment> getInvoiceAdjustments()
  {
    return invoiceAdjustments;
  }

  public void setLines( List<InvoiceEntry> lines )
  {
    this.lines = lines;
  }

  public List<InvoiceEntry> getLines()
  {
    return lines;
  }
}
