package edu.ucla.library.libservices.invoicing.webservices.status.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.status.beans.StatusChange;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class StatusChangeMapper
  implements RowMapper
{
  public StatusChangeMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    StatusChange bean;
    
    bean = new StatusChange();
    bean.setFromStatus( rs.getString( "from_status" ) );
    bean.setRoleName( rs.getString( "role_name" ) );
    bean.setToStatus( rs.getString( "to_status" ) );
    
    return bean;
  }
}
