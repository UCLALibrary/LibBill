package edu.ucla.library.libservices.invoicing.webservices.staff.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.staff.beans.UserRole;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class UserRoleMapper
  implements RowMapper
{
  public UserRoleMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    UserRole bean;
    
    bean = new UserRole();
    bean.setFirstName( rs.getString( "first_name" ) );
    bean.setLastName( rs.getString( "last_name" ) );
    bean.setPrivilege( rs.getString( "privilege_name" ) );
    bean.setRole( rs.getString( "user_role" ) );
    bean.setUserName( rs.getString( "user_name" ) );
    bean.setUserUid( rs.getString( "user_uid" ) );
    
    return bean;
  }
}
