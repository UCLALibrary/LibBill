package edu.ucla.library.libservices.invoicing.webservices.zipcodes.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.webservices.zipcodes.beans.ZipCode;

import edu.ucla.library.libservices.invoicing.webservices.zipcodes.db.mappers.ZipCodeMapper;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

public class ZipCodeGenerator
{
  private List<ZipCode> allZipCodes;
  private List<ZipCode> matchingZipCodes;
  private ZipCode theZipCode;
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String dbName;
  private String searchCode;
  private static final String ALL_ZIPS =
    //"SELECT * FROM invoice_owner.taxable_zip_code ORDER BY zip_code";
    "SELECT * FROM taxable_zip_code ORDER BY zip_code";
  private static final String MATCHING_ZIPS =
    //"SELECT * FROM invoice_owner.taxable_zip_code WHERE lower(zip_code) LIKE ? ORDER BY zip_code";
    "SELECT * FROM taxable_zip_code WHERE lower(zip_code) LIKE ? ORDER BY zip_code";
  private static final String GET_ZIP_CODE =
    //"SELECT * FROM invoice_owner.taxable_zip_code WHERE lower(zip_code) = ? ORDER BY zip_code";
    "SELECT * FROM taxable_zip_code WHERE lower(zip_code) = ? ORDER BY zip_code";
  private static final String LIKE_SIGN = "%";

  public ZipCodeGenerator()
  {
    super();
  }

  public List<ZipCode> getAllZipCodes()
  {
    makeConnection();
    allZipCodes =
        new JdbcTemplate( ds ).query( ALL_ZIPS, new ZipCodeMapper() );
    return allZipCodes;
  }

  public List<ZipCode> getMatchingZipCodes()
  {
    makeConnection();
    allZipCodes = new JdbcTemplate( ds ).query( MATCHING_ZIPS, new Object[]
          { LIKE_SIGN.concat( getSearchCode().toLowerCase() ).concat( LIKE_SIGN ) },
          new ZipCodeMapper() );
    return matchingZipCodes;
  }

  public ZipCode getTheZipCode()
  {
    makeConnection();
    theZipCode =
        ( ZipCode ) new JdbcTemplate( ds ).queryForObject( GET_ZIP_CODE,
                                                           new Object[]
          { getSearchCode().toLowerCase() }, new ZipCodeMapper() );
    return theZipCode;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }

  private String getDbName()
  {
    return dbName;
  }

  public void setSearchCode( String searchCode )
  {
    this.searchCode = searchCode;
  }

  private String getSearchCode()
  {
    return searchCode;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }
}
