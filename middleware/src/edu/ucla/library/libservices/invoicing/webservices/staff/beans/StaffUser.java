package edu.ucla.library.libservices.invoicing.webservices.staff.beans;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement( name = "user" )
@XmlAccessorType( XmlAccessType.FIELD )
public class StaffUser
{
  @XmlElement( name = "userName")
  private String userName;
  @XmlElement( name = "idKey")
  private String idKey;
  @XmlElement( name = "cryptoKey")
  private String cryptoKey;
  @XmlElement( name = "userUid")
  private String userUid;
  @XmlElement( name = "role")
  private String role;
  @XmlElement( name = "userPrivilege")
  private List<UserRole> privileges;

  public StaffUser()
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

  public void setIdKey( String idKey )
  {
    this.idKey = idKey;
  }

  public String getIdKey()
  {
    return idKey;
  }

  public void setCryptoKey( String cryptoKey )
  {
    this.cryptoKey = cryptoKey;
  }

  public String getCryptoKey()
  {
    return cryptoKey;
  }

  public void setUserUid( String userUid )
  {
    this.userUid = userUid;
  }

  public String getUserUid()
  {
    return userUid;
  }

  public void setPrivileges( List<UserRole> privileges )
  {
    this.privileges = privileges;
  }

  public List<UserRole> getPrivileges()
  {
    return privileges;
  }

  public void setRole( String role )
  {
    this.role = role;
  }

  public String getRole()
  {
    return role;
  }
  
  public String toString()
  {
    return "I am " + getUserName() + "\tUID = " + getUserUid() + "\tID key = " + getIdKey();
  }
}
