package edu.ucla.library.libservices.invoicing.utiltiy.testing;

import com.itextpdf.text.Document;

import com.itextpdf.text.DocumentException;
import com.itextpdf.text.PageSize;

import com.itextpdf.text.pdf.PdfWriter;

import edu.ucla.library.libservices.invoicing.security.signatures.SignatureCreator;
import edu.ucla.library.libservices.invoicing.webservices.invoices.generator.PdfGenerator;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Address;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.AlmaPatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Email;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Phone;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.UserIdentifier;
import edu.ucla.library.libservices.invoicing.webservices.patrons.clients.PatronClient;

import edu.ucla.library.libservices.invoicing.webservices.patrons.converters.AlmaVgerConverter;

import java.io.ByteArrayOutputStream;

import java.security.SignatureException;

public class Tester
{

  public Tester()
  {
    super();
  }

  public static void main(String[] args)
  {
    /*StringBuffer buffer;

    buffer = new StringBuffer( "get" ).append( "\n" );
    buffer.append( "/invoicing/patrons/patron_record/6035136122" ).append( "\n" );
    buffer.append( "-30-" );

    try
    {
      System.out.println(SignatureCreator.hashSignature(buffer.toString().trim(), "E4538829F1"));
    }
    catch (SignatureException e)
    {
      e.printStackTrace();
    }*/
    AlmaPatron thePatron;
    PatronBean theVger;
    PatronClient client;

    client = new PatronClient();
    client.setKey("l8xx8cb982c2d4b04ef79375f5c776dbae71");
    client.setUriBase("https://api-na.hosted.exlibrisgroup.com/almaws/v1/users/");
    client.setUserID("6035136122");

    thePatron = client.getThePatron();
    theVger = AlmaVgerConverter.convertPatron(thePatron);
    System.out.println(theVger.getFirstName() + " " + theVger.getLastName() + " " + theVger.getBarcode());
    System.out.println(theVger.getPermAddress1() + " " + theVger.getPermAddress2() + " " + theVger.getPermCity() + " " +
                       theVger.getPermState() + " " + theVger.getPermCountry() + " " + theVger.getPermZip());
    System.out.println(theVger.getEmail() + " " + theVger.getPhoneNumber());

    System.out.println(thePatron.getFirstName() + " " + thePatron.getLastName() + " " + thePatron.getPatronID() + " " +
                       thePatron.getUserGroup().getValue() + " " + thePatron.getUserGroup().getDescription());
    for (UserIdentifier theID: thePatron.getUserIdentifiers())
    {
      System.out.println(theID.getType().getValue() + " " + theID.getValue());
    }
    for ( Address theAddress : thePatron.getContactInfo().getAddresses() )
    {
      System.out.println(theAddress.getLine1() + " " + theAddress.getLine2() + " " + theAddress.getCity()
                         + " " + theAddress.getState() + " " + theAddress.getCountry().getDescription()
                         + " " + theAddress.getZipCode());
    }
    for ( Email theMail : thePatron.getContactInfo().getEmails() )
    {
      System.out.println( theMail.getEmailAddress() + " " + theMail.isPreferred() );
    }
    for ( Phone thePhone : thePatron.getContactInfo().getPhones() )
    {
      System.out.println( thePhone.getPhoneNumber() + " " + thePhone.isPreferred() );
    }

    /*ByteArrayOutputStream baos;
    Document document;
    PdfGenerator generator;

    document = new Document( PageSize.LETTER );
    baos = new ByteArrayOutputStream();
    generator = new PdfGenerator();
    generator.setInvoiceNumber( "AS011102" );
    try
    {
      PdfWriter.getInstance(document, baos);
      generator.populatePdf( document, "204684742" );
    }
    catch (DocumentException de)
    {
      de.printStackTrace();
    }*/

  }

}
