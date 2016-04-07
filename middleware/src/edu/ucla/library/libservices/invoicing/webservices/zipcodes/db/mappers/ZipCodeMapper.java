package edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.ZipCode;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class ZipCodeMapper
  implements RowMapper
{
  public ZipCodeMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    ZipCode bean;

    bean = new ZipCode();
    bean.setCode( rs.getString( "zip_code" ) );
    bean.setTaxRateName( rs.getString( "tax_rate_name" ) );

    return bean;
  }
}
    //bean.setCaliforniaTaxable( ( rs.getString( "california_taxable" ).equalsIgnoreCase( "Y" ) ? true: false ) );
    //bean.setLaCountyTaxable( ( rs.getString( "la_county_taxable" ).equalsIgnoreCase( "Y" ) ? true: false ) );
