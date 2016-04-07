package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.DisplayLineItem;

import java.sql.ResultSet;

import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class DisplayLineItemMapper
  implements RowMapper
{
  public DisplayLineItemMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    DisplayLineItem bean;
    
    bean = new DisplayLineItem();
    bean.setBranchName( rs.getString( "location_name" ) );
    bean.setBranchServiceID( rs.getInt("location_service_id") );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setItemCode( rs.getString( "item_code" ) );
    bean.setLineNumber( rs.getInt( "line_number" ) );
    bean.setNonUcMinimum( rs.getDouble( "non_uc_minimum_amount" ) );
    bean.setQuantity( rs.getDouble( "quantity" ) );
    bean.setRequireCustomPrice( ( rs.getString( "require_custom_price" ).equalsIgnoreCase( "Y" ) ?
                                  true: false ) );
    bean.setService( rs.getString( "service_name" ) );
    bean.setServiceSubtype( rs.getString( "subtype_name" ) );
    bean.setTotalPrice( rs.getDouble( "total_price" ) );
    bean.setUcMinimum( rs.getDouble( "uc_minimum_amount" ) );
    bean.setUnitPrice( rs.getDouble( "unit_price" ) );
    bean.setUnitMeasure( rs.getString( "unit_measure" ) );

    return bean;
  }
}
