package edu.ucla.library.libservices.invoicing.webservices.invoices.db.procs;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.LineItemBean;

import java.sql.Types;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.object.StoredProcedure;

public class UpdateLineItemProcedure
  extends StoredProcedure
{
  private LineItemBean data;
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;

  public UpdateLineItemProcedure( JdbcTemplate jdbcTemplate,
                                  String string )
  {
    super( jdbcTemplate, string );
  }

  public UpdateLineItemProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public UpdateLineItemProcedure()
  {
    super();
  }

  public void setData( LineItemBean data )
  {
    this.data = data;
  }

  private LineItemBean getData()
  {
    return data;
  }

  private void makeConnection()
  {
    //ds = DataSourceFactory.createDataSource( getDbName() );
    ds = DataSourceFactory.createBillSource();
  }

  public void updateLineItem()
  {
    Map results;

    makeConnection();
    prepProc();
    results = execute();
  }

  private void prepProc()
  {
    setDataSource( ds );
    setFunction( false );
    //setSql( "invoice_owner.update_line_item" );
    setSql( "update_line_item" );
    declareParameter( new SqlParameter( "p_invoice_number",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_line_number", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_location_service_id",
                                        Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_quantity", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    if ( data.getUnitPrice() != 0D )
      declareParameter( new SqlParameter( "p_unit_price",
                                          Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_is_uc_member", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", getData().getInvoiceNumber() );
    input.put( "p_line_number", getData().getLineNumber() );
    input.put( "p_location_service_id", getData().getBranchServiceID() );
    input.put( "p_quantity", getData().getQuantity() );
    input.put( "p_user_name", getData().getCreatedBy() );
    if ( data.getUnitPrice() != 0D )
      input.put( "p_unit_price", getData().getUnitPrice() );
    input.put( "p_is_uc_member", data.getUcMember() );

    out = execute( input );

    return out;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }
}
