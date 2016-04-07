package edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.LineItemAdjustment;

import java.sql.ResultSet;

import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class LineItemAdjustmentMapper
  implements RowMapper
{
  public LineItemAdjustmentMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    LineItemAdjustment bean;
    
    bean = new LineItemAdjustment();
    bean.setAdjustmentReason( rs.getString( "adjustment_reason" ) );
    bean.setAdjustmentType( rs.getString( "adjustment_type" ) );
    bean.setAmount( rs.getDouble( "adjustment_amount" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setLineNumber( rs.getInt( "line_number" ) );
    bean.setTaxable( ( rs.getString( "taxable" ).equalsIgnoreCase( "Y" ) ? true : false ) );

    return bean;
  }
}
