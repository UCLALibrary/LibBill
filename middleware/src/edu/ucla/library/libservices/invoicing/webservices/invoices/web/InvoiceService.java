package edu.ucla.library.libservices.invoicing.webservices.invoices.web;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;

//import edu.ucla.library.libservices.invoicing.utiltiy.mail.CustomMailMessage;
import edu.ucla.library.libservices.invoicing.utiltiy.mail.FileMailer;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.CashNetInvoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InsertHeaderBean;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.Invoice;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemBean;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemNote;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.SimpleHeader;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.AddInvoiceNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.AddInvoiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.AddLineItemNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.AddLineItemProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.DeleteInvoiceNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.DeleteLineItemNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.DeleteLineItemProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.UpdateInvoiceNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.UpdateInvoiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.UpdateLineItemNoteProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs.UpdateLineItemProcedure;
import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.InvoiceGenerator;
import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.PdfGenerator;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import java.io.IOException;

import java.io.UnsupportedEncodingException;

import java.net.URLDecoder;

//import java.util.ArrayList;
//import java.util.List;

import javax.mail.MessagingException;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

import org.springframework.jdbc.UncategorizedSQLException;

@Path( "/invoices/" )
public class InvoiceService
{
  @Context
  ServletConfig config;
  //private static final String FILE_BASE = "C:\\Temp\\pdf\\";

  public InvoiceService()
  {
    super();
  }

  /**
   * @param theInvoice
   * @return
   */
  @PUT
  @Produces( "text/plain" )
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_invoice" )
  public Response putInvoice( InsertHeaderBean theInvoice )
  {
    AddInvoiceProcedure proc;
    String invNo;

    try
    {
      proc = new AddInvoiceProcedure();
      proc.setData( theInvoice );
      proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
      invNo = proc.addInvoice();

      return Response.ok( invNo ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( e.getMessage() ) ).build();
    }
  }

  /**
   * @param theInvoice
   * @return
   */
  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_line_item" )
  public Response putLineItem( LineItemBean theInvoice )
  {
    AddLineItemProcedure proc;

    proc = new AddLineItemProcedure();
    proc.setData( theInvoice );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.addLineItem();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Line add failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Line add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_number/{in}" )
  public Invoice getInvoiceByNumber( @PathParam( "in" )
    String invoiceNo )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setInvoiceNumber( invoiceNo );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    return generator.getInvoice();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_patron/{pn}" )
  public InvoiceGenerator getInvoiceByPatron( @PathParam( "pn" )
    String patronID )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setPatronID( Integer.parseInt( patronID ) );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByPatron();
    return generator;
  }

  @GET
  @Produces( "application/json" ) //"text/xml" )
  @Path( "unpaid_invoices/{pn}" )
  public SimpleHeader getUnpaidInvoice( @PathParam( "pn" )
    String invoiceID )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setInvoiceNumber( invoiceID );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    //generator.getInvoicesByPatron();
    return generator.getSimpleInvoice();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "cashnet_invoice/{pn}" )
  public CashNetInvoice getCashNetInvoice( @PathParam( "pn" )
    String invoiceID )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setInvoiceNumber( invoiceID );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    //generator.getInvoicesByPatron();
    return generator.getCnInvoice();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_total/{amt}" )
  public InvoiceGenerator getInvoiceByTotal( @PathParam( "amt" )
    String amount )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setInvoiceTotal( Double.parseDouble( amount ) );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByTotal();
    return generator;
  }


  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_total_range/lower/{low}/higher/{high}" )
  public InvoiceGenerator getInvoiceByTotalRange( @PathParam( "low" )
    String low, @PathParam( "high" )
    String high )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setTotalLow( Double.parseDouble( low ) );
    generator.setTotalHigh( Double.parseDouble( high ) );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByTotalRange();
    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_date/{date}" )
  public InvoiceGenerator getInvoiceByCreate( @PathParam( "date" )
    String date )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setStartDate( date );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByOneDate();
    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_note/{note}" )
  public InvoiceGenerator getInvoiceByNote( @PathParam( "note" )
    String note )
    throws UnsupportedEncodingException
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setNote( note );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByNote();
    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_inv_note/{note}" )
  public InvoiceGenerator getInvoiceByInvNote( @PathParam( "note" )
    String note )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setNote( note );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByInvNote();
    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_line_note/{note}" )
  public InvoiceGenerator getInvoiceByLineNote( @PathParam( "note" )
    String note )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setNote( note );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByLineNote();
    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "invoice_by_date_range/start/{start}/end/{end}" )
  public InvoiceGenerator getInvoiceByDateRange( @PathParam( "start" )
    String start, @PathParam( "end" )
    String end )
  {
    InvoiceGenerator generator;

    generator = new InvoiceGenerator();
    generator.setStartDate( start );
    generator.setEndDate( end );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getInvoicesByDateRange();
    return generator;
  }

  @PUT
  @Path( "edit_invoice/invoice/{in}/status/{st}/whoby/{wb}" )
  public Response editInvoice( @PathParam( "in" )
    String invNumber, @PathParam( "st" )
    String status, @PathParam( "wb" )
    String whoBy )
    throws UnsupportedEncodingException
  {
    UpdateInvoiceProcedure proc;

    proc = new UpdateInvoiceProcedure();
    proc.setInvoiceNumber( invNumber );
    proc.setStatus( URLDecoder.decode( status, "utf-8" ) );
    proc.setWhoBy( whoBy );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.updateInvoice();

    return Response.ok().build();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_line_item" )
  public Response editLineItem( LineItemBean theInvoice )
  {
    UpdateLineItemProcedure proc;

    proc = new UpdateLineItemProcedure();
    proc.setData( theInvoice );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.updateLineItem();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      switch ( use.getSQLException().getErrorCode() )
      {
        case 20001: //error 406?
          return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Line add failed: ".concat( use.getSQLException().getMessage() ) ).build();
        case 20002: //error 404?
          return Response.status( Response.Status.NOT_FOUND ).entity( "Line edit failed: ".concat( use.getSQLException().getMessage() ) ).build();
        default: //error 500?
          return Response.serverError().entity( "Line edit failed: ".concat( use.getSQLException().getMessage() ) ).build();
      }
    }
  }

  @GET
  @Produces( "application/pdf" )
  @Path( "/display_invoice/{in}" )
  public Response getInvoicePdf( @PathParam( "in" )
    String invoiceNo )
  {
    ByteArrayOutputStream baos;
    Document document;
    PdfGenerator generator;

    try
    {
      document = new Document( PageSize.LETTER );
      baos = new ByteArrayOutputStream();
      generator = new PdfGenerator();
      generator.setInvoiceNumber( invoiceNo );
      generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

      PdfWriter.getInstance( document, baos );
      generator.populatePdf( document );
      
      return Response.ok( baos.toByteArray() ).build();
    }
    catch ( DocumentException de )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( de.getMessage() ) ).build();
    }
  }

  @GET
  //  @PUT
  //  @Consumes( { "application/xml", "text/xml" } )
  @Path( "/mail_invoice/{in}" )
  public Response mailInvoicePdf( @PathParam( "in" )
    String invoiceNo )
    //CustomMailMessage message )
  {
    File file;
    FileOutputStream output;
    Document document;
    PdfGenerator generator;
    StringBuffer fileName;
    try
    {
      generator = new PdfGenerator();
      generator.setInvoiceNumber( invoiceNo ); // message.getInvoiceNo().trim() );
      generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

      //message.getInvoiceNo().trim() ).append( ".pdf" );
      fileName =
          new StringBuffer( config.getServletContext().getInitParameter( "mail.filebase" ) ).append( invoiceNo ).append( ".pdf" );
      file = new File( fileName.toString() );
      document = new Document( PageSize.LETTER );
      output = new FileOutputStream( file );

      PdfWriter.getInstance( document, output );
      generator.populatePdf( document );

      if ( !ContentTests.isEmpty( generator.getTheInvoice().getPatron().getEmail() ) )
      {
        //message.getInvoiceNo().trim().concat( ".pdf" ),
        //message.getMessage() );
        FileMailer.mailFile( invoiceNo.concat( ".pdf" ),
                             generator.getTheInvoice().getPatron().getEmail(),
                             config.getServletContext().getInitParameter( "mail.propsfile" ) );
        file.delete();
        return Response.ok().build();
      }
      else
      {
        file.delete();
        return Response.status( Response.Status.NOT_FOUND ).entity( "Patron lacks an email address" ).build();
      }
    }
    catch ( DocumentException de )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( de.getMessage() ) ).build();
    }
    catch ( FileNotFoundException fnfe )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( fnfe.getMessage() ) ).build();
    }
    catch ( IOException ioe )
    {
      return Response.serverError().entity( "Invoice mailing failed: ".concat( ioe.getMessage() ) ).build();
    }
    catch ( MessagingException me )
    {
      return Response.serverError().entity( "Invoice mailing failed: ".concat( me.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_invoice_note" )
  public Response putInvNote( InvoiceNote theNote )
  {
    AddInvoiceNoteProcedure proc;

    proc = new AddInvoiceNoteProcedure();
    proc.setData( theNote );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.addNote();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @DELETE
  @Path( "delete_line/invoice/{in}/line/{ln}/whoby/{wb}" )
  public Response deleteLine( @PathParam( "in" )
    String invNumber, @PathParam( "ln" )
    String lineNumber, @PathParam( "wb" )
    String whoBy )
  {
    DeleteLineItemProcedure deleter;

    deleter = new DeleteLineItemProcedure();
    deleter.setInvoiceNumber( invNumber );
    deleter.setLineNumber( lineNumber );
    deleter.setUserName( whoBy );
    deleter.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      deleter.deleteLineItem();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      switch ( use.getSQLException().getErrorCode() )
      {
        case 20001: //error 406?
          return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Line deletion failed: ".concat( use.getSQLException().getMessage() ) ).build();
        case 20002: //error 404?
          return Response.status( Response.Status.NOT_FOUND ).entity( "Line deletion failed: ".concat( use.getSQLException().getMessage() ) ).build();
        default: //error 500?
          return Response.serverError().entity( "Line deletion failed: ".concat( use.getSQLException().getMessage() ) ).build();
      }
    }
  }

  @DELETE
  @Path( "delete_line_note/invoice/{in}/line/{ln}/note/{sn}/whoby/{wb}" )
  public Response deleteLineNote( @PathParam( "in" )
    String invNumber, @PathParam( "ln" )
    int lineNumber, @PathParam( "sn" )
    int seqNumber, @PathParam( "wb" )
    String whoBy )
  {
    DeleteLineItemNoteProcedure deleter;

    deleter = new DeleteLineItemNoteProcedure();
    deleter.setInvoiceNumber( invNumber );
    deleter.setLineNumber( lineNumber );
    deleter.setSequenceNumber( seqNumber );
    deleter.setUserName( whoBy );
    deleter.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      deleter.deleteNote();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_FOUND ).entity( "Note deletion failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_invoice_note" )
  public Response editInvNote( InvoiceNote theNote )
  {
    UpdateInvoiceNoteProcedure proc;

    proc = new UpdateInvoiceNoteProcedure();
    proc.setData( theNote );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.editNote();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_FOUND ).entity( "Note edit failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note edit failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @DELETE
  @Path( "delete_invoice_note/invoice/{in}/note/{sn}/whoby/{wb}" )
  public Response deleteInvNote( @PathParam( "in" )
    String invNumber, @PathParam( "sn" )
    int seqNumber, @PathParam( "wb" )
    String whoBy )
  {
    DeleteInvoiceNoteProcedure deleter;

    deleter = new DeleteInvoiceNoteProcedure();
    deleter.setInvoiceNumber( invNumber );
    deleter.setSequenceNumber( seqNumber );
    deleter.setUserName( whoBy );
    deleter.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      deleter.deleteNote();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_FOUND ).entity( "Note deletion failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_line_note" )
  public Response putLineNote( LineItemNote theNote )
  {
    AddLineItemNoteProcedure proc;

    proc = new AddLineItemNoteProcedure();
    proc.setData( theNote );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.addNote();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_line_note" )
  public Response editLineNote( LineItemNote theNote )
  {
    UpdateLineItemNoteProcedure proc;

    proc = new UpdateLineItemNoteProcedure();
    proc.setData( theNote );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.editNote();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_FOUND ).entity( "Note edit failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Note edit failed: ".concat( e.getMessage() ) ).build();
    }
  }

}
