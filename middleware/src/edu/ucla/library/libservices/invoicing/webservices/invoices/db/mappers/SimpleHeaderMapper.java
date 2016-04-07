package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.SimpleHeader;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class SimpleHeaderMapper
  implements RowMapper
{
  public SimpleHeaderMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    SimpleHeader bean;
    
    bean = new SimpleHeader();
    bean.setBalanceDue( rs.getDouble( "balance_due" ) );
    bean.setInvoiceDate( rs.getDate( "invoice_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setLocationName( rs.getString( "location_name" ) );
    
    return bean;
  }
}
