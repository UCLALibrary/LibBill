package edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.PaymentType;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class PaymentTypeMapper
  implements RowMapper
{
  public PaymentTypeMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    PaymentType bean;
    
    bean = new PaymentType();
    bean.setPaymentType( rs.getString( "payment_type" ) );
    bean.setPaymentTypeID( rs.getInt( "payment_type_id" ) );

    return bean;
  }
}
