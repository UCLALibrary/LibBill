package edu.ucla.library.libservices.invoicing.webservices.status.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.status.beans.StatusChange;
import edu.ucla.library.libservices.invoicing.webservices.status.db.mappers.StatusChangeMapper;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "statusChangeList" )
public class StatusChangeGenerator
{
  private static final String ALL_CHANGES_QUERY =
    //"SELECT * FROM invoice_owner.invoice_status_change_vw ORDER BY " 
    "SELECT * FROM invoice_status_change_vw ORDER BY " 
    + "role_name, from_status, to_status";
  private static final String FILTERED_CHANGES_QUERY =
    //"SELECT * FROM invoice_owner.invoice_status_change_vw WHERE lower(role_name)" 
    "SELECT * FROM invoice_status_change_vw WHERE lower(role_name)" 
    + " = ? AND lower(from_status) = ? ORDER BY role_name, from_status, to_status";

  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String role;
  private String status;
  @XmlElement( name = "changes" )
  private List<StatusChange> allChanges;
  @XmlElement( name = "changes" )
  private List<StatusChange> filteredChanges;

  public StatusChangeGenerator()
  {
    super();
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void populateAllChanges()
  {
    makeConnection();

    allChanges =
        new JdbcTemplate( ds ).query( ALL_CHANGES_QUERY, new StatusChangeMapper() );
  }

  public void populateFilteredChanges()
  {
    makeConnection();

    filteredChanges =
        new JdbcTemplate( ds ).query( FILTERED_CHANGES_QUERY, new Object[]
          { getRole().toLowerCase(), getStatus().toLowerCase() }, 
                                      new StatusChangeMapper() );
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void setRole( String role )
  {
    this.role = role;
  }

  private String getRole()
  {
    return role;
  }

  public void setStatus( String status )
  {
    this.status = status;
  }

  private String getStatus()
  {
    return status;
  }
}
