package edu.ucla.library.libservices.invoicing.webservices.staff.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlType;

@XmlRootElement( name = "userRole" )
@XmlAccessorType( XmlAccessType.FIELD )
public class UserRole
{
  @XmlElement( name = "userName" )
  private String userName;
  @XmlElement( name = "role" )
  private String role;
  @XmlElement( name = "userUid" )
  private String userUid;
  @XmlElement( name = "firstName", required = false )
  private String firstName;
  @XmlElement( name = "lastName", required = false )
  private String lastName;
  @XmlElement( name = "privilege", required = false )
  private String privilege;
  @XmlElement( name = "whoBy", required = false )
  private String whoBy;

  public UserRole()
  {
    super();
  }

  public void setUserName( String userName )
  {
    this.userName = userName;
  }

  public String getUserName()
  {
    return userName;
  }

  public void setRole( String role )
  {
    this.role = role;
  }

  public String getRole()
  {
    return role;
  }

  public void setPrivilege( String privilege )
  {
    this.privilege = privilege;
  }

  public String getPrivilege()
  {
    return privilege;
  }

  public String toString()
  {
    return "I am " + getUserName() + "\tmy role is " + getRole() +
      "\tmy UID = " + getUserUid() + "\tmy name = " + getLastName() 
      + ", " + getFirstName();
  }

  public void setUserUid( String userUid )
  {
    this.userUid = userUid;
  }

  public String getUserUid()
  {
    return userUid;
  }

  public void setFirstName( String firstName )
  {
    this.firstName = firstName;
  }

  public String getFirstName()
  {
    return firstName;
  }

  public void setLastName( String lastName )
  {
    this.lastName = lastName;
  }

  public String getLastName()
  {
    return lastName;
  }

  public void setWhoBy( String whoBy )
  {
    this.whoBy = whoBy;
  }

  public String getWhoBy()
  {
    return whoBy;
  }
}
