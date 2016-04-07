package edu.ucla.library.libservices.invoicing.webservices.logging.web;

import edu.ucla.library.libservices.invoicing.webservices.logging.beans.CashnetLog;
import edu.ucla.library.libservices.invoicing.webservices.logging.db.procs.AddCashnetLogProcedure;

import javax.servlet.ServletConfig;

import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/logging/" )
public class LoggingService
{
  @Context
  ServletConfig config;

  public LoggingService()
  {
    super();
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_log" )
  public Response putCashnetLog( CashnetLog data )
  {
    AddCashnetLogProcedure proc;

    proc = new AddCashnetLogProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.setUser( config.getServletContext().getInitParameter( "user.logging.cashnet" ) );
    try
    {
      proc.addLog();

      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Log-entry creation failed: ".concat( e.getMessage() ) ).build();
    }
  }
}
