package edu.ucla.library.libservices.invoicing.webservices.patrons.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class PatronMapper
  implements RowMapper
{
  public PatronMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    PatronBean bean;

    bean = new PatronBean();

    bean.setBarcode( rs.getString( "patron_barcode" ) );
    bean.setEmail( rs.getString( "email" ) );
    bean.setFirstName( rs.getString( "normal_first_name" ) );
    bean.setInstitutionID( rs.getString( "institution_id" ) );
    bean.setIsUC( rs.getString( "uc_community" ) );
    bean.setLastName( rs.getString( "normal_last_name" ) );
    bean.setLocalAddress1( rs.getString( "temp_address1" ) );
    bean.setLocalAddress2( rs.getString( "temp_address2" ) );
    bean.setLocalAddress3( rs.getString( "temp_address3" ) );
    bean.setLocalAddress4( rs.getString( "temp_address4" ) );
    bean.setLocalAddress5( rs.getString( "temp_address5" ) );
    bean.setLocalCity( rs.getString( "temp_city" ) );
    bean.setLocalCountry( rs.getString( "temp_country" ) );
    bean.setLocalState( rs.getString( "temp_state" ) );
    bean.setLocalZip( rs.getString( "temp_zip" ) );
    bean.setPatronID( rs.getString( "patron_id" ) );
    bean.setPermAddress1( rs.getString( "perm_address1" ) );
    bean.setPermAddress2( rs.getString( "perm_address2" ) );
    bean.setPermAddress3( rs.getString( "perm_address3" ) );
    bean.setPermAddress4( rs.getString( "perm_address4" ) );
    bean.setPermAddress5( rs.getString( "perm_address5" ) );
    bean.setPermCity( rs.getString( "perm_city" ) );
    bean.setPermCountry( rs.getString( "perm_country" ) );
    bean.setPermState( rs.getString( "perm_state" ) );
    bean.setPermZip( rs.getString( "perm_zip" ) );
    bean.setPhoneNumber( rs.getString( "phone_number" ) );
    bean.setTempEffectdate( rs.getDate( "temp_effect_date" ) );
    bean.setTempExpireDate( rs.getDate( "temp_expire_date" ) );

    return bean;
  }
}
