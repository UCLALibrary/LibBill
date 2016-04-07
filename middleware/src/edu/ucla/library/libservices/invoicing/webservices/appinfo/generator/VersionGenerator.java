package edu.ucla.library.libservices.invoicing.webservices.appinfo.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class VersionGenerator
{
  private static final String VERSION_QUERY =
    "SELECT get_application_setting('version') FROM dual";
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;

  public VersionGenerator()
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

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public String getVersion()
  {
    makeConnection();
    return new JdbcTemplate( ds ).queryForObject( VERSION_QUERY,
                                                  String.class ).toString();
  }
}
