package edu.ucla.library.libservices.invoicing.webservices.invoices.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.generator.InvoiceAdjustmentGenerator;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceEntry;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceHeaderBean;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.PdfInvoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.InvoiceEntryMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.InvoiceHeaderMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.InvoiceNoteMapper;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.generator.PatronGenerator;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;
import edu.ucla.library.libservices.invoicing.webservices.payments.generator.PaymentGenerator;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class PdfInvoiceGenerator
{
  private static final String GET_INVOICE =
    //"SELECT * FROM invoice_owner.invoice_vw WHERE lower(invoice_number) = ?";
    "SELECT * FROM invoice_vw WHERE lower(invoice_number) = ?";
  private static final String GET_INV_NOTES =
    //"SELECT * FROM invoice_owner.invoice_note_vw WHERE lower(invoice_number)" 
    "SELECT * FROM invoice_note_vw WHERE lower(invoice_number)" 
    + " = ? AND internal = 'N' ORDER BY sequence_number";
  private static final String GET_LINES = 
    //"SELECT * FROM invoice_owner.invoice_line_full_vw WHERE " 
    "SELECT * FROM invoice_line_full_vw WHERE " 
    + "lower(invoice_number) = ? ORDER BY invoice_number,service_name," 
    + "subtype_name,line_number,line_type";
  
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private PdfInvoice invoice;
  private String dbName;
  private String invoiceNumber;
  private String almaKey;
  private String almaURI;
  private String patronPrimaryID;

  public PdfInvoiceGenerator()
  {
    super();
  }

  public void setInvoice( PdfInvoice invoice )
  {
    this.invoice = invoice;
  }

  public PdfInvoice getInvoice()
  {
    makeConnection();
    invoice = new PdfInvoice();
    invoice.setHeader( populateHeader() );
    invoice.setPatron( populatePatron( invoice.getHeader().getPatronID() ) );
    //invoice.setPatron( populatePatron( invoice.getHeader().getPatronPrimaryID() ) );
    invoice.setPayments( populatePayments() );
    invoice.setInvoiceNotes( populateInvoiceNotes() );
    invoice.setInvoiceAdjustments( populateInvoiceAdjustments() );
    invoice.setLines( populateLines() );
    return invoice;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  private String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  private void makeConnection()
  {
    //ds = DataSourceFactory.createDataSource( getDbName() );
    ds = DataSourceFactory.createBillSource();
  }

  private InvoiceHeaderBean populateHeader()
  {
    return ( InvoiceHeaderBean ) new JdbcTemplate( ds ).query( 
      GET_INVOICE, new Object[] { getInvoiceNumber().toLowerCase() }, 
      new InvoiceHeaderMapper() ).get( 0 );
  }

  private PatronBean populatePatron( int patronID )
  {
    PatronGenerator generator;
    generator = new PatronGenerator();
    generator.setPatronID( patronID );
    generator.setDbName( getDbName() );
    return generator.getThePatronByID();
  }

  private PatronBean populatePatron( String barcode )
  {
    PatronGenerator generator;

    generator = new PatronGenerator();

    generator.setBarcode(barcode);
    generator.setAlmaKey(getAlmaKey());
    generator.setAlmaURI(getAlmaURI());
    return generator.getPatronFromAlma();
  }

  private List<Payment> populatePayments()
  {
    PaymentGenerator generator;
    generator = new PaymentGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );
    return generator.getPayments();
  }

  private List<InvoiceNote> populateInvoiceNotes()
  {
    return new JdbcTemplate( ds ).query( GET_INV_NOTES, new Object[]
        { getInvoiceNumber().toLowerCase() }, new InvoiceNoteMapper() );
  }

  private List<InvoiceAdjustment> populateInvoiceAdjustments()
  {
    InvoiceAdjustmentGenerator generator;
    generator = new InvoiceAdjustmentGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );
    return generator.getAdjustments();
  }

  private List<InvoiceEntry> populateLines()
  {
    return new JdbcTemplate( ds ).query( GET_LINES, new Object[]
        { getInvoiceNumber().toLowerCase() }, new InvoiceEntryMapper() );
  }

  public void setAlmaKey(String almaKey)
  {
    this.almaKey = almaKey;
  }

  public String getAlmaKey()
  {
    return almaKey;
  }

  public void setAlmaURI(String almaURI)
  {
    this.almaURI = almaURI;
  }

  public String getAlmaURI()
  {
    return almaURI;
  }

  public void setPatronPrimaryID(String patronPrimaryID)
  {
    this.patronPrimaryID = patronPrimaryID;
  }

  public String getPatronPrimaryID()
  {
    return patronPrimaryID;
  }
}
