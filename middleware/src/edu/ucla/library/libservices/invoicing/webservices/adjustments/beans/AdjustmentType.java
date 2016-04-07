package edu.ucla.library.libservices.invoicing.webservices.adjustments.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType//(name = "adjustmentTypes")
@XmlAccessorType( XmlAccessType.FIELD )
public class AdjustmentType
{
  @XmlElement( name = "type" )
  private String type;
  
  public AdjustmentType()
  {
    super();
  }

  public void setType( String type )
  {
    this.type = type;
  }

  public String getType()
  {
    return type;
  }
  
  public String toString()
  {
    return "Reason: " + getType();
  }
}
