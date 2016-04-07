package edu.ucla.library.libservices.invoicing.security.filters;

import edu.ucla.library.libservices.invoicing.clients.staff.StaffUserClient;
import edu.ucla.library.libservices.invoicing.security.signatures.SignatureCreator;
import edu.ucla.library.libservices.invoicing.utiltiy.adapters.RequestWrapper;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.StaffUser;

import java.io.BufferedReader;
import java.io.IOException;

import java.security.SignatureException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

public class AuthenticationServlet
  implements Filter
{
  private FilterConfig _filterConfig = null;

  public void init( FilterConfig filterConfig )
    throws ServletException
  {
    _filterConfig = filterConfig;
  }

  public void destroy()
  {
    _filterConfig = null;
  }

  public void doFilter( ServletRequest request, ServletResponse response,
                        FilterChain chain )
    throws IOException, ServletException
  {
    ServletContext context;
    HttpServletRequest httpReq;
    HttpServletResponse httpResp;
    RequestWrapper wrapper;
    String signature, idKey, hash, local;
    StaffUser user;

    httpReq = ( HttpServletRequest ) request;
    httpResp = ( HttpServletResponse ) response;
    wrapper = new RequestWrapper( httpReq );

    context = _filterConfig.getServletContext();
    
    signature = httpReq.getHeader( "Authorization" );

    if ( !ContentTests.isEmpty( signature ) )
    {
      idKey = signature.split( ":" )[ 0 ];
      hash = signature.split( ":" )[ 1 ];

      if ( context.getAttribute( idKey ) != null )
      {
        user = ( StaffUser ) context.getAttribute( idKey );
      }
      else
      {
        user = getUser( idKey, context.getInitParameter( "datasource.invoice" ) );
        context.setAttribute( idKey, user );
      }

      try
      {
        local = computeSignature( user, wrapper );
        if ( hash.equalsIgnoreCase( local ) )
          chain.doFilter( wrapper, response );
        else
          httpResp.sendError( HttpServletResponse.SC_FORBIDDEN,
                              "signatures don't match: received " + hash +
                              "\tgenerated " + local );
      }
      catch ( SignatureException se )
      {
        context.log( se.getMessage(), se );
        httpResp.sendError( HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "run-time error generating signature" );
      }
    }
    else
    {
      httpResp.sendError( HttpServletResponse.SC_FORBIDDEN,
                          "no message signature received" );
    }
  }

  private StaffUser getUser( String idKey, String dbName )
  {
    StaffUserClient client;
    client = new StaffUserClient();
    return client.getUserByKey( idKey, dbName );
  }

  private String computeSignature( StaffUser user,
                                   RequestWrapper wrapper )
    throws IOException, SignatureException
  {
    StringBuffer buffer;

    buffer = new StringBuffer( wrapper.getMethod() ).append( "\n" );
    buffer.append( wrapper.getRequestURI() ).append( "\n" );
    if ( wrapper.getContentLength() > 0 ) 
    // && !ContentTests.isEmpty( request.getHeader( "payload" ) ) )
    {
      BufferedReader reader;
      String line;

      reader = wrapper.getReader();

      while ( ( line = reader.readLine() ) != null )
        buffer.append( line ).append( "\n" );
      reader.mark( 0 );
      reader.reset();
      reader.close();
      //buffer.append( request.getHeader( "payload" ) ).append( "\n" );
    }
    buffer.append( "-30-" );

    return SignatureCreator.hashSignature( buffer.toString().trim(),
                                           user.getCryptoKey() );
    //SignatureCreator.createSignature( request ).trim()
  }
}
//use a jersey client class to retrieve StaffUser object first time id_key is
//received & store in session under id_key key;

/*
 * intercept request
 * look for staffuser obj in session via id_key
 *  if not in session, retrieve & store obj
 * compute & compare signature with received signature
 * if good, doFilter (send to service or check authorization)
 * if bad, do 403 redirect
 */