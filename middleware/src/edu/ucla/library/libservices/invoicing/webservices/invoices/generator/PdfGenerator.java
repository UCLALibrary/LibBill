package edu.ucla.library.libservices.invoicing.webservices.invoices.generator;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.List;
import com.itextpdf.text.ListItem;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;

import com.itextpdf.text.pdf.draw.LineSeparator;

import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceEntry;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.PdfInvoice;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;

import java.io.IOException;

import java.net.MalformedURLException;
import java.net.URL;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

public class PdfGenerator
{
  private String dbName;
  private String invoiceNumber;
  private Paragraph paragraph;
  private PdfInvoiceGenerator generator;
  private PdfInvoice theInvoice;
  private PdfPCell defaultCell;
  private PdfPCell tableCell;
  private PdfPCell numberCell;
  private PdfPTable table;
  private StringBuffer buffer;
  private float[] columnWidths;
  private double adjustTotal = 0D;
  private boolean didAdjustCalc = false;

  private static final SimpleDateFormat DATE_OUTPUT =
    new SimpleDateFormat( "MM/dd/yyyy" );
  private static final DecimalFormat MONEY_OUTPUT =
    new DecimalFormat( "$###########0.00" );
  private static final Font BOLD =
    new Font( Font.getFamily( "Arial-BoldMT" ), 8, Font.BOLD );
  private static final Font HEADER =
    new Font( Font.getFamily( "Arial-BoldMT" ), 14, Font.BOLD );
  private static final Font ITALIC =
    new Font( Font.getFamily( "ArialMT" ), 8, Font.ITALIC );
  private static final Font NORMAL =
    new Font( Font.getFamily( "ArialMT" ), 8, Font.NORMAL );

  public PdfGenerator()
  {
    super();
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

  public void populatePdf( Document document, String uid )
  {
    if ( ContentTests.isLegitInvoice( getInvoiceNumber(), uid, getDbName() ) )
      this.populatePdf( document );
  }

  public void populatePdf( Document document )
  {
    generator = new PdfInvoiceGenerator();
    generator.setInvoiceNumber( getInvoiceNumber() );
    generator.setDbName( getDbName() );

    theInvoice = generator.getInvoice();

    try
    {
      document.open();

      addImage( document );
      addTitle( document );
      addHeader( document );
      addPayment( document );
      addMiddle( document );
      addEntries( document );

      document.add( new LineSeparator( 1F, 100F, BaseColor.BLACK,
                                       Element.ALIGN_MIDDLE, 0F ) );
      columnWidths = new float[]
          { 60f, 20f, 10f, 10f };
      table = new PdfPTable( 4 );
      table.setWidthPercentage( 98 );
      table.setSpacingAfter( 5f );
      table.setWidths( columnWidths );

      defaultCell = table.getDefaultCell();
      defaultCell.setBorder( PdfPCell.NO_BORDER );
      defaultCell.setHorizontalAlignment( Element.ALIGN_LEFT );
      defaultCell.setVerticalAlignment( Element.ALIGN_MIDDLE );

      buffer =
          new StringBuffer( ( !ContentTests.isEmpty( theInvoice.getPatron().getFirstName() ) ?
                            theInvoice.getPatron().getFirstName().trim():
                            "" ) );
      buffer.append( " " ).append( ( !ContentTests.isEmpty( theInvoice.getPatron().getLastName() ) ) ?
                                   theInvoice.getPatron().getLastName().trim():
                                   "" );

      table.addCell( new Paragraph( buffer.toString().trim(), NORMAL ) );
      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( new Paragraph( "NonTaxable:", NORMAL ) );
      numberCell = getRightAlignedCell();
      paragraph =
          new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getNontaxableTotal() ),
                         NORMAL );
      paragraph.setAlignment( Element.ALIGN_RIGHT );
      numberCell.addElement( paragraph );
      table.addCell( numberCell );

      buffer = new StringBuffer();
      for ( InvoiceNote theNote: theInvoice.getInvoiceNotes() )
      {
        if ( !theNote.isInternal() )
          buffer.append( theNote.getNote().trim() ).append( " " );
      }
      tableCell = new PdfPCell();
      tableCell.setBorder( PdfPCell.NO_BORDER );
      tableCell.setHorizontalAlignment( Element.ALIGN_LEFT );
      tableCell.setVerticalAlignment( Element.ALIGN_MIDDLE );
      tableCell.setIndent( 10f );
      paragraph = new Paragraph( buffer.toString().trim(), ITALIC );
      paragraph.setIndentationLeft( 10f );
      tableCell.addElement( paragraph );
      table.addCell( tableCell );
      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( new Paragraph( "Taxable:", NORMAL ) );
      numberCell = getRightAlignedCell();
      paragraph =
          new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getTaxableTotal() ),
                         NORMAL );
      paragraph.setAlignment( Element.ALIGN_RIGHT );
      numberCell.addElement( paragraph );
      table.addCell( numberCell );

      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( new Paragraph( "Tax:", NORMAL ) );
      numberCell = getRightAlignedCell();
      //MONEY_OUTPUT.format( theInvoice.getHeader().getCountyTax() + theInvoice.getHeader().getStateTax() ),
      paragraph = new Paragraph( outputTax(), NORMAL );
      paragraph.setAlignment( Element.ALIGN_RIGHT );
      numberCell.addElement( paragraph );
      table.addCell( numberCell );

      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( new Paragraph( "Adjustments:", NORMAL ) );
      numberCell = getRightAlignedCell();
      paragraph =
          new Paragraph( MONEY_OUTPUT.format( getAdjustTotal() ), NORMAL );
      paragraph.setAlignment( Element.ALIGN_RIGHT );
      numberCell.addElement( paragraph );
      table.addCell( numberCell );

      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( prepEmptyCell( 1 ) );
      table.addCell( new Paragraph( "Amount Due:", NORMAL ) );
      numberCell = getRightAlignedCell();
      paragraph =
          new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getBalanceDue() ),
                         NORMAL );
      paragraph.setAlignment( Element.ALIGN_RIGHT );
      numberCell.addElement( paragraph );
      table.addCell( numberCell );

      document.add( table );

      printFooter( document, paragraph );

      document.close();
    }
    catch ( DocumentException de )
    {
      de.printStackTrace();
      document = null;
    }
    catch ( MalformedURLException mue )
    {
      mue.printStackTrace();
      document = null;
    }
    catch ( IOException ioe )
    {
      ioe.printStackTrace();
      document = null;
    }
  }


  private PdfPTable prepNestedTable( PdfPTable nestedTable )
  {
    nestedTable = new PdfPTable( 2 );
    nestedTable.setWidthPercentage( 98 );

    return nestedTable;
  }

  private PdfPCell prepNestedCell( PdfPTable nestedTable,
                                   PdfPCell defaultNestedCell )
  {
    defaultNestedCell = nestedTable.getDefaultCell();
    defaultNestedCell.setBorder( PdfPCell.NO_BORDER );
    defaultNestedCell.setHorizontalAlignment( Element.ALIGN_LEFT );
    defaultNestedCell.setVerticalAlignment( Element.ALIGN_MIDDLE );

    return defaultNestedCell;
  }

  private String getStreetAddress( PatronBean thePatron )
  {
    if ( !ContentTests.isEmpty( thePatron.getPermAddress1() ) )
    {
      buffer = new StringBuffer( thePatron.getPermAddress1().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermAddress2() ) )
        buffer.append( " " ).append( thePatron.getPermAddress2().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermAddress3() ) )
        buffer.append( " " ).append( thePatron.getPermAddress3().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermAddress4() ) )
        buffer.append( " " ).append( thePatron.getPermAddress4().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermAddress5() ) )
        buffer.append( " " ).append( thePatron.getPermAddress5().trim() );
    }
    else
    {
      if ( !ContentTests.isEmpty( thePatron.getLocalAddress1() ) )
        buffer = new StringBuffer( thePatron.getLocalAddress1().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalAddress2() ) )
        buffer.append( " " ).append( thePatron.getLocalAddress2().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalAddress3() ) )
        buffer.append( " " ).append( thePatron.getLocalAddress3().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalAddress4() ) )
        buffer.append( " " ).append( thePatron.getLocalAddress4().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalAddress5() ) )
        buffer.append( " " ).append( thePatron.getLocalAddress5().trim() );
    }

    return buffer.toString().trim();
  }

  private String getCityStateZip( PatronBean thePatron )
  {
    buffer = new StringBuffer();

    if ( !ContentTests.isEmpty( thePatron.getPermAddress1() ) )
    {
      if ( !ContentTests.isEmpty( thePatron.getPermCity() ) )
        buffer = new StringBuffer( thePatron.getPermCity().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermState() ) )
        buffer.append( " " ).append( thePatron.getPermState().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermZip() ) )
        buffer.append( " " ).append( thePatron.getPermZip().trim() );
      if ( !ContentTests.isEmpty( thePatron.getPermCountry() ) )
        buffer.append( " " ).append( thePatron.getPermCountry().trim() );
    }
    else
    {
      if ( !ContentTests.isEmpty( thePatron.getLocalCity() ) )
        buffer = new StringBuffer( thePatron.getLocalCity().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalState() ) )
        buffer.append( " " ).append( thePatron.getLocalState().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalZip() ) )
        buffer.append( " " ).append( thePatron.getLocalZip().trim() );
      if ( !ContentTests.isEmpty( thePatron.getLocalCountry() ) )
        buffer.append( " " ).append( thePatron.getLocalCountry().trim() );
    }

    return buffer.toString().trim();
  }

  public PdfInvoice getTheInvoice()
  {
    return theInvoice;
  }

  private PdfPCell getRightAlignedCell()
  {
    PdfPCell right;

    right = new PdfPCell();
    right.setBorder( PdfPCell.NO_BORDER );
    right.setHorizontalAlignment( Element.ALIGN_RIGHT );
    right.setVerticalAlignment( Element.ALIGN_MIDDLE );

    return right;
  }

  private void printFooter( Document doc, Paragraph para )
    throws DocumentException
  {
    List list;

    para = new Paragraph( " ", NORMAL );
    para.setAlignment( Element.ALIGN_CENTER );
    para.setSpacingAfter( 5f );
    doc.add( para );

    para =
        new Paragraph( "To pay by check:",
                       NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    doc.add( para );

    list = new List( false, 10 );
    list.setListSymbol( "*" );
    list.add( new ListItem( "Make payable to the Regents of the University of California.  Do not send cash.", NORMAL ) );
    doc.add( list );

    para =
        new Paragraph( "To pay by credit card:",
                       NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    para.setSpacingBefore( 5f );
    doc.add( para );

    list = new List( false, 10 );
    list.setListSymbol( "*" );
    list.add( new ListItem( "Go to Library Payments Online, http://www.library.ucla.edu/use/access-privileges/library-payments-online.  E-check also accepted.", NORMAL ) );
    list.add( new ListItem( "Or complete credit card information requested above and mail to above address or telephone information to 310.206.9770.  Do not send credit card information by fax or email.", NORMAL ) );
    doc.add( list );

    para =
        new Paragraph( "Questions?",
                       NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    para.setSpacingBefore( 5f );
    doc.add( para );

    list = new List( false, 10 );
    list.setListSymbol( "*" );
    list.add( new ListItem( "Contact the library location listed above for questions about the bill amount or the services you’ve received.", NORMAL ) );
    list.add( new ListItem( "Contact Library Business Services for questions about payment options and payment status. 310.206.9770, lbs-billing@library.ucla.edu", NORMAL ) );
    doc.add( list );
  }

  private void addImage( Document doc )
    throws BadElementException, MalformedURLException, IOException,
           DocumentException
  {
    Image image;

    image =
        Image.getInstance( new URL( "http://webservices.library.ucla.edu/images/Lib_Logo4Invoices.gif" ) );

    image.setAbsolutePosition( 350f, 750f );
    //image.scaleAbsolute( 50f, 15f );
    image.scalePercent( 50f );
    doc.add( image );
  }

  private void addTitle( Document doc )
    throws DocumentException
  {
    if ( theInvoice.getHeader().getStatus().equals( "Pending" ) )
      paragraph = new Paragraph( "Pending Invoice/Quotation", HEADER );
    else
      paragraph = new Paragraph( "Invoice", HEADER );
    paragraph.setAlignment( Element.ALIGN_CENTER );
    paragraph.setSpacingAfter( 5f );

    doc.add( paragraph );
  }

  private void addHeader( Document doc )
    throws DocumentException
  {
    PdfPTable nestedTable = null;
    PdfPCell defaultNestedCell = null;

    columnWidths = new float[]
        { 20f, 30f, 30f, 20f };
    table = new PdfPTable( 4 );
    table.setWidthPercentage( 98 );
    table.setSpacingAfter( 3f );
    table.setWidths( columnWidths );

    defaultCell = prepDefaultCell( table.getDefaultCell() );

    table.addCell( new Paragraph( "Invoice Date:", NORMAL ) );
    table.addCell( new Paragraph( DATE_OUTPUT.format( theInvoice.getHeader().getInvoiceDate() ),
                                  NORMAL ) );
    table.addCell( prepEmptyCell( 2 ) );
    table.addCell( new Paragraph( "Invoice Number:", NORMAL ) );
    table.addCell( new Paragraph( theInvoice.getHeader().getInvoiceNumber(),
                                  NORMAL ) );
    table.addCell( prepEmptyCell( 2 ) );

    table.addCell( prepEmptyCell( 4 ) );

    //will need to extract location from invoice later
    table.addCell( new Paragraph( "Send Payment To:", NORMAL ) );
    table.addCell( new Paragraph( "Library Business Services", NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( theInvoice.getHeader().getLocationName(), NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Payment Processing Unit", NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Department ".concat( theInvoice.getHeader().getDepartmentNumber() ), NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Box 951575", NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( theInvoice.getHeader().getPhoneNumber(), NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Los Angeles, CA  90095-1575",
                                  NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( prepEmptyCell( 1 ) );

    for ( int i = 0; i < 9; i++ )
      table.addCell( prepEmptyCell( 4 ) );

    buffer =
        new StringBuffer( ( !ContentTests.isEmpty( theInvoice.getPatron().getFirstName() ) ?
                            theInvoice.getPatron().getFirstName().trim():
                            "" ) );
    buffer.append( " " ).append( ( !ContentTests.isEmpty( theInvoice.getPatron().getLastName() ) ) ?
                                 theInvoice.getPatron().getLastName().trim():
                                 "" );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( buffer.toString().trim(), NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );

    nestedTable = prepNestedTable( nestedTable );
    defaultNestedCell = prepNestedCell( nestedTable, defaultNestedCell );
    nestedTable.addCell( new Paragraph( "NonTaxable:", NORMAL ) );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getNontaxableTotal() ),
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    nestedTable.addCell( numberCell );
    table.addCell( nestedTable );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( getStreetAddress( theInvoice.getPatron() ),
                                  NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );

    nestedTable = prepNestedTable( nestedTable );
    defaultNestedCell = prepNestedCell( nestedTable, defaultNestedCell );
    nestedTable.addCell( new Paragraph( "Taxable:", NORMAL ) );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getTaxableTotal() ),
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    nestedTable.addCell( numberCell );
    table.addCell( nestedTable );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( getCityStateZip( theInvoice.getPatron() ),
                                  NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );

    nestedTable = prepNestedTable( nestedTable );
    defaultNestedCell = prepNestedCell( nestedTable, defaultNestedCell );
    nestedTable.addCell( new Paragraph( "Tax:", NORMAL ) );
    numberCell = getRightAlignedCell();
    //MONEY_OUTPUT.format( theInvoice.getHeader().getCountyTax() + theInvoice.getHeader().getStateTax() ),
    paragraph = new Paragraph( outputTax(), NORMAL );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    nestedTable.addCell( numberCell );
    table.addCell( nestedTable );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( prepEmptyCell( 1 ) );

    nestedTable = prepNestedTable( nestedTable );
    defaultNestedCell = prepNestedCell( nestedTable, defaultNestedCell );
    nestedTable.addCell( new Paragraph( "Adjustments:", NORMAL ) );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( getAdjustTotal() ), NORMAL );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    nestedTable.addCell( numberCell );
    table.addCell( nestedTable );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( prepEmptyCell( 1 ) );

    nestedTable = prepNestedTable( nestedTable );
    defaultNestedCell = prepNestedCell( nestedTable, defaultNestedCell );
    nestedTable.addCell( new Paragraph( "Amount Due:", BOLD ) );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( theInvoice.getHeader().getBalanceDue() ),
                       BOLD );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    nestedTable.addCell( numberCell );
    table.addCell( nestedTable );

    doc.add( table );
  }

  private PdfPCell prepDefaultCell( PdfPCell data )
  {
    PdfPCell defaultCell = data;
    defaultCell.setBorder( PdfPCell.NO_BORDER );
    defaultCell.setHorizontalAlignment( Element.ALIGN_LEFT );
    defaultCell.setVerticalAlignment( Element.ALIGN_MIDDLE );

    return defaultCell;
  }

  private PdfPCell prepEmptyCell( int cols )
  {
    PdfPCell empty;

    empty = new PdfPCell();
    empty.setColspan( cols );
    empty.setBorder( PdfPCell.NO_BORDER );

    return empty;
  }

  private void addPayment( Document doc )
    throws DocumentException
  {
    columnWidths = new float[]
        { 60f, 20f, 20f };
    table = new PdfPTable( 3 );
    table.setWidthPercentage( 98 );
    table.setSpacingAfter( 5f );
    table.setWidths( columnWidths );

    defaultCell = prepDefaultCell( table.getDefaultCell() );

    /*table.addCell( prepEmptyCell( 1 ) );
    tableCell = new PdfPCell();
    tableCell.setBorder( PdfPCell.NO_BORDER );
    tableCell.setHorizontalAlignment( Element.ALIGN_LEFT );
    tableCell.setVerticalAlignment( Element.ALIGN_MIDDLE );
    tableCell.addElement( new Paragraph( "Credit Card Type (Circle One): VISA / MC / DISC / AMEX",
                                         NORMAL ) );
    tableCell.setColspan( 2 );
    table.addCell( prepEmptyCell( 2 ) );*/

    table.addCell( new Paragraph( "---", NORMAL ) );
    table.addCell( prepEmptyCell( 1 ) );
    /*tableCell = prepTableCell( new PdfPCell(), 1, Element.ALIGN_RIGHT );
    tableCell.addElement( new Paragraph( "                             ---", NORMAL ) );
    table.addCell( tableCell );*/
    table.addCell( new Paragraph( "                                          ---", NORMAL ) );
    //table.addCell( new Paragraph( "---", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Name on card:", NORMAL ) );
    table.addCell( new Paragraph( "______________________", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Credit Card Type (Circle One):", NORMAL ) );
    table.addCell( new Paragraph( "VISA/MC/DISC/AMEX", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Account Number:", NORMAL ) );
    table.addCell( new Paragraph( "______________________", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Expiration Date:", NORMAL ) );
    table.addCell( new Paragraph( "______________________", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Amount to be charged:", NORMAL ) );
    table.addCell( new Paragraph( "______________________", NORMAL ) );

    table.addCell( prepEmptyCell( 1 ) );
    table.addCell( new Paragraph( "Authorized Signature:", NORMAL ) );
    table.addCell( new Paragraph( "______________________", NORMAL ) );

    doc.add( table );
  }

  private void addMiddle( Document doc )
    throws DocumentException
  {
    paragraph =
        new Paragraph( "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_LEFT );
    paragraph.setSpacingAfter( 5f );
    doc.add( paragraph );

    paragraph =
        new Paragraph( "Submit top portion with payment.  Payment terms: due " 
                       + "and payable upon receipt.  Deposits are non-refundable.",
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_CENTER );
    paragraph.setSpacingAfter( 5f );
    doc.add( paragraph );

    paragraph =
        new Paragraph( "Keep lower portion of invoice for your records.",
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_CENTER );
    paragraph.setSpacingAfter( 5f );
    doc.add( paragraph );

    paragraph = new Paragraph( "UCLA FEIN: 95-6006143", NORMAL );
    paragraph.setAlignment( Element.ALIGN_CENTER );
    paragraph.setSpacingAfter( 5f );
    doc.add( paragraph );
  }

  private void addEntries( Document doc )
    throws DocumentException
  {
    int totalLines;

    totalLines = theInvoice.getLines().size();
    if ( totalLines > 19 )
    {
      int remainingLines, start, end;

      start = 0;
      end = 19;
      printLines( doc, start, end, true );

      remainingLines = totalLines - 19;
      start = 19;
      end = 58;

      while ( remainingLines > 59 && end < theInvoice.getLines().size() )
      {
        printLines( doc, start, end, true );
        start += 39;
        end += 39;
        remainingLines -= 39;
      }

      if ( remainingLines > 0 )
        printLines( doc, start, theInvoice.getLines().size(),
                    ( remainingLines > 29 ? true: false ) );
    }
    else
    {
      printLinesHeader();
      printWholeList();
      doc.add( table );
      if ( totalLines > 9 )
        doc.newPage();
    }

  }

  private PdfPCell prepTableCell( PdfPCell cell, int cols, int align )
  {
    PdfPCell defaultCell = cell;
    defaultCell.setBorder( PdfPCell.NO_BORDER );
    defaultCell.setHorizontalAlignment( align );
    defaultCell.setVerticalAlignment( Element.ALIGN_MIDDLE );
    defaultCell.setColspan( cols );

    return defaultCell;
  }

  private void printWholeList()
  {
    String oldType = "", newType = "";

    for ( InvoiceEntry theItem: theInvoice.getLines() )
    {
      newType = theItem.getServiceName();
      if ( !newType.equals( oldType ) )
      {
        table.addCell( new Paragraph( newType, NORMAL ) );
      }
      else
      {
        table.addCell( new Paragraph( " ", NORMAL ) );
      }
      switch ( theItem.getLineType() )
      {
        case 1:
          {
            printCharge( theItem );
          }
          break;
        case 2:
          {
            printAdjustment( theItem );
          }
          break;
        case 3:
          {
            printNote( theItem );
          }
          break;
      }
      oldType = newType;
    }
  }

  private void printCharge( InvoiceEntry theItem )
  {
    buffer = new StringBuffer( theItem.getSubtypeName() ).append( ": " );
    buffer.append( theItem.getQuantity() ).append( " @ " ).append( MONEY_OUTPUT.format( theItem.getUnitPrice() ) );
    buffer.append( " per " ).append( theItem.getUnitMeasure().trim() );
    table.addCell( new Paragraph( buffer.toString().trim(), NORMAL ) );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( theItem.getTotalPrice() ),
                       NORMAL );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    table.addCell( numberCell );
  }

  private void printAdjustment( InvoiceEntry theItem )
  {
    buffer =
        new StringBuffer( theItem.getAdjustmentType() ).append( ": " ).append( theItem.getAdjustmentReason() );
    tableCell = new PdfPCell();
    tableCell.setBorder( PdfPCell.NO_BORDER );
    tableCell.setHorizontalAlignment( Element.ALIGN_LEFT );
    tableCell.setVerticalAlignment( Element.ALIGN_MIDDLE );
    tableCell.setIndent( 10f );
    paragraph = new Paragraph( buffer.toString().trim(), ITALIC );
    paragraph.setIndentationLeft( 10f );
    tableCell.addElement( paragraph );
    table.addCell( tableCell );
    numberCell = getRightAlignedCell();
    paragraph =
        new Paragraph( MONEY_OUTPUT.format( theItem.getTotalPrice() ),
                       ITALIC );
    paragraph.setAlignment( Element.ALIGN_RIGHT );
    numberCell.addElement( paragraph );
    table.addCell( numberCell );
  }

  private void printNote( InvoiceEntry theItem )
  {
    tableCell = new PdfPCell();
    tableCell.setBorder( PdfPCell.NO_BORDER );
    tableCell.setHorizontalAlignment( Element.ALIGN_LEFT );
    tableCell.setVerticalAlignment( Element.ALIGN_MIDDLE );
    tableCell.setIndent( 10f );
    paragraph = new Paragraph( theItem.getNote().trim(), ITALIC );
    paragraph.setIndentationLeft( 10f );
    tableCell.addElement( paragraph );
    tableCell.setColspan( 2 );
    table.addCell( tableCell );
  }

  private void printLines( Document doc, int start, int end,
                           boolean doPageBreak )
    throws DocumentException
  {
    String oldType = "", newType = "";

    printLinesHeader();
    for ( int index = start; index < end; index++ )
    {
      InvoiceEntry theItem;

      theItem = theInvoice.getLines().get( index );
      newType = theItem.getServiceName();

      if ( !newType.equals( oldType ) )
      {
        table.addCell( new Paragraph( newType, NORMAL ) );
      }
      else
      {
        table.addCell( new Paragraph( " ", NORMAL ) );
      }
      switch ( theItem.getLineType() )
      {
        case 1:
          {
            printCharge( theItem );
          }
          break;
        case 2:
          {
            printAdjustment( theItem );
          }
          break;
        case 3:
          {
            printNote( theItem );
          }
          break;
      }
      oldType = newType;
    }

    doc.add( table );

    if ( doPageBreak )
      doc.newPage();
  }

  private void printLinesHeader()
    throws DocumentException
  {
    columnWidths = new float[]
        { 40f, 40f, 20f };
    table = new PdfPTable( 3 );
    table.setWidthPercentage( 98 );
    table.setSpacingAfter( 5f );
    table.setWidths( columnWidths );

    defaultCell = prepDefaultCell( table.getDefaultCell() );

    tableCell = prepTableCell( new PdfPCell(), 2, Element.ALIGN_LEFT );
    tableCell.addElement( new Paragraph( "Product/Service", BOLD ) );
    table.addCell( tableCell );
    tableCell = prepTableCell( new PdfPCell(), 1, Element.ALIGN_RIGHT );
    tableCell.addElement( new Paragraph( "Total", BOLD ) );
    table.addCell( tableCell );

    tableCell = prepTableCell( new PdfPCell(), 3, Element.ALIGN_LEFT );
    tableCell.addElement( new LineSeparator( 1F, 100F, BaseColor.BLACK,
                                             Element.ALIGN_MIDDLE, 0F ) );
    table.addCell( tableCell );
  }

  private double getAdjustTotal()
  {
    if ( !didAdjustCalc )
    {
      for ( InvoiceEntry theItem: theInvoice.getLines() )
      {
        if ( theItem.getLineType() == 2 )
        {
          adjustTotal += theItem.getTotalPrice();
        }
      }
      didAdjustCalc = true;
    }

    return adjustTotal;
  }

  private String outputTax()
  {
    String output;
    output = null;
    if ( theInvoice.getInvoiceAdjustments().size() > 0 )
    {
      for ( InvoiceAdjustment adj : theInvoice.getInvoiceAdjustments() )
      {
        if ( adj.getAdjustmentType().equalsIgnoreCase( "CANCEL TAX" ) )
          output = "Canceled";
      }
    }
    else
      output =  MONEY_OUTPUT.format( theInvoice.getHeader().getTotalTax() );
    return output;
  }
}
    /*para =
        new Paragraph( "Should you have any payment inquiries, please email lbs-billing@library.ucla.edu or phone (310) 206-9770.",
                       NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    doc.add( para );

    para =
        new Paragraph( "To pay with a credit card by phone, call (310) 206-9770.",
                       NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    doc.add( para );

    para = new Paragraph( "Never fax or email credit card information.", NORMAL );
    para.setAlignment( Element.ALIGN_LEFT );
    para.setSpacingAfter( 5f );
    doc.add( para );

    para = new Paragraph( " ", NORMAL );
    para.setAlignment( Element.ALIGN_CENTER );
    para.setSpacingAfter( 5f );
    doc.add( para );

    para =
        new Paragraph( "Payment terms: due and payable upon receipt.", BOLD );
    para.setAlignment( Element.ALIGN_CENTER );
    para.setSpacingAfter( 5f );
    doc.add( para );
theInvoice.getHeader().getCountyTax() + theInvoice.getHeader().getStateTax()
*/
