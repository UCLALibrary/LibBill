package edu.ucla.library.libservices.invoicing.webservices.locations.web;

import edu.ucla.library.libservices.invoicing.webservices.locations.beans.Location;
import edu.ucla.library.libservices.invoicing.webservices.locations.beans.LocationServiceBean;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.AddLocationProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.AddLocationServiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.DeleteLocationProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.DeleteLocationServiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.EditLocationProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.db.procs.EditLocationServiceProcedure;
import edu.ucla.library.libservices.invoicing.webservices.locations.generator.LocationGenerator;
import edu.ucla.library.libservices.invoicing.webservices.locations.generator.LocationServiceGenerator;

import java.io.UnsupportedEncodingException;

import java.net.URLDecoder;

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

@Path( "/branches/" )
public class LocationService
{
  @Context
  ServletConfig config;

  public LocationService()
  {
    super();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "branch_services/{ln}" )
  public LocationServiceGenerator servicesByBranch( @PathParam( "ln" )
    String locationName )
    throws UnsupportedEncodingException
  {
    LocationServiceGenerator docMaker;

    docMaker = new LocationServiceGenerator();

    docMaker.setBranchName( URLDecoder.decode( locationName, "utf-8" ) );
    docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.getServicesByLocation();

    return docMaker;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "branch_services/{ln}/for_uc/{uc}" )
  public LocationServiceGenerator filteredByBranch( @PathParam( "ln" )
    String locationName, @PathParam( "uc" )
    String forUC )
  {
    LocationServiceGenerator docMaker;

    docMaker = new LocationServiceGenerator();

    docMaker.setBranchCode( locationName );
    docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.setForUC( forUC.equalsIgnoreCase("Y") );
    docMaker.setItemCode( null );
    docMaker.getFilteredServicesByLocation();

    return docMaker;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "branch_services/{ln}/for_uc/{uc}/code/{ic}" )
  public LocationServiceGenerator filteredByBranchAndCode( @PathParam( "ln" )
    String locationName, @PathParam( "uc" )
    String forUC, @PathParam( "ic" )
    String itemCode )
  {
    LocationServiceGenerator docMaker;

    docMaker = new LocationServiceGenerator();

    docMaker.setBranchCode( locationName );
    docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.setForUC( forUC.equalsIgnoreCase("Y") );
    docMaker.setItemCode( itemCode );
    docMaker.getFilteredServicesByLocation();

    return docMaker;
  }

  @GET
  @Produces( "text/xml" )
  @Path( "unit_list" )
  public LocationGenerator allUnits()
  {
    LocationGenerator docMaker;

    docMaker = new LocationGenerator();

    docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.popUnits();

    return docMaker;
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_unit" )
  public Response addBranch( Location data )
  {
    AddLocationProcedure proc;

    proc = new AddLocationProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.addBranch();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location creation failed: " +
                                            e.getMessage() ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "add_service" )
  public Response addBranchService( LocationServiceBean data )
  {
    AddLocationServiceProcedure proc;

    proc = new AddLocationServiceProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.addService();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location creation failed: " +
                                            e.getMessage() ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_unit" )
  public Response editBranch( Location data )
  {
    EditLocationProcedure proc;

    proc = new EditLocationProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.editBranch();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location update failed: " +
                                            e.getMessage() ).build();
    }
  }

  @PUT
  @Consumes(
    { "application/xml", "text/xml" } )
  @Path( "edit_service" )
  public Response editBranchService( LocationServiceBean data )
  {
    EditLocationServiceProcedure proc;

    proc = new EditLocationServiceProcedure();
    proc.setData( data );
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );

    try
    {
      proc.editService();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location creation failed: " +
                                            e.getMessage() ).build();
    }
  }

  @DELETE
  @Path( "delete_unit/unit/{id}/whoby/{wb}" )
  public Response deleteUnit( @PathParam( "id" )
    int unitID, @PathParam( "wb" )
    String whoBy )
  {
    DeleteLocationProcedure proc;

    proc = new DeleteLocationProcedure();
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.setId( unitID );
    proc.setWhoBy( whoBy );

    try
    {
      proc.deleteBranch();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location deletion failed: " +
                                            e.getMessage() ).build();
    }
  }

  @DELETE
  @Path( "delete_service/service/{id}/whoby/{wb}" )
  public Response deleteBranchService( @PathParam( "id" )
    int serviceID, @PathParam( "wb" )
    String whoBy )
  {
    DeleteLocationServiceProcedure proc;

    proc = new DeleteLocationServiceProcedure();
    proc.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    proc.setLocSvcKey( serviceID );
    proc.setWhoBy( whoBy );

    try
    {
      proc.deleteService();
      return Response.ok().build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "Location-service deletion failed: " +
                                            e.getMessage() ).build();
    }
  }
}
