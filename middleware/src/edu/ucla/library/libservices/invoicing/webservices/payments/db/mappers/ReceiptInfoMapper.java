package edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.ReceiptInfo;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class ReceiptInfoMapper
  implements RowMapper
{
  public ReceiptInfoMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    ReceiptInfo bean;
    
    bean = new ReceiptInfo();
    bean.setPatronID( rs.getString( "patron_id" ) );
    bean.setStatus( rs.getString( "status" ) );
    bean.setUid( rs.getString( "institution_id" ) );
    bean.setUserName( rs.getString( "user_name" ) );
    
    return bean;
  }
}
