package edu.ucla.library.libservices.invoicing.webservices.patrons.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.SimplePatron;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class SimplePatronMapper
  implements RowMapper
{
  public SimplePatronMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    SimplePatron bean;

    bean = new SimplePatron();

    //bean.setBarcode( rs.getString( "patron_barcode" ) );
    //bean.setEmail( rs.getString( "email" ) );
    bean.setFirstName( rs.getString( "normal_first_name" ) );
    bean.setInstitutionID( rs.getString( "institution_id" ) );
    //bean.setIsUC( rs.getBoolean( "uc_community" ) );
    bean.setLastName( rs.getString( "normal_last_name" ) );
    bean.setPatronID( rs.getInt( "patron_id" ) );

    return bean;
  }
}
