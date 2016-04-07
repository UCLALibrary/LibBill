package edu.ucla.library.libservices.invoicing.webservices.appinfo.web;

import edu.ucla.library.libservices.invoicing.webservices.appinfo.generator.VersionGenerator;

import javax.servlet.ServletConfig;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/appinfo/" )
public class AppInfoService
{
  @Context
  ServletConfig config;

  public AppInfoService()
  {
    super();
  }

  @GET
  @Produces( "text/plain" )
  @Path( "version" )
  public Response getVersion()
  {
    VersionGenerator generator;

    generator = new VersionGenerator();
    generator.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    return Response.ok( generator.getVersion() ).build();
  }
}
