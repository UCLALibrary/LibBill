package edu.ucla.library.libservices.invoicing.webservices.patrons.generator;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;
import edu.ucla.library.libservices.invoicing.utiltiy.testing.ContentTests;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.SimpleHeaderMapper;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.AlmaPatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.SimplePatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.clients.PatronClient;
import edu.ucla.library.libservices.invoicing.webservices.patrons.converters.AlmaVgerConverter;
import edu.ucla.library.libservices.invoicing.webservices.patrons.db.mappers.PatronMapper;
import edu.ucla.library.libservices.invoicing.webservices.patrons.db.mappers.SimplePatronMapper;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import javax.xml.bind.annotation.XmlTransient;

import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.datasource.DriverManagerDataSource;

@XmlRootElement( name = "patronList" )
public class PatronGenerator
{
  //private DriverManagerDataSource ds;
  private DataSource ds;
  private String barcode;
  private String lastName;
  private String firstName;
  private String institutionID;
  private String dbName;
  private String dbVger;
  private String dbBill;
  private String patronID;
  @XmlTransient
  private String almaKey;
  @XmlTransient
  private String almaURI;
  @XmlElement( name = "patron" )
  private List<PatronBean> patrons;
  private PatronBean thePatronByID;
  private SimplePatron basicPatron;
  private static final String BARCODE_COUNT =
    "SELECT COUNT(patron_id) FROM patron_vw WHERE lower(patron_id) = ? ORDER BY normal_last_name";
  private static final String PATRON_BY_BARCODE =
    "SELECT * FROM patron_vw WHERE lower(patron_id) = ? ORDER BY normal_last_name";
  private static final String PATRON_BY_ID =
    "SELECT * FROM patron_vw WHERE patron_id = ? ORDER BY normal_last_name";
  private static final String PATRON_BY_LNAME =
    "SELECT * FROM patron_vw WHERE normal_last_name like '%' || ? || '%' " +
    "ORDER BY normal_last_name, normal_first_name";
  private static final String PATRON_BY_FNAME =
    "SELECT * FROM patron_vw WHERE normal_first_name like '%' || ? || '%' " +
    "ORDER BY normal_last_name, normal_first_name";
  private static final String PATRON_BY_FULLNAME =
    "SELECT * FROM patron_vw WHERE normal_last_name like '%' || ? || '%' AND " +
    "normal_first_name like '%' || ? || '%' ORDER BY normal_last_name, normal_first_name";
  private static final String PATRON_COUNT =
    "SELECT COUNT(patron_id) FROM ucladb.patron WHERE lower(patron_id) = ?";
  private static final String PATRON_BY_INSTITUTION =
    "SELECT * FROM ucladb.patron WHERE lower(patron_id) = ? ORDER BY normal_last_name";
  private static final String UNPAID_INVOICE_IDS =
    "SELECT i.* FROM invoice_vw i WHERE i.status IN ('Partially Paid','Unpaid', 'Deposit Due', " 
    + "'Final Payment Due') AND lower(i.patron_id) = ?";
    /*"SELECT i.* FROM invoice_vw i INNER JOIN patron_vw p ON i.patron_id = " +
    "p.patron_id WHERE i.status IN ('Partially Paid','Unpaid', 'Deposit Due'," +
    " 'Final Payment Due') AND lower(p.patron_id) = ? UNION SELECT " +
    "i.* FROM invoice_vw i INNER JOIN patron_vw p ON i.patron_id = " +
    "p.patron_id WHERE i.status IN ('Partially Paid','Unpaid', 'Deposit " +
    "Due', 'Final Payment Due') AND lower(p.patron_barcode) = ?";*/

  public PatronGenerator()
  {
    super();
    setFirstName( null );
    setLastName( null );
  }

  public void setBarcode( String barcode )
  {
    this.barcode = barcode;
  }

  private String getBarcode()
  {
    return barcode;
  }

  public void setDbName( String dbName )
  {
    this.dbName = dbName;
  }


  private String getDbName()
  {
    return dbName;
  }

  public void setLastName( String lastName )
  {
    this.lastName = lastName;
  }

  private String getLastName()
  {
    return lastName;
  }

  public void setPatronID( String patronID )
  {
    this.patronID = patronID;
  }

  private String getPatronID()
  {
    return patronID;
  }

  public void setFirstName( String firstName )
  {
    this.firstName = firstName;
  }

  private String getFirstName()
  {
    return firstName;
  }

  private void makeConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbName() );
    //ds = DataSourceFactory.createBillSource();
  }

  private void makeBillConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbBill() );
    //ds = DataSourceFactory.createBillSource();
  }

  private void makeVgerConnection()
  {
    ds = DataSourceFactory.createDataSource( getDbVger() );
    //ds = DataSourceFactory.createVgerSource();
  }

  public void getPatronsByBarcode()
  {
    makeConnection();

    patrons = new JdbcTemplate( ds ).query( PATRON_BY_BARCODE, new Object[]
          { getBarcode().toLowerCase() }, new PatronMapper() );
  }

  public void getPatronsByName()
  {
    makeConnection();

    //both first & last
    if ( !ContentTests.isEmpty( getFirstName() ) &&
         !ContentTests.isEmpty( getLastName() ) )
    {
      patrons =
          new JdbcTemplate( ds ).query( PATRON_BY_FULLNAME, new Object[]
            { getLastName().toUpperCase(), getFirstName().toUpperCase() },
            new PatronMapper() );
    }
    //else first only
    else if ( !ContentTests.isEmpty( getFirstName() ) )
    {
      patrons = new JdbcTemplate( ds ).query( PATRON_BY_FNAME, new Object[]
            { getFirstName().toUpperCase() }, new PatronMapper() );
    }
    //else last only
    else if ( !ContentTests.isEmpty( getLastName() ) )
    {
      patrons = new JdbcTemplate( ds ).query( PATRON_BY_LNAME, new Object[]
            { getLastName().toUpperCase() }, new PatronMapper() );
    }
    else
    {
      patrons = new ArrayList<PatronBean>();
    }
    //return patrons;
  }

  public PatronBean getThePatronByID()
  {
    makeConnection();
    List<PatronBean> temp;

    temp = new JdbcTemplate( ds ).query( PATRON_BY_ID, new Object[]
          { getPatronID() }, new PatronMapper() );
    if ( temp.size() == 1 )
      thePatronByID = temp.get( 0 );
    else
      thePatronByID = new PatronBean();
    return thePatronByID;
  }

  public PatronBean getThePatron()
  {
    return thePatronByID;
  }

  public SimplePatron getBasicPatron()
  {
    //makeVgerConnection();
    basicPatron = new SimplePatron();
    makeBillConnection();
    basicPatron.setInvoices(new JdbcTemplate(ds)
                            .query(UNPAID_INVOICE_IDS, new Object[] { getInstitutionID() }, new SimpleHeaderMapper()));
    return basicPatron;

    /*if ( new JdbcTemplate( ds ).queryForInt( PATRON_COUNT, new Object[]
        { getInstitutionID().toLowerCase() } ) == 1 )
    {
      basicPatron =
          ( SimplePatron ) new JdbcTemplate( ds ).query( PATRON_BY_INSTITUTION,
                                                         new Object[]
            { getInstitutionID().toLowerCase() },
            new SimplePatronMapper() ).get( 0 );

      makeBillConnection();
      basicPatron.setInvoices( new JdbcTemplate( ds ).query( UNPAID_INVOICE_IDS,
                                                             new Object[]
            { basicPatron.getInstitutionID(), basicPatron.getBarcode() },
            new SimpleHeaderMapper() ) );
    }
    else
    {
      makeBillConnection();
      if ( new JdbcTemplate( ds ).queryForInt( BARCODE_COUNT, new Object[]
          { getInstitutionID().concat( "@ucla.edu" ).toLowerCase() } ) == 1 )
      {
        basicPatron =
            ( SimplePatron ) new JdbcTemplate( ds ).query( PATRON_BY_BARCODE,
                                                           new Object[]
              { getInstitutionID().concat( "@ucla.edu" ).toLowerCase() },
              new SimplePatronMapper() ).get( 0 );
        basicPatron.setBarcode( institutionID.concat( "@ucla.edu" ) );

        basicPatron.setInvoices( new JdbcTemplate( ds ).query( UNPAID_INVOICE_IDS,
                                                               new Object[]
              { basicPatron.getInstitutionID(), basicPatron.getBarcode() },
              new SimpleHeaderMapper() ) );
      }
    }*/
  }

  public PatronBean getPatronFromAlma()
  {
    AlmaPatron thePatron;
    PatronBean theVger;
    PatronClient client;

    client = new PatronClient();
    client.setKey(getAlmaKey());
    client.setUriBase(getAlmaURI());
    client.setUserID(getBarcode());

    thePatron = client.getThePatron();
    theVger = AlmaVgerConverter.convertPatron(thePatron);
    return theVger;
  }

  public void prepPatronFromAlma()
  {
    AlmaPatron thePatron;
    PatronBean theVger;
    PatronClient client;

    client = new PatronClient();
    client.setKey(getAlmaKey());
    client.setUriBase(getAlmaURI());
    client.setUserID(getBarcode());

    thePatron = client.getThePatron();
    theVger = AlmaVgerConverter.convertPatron(thePatron);
    patrons = new ArrayList<PatronBean>();
    patrons.add(theVger);
    //return theVger;
  }
  public void setInstitutionID( String institutionID )
  {
    this.institutionID = institutionID;
  }

  private String getInstitutionID()
  {
    return institutionID;
  }

  public List<PatronBean> getPatrons()
  {
    return patrons;
  }

  public void setDbVger( String dbVger )
  {
    this.dbVger = dbVger;
  }

  public String getDbVger()
  {
    return dbVger;
  }

  public void setDbBill( String dbBill )
  {
    this.dbBill = dbBill;
  }

  public String getDbBill()
  {
    return dbBill;
  }

  public void setAlmaKey(String almaKey)
  {
    this.almaKey = almaKey;
  }

  public String getAlmaKey()
  {
    return almaKey;
  }

  public void setAlmaURI(String almaURI)
  {
    this.almaURI = almaURI;
  }

  public String getAlmaURI()
  {
    return almaURI;
  }
}
