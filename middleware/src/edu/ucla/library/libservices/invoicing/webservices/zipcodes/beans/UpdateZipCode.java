package edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType( name = "zipCode" )
@XmlAccessorType( XmlAccessType.FIELD )
public class UpdateZipCode
{
  @XmlElement( name = "code" )
  private String code;
  @XmlElement( name = "oldRateName" )
  private String oldName;
  @XmlElement( name = "newRateName" )
  private String newName;
  @XmlElement( name = "createdBy", required=false )
  private String createdBy;

  public UpdateZipCode()
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

  public void setOldName( String oldName )
  {
    this.oldName = oldName;
  }

  public String getOldName()
  {
    return oldName;
  }

  public void setNewName( String newName )
  {
    this.newName = newName;
  }

  public String getNewName()
  {
    return newName;
  }

  public void setCreatedBy( String createdBy )
  {
    this.createdBy = createdBy;
  }

  public String getCreatedBy()
  {
    return createdBy;
  }
}
