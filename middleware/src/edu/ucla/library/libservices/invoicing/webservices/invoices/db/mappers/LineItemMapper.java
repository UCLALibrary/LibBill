package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemBean;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class LineItemMapper
  implements RowMapper
{
  public LineItemMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    LineItemBean bean;

    bean = new LineItemBean();
    bean.setBranchServiceID( rs.getInt( "loc_svc_xref_id" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setQuantity( rs.getDouble( "quantity" ) );
    bean.setUnitPrice( rs.getDouble( "unitprice" ) );

    return bean;
  }
}
