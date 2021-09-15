package edu.ucla.library.libservices.invoicing.webservices.patrons.beans;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "user")
@XmlAccessorType( XmlAccessType.FIELD )
public class AlmaPatron
{
  @XmlElement( name = "primary_id" )
  private String patronID;
  @XmlElement( name = "first_name" )
  private String firstName;
  @XmlElement( name = "last_name" ) 
  private String lastName;
  @XmlElement( name = "user_group" )
  private UserGroup userGroup;
  @XmlElement( name = "expiry_date" )
  private String expiryDate;
  @XmlElement( name = "contact_info" )
  private ContactInfo contactInfo;
  @XmlElement( name = "user_identifier" )
  private List<UserIdentifier> userIdentifiers;
  /*@XmlElement(name = "addresses")
  private List<Address> addresses;
  @XmlElement(name = "emails")
  private List<Email> emails;
  @XmlElement(name = "phones")
  private List<Phone> phones;*/
 
  public AlmaPatron()
  {
    super();
  }

  public void setPatronID(String patronID)
  {
    this.patronID = patronID;
  }

  public String getPatronID()
  {
    return patronID;
  }

  public void setFirstName(String firstName)
  {
    this.firstName = firstName;
  }

  public String getFirstName()
  {
    return firstName;
  }

  public void setLastName(String lastName)
  {
    this.lastName = lastName;
  }

  public String getLastName()
  {
    return lastName;
  }

  public void setContactInfo(ContactInfo contactInfo)
  {
    this.contactInfo = contactInfo;
  }

  public ContactInfo getContactInfo()
  {
    return contactInfo;
  }

  public void setUserGroup(UserGroup userGroup)
  {
    this.userGroup = userGroup;
  }

  public UserGroup getUserGroup()
  {
    return userGroup;
  }

  public void setExpiryDate(String expiryDate)
  {
    this.expiryDate = expiryDate;
  }

  public String getExpiryDate()
  {
    return expiryDate;
  }

  public void setUserIdentifiers(List<UserIdentifier> userIdentifiers)
  {
    this.userIdentifiers = userIdentifiers;
  }

  public List<UserIdentifier> getUserIdentifiers()
  {
    return userIdentifiers;
  }

  /*public void setAddresses(List<Address> addresses)
  {
    this.addresses = addresses;
  }

  public List<Address> getAddresses()
  {
    return addresses;
  }

  public void setEmails(List<Email> emails)
  {
    this.emails = emails;
  }

  public List<Email> getEmails()
  {
    return emails;
  }

  public void setPhones(List<Phone> phones)
  {
    this.phones = phones;
  }

  public List<Phone> getPhones()
  {
    return phones;
  }*/
}
