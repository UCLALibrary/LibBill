package edu.ucla.library.libservices.invoicing.webservices.patrons.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "user_group")
@XmlAccessorType(XmlAccessType.FIELD)
public class UserGroup
{
  @XmlElement(name="value")
  private String value; //use this one for determining UC member status
  @XmlElement(name="desc")
  private String description; //use this one for output
  
  public UserGroup()
  {
    super();
  }

  public void setValue(String value)
  {
    this.value = value;
  }

  public String getValue()
  {
    return value;
  }

  public void setDescription(String description)
  {
    this.description = description;
  }

  public String getDescription()
  {
    return description;
  }
}
