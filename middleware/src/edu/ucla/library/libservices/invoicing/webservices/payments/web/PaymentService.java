package edu.ucla.library.libservices.invoicing.webservices.payments.web;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;
import edu.ucla.library.libservices.invoicing.webservices.payments.db.procs.AddPaymentProcedure;

import edu.ucla.library.libservices.invoicing.webservices.payments.db.procs.ApplyFullPaymentProcedure;
import edu.ucla.library.libservices.invoicing.webservices.payments.generator.PaymentTypeGenerator;

import edu.ucla.library.libservices.invoicing.webservices.payments.generator.ReceiptInfoGenerator;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/payments/" )
public class PaymentService
{
  @Context
  ServletConfig config;

  public PaymentService()
  {
    super();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_payment" )
  public Response putPayment( Payment data )
  {
    AddPaymentProcedure proc;
    
    proc = new AddPaymentProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.addPayment();

    return Response.ok().build();
  }

  @PUT
  @Path( "full_payment/invoice/{in}/type/{pt}" )
  public Response doFullPayment( @PathParam( "in" )
    String invNumber, @PathParam( "pt" ) int pmtType )
  {
    ApplyFullPaymentProcedure proc;
    
    proc = new ApplyFullPaymentProcedure();
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.setUserName( config.getServletContext().getInitParameter( "user.logging.cashnet" ) );
    proc.setInvoiceNumber( invNumber );
    proc.setPaymentType( pmtType );
    try
    {
      proc.addPayment();

      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Payment failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @GET
  @Produces( "text/xml" )
  @Path( "receipt/{inv}" )
  public Response getReceipt( @PathParam( "inv" )
    String inv )
  {
    ReceiptInfoGenerator generator;

    generator = new ReceiptInfoGenerator();

    generator.setInvoiceNumber( inv );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    
    try
    {
      return Response.ok().entity( generator.getInfo() ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "search failed: " + e.getMessage() ).build();
    }
  }

  @GET
  @Produces( "text/xml" )
  @Path( "types" )
  public PaymentTypeGenerator getPaymentTypes()
  {
    PaymentTypeGenerator generator;

    generator = new PaymentTypeGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.populateTypes();

    return generator;
  }
}
