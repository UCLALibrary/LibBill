package edu.ucla.library.libservices.invoicing.webservices.payments.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.payments.beans.Payment;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class PaymentMapper
  implements RowMapper
{
  public PaymentMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    Payment bean;
    
    bean = new Payment();
    bean.setAmount( rs.getDouble( "amount" ) );
    bean.setCheckNote( rs.getString( "check_note" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setPaymentDate( rs.getDate( "payment_date" ) );
    bean.setPaymentType( rs.getString( "payment_type" ) );
    bean.setPaymentTypeID( rs.getInt( "payment_type_id" ) );

    return bean;
  }
}
