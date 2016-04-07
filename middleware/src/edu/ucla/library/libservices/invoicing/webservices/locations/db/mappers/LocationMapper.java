package edu.ucla.library.libservices.invoicing.webservices.locations.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.locations.beans.Location;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class LocationMapper
  implements RowMapper
{
  public LocationMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    Location bean;
    
    bean = new Location();
    bean.setCode( rs.getString( "location_code" ) );
    bean.setName( rs.getString( "location_name" ) );
    bean.setDepartment( rs.getString( "department_number" ) );
    bean.setId( rs.getInt( "location_id" ) );
    bean.setPhone( rs.getString( "phone_number" ) );
    
    return bean;
  }
}
