package edu.ucla.library.libservices.invoicing.webservices.invoices.web;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;

import edu.ucla.library.libservices.invoicing.utiltiy.mail.FileMailer;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.PdfGenerator;

import java.io.ByteArrayOutputStream;

import java.io.File;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import java.io.IOException;

import javax.mail.MessagingException;

import javax.servlet.ServletConfig;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/pdfs/" )
public class PdfService
{
  @Context
  ServletConfig config;

  public PdfService()
  {
    super();
  }

  @GET
  @Produces( "application/pdf" )
  @Path( "display_invoice/{in}/{uid}" )
  public Response getInvoicePdf( @PathParam( "in" )
    String invoiceNo, @PathParam( "uid" )
    String uid )
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
      generator.setAlmaKey(config.getServletContext().getInitParameter( "alma.key" ));
      generator.setAlmaURI(config.getServletContext().getInitParameter( "alma.patron" ));

      PdfWriter.getInstance( document, baos );
      generator.populatePdf( document, uid );
      
      return Response.ok( baos.toByteArray() ).build();
    }
    catch ( DocumentException de )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( de.getMessage() ) ).build();
    }
  }

  @GET
  @Path( "/mail_invoice/{in}" )
  public Response mailInvoicePdf( @PathParam( "in" )
    String invoiceNo )
  {
    File file;
    FileOutputStream output;
    Document document;
    PdfGenerator generator;
    StringBuffer fileName;
    try
    {
      generator = new PdfGenerator();
      generator.setInvoiceNumber( invoiceNo ); 
      generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
      generator.setAlmaKey(config.getServletContext().getInitParameter( "alma.key" ));
      generator.setAlmaURI(config.getServletContext().getInitParameter( "alma.patron" ));

      fileName =
          new StringBuffer( config.getServletContext().getInitParameter( "mail.filebase" ) ).append( invoiceNo ).append( ".pdf" );
      file = new File( fileName.toString() );
      document = new Document( PageSize.LETTER );
      output = new FileOutputStream( file );

      PdfWriter.getInstance( document, output );
      generator.populatePdf( document );

      if ( !ContentTests.isEmpty( generator.getTheInvoice().getPatron().getEmail() ) )
      {
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
}
