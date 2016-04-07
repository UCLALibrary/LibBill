package edu.ucla.library.libservices.invoicing.webservices.staff.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.staff.beans.StaffUser;

import java.sql.ResultSet;

import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class StaffUserMapper
  implements RowMapper
{
  public StaffUserMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    StaffUser bean;
    
    bean = new StaffUser();
    bean.setCryptoKey( rs.getString( "crypto_key" ) );
    bean.setIdKey( rs.getString( "id_key" ) );
    bean.setUserName( rs.getString( "user_name" ) );
    bean.setUserUid( rs.getString( "user_uid" ) );

    return bean;
  }
}
