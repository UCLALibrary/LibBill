package edu.ucla.library.libservices.invoicing.webservices.zipcodes.web;

import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.UpdateZipCode;
import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.ZipCode;
import edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.procs.InsertTaxableZipCodeProcedure;

import edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.procs.UpdateTaxableZipCodeProcedure;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

import org.springframework.jdbc.UncategorizedSQLException;

@Path( "/zipcodes/" )
public class ZipcodeService
{
  @Context
  ServletConfig config;

  public ZipcodeService()
  {
    super();
  }
  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_zipcode" )
  public Response addZipcode( ZipCode theCode )
  {
    InsertTaxableZipCodeProcedure proc;

    proc = new InsertTaxableZipCodeProcedure();
    proc.setData( theCode );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.addZip();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Zip code add failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Zip code add failed: ".concat( e.getMessage() ) ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_zipcode" )
  public Response editZipcode( UpdateZipCode theCode )
  {
    UpdateTaxableZipCodeProcedure proc;

    proc = new UpdateTaxableZipCodeProcedure();
    proc.setData( theCode );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    try
    {
      proc.editZip();
      return Response.ok().build();
    }
    catch ( UncategorizedSQLException use )
    {
      return Response.status( Response.Status.NOT_ACCEPTABLE ).entity( "Zip code add failed: ".concat( use.getSQLException().getMessage() ) ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Zip code add failed: ".concat( e.getMessage() ) ).build();
    }
  }

}
