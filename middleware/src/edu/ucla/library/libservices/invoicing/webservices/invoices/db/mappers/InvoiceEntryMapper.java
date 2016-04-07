package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceEntry;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class InvoiceEntryMapper
  implements RowMapper
{
  public InvoiceEntryMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    InvoiceEntry bean;
    
    bean = new InvoiceEntry();
    bean.setAdjustmentReason( rs.getString( "adjustment_reason" ) );
    bean.setAdjustmentType( rs.getString( "adjustment_type" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setLineNumber( rs.getInt( "line_number" ) );
    bean.setLineType( rs.getInt( "line_type" ) );
    bean.setNote( rs.getString( "note" ) );
    bean.setQuantity( rs.getDouble( "quantity" ) );
    bean.setServiceName( rs.getString( "service_name" ) );
    bean.setSubtypeName( rs.getString( "subtype_name" ) );
    bean.setTotalPrice( rs.getDouble( "total_price" ) );
    bean.setUnitPrice( rs.getDouble( "unit_price" ) );
    bean.setUnitMeasure( rs.getString( "unit_measure" ) );

    return bean;
  }
}
