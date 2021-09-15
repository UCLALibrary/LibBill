package edu.ucla.library.libservices.invoicing.webservices.invoices.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.LineItemAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.generator.InvoiceAdjustmentGenerator;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.generator.LineItemAdjustmentGenerator;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.CashNetInvoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.DisplayLineItem;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.Invoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceHeaderBean;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.SimpleHeader;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.CashNetLineMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.DisplayLineItemMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.InvoiceHeaderMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.InvoiceNoteMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.LineItemNoteMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.SimpleHeaderMapper;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.generator.PatronGenerator;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;
import edu.ucla.library.libservices.invoicing.webservices.payments.generator.PaymentGenerator;

import java.io.UnsupportedEncodingException;

import java.net.URLDecoder;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "multipleInvoices" )
public class InvoiceGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private Invoice invoice;
  //private ArrayList<SimpleHeader> simpleInvoices;
  private SimpleHeader simpleInvoice;
  private CashNetInvoice cnInvoice;
  @XmlElement( name = "invoice" )
  private List<Invoice> multipleInvoices;
  private String dbName;
  private String invoiceNumber;
  private int patronID;
  private String patronPrimaryID;
  private String almaKey;
  private String almaURI;
  private double invoiceTotal;
  private double totalLow;
  private double totalHigh;
  private String startDate;
  private String endDate;
  private String note;

  private static final String GET_INVOICE =
    //"SELECT * FROM invoice_owner.invoice_vw WHERE lower(invoice_number) = ?";
    "SELECT * FROM invoice_vw WHERE lower(invoice_number) = ?";

  private static final String GET_NOS_BY_PATRON =
    //"SELECT invoice_number FROM invoice_owner.invoice_vw WHERE patron_id = ?";
    "SELECT invoice_number FROM invoice_vw WHERE patron_id = ?";
    //"SELECT invoice_number FROM invoice_vw WHERE patron_primary_id = ?";
  private static final String GET_NOS_BY_TOTAL =
    //"SELECT invoice_number FROM invoice_owner.invoice_vw WHERE total_amount = ?";
    "SELECT invoice_number FROM invoice_vw WHERE total_amount = ?";
  private static final String GET_NOS_BY_TOTAL_RANGE =
    //"SELECT invoice_number FROM invoice_owner.invoice_vw WHERE " +
    "SELECT invoice_number FROM invoice_vw WHERE " +
    "total_amount between ? and ?";
  private static final String GET_NOS_BY_CREATE =
    //"SELECT invoice_number FROM invoice_owner.invoice_vw WHERE " +
    "SELECT invoice_number FROM invoice_vw WHERE " +
    "trunc(created_date) = trunc(to_date(?,'YYYY-MM-DD'))";
  private static final String GET_NOS_BY_CREATE_RANGE =
    //"SELECT invoice_number FROM invoice_owner.invoice_vw WHERE " +
    "SELECT invoice_number FROM invoice_vw WHERE " +
    "trunc(created_date) between trunc(to_date(?,'YYYY-MM-DD')) and " +
    "trunc(to_date(?,'YYYY-MM-DD'))";
  private static final String GET_NOS_BY_NOTES =
    //"SELECT DISTINCT iv.invoice_number FROM invoice_owner.invoice_vw iv INNER JOIN invoice_owner.invoice_note_vw inv ON iv.invoice_number = inv.invoice_number WHERE lower(inv.note) LIKE ? UNION SELECT DISTINCT iv.invoice_number FROM invoice_owner.invoice_vw iv INNER JOIN invoice_owner.line_item_note_vw linv ON iv.invoice_number = linv.invoice_number WHERE lower(linv.note) LIKE ?";
    "SELECT DISTINCT iv.invoice_number FROM invoice_vw iv " +
    "INNER JOIN invoice_note_vw inv ON iv.invoice_number = " +
    "inv.invoice_number WHERE lower(inv.note) LIKE ? UNION SELECT DISTINCT " +
    "iv.invoice_number FROM invoice_vw iv INNER JOIN " +
    "line_item_note_vw linv ON iv.invoice_number = " +
    "linv.invoice_number WHERE lower(linv.note) LIKE ?";
  private static final String GET_NOS_BY_INV_NOTE =
    //"SELECT DISTINCT iv.invoice_number FROM invoice_owner.invoice_vw iv INNER JOIN invoice_owner.invoice_note_vw inv ON iv.invoice_number = inv.invoice_number WHERE lower(inv.note) LIKE ?";
    "SELECT DISTINCT iv.invoice_number FROM invoice_vw iv " +
    "INNER JOIN invoice_note_vw inv ON iv.invoice_number = " +
    "inv.invoice_number WHERE lower(inv.note) LIKE ?";
  private static final String GET_NOS_BY_LINE_NOTE =
    //"SELECT DISTINCT iv.invoice_number FROM invoice_owner.invoice_vw iv INNER JOIN invoice_owner.line_item_note_vw linv ON iv.invoice_number = linv.invoice_number WHERE lower(linv.note) LIKE ?";
    "SELECT DISTINCT iv.invoice_number FROM invoice_vw iv " +
    "INNER JOIN line_item_note_vw linv ON iv.invoice_number " +
    "= linv.invoice_number WHERE lower(linv.note) LIKE ?";
  //private static final String GET_UNPAID_INVOICES = "SELECT * FROM invoice_vw WHERE patron_id = ? AND status IN ('Partially Paid','Unpaid') ORDER BY invoice_number";

  private static final String GET_LINE_ITEMS =
    //"SELECT * FROM invoice_owner.invoice_line_vw WHERE lower(invoice_number) = ? " +
    "SELECT i.*, l.item_code FROM invoice_line_vw i INNER JOIN " 
    + "location_service_vw l ON i.location_service_id = l.location_service_id" 
    + " WHERE lower(i.invoice_number) = ? ORDER BY i.line_number";
  private static final String GET_CASHNET_LINES = 
    "SELECT * FROM line_item_code_vw WHERE lower(invoice_number) = ? and " 
    + "total_price <> 0 ORDER BY item_code";
  private static final String GET_INV_NOTES =
    //"SELECT * FROM invoice_owner.invoice_note_vw WHERE lower(invoice_number) = ? " +
    "SELECT * FROM invoice_note_vw WHERE lower(invoice_number) = ? " +
    "ORDER BY sequence_number";

  private static final String GET_LINE_NOTES =
    //"SELECT * FROM invoice_owner.line_item_note_vw WHERE lower(invoice_number) = ? " +
    "SELECT * FROM line_item_note_vw WHERE lower(invoice_number) = ? " +
    "ORDER BY line_number, sequence_number";

  public InvoiceGenerator()
  {
    super();
  }

  public Invoice getInvoice()
  {
    makeConnection();
    invoice = new Invoice();
    invoice.setHeader( populateHeader() );
    invoice.setPatron( populatePatron( invoice.getHeader().getPatronID() ) );
    //invoice.setPatron( populatePatron( invoice.getHeader().getPatronPrimaryID() ) );
    invoice.setLineItems( populateLineItems() );
    invoice.setPayments( populatePayments() );
    invoice.setLineAdjustments( populateLineAdjustments() );
    invoice.setInvoiceNotes( populateInvoiceNotes() );
    invoice.setLineNotes( populateLineNotes() );
    invoice.setInvoiceAdjustments( populateInvoiceAdjustments() );
    return invoice;
  }

  public void getInvoicesByPatron()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_PATRON,
                                             new Object[]
          { getPatronID() }, String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByTotal()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_TOTAL, new Object[]
          { getInvoiceTotal() }, String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByTotalRange()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_TOTAL_RANGE,
                                             new Object[]
          { getTotalLow(), getTotalHigh() }, String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByOneDate()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_CREATE,
                                             new Object[]
          { getStartDate() }, String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByDateRange()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_CREATE_RANGE,
                                             new Object[]
          { getStartDate(), getEndDate() }, String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByNote()
    throws UnsupportedEncodingException
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_NOTES, new Object[]
          { "%".concat( URLDecoder.decode( getNote(),
                                           "utf-8" ) ).concat( "%" ).toLowerCase(),
            "%".concat( URLDecoder.decode( getNote(),
                                           "utf-8" ) ).concat( "%" ).toLowerCase() },
          String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByInvNote()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_INV_NOTE,
                                             new Object[]
          { "%".concat( getNote() ).concat( "%" ).toLowerCase() },
          String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  public void getInvoicesByLineNote()
  {
    List<String> invoiceNumbers;

    makeConnection();

    invoiceNumbers =
        new JdbcTemplate( ds ).queryForList( GET_NOS_BY_LINE_NOTE,
                                             new Object[]
          { "%".concat( getNote() ).concat( "%" ).toLowerCase() },
          String.class );

    multipleInvoices = new ArrayList<Invoice>();
    for ( String theNo: invoiceNumbers )
    {
      this.setInvoiceNumber( theNo );
      multipleInvoices.add( getInvoice() );
    }
  }

  private InvoiceHeaderBean populateHeader()
  {
    return ( InvoiceHeaderBean ) new JdbcTemplate( ds ).query( GET_INVOICE,
                                                               new Object[]
        { getInvoiceNumber().toLowerCase() },
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

  private List<DisplayLineItem> populateLineItems()
  {
    return new JdbcTemplate( ds ).query( GET_LINE_ITEMS, new Object[]
        { getInvoiceNumber().toLowerCase() },
        new DisplayLineItemMapper() );
  }

  private List<Payment> populatePayments()
  {
    PaymentGenerator generator;
    generator = new PaymentGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );
    return generator.getPayments();
  }

  private List<LineItemAdjustment> populateLineAdjustments()
  {
    LineItemAdjustmentGenerator generator;
    generator = new LineItemAdjustmentGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );
    return generator.getLineAdjustments();
  }

  private List<InvoiceNote> populateInvoiceNotes()
  {
    return new JdbcTemplate( ds ).query( GET_INV_NOTES, new Object[]
        { getInvoiceNumber().toLowerCase() }, new InvoiceNoteMapper() );
  }

  private List<LineItemNote> populateLineNotes()
  {
    return new JdbcTemplate( ds ).query( GET_LINE_NOTES, new Object[]
        { getInvoiceNumber().toLowerCase() }, new LineItemNoteMapper() );
  }

  private List<InvoiceAdjustment> populateInvoiceAdjustments()
  {
    InvoiceAdjustmentGenerator generator;
    generator = new InvoiceAdjustmentGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );
    return generator.getAdjustments();
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void setPatronID( int patronID )
  {
    this.patronID = patronID;
  }

  private int getPatronID()
  {
    return patronID;
  }

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  private String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  public void setInvoiceTotal( double invoiceTotal )
  {
    this.invoiceTotal = invoiceTotal;
  }

  private double getInvoiceTotal()
  {
    return invoiceTotal;
  }

  public void setStartDate( String startDate )
  {
    this.startDate = startDate;
  }

  private String getStartDate()
  {
    return startDate;
  }

  public void setEndDate( String endDate )
  {
    this.endDate = endDate;
  }

  private String getEndDate()
  {
    return endDate;
  }

  public void setTotalLow( double totalLow )
  {
    this.totalLow = totalLow;
  }

  private double getTotalLow()
  {
    return totalLow;
  }

  public void setTotalHigh( double totalHigh )
  {
    this.totalHigh = totalHigh;
  }

  private double getTotalHigh()
  {
    return totalHigh;
  }

  public void setNote( String note )
  {
    this.note = note;
  }

  private String getNote()
  {
    return note;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public SimpleHeader getSimpleInvoice()
  {
    makeConnection();

    simpleInvoice =
        ( SimpleHeader ) new JdbcTemplate( ds ).queryForObject( GET_INVOICE,
                                                                new Object[]
          { getInvoiceNumber().toLowerCase() }, new SimpleHeaderMapper() );
    return simpleInvoice;
  }

  public CashNetInvoice getCnInvoice()
  {
    makeConnection();
    
    cnInvoice = new CashNetInvoice();
    cnInvoice.setInvoiceNumber( getInvoiceNumber() );
    cnInvoice.setLineItems( new JdbcTemplate( ds ).query( GET_CASHNET_LINES,
                                                          new Object[]
          { getInvoiceNumber().toLowerCase() },
          new CashNetLineMapper() ) );

    return cnInvoice;
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
