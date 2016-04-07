package edu.ucla.library.libservices.invoicing.webservices.taxes.web;

import edu.ucla.library.libservices.invoicing.webservices.taxes.beans.TaxRate;
import edu.ucla.library.libservices.invoicing.webservices.taxes.db.procs.AddTaxRateProcedure;
import edu.ucla.library.libservices.invoicing.webservices.taxes.db.procs.EditTaxRateProcedure;
import edu.ucla.library.libservices.invoicing.webservices.taxes.generator.TaxRateGenerator;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/taxes/" )
public class TaxService
{
  @Context
  ServletConfig config;

  public TaxService()
  {
    super();
  }
  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_tax" )
  public Response addTax( TaxRate tax )
  {
    AddTaxRateProcedure proc;
    proc = new AddTaxRateProcedure();
    proc.setData( tax );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.addTax();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Tax rate add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_tax" )
  public Response editTax( TaxRate tax )
  {
    EditTaxRateProcedure proc;
    proc = new EditTaxRateProcedure();
    proc.setData( tax );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.editTax();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Tax rate edit failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @GET
  @Produces( {"text/xml", "application/xml"} )
  @Path( "rate_list" )
  public TaxRateGenerator getRates()
  {
    TaxRateGenerator generator;

    generator = new TaxRateGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.populateRates();

    return generator;
  }
}
