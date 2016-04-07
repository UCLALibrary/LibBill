package edu.ucla.library.libservices.invoicing.webservices.status.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.status.beans.InvoiceStatus;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class InvoiceStatusMapper
  implements RowMapper
{
  public InvoiceStatusMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    InvoiceStatus bean;
    
    bean = new InvoiceStatus();
    bean.setStatus( rs.getString( "status" ) );

    return bean;
  }
}
