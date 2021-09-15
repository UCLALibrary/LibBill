package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceHeaderBean;

import java.sql.ResultSet;

import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class InvoiceHeaderMapper
  implements RowMapper
{
  public InvoiceHeaderMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    InvoiceHeaderBean bean;
    
    bean = new InvoiceHeaderBean();
    bean.setBalanceDue( rs.getDouble( "balance_due" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setDepartmentNumber( rs.getString( "department_number" ) );
    bean.setInvoiceDate( rs.getDate( "invoice_date" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setLineItemTotal( rs.getDouble( "line_item_total" ) );
    bean.setLocationName( rs.getString( "location_name" ) );
    bean.setNontaxableTotal( rs.getDouble( "nontaxable_total" ) );
    bean.setOnPremises( rs.getString( "patron_on_premises" ) );
    bean.setPatronID( rs.getInt( "patron_id" ) );
    bean.setPatronPrimaryID(rs.getString("priamry_id"));
    bean.setPhoneNumber( rs.getString( "phone_number" ) );
    bean.setStatus( rs.getString( "status" ) );
    bean.setTaxableTotal( rs.getDouble( "taxable_total" ) );
    bean.setTotalAmount( rs.getDouble( "total_amount" ) );
    bean.setTotalTax( rs.getDouble( "total_tax" ) );

    return bean;
  }
}
    //bean.setCountyTax( rs.getDouble( "la_county_tax" ) );
    //bean.setStateTax( rs.getDouble( "california_tax" ) );
    //bean.setCityTax( rs.getDouble( "city_tax" ) );
