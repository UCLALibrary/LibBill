package edu.ucla.library.libservices.invoicing.webservices.status.web;

import edu.ucla.library.libservices.invoicing.webservices.status.beans.InvoiceStatus;
import edu.ucla.library.libservices.invoicing.webservices.status.generator.InvoiceStatusGenerator;

import edu.ucla.library.libservices.invoicing.webservices.status.generator.StatusChangeGenerator;

import java.util.List;

import javax.servlet.ServletConfig;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;

@Path( "/invoice_status/" )
public class InvoiceStatusService
{
  @Context
  ServletConfig config;

  public InvoiceStatusService()
  {
    super();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "list" )
  public InvoiceStatusGenerator getInvoiceStatuses()
  {
    InvoiceStatusGenerator generator;

    generator = new InvoiceStatusGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.populateStatuses();

    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "all_changes" )
  public StatusChangeGenerator getStatuseChanges()
  {
    StatusChangeGenerator generator;

    generator = new StatusChangeGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.populateAllChanges();

    return generator;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "filtered_changes/role/{rn}/status/{sn}" )
  public StatusChangeGenerator getFilteredChanges(@PathParam( "rn" )
    String role, @PathParam( "sn" ) String status)
  {
    StatusChangeGenerator generator;

    generator = new StatusChangeGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    generator.setRole( role );
    generator.setStatus( status );
    generator.populateFilteredChanges();

    return generator;
  }
}
