package edu.ucla.library.libservices.invoicing.webservices.status.beans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType
@XmlAccessorType( XmlAccessType.FIELD )
public class StatusChange
{
  @XmlElement( name = "fromStatus" )
  private String fromStatus;
  @XmlElement( name = "toStatus" )
  private String toStatus;
  @XmlElement( name = "roleName" )
  private String roleName;

  public StatusChange()
  {
    super();
  }

  public void setFromStatus( String fromStatus )
  {
    this.fromStatus = fromStatus;
  }

  public String getFromStatus()
  {
    return fromStatus;
  }

  public void setToStatus( String toStatus )
  {
    this.toStatus = toStatus;
  }

  public String getToStatus()
  {
    return toStatus;
  }

  public void setRoleName( String roleName )
  {
    this.roleName = roleName;
  }

  public String getRoleName()
  {
    return roleName;
  }
}
