package edu.ucla.library.libservices.invoicing.webservices.patrons.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "id_type")
@XmlAccessorType(XmlAccessType.FIELD)
public class IdType
{
  @XmlElement(name="value")
  private String value; //use this one for finding barcode
  @XmlElement(name="desc")
  private String description; //use this one for output
  
  public IdType()
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
