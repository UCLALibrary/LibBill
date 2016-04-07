package edu.ucla.library.libservices.invoicing.webservices.taxes.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.taxes.beans.TaxRate;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class TaxRateMapper
  implements RowMapper
{
  public TaxRateMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    TaxRate bean;
    
    bean = new TaxRate();
    bean.setEndDate( rs.getDate( "end_date" ) );
    bean.setRate( rs.getDouble( "rate" ) );
    bean.setRateID( rs.getInt( "rate_id" ) );
    bean.setRateName( rs.getString( "rate_name" ) );
    bean.setStartDate( rs.getDate( "start_date" ) );

    return bean;
  }
}
