package edu.ucla.library.libservices.invoicing.webservices.locations.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.locations.beans.LocationServiceBean;

import java.sql.ResultSet;

import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class LocationServiceMapper
  implements RowMapper
{
  public LocationServiceMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    LocationServiceBean bean;

    bean = new LocationServiceBean();
    bean.setFau( rs.getString( "fau" ) );
    bean.setItemCode( rs.getString( "item_code" ) );
    bean.setLocSvcKey( rs.getInt( "location_service_id" ) );
    bean.setLocationCode( rs.getString( "location_code" ) );
    bean.setLocationName( rs.getString( "location_name" ) );
    bean.setNonUCMinimum( rs.getDouble( "non_uc_minimum_amount" ) );
    bean.setNonUCPrice( rs.getDouble( "non_uc_price" ) );
    bean.setRequireCustomPrice( ( rs.getString( "require_custom_price" ).equalsIgnoreCase( "Y" ) ?
                                  true: false ) );
    bean.setServiceName( rs.getString( "service_name" ) );
    bean.setSubtypeName( rs.getString( "subtype_name" ) );
    bean.setTaxable( ( rs.getString( "taxable" ).equalsIgnoreCase( "Y" ) ?
                       true: false ) );
    bean.setUcMinimum( rs.getDouble( "uc_minimum_amount" ) );
    bean.setUcPrice( rs.getDouble( "uc_price" ) );
    bean.setUnitMeasure( rs.getString( "unit_measure" ) );

    return bean;
  }
}
