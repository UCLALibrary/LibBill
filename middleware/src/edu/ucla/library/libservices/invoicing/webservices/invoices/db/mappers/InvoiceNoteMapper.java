package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.InvoiceNote;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class InvoiceNoteMapper
  implements RowMapper
{
  public InvoiceNoteMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    InvoiceNote bean;

    bean = new InvoiceNote();
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setInternal( ( rs.getString( "internal" ).equalsIgnoreCase( "Y" ) ?
                        true : false ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setNote( rs.getString( "note" ) );
    bean.setSequenceNumber( rs.getInt( "sequence_number" ) );

    return bean;
  }
}
