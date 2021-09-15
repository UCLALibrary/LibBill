package edu.ucla.library.libservices.invoicing.webservices.patrons.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "user_identifier")
@XmlAccessorType(XmlAccessType.FIELD)
public class UserIdentifier implements Comparable<UserIdentifier>
{
  @XmlElement(name = "id_type")
  private IdType type;
  @XmlElement(name = "value")
  private String value;
  @XmlElement(name = "note")
  private String note;
  @XmlElement(name = "status")
  private String status;

  public UserIdentifier()
  {
    super();
  }

  public void setType(IdType type)
  {
    this.type = type;
  }

  public IdType getType()
  {
    return type;
  }

  public void setValue(String value)
  {
    this.value = value;
  }

  public String getValue()
  {
    return value;
  }

  public void setNote(String note)
  {
    this.note = note;
  }

  public String getNote()
  {
    return note;
  }

  public void setStatus(String status)
  {
    this.status = status;
  }

  public String getStatus()
  {
    return status;
  }

  @Override
  public int compareTo(UserIdentifier userIdentifier)
  {
    // TODO Implement this method
    return this.getValue().compareTo(userIdentifier.getValue());
  }
}
