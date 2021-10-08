package edu.ucla.library.libservices.invoicing.webservices.patrons.web;

import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.AlmaPatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.clients.PatronClient;
import edu.ucla.library.libservices.invoicing.webservices.patrons.converters.AlmaVgerConverter;
import edu.ucla.library.libservices.invoicing.webservices.patrons.generator.PatronGenerator;

import java.io.UnsupportedEncodingException;

import java.net.URLDecoder;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

@Path( "/patrons/" )
public class PatronService
{
  @Context
  ServletConfig config;

  public PatronService()
  {
    super();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "patron_record/{bc}" )
  public PatronGenerator xmlByBarcode( @PathParam( "bc" )
    String barcode )
  {
    PatronGenerator docMaker;

    docMaker = new PatronGenerator();

    docMaker.setBarcode( barcode );
    docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.getPatronsByBarcode();

    return docMaker;
  }


  @GET
  @Produces( "text/xml" )
  @Path( "alma/{bc}" )
  public Response fromAlma( @PathParam( "bc" )
    String barcode )
  {
    PatronGenerator docMaker;

    docMaker = new PatronGenerator();

    docMaker.setBarcode( barcode );
    //docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.setAlmaKey(config.getServletContext().getInitParameter( "alma.key" ));
    docMaker.setAlmaURI(config.getServletContext().getInitParameter( "alma.patron" ));
    docMaker.prepPatronFromAlma();
    return Response.ok().entity( docMaker ).build();
  }

  @GET
  @Produces( "text/xml" )
  @Path( "by_uid/{uid}" )
  public Response xmlByUID( @PathParam( "uid" )
    String uid )
  {
    PatronGenerator docMaker;

    docMaker = new PatronGenerator();

    docMaker.setInstitutionID( uid );
    //docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.setDbBill( config.getServletContext().getInitParameter( "datasource.invoice" ) );
    docMaker.setDbVger( config.getServletContext().getInitParameter( "datasource.oracle" ) );
    
    try
    {
      return Response.ok().entity( docMaker.getBasicPatron() ).build();
    }
    catch ( Exception e )
    {
      return Response.serverError().entity( "search failed: " + e.getMessage() ).build();
    }
  }

  @GET
  @Produces( "text/xml" )
  @Path( "patron_list/{path:.*}" )
  public Response xmlByName( @PathParam( "path" )
    String path )
  {
    Map<String, String> params;

    params = parsePath( path );
    if ( params.size() == 0 )
    {
      return Response.status( 406 ).entity( "Please submit a search term" ).build();
    }
    else
    {
      PatronGenerator docMaker;

      docMaker = new PatronGenerator();

      try
      {
        docMaker.setFirstName( URLDecoder.decode( ( !ContentTests.isEmpty( params.get( "first" ) ) ?
                                                    params.get( "first" ):
                                                    "" ), "utf-8" ) );
        docMaker.setLastName( URLDecoder.decode( ( !ContentTests.isEmpty( params.get( "last" ) ) ?
                                                   params.get( "last" ):
                                                   "" ), "utf-8" ) );
        docMaker.setDbName( config.getServletContext().getInitParameter( "datasource.invoice" ) );
        docMaker.setAlmaKey( "l8xx8cb982c2d4b04ef79375f5c776dbae71" );
        docMaker.setAlmaURI( "https://api-na.hosted.exlibrisgroup.com/almaws/v1/users/" );
        docMaker.getPatronsByName();
        
        return Response.ok( docMaker ).build();
      }
      catch ( UnsupportedEncodingException uee )
      {
        return Response.serverError().entity( "Patron search failed: ".concat( uee.getMessage() ) ).build();
      }
    }

  }


  private Map<String, String> parsePath( String path )
  {
    Map<String, String> pathMap;

    if ( path.startsWith( "/" ) )
    {
      path = path.substring( 1 );
    }

    String[] pathParts = path.split( "/" );

    pathMap = new HashMap<String, String>();

    for ( int i = 0; i < pathParts.length / 2; i++ )
    {
      String key = pathParts[ 2 * i ];
      String value = pathParts[ 2 * i + 1 ];
      pathMap.put( key, value );
    }
    return pathMap;
  }
}
