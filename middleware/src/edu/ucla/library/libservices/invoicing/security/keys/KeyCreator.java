package edu.ucla.library.libservices.invoicing.security.keys;

import java.security.NoSuchAlgorithmException;

import java.security.SecureRandom;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

public class KeyCreator
{
  public KeyCreator()
  {
    super();
  }

  public static String generateKey( int keyLength )
  {
    KeyGenerator kg;
    SecretKey key;

    try
    {
      kg = KeyGenerator.getInstance( "HmacSHA1" );
      kg.init( keyLength, new SecureRandom() );
      key = kg.generateKey();
      return getHexString( key.getEncoded() );
    }
    catch ( NoSuchAlgorithmException nsae )
    {
      nsae.printStackTrace();
      return null;
    }
  }

  private static String getHexString( byte[] raw )
  {
    String hexes;

    hexes = "0123456789abcdef";
    if ( raw == null )
    {
      return null;
    }
    final StringBuilder hex = new StringBuilder( 2 * raw.length );
    for ( final byte b: raw )
    {
      hex.append( hexes.charAt( ( b & 0xF0 ) >>
                                4 ) ).append( hexes.charAt( ( b &
                                                              0x0F ) ) );
    }
    return hex.toString();
  }
}
