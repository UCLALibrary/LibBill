package edu.ucla.library.libservices.invoicing.utiltiy.db;

import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;

import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class DataSourceFactory
{
  public DataSourceFactory()
  {
    super();
  }

  public static DriverManagerDataSource createVgerSource()
  {
    DriverManagerDataSource ds;

    ds = new DriverManagerDataSource();
    ds.setDriverClassName( "oracle.jdbc.OracleDriver" );
    ds.setUrl( "jdbc:oracle:thin:@ils-db-test.library.ucla.edu:1521:VGER" );
    ds.setUsername( "vger_support" );
    ds.setPassword( "vger_support_pwd" );

    return ds;
  }

  public static DriverManagerDataSource createBillSource()
  {
    DriverManagerDataSource ds;

    ds = new DriverManagerDataSource();
    ds.setDriverClassName( "oracle.jdbc.OracleDriver" );
    ds.setUrl( "jdbc:oracle:thin:@ils-db-test.library.ucla.edu:1521:VGER" );
    ds.setUsername( "invoice_service_dev" );
    ds.setPassword( "invoice_service_dev_pwd" );

    return ds;
  }

  public static DataSource createDataSource( String name )
  {
    InitialContext context;
    DataSource connection;

    try
    {
      context = new InitialContext();
      connection = ( DataSource ) context.lookup( name );
    }
    catch ( NamingException e )
    {
      e.printStackTrace();
      connection = null;
    }

    return connection;
  }
}
