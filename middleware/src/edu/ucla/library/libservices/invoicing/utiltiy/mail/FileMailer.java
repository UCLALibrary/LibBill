package edu.ucla.library.libservices.invoicing.utiltiy.mail;

import java.io.File;
import java.io.FileInputStream;

import java.io.IOException;

import java.util.Date;
import java.util.Properties;

import javax.activation.FileDataSource;
import javax.activation.DataHandler;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class FileMailer
{
  public FileMailer()
  {
    super();
  }

  public static void mailFile( String fileName, String toAddress,
                               String propFile ) //, String messageText )
    throws MessagingException, IOException
  {
    FileDataSource file;
    InternetAddress[] address;
    Message message;
    MimeBodyPart attachment;
    MimeBodyPart content;
    Multipart letter;
    Properties appProps;
    Properties sysProps;
    Session mailSession;

    appProps = new Properties();
    appProps.load( new FileInputStream( new File( propFile ) ) );
    sysProps = System.getProperties();
    sysProps.put( "mail.smtp.host",
                  appProps.getProperty( "mail.mailhost" ) );
    mailSession = Session.getDefaultInstance( sysProps, null );
    message = new MimeMessage( mailSession );
    message.setFrom( new InternetAddress( appProps.getProperty( "mail.fromaddress" ) ) );
    address = new InternetAddress[]
        { new InternetAddress( toAddress ) };
    message.setRecipients( Message.RecipientType.TO, address );
    message.setSubject( "UCLA Library Invoice" );
    message.setSentDate( new Date() );
    content = new MimeBodyPart();
    content.setText( "Your invoice is attached." ); //messageText ); 
    attachment = new MimeBodyPart();
    file =
        new FileDataSource( appProps.getProperty( "mail.filebase" ).trim().concat( fileName ) );
    attachment.setDataHandler( new DataHandler( file ) );
    attachment.setFileName( fileName );
    letter = new MimeMultipart();
    letter.addBodyPart( content );
    letter.addBodyPart( attachment );
    message.setContent( letter );
    Transport.send( message );
  }
}
