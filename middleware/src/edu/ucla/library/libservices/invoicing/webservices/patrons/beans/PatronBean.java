package edu.ucla.library.libservices.invoicing.webservices.patrons.beans;

import edu.ucla.library.libservices.invoicing.utiltiy.adapters.DateAdapter;
import edu.ucla.library.libservices.invoicing.utiltiy.strings.StringCleaner;

import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

@XmlType //(propOrder={"patronID", "barcode" , "lastName", "firstName" })
@XmlAccessorType( XmlAccessType.FIELD )
public class PatronBean
{
  @XmlElement( name = "patronID" ) //, nillable = true )
  private int patronID;
  @XmlElement( name = "barcode" ) //, nillable = true )
  private String barcode;
  @XmlElement( name = "lastName" ) //, nillable = true )
  private String lastName;
  @XmlElement( name = "firstName" ) //, nillable = true )
  private String firstName;
  @XmlElement( name = "permAddress1" ) //, nillable = true )
  private String permAddress1;
  @XmlElement( name = "permAddress2" ) //, nillable = true )
  private String permAddress2;
  @XmlElement( name = "permAddress3" ) //, nillable = true )
  private String permAddress3;
  @XmlElement( name = "permAddress4" ) //, nillable = true )
  private String permAddress4;
  @XmlElement( name = "permAddress5" ) //, nillable = true )
  private String permAddress5;
  @XmlElement( name = "permCity" ) //, nillable = true )
  private String permCity;
  @XmlElement( name = "permState" ) //, nillable = true )
  private String permState;
  @XmlElement( name = "permZip" ) //, nillable = true )
  private String permZip;
  @XmlElement( name = "permCountry" ) //, nillable = true )
  private String permCountry;
  @XmlElement( name = "localAddress1" ) //, nillable = true )
  private String localAddress1;
  @XmlElement( name = "localAddress2" ) //, nillable = true )
  private String localAddress2;
  @XmlElement( name = "localAddress3" ) //, nillable = true )
  private String localAddress3;
  @XmlElement( name = "localAddress4" ) //, nillable = true )
  private String localAddress4;
  @XmlElement( name = "localAddress5" ) //, nillable = true )
  private String localAddress5;
  @XmlElement( name = "localCity" ) //, nillable = true )
  private String localCity;
  @XmlElement( name = "localState" ) //, nillable = true )
  private String localState;
  @XmlElement( name = "localZip" ) //, nillable = true )
  private String localZip;
  @XmlElement( name = "localCountry" ) //, nillable = true )
  private String localCountry;
  @XmlElement( name = "ucMember" ) //, nillable = true )
  private boolean isUC;
  @XmlElement( name = "email" ) //, nillable = true )
  private String email;
  @XmlElement( name = "institutionID" )
  private String institutionID;
  @XmlElement( name = "tempEffectdate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date tempEffectdate;
  @XmlElement( name = "tempExpireDate" )
  @XmlJavaTypeAdapter( DateAdapter.class )
  private Date tempExpireDate;
  @XmlElement( name = "phoneNumber" )
  private String phoneNumber;
  @XmlElement( name = "primaryID" )
  private String primaryID;

  public PatronBean()
  {
    super();
  }

  public void setPatronID( int patronID )
  {
    this.patronID = patronID;
  }

  public int getPatronID()
  {
    return patronID;
  }

  public void setBarcode( String barcode )
  {
    this.barcode =
        ( !ContentTests.isEmpty( barcode ) ? StringCleaner.removeControlChars( barcode ):
          "" );
  }

  public String getBarcode()
  {
    return barcode;
  }

  public void setLastName( String lastName )
  {
    this.lastName =
        ( !ContentTests.isEmpty( lastName ) ? StringCleaner.removeControlChars( lastName ):
          "" );
  }

  public String getLastName()
  {
    return lastName;
  }

  public void setFirstName( String firstName )
  {
    this.firstName =
        ( !ContentTests.isEmpty( firstName ) ? StringCleaner.removeControlChars( firstName ):
          "" );
  }

  public String getFirstName()
  {
    return firstName;
  }

  public void setPermAddress1( String permAddress1 )
  {
    this.permAddress1 =
        ( !ContentTests.isEmpty( permAddress1 ) ? StringCleaner.removeControlChars( permAddress1 ):
          "" );
  }

  public String getPermAddress1()
  {
    return permAddress1;
  }

  public void setPermAddress2( String permAddress2 )
  {
    this.permAddress2 =
        ( !ContentTests.isEmpty( permAddress2 ) ? StringCleaner.removeControlChars( permAddress2 ):
          "" );
  }

  public String getPermAddress2()
  {
    return permAddress2;
  }

  public void setPermAddress3( String permAddress3 )
  {
    this.permAddress3 =
        ( !ContentTests.isEmpty( permAddress3 ) ? StringCleaner.removeControlChars( permAddress3 ):
          "" );
  }

  public String getPermAddress3()
  {
    return permAddress3;
  }

  public void setPermAddress4( String permAddress4 )
  {
    this.permAddress4 =
        ( !ContentTests.isEmpty( permAddress4 ) ? StringCleaner.removeControlChars( permAddress4 ):
          "" );
  }

  public String getPermAddress4()
  {
    return permAddress4;
  }

  public void setPermAddress5( String permAddress5 )
  {
    this.permAddress5 =
        ( !ContentTests.isEmpty( permAddress5 ) ? StringCleaner.removeControlChars( permAddress5 ):
          "" );
  }

  public String getPermAddress5()
  {
    return permAddress5;
  }

  public void setPermCity( String permCity )
  {
    this.permCity =
        ( !ContentTests.isEmpty( permCity ) ? StringCleaner.removeControlChars( permCity ):
          "" );
  }

  public String getPermCity()
  {
    return permCity;
  }

  public void setPermState( String permState )
  {
    this.permState =
        ( !ContentTests.isEmpty( permState ) ? StringCleaner.removeControlChars( permState ):
          "" );
  }

  public String getPermState()
  {
    return permState;
  }

  public void setPermZip( String permZip )
  {
    this.permZip =
        ( !ContentTests.isEmpty( permZip ) ? StringCleaner.removeControlChars( permZip ):
          "" );
  }

  public String getPermZip()
  {
    return permZip;
  }

  public void setPermCountry( String permCountry )
  {
    this.permCountry =
        ( !ContentTests.isEmpty( permCountry ) ? StringCleaner.removeControlChars( permCountry ):
          "" );
  }

  public String getPermCountry()
  {
    return permCountry;
  }

  public void setLocalAddress1( String localAddress1 )
  {
    this.localAddress1 =
        ( !ContentTests.isEmpty( localAddress1 ) ? StringCleaner.removeControlChars( localAddress1 ):
          "" );
  }

  public String getLocalAddress1()
  {
    return localAddress1;
  }

  public void setLocalAddress2( String localAddress2 )
  {
    this.localAddress2 =
        ( !ContentTests.isEmpty( localAddress2 ) ? StringCleaner.removeControlChars( localAddress2 ):
          "" );
  }

  public String getLocalAddress2()
  {
    return localAddress2;
  }

  public void setLocalAddress3( String localAddress3 )
  {
    this.localAddress3 =
        ( !ContentTests.isEmpty( localAddress3 ) ? StringCleaner.removeControlChars( localAddress3 ):
          "" );
  }

  public String getLocalAddress3()
  {
    return localAddress3;
  }

  public void setLocalAddress4( String localAddress4 )
  {
    this.localAddress4 =
        ( !ContentTests.isEmpty( localAddress4 ) ? StringCleaner.removeControlChars( localAddress4 ):
          "" );
  }

  public String getLocalAddress4()
  {
    return localAddress4;
  }

  public void setLocalAddress5( String localAddress5 )
  {
    this.localAddress5 =
        ( !ContentTests.isEmpty( localAddress5 ) ? StringCleaner.removeControlChars( localAddress5 ):
          "" );
  }

  public String getLocalAddress5()
  {
    return localAddress5;
  }

  public void setLocalCity( String localCity )
  {
    this.localCity =
        ( !ContentTests.isEmpty( localCity ) ? StringCleaner.removeControlChars( localCity ):
          "" );
  }

  public String getLocalCity()
  {
    return localCity;
  }

  public void setLocalState( String localState )
  {
    this.localState =
        ( !ContentTests.isEmpty( localState ) ? StringCleaner.removeControlChars( localState ):
          "" );
  }

  public String getLocalState()
  {
    return localState;
  }

  public void setLocalZip( String localZip )
  {
    this.localZip =
        ( !ContentTests.isEmpty( localZip ) ? StringCleaner.removeControlChars( localZip ):
          "" );
  }

  public String getLocalZip()
  {
    return localZip;
  }

  public void setLocalCountry( String localCountry )
  {
    this.localCountry =
        ( !ContentTests.isEmpty( localCountry ) ? StringCleaner.removeControlChars( localCountry ):
          "" );
  }

  public String getLocalCountry()
  {
    return localCountry;
  }

  public void setIsUC( boolean isUC )
  {
    this.isUC = isUC;
  }

  public boolean isIsUC()
  {
    return isUC;
  }

  public void setEmail( String email )
  {
    this.email =
        ( !ContentTests.isEmpty( email ) ? StringCleaner.removeControlChars( email ):
          "" );
  }

  public String getEmail()
  {
    return email;
  }

  public void setInstitutionID( String institutionID )
  {
    this.institutionID =
        ( !ContentTests.isEmpty( institutionID ) ? StringCleaner.removeControlChars( institutionID ):
          "" );
  }

  public String getInstitutionID()
  {
    return institutionID;
  }

  public void setTempEffectdate( Date tempEffectdate )
  {
    this.tempEffectdate = tempEffectdate;
  }

  public Date getTempEffectdate()
  {
    return tempEffectdate;
  }

  public void setTempExpireDate( Date tempExpireDate )
  {
    this.tempExpireDate = tempExpireDate;
  }

  public Date getTempExpireDate()
  {
    return tempExpireDate;
  }

  public void setPhoneNumber( String phoneNumber )
  {
    this.phoneNumber = phoneNumber;
  }

  public String getPhoneNumber()
  {
    return phoneNumber;
  }

  public void setPrimaryID(String primaryID)
  {
    this.primaryID = primaryID;
  }

  public String getPrimaryID()
  {
    return primaryID;
  }
}
