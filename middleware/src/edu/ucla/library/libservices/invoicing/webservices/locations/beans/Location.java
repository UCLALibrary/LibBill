package edu.ucla.library.libservices.invoicing.webservices.locations.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "branch")
@XmlAccessorType( XmlAccessType.FIELD )
public class Location
{
  @XmlElement( name = "code" )
  private String code;
  @XmlElement( name = "name" )
  private String name;
  @XmlElement( name = "department" )
  private String department;
  @XmlElement( name = "phone" )
  private String phone;
  @XmlElement( name = "whoBy", required = false )
  private String whoBy;
  @XmlElement( name = "id" )
  private int id;

  public Location()
  {
    super();
  }

  public void setCode( String code )
  {
    this.code = code;
  }

  public String getCode()
  {
    return code;
  }

  public void setName( String name )
  {
    this.name = name;
  }

  public String getName()
  {
    return name;
  }

  public void setDepartment( String department )
  {
    this.department = department;
  }

  public String getDepartment()
  {
    return department;
  }

  public void setPhone( String phone )
  {
    this.phone = phone;
  }

  public String getPhone()
  {
    return phone;
  }

  public void setWhoBy( String whoBy )
  {
    this.whoBy = whoBy;
  }

  public String getWhoBy()
  {
    return whoBy;
  }

  public void setId( int id )
  {
    this.id = id;
  }

  public int getId()
  {
    return id;
  }
}
