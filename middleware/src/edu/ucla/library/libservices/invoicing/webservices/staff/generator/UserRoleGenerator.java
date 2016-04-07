package edu.ucla.library.libservices.invoicing.webservices.staff.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.staff.beans.UserRole;

import edu.ucla.library.libservices.invoicing.webservices.staff.db.mappers.UserRoleMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class UserRoleGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String userName;
  private List<UserRole> privileges;
  private List<UserRole> users;
  private static final String PRIVILEGES_BY_USER =
    //"SELECT * FROM invoice_owner.user_role_privilege_vw WHERE lower(user_name) = ?" +
    "SELECT * FROM user_role_privilege_vw WHERE lower(user_name) = ?" +
    " ORDER BY privilege_name";
  private static final String ALL_USERS =
    "SELECT DISTINCT user_name, user_role, NULL AS privilege_name, user_uid," 
    + " first_name, last_name FROM user_role_privilege_vw ORDER BY last_name, first_name";
    //+ "invoice_owner.user_role_privilege_vw ORDER BY user_name";

  public UserRoleGenerator()
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

  public void setUserName( String userName )
  {
    this.userName = userName;
  }

  private String getUserName()
  {
    return userName;
  }

  public List<UserRole> getPrivileges()
  {
    makeConnection();

    privileges =
        new JdbcTemplate( ds ).query( PRIVILEGES_BY_USER, new Object[]
          { getUserName().toLowerCase() }, new UserRoleMapper() );
    return privileges;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public List<UserRole> getUsers()
  {
    makeConnection();

    users =
        new JdbcTemplate( ds ).query( ALL_USERS, new UserRoleMapper() );
    return users;
  }
}
