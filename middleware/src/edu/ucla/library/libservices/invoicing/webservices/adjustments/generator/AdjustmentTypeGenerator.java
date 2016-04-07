package edu.ucla.library.libservices.invoicing.webservices.adjustments.generator;

import edu.ucla.library.libservices.invoicing.webservices.adjustments.beans.AdjustmentType;
import edu.ucla.library.libservices.invoicing.webservices.adjustments.db.mappers.AdjustmentTypeMapper;
import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement(name = "typesList")
public class AdjustmentTypeGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String adjType;
  @XmlElement( name = "adjustmentType" )
  private List<AdjustmentType> types;
  private static final String INVOICE_TYPES =
    "SELECT * FROM invoice_adjustment_type_vw ORDER BY adjustment_type";
  private static final String LINE_TYPES =
    "SELECT * FROM line_item_adjustment_type_vw ORDER BY adjustment_type";
  private static final String INV_LEVEL = "invoice";
  
  public AdjustmentTypeGenerator()
  {
    super();
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setAdjType( String adjType )
  {
    this.adjType = adjType;
  }

  private String getAdjType()
  {
    return adjType;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  public void getTypes()
  {
    makeConnection();
    
    if ( INV_LEVEL.equalsIgnoreCase( getAdjType() ) )
    {
      types =
          new JdbcTemplate( ds ).query( INVOICE_TYPES, new AdjustmentTypeMapper() );
    }
    else
    {
      types =
          new JdbcTemplate( ds ).query( LINE_TYPES, new AdjustmentTypeMapper() );
    }
    //return types;
  }
}
