package edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemNote;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class LineItemNoteMapper
  implements RowMapper
{
  public LineItemNoteMapper()
  {
    super();
  }

  public Object mapRow( ResultSet rs, int rowNum )
    throws SQLException
  {
    LineItemNote bean;
    
    bean = new LineItemNote();
    bean.setCreatedBy( rs.getString( "created_by" ) );
    bean.setCreatedDate( rs.getDate( "created_date" ) );
    bean.setInternal( ( rs.getString( "internal" ).equalsIgnoreCase( "Y" ) ? true : false ) );
    bean.setInvoiceNumber( rs.getString( "invoice_number" ) );
    bean.setLineNumber( rs.getInt( "line_number" ) );
    bean.setNote( rs.getString( "note" ) );
    bean.setSequenceNumber( rs.getInt( "sequence_number" ) );

    return bean;
  }
}
