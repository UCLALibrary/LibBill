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

public class AddLineItemProcedure
  extends StoredProcedure
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private LineItemBean data;
  private String dbName;

  public AddLineItemProcedure( JdbcTemplate jdbcTemplate, String string )
  {
    super( jdbcTemplate, string );
  }

  public AddLineItemProcedure( DataSource dataSource, String string )
  {
    super( dataSource, string );
  }

  public AddLineItemProcedure()
  {
    super();
  }

  public void setData( LineItemBean data )
  {
    this.data = data;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }


  private void makeConnection()
  {
    //ds = DataSourceFactory.createDataSource( getDbName() );
    ds = DataSourceFactory.createBillSource();
  }

  public void addLineItem()
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
    //setSql( "invoice_owner.insert_line_item" );
    setSql( "invoice_owner_test.insert_line_item" );
    declareParameter( new SqlParameter( "p_invoice_number",
                                        Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_location_service_id",
                                        Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_user_name", Types.VARCHAR ) );
    declareParameter( new SqlParameter( "p_quantity", Types.NUMERIC ) );
    if ( data.getUnitPrice() != 0D )
      declareParameter( new SqlParameter( "p_unit_price", Types.NUMERIC ) );
    declareParameter( new SqlParameter( "p_is_uc_member", Types.VARCHAR ) );
    compile();
  }

  private Map execute()
  {
    Map input;
    Map out;

    out = null;
    input = new HashMap();

    input.put( "p_invoice_number", data.getInvoiceNumber() );
    input.put( "p_location_service_id", data.getBranchServiceID() );
    input.put( "p_user_name", data.getCreatedBy() );
    input.put( "p_quantity", data.getQuantity() );
    if ( data.getUnitPrice() != 0D )
      input.put( "p_unit_price", data.getUnitPrice() );
    input.put( "p_is_uc_member", data.getUcMember() );

    out = execute( input );

    return out;
  }
}
