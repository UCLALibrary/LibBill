package edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.InvoiceAdjustment;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class InvoiceAdjustmentMapper
  implements RowMapper
{
  public InvoiceAdjustmentMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    InvoiceAdjustment bean;
    
    bean = new InvoiceAdjustment();
    bean.setAdjustmentAmount( rs.getDouble( "adjustment_amount" ) );
    bean.setAdjustmentReason( rs.getString( "adjustment_reason" ) );
    bean.setAdjustmentType( rs.getString( "adjustment_type" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );

    return bean;
  }
}
