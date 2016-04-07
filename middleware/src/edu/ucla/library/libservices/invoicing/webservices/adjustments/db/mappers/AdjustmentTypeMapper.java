package edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.AdjustmentType;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class AdjustmentTypeMapper
  implements RowMapper
{
  public AdjustmentTypeMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    AdjustmentType bean;
    
    bean = new AdjustmentType();
    bean.setType( rs.getString( "adjustment_type" ) );
    
    return bean;
  }
}
