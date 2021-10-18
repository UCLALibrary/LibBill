package edu.ucla.library.libservices.invoicing.utiltiy.adapters;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;

import java.io.IOException;

import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class RequestWrapper
  extends HttpServletRequestWrapper
{
  private byte[] bytes = null;

  public RequestWrapper( HttpServletRequest httpServletRequest )
  {
    super( httpServletRequest );
  }

  public ServletInputStream getInputStream()
    throws IOException
  {
    if ( bytes == null )
    { // first time
      InputStream in = super.getRequest().getInputStream();
      bytes = new byte[ super.getRequest().getContentLength() < 0 ? 0 : super.getRequest().getContentLength() ];
      for ( int r, offset = 0;
            ( r = in.read( bytes, offset, bytes.length - offset ) ) > -1; )
      {
        offset += r;
      }
    }
    final InputStream in = new ByteArrayInputStream( bytes );
    return new ServletInputStream()
    {
      public int read()
        throws IOException
      {
        return in.read();
      }

      @Override
      public boolean isFinished()
      {
        // TODO Implement this method
        return false;
      }

      @Override
      public boolean isReady()
      {
        // TODO Implement this method
        return false;
      }

      @Override
      public void setReadListener(ReadListener readListener)
      {
        // TODO Implement this method
      }
    };
  }

  public BufferedReader getReader()
    throws IOException
  {
    return new BufferedReader( new InputStreamReader( getInputStream() ) );
  }

}
  /*private HttpServletRequest origRequest;
  private byte[] reqBytes;
  private boolean firstTime = true;*/
  //    origRequest = httpServletRequest;

/*
    BufferedReader returnReader;
    BufferedReader originalReader;
    InputStreamReader newReader;
    StringBuffer buffer;
    String line;

    if ( firstTime )
    {
      firstTime = false;
      buffer = new StringBuffer();
      originalReader = origRequest.getReader();
      while ( ( line = originalReader.readLine() ) != null )
      {
        buffer.append( line );
        buffer.append( "\n" );
      }
      reqBytes = buffer.toString().getBytes();
    }

    newReader = new InputStreamReader( new ByteArrayInputStream( reqBytes ) );
    returnReader = new BufferedReader( newReader );
    return returnReader;
 */