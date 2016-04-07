package edu.ucla.library.libservices.invoicing.webservices.invoices.web;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfWriter;

import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.PdfGenerator;

import java.io.ByteArrayOutputStream;

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

      PdfWriter.getInstance( document, baos );
      generator.populatePdf( document, uid );
      
      return Response.ok( baos.toByteArray() ).build();
    }
    catch ( DocumentException de )
    {
      return Response.serverError().entity( "Invoice creation failed: ".concat( de.getMessage() ) ).build();
    }
  }

}
