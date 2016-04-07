package edu.ucla.library.libservices.invoicing.utiltiy.testing;

import edu.ucla.library.libservices.invoicing.security.signatures.SignatureCreator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.utiltiy.strings.StringCleaner;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.AdjustmentType;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs.AddInvoiceAdjustmentProcedure;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.generator.AdjustmentTypeGenerator;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.CashNetInvoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.CashNetLine;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.DisplayLineItem;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemBean;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.SimpleHeader;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.DisplayLineItemMapper;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.AddLineItemProcedure;

import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.UpdateLineItemProcedure;

import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.InvoiceGenerator;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.Location;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.LocationServiceBean;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.AddLocationProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.AddLocationServiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.EditLocationProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.EditLocationServiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.generator.LocationServiceGenerator;
import edu.ucla.library.libservices.invoicing.webservices.logging.beans.CashnetLog;
import edu.ucla.library.libservices.invoicing.webservices.logging.db.procs.AddCashnetLogProcedure;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.SimplePatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.generator.PatronGenerator;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;
import edu.ucla.library.libservices.invoicing.webservices.payments.beans.ReceiptInfo;
import edu.ucla.library.libservices.invoicing.webservices.payments.db.procs.AddPaymentProcedure;
import edu.ucla.library.libservices.invoicing.webservices.payments.db.procs.ApplyFullPaymentProcedure;
import edu.ucla.library.libservices.invoicing.webservices.payments.generator.ReceiptInfoGenerator;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.StaffUser;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.UserRole;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.GetStaffUserFunction;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.InsertStaffUserProcedure;
import edu.ucla.library.libservices.invoicing.webservices.staff.db.procs.UpdateStaffUserProcedure;
import edu.ucla.library.libservices.invoicing.webservices.staff.generator.UserRoleGenerator;

import edu.ucla.library.libservices.invoicing.webservices.taxes.beans.TaxRate;

import edu.ucla.library.libservices.invoicing.webservices.taxes.db.procs.AddTaxRateProcedure;

import edu.ucla.library.libservices.invoicing.webservices.taxes.db.procs.EditTaxRateProcedure;

import edu.ucla.library.libservices.invoicing.webservices.taxes.generator.TaxRateGenerator;

import java.io.UnsupportedEncodingException;

import java.net.URLEncoder;

import java.security.SignatureException;

import java.util.Date;

import java.util.List;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.ws.rs.core.Response;

import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class Tester
{
  private static final String GET_LINE_ITEMS =
    //"SELECT * FROM invoice_owner.invoice_line_vw WHERE lower(invoice_number) = ? " +
    "SELECT i.*, l.item_code FROM invoice_line_vw i INNER JOIN " +
    "location_service_vw l ON i.location_service_id = l.location_service_id" +
    " WHERE lower(i.invoice_number) = ? ORDER BY i.line_number";

  public Tester()
  {
    super();
  }

  public static void main( String[] args )
    throws SignatureException, UnsupportedEncodingException
  {
    DriverManagerDataSource ds;
    List<DisplayLineItem> items;

    ds = DataSourceFactory.createBillSource();
    items = new JdbcTemplate( ds ).query( GET_LINE_ITEMS, new Object[]
          { "SC003689".toLowerCase() }, new DisplayLineItemMapper() );

    for ( DisplayLineItem theItem: items )
      System.out.println( "item " + theItem.getLineNumber() +
                          " has UC min " + theItem.getUcMinimum() +
                          " and non-UC min " + theItem.getNonUcMinimum() );
    /*Pattern p = Pattern.compile("[0-9]{9}");
    Matcher m = p.matcher("1234567a9");
    boolean b = Pattern.matches( "[0-9]{9}", "123456789" ); // m.matches();
    System.out.println( "12345678 matches? " + b );
    StringBuffer buffer;
    buffer = new StringBuffer( "PUT" ).append( "\n" );
    buffer.append( "invoicing-dev/invoices/add_invoice" ).append( "\n" );
    buffer.append( "<invoice>" ).append( "\n" );
    buffer.append( "<branchCode>SC</branchCode>" ).append( "\n" );
    buffer.append( "<invoiceDate>Fri Feb 13 06:30:21 PST 2015</invoiceDate>" ).append( "\n" );
    buffer.append( "<status>Pending</status>" ).append( "\n" );
    buffer.append( "<createdBy>aeon_user</createdBy>" ).append( "\n" );
    buffer.append( "<patronID>1</patronID>" ).append( "\n" );
    buffer.append( "<onPremises>true</onPremises>" ).append( "\n" );
    buffer.append( "</invoice>" ).append( "\n" );
    buffer.append( "-30-" );
    System.out.println( SignatureCreator.hashSignature(
      buffer.toString().trim(), "AD346AFFAC79596A6420" ) ); // "D55CDF30293C5EDCBD9A" ) );
    System.out.println();


    for ( String theLine : content )
    {
      output.append( theLine ).append( "\n" );
    }
    output.append( "-30-" );

    /*long start = System.currentTimeMillis();
    PatronGenerator docMaker;

    docMaker = new PatronGenerator();

    docMaker.setDbBill( "" );
    docMaker.setDbVger( "" );
    docMaker.setInstitutionID( "001904955" );

    SimplePatron thePatron;
    thePatron = docMaker.getBasicPatron();
    long end = System.currentTimeMillis();
    System.out.println( "time = " + ( end - start ) / 1000 );
    System.out.println( "name = " + thePatron.getLastName() + ", " + thePatron.getFirstName() );
    for ( SimpleHeader theInvoice : thePatron.getInvoices() )
      System.out.println( "\t" + theInvoice.getInvoiceNumber() );*/
  }

}
