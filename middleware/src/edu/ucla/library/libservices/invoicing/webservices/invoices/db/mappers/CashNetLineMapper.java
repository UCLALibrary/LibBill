package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.CashNetLine;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class CashNetLineMapper
  implements RowMapper
{
  public CashNetLineMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    CashNetLine bean;
    
    bean = new CashNetLine();
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setItemCode( rs.getString( "item_code" ) );
    bean.setTotalPrice( rs.getDouble( "total_price" ) );
    
    return bean;
  }
}
