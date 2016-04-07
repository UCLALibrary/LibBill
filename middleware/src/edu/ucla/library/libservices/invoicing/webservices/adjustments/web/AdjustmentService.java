package edu.ucla.library.libservices.invoicing.webservices.adjustments.web;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.LineItemAdjustment;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs.AddInvoiceAdjustmentProcedure;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs.AddLineItemAdjustmentProcedure;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.procs.CancelTaxProcedure;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.generator.AdjustmentTypeGenerator;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/adjustments/" )
public class AdjustmentService
{
  @Context
  ServletConfig config;

  public AdjustmentService()
  {
    super();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_line_credit" )
  public Response putLineAdjustment( LineItemAdjustment data )
  {
    AddLineItemAdjustmentProcedure proc;

    proc = new AddLineItemAdjustmentProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.addAdjustment();

    return Response.ok().build();
  }

  @PUT
  @Path( "cancel_tax/invoice/{in}/whoby/{un}" )
  public Response putTaxAdjustment( @PathParam( "in" )
    String invNumber, @PathParam( "un" )
    String user )
  {
    CancelTaxProcedure proc;

    proc = new CancelTaxProcedure();
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.setInvoiceNumber( invNumber );
    proc.setUserName( user );
    proc.cancelTax();

    return Response.ok().build();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_inv_credit" )
  public Response putInvoiceAdjustment( InvoiceAdjustment data )
  {
    AddInvoiceAdjustmentProcedure proc;

    proc = new AddInvoiceAdjustmentProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.addAdjustment();

    return Response.ok().build();
  }

  @GET
  @Produces( "application/xml, text/xml" )
  @Path( "types/{type}" )
  public Response getTypes( @PathParam( "type" )
    String type )
  {
    AdjustmentTypeGenerator generator;
    
    generator = new AdjustmentTypeGenerator();
    generator.setAdjType( type );
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.getTypes();
    
    return Response.ok( generator ).build();
  }
}
