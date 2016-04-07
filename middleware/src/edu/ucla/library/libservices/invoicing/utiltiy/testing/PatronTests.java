package edu.ucla.library.libservices.invoicing.utiltiy.testing;

import edu.ucla.library.libservices.invoicing.utiltiy.db.DataSourceFactory;

import edu.ucla.library.libservices.invoicing.webservices.invoices.beans.SimpleHeader;
import edu.ucla.library.libservices.invoicing.webservices.invoices.db.mappers.SimpleHeaderMapper;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.SimplePatron;

import edu.ucla.library.libservices.invoicing.webservices.patrons.db.mappers.SimplePatronMapper;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

public class PatronTests
{
  private static DataSource ds;
  private static SimplePatron basicPatron;

  private static final String PATRON_BY_BARCODE =
    "SELECT * FROM patron_vw WHERE lower(patron_barcode) = ? ORDER BY normal_last_name";
  private static final String BARCODE_COUNT =
    "SELECT COUNT(patron_id) FROM patron_vw WHERE lower(patron_barcode) = ? ORDER BY normal_last_name";
  private static final String PATRON_COUNT =
    "SELECT COUNT(patron_id) FROM ucladb.patron WHERE lower(institution_id) = ?";
  private static final String PATRON_BY_INSTITUTION =
    "SELECT * FROM ucladb.patron WHERE lower(institution_id) = ? ORDER BY normal_last_name";
  private static final String UNPAID_INVOICE_IDS =
    "SELECT i.* FROM invoice_vw i INNER JOIN patron_vw p ON i.patron_id = " +
    "p.patron_id WHERE i.status IN ('Partially Paid','Unpaid', 'Deposit Due'," +
    " 'Final Payment Due') AND lower(p.institution_id) = ? UNION SELECT " +
    "i.* FROM invoice_vw i INNER JOIN patron_vw p ON i.patron_id = " +
    "p.patron_id WHERE i.status IN ('Partially Paid','Unpaid', 'Deposit " +
    "Due', 'Final Payment Due') AND lower(p.patron_barcode) = ?";

  public PatronTests()
  {
    super();
  }

  public static void main( String[] args )
  {
    int count;
    String institutionID;

    count = 0;
    institutionID = "603513612";

    makeVgerConnection();
    basicPatron = new SimplePatron();

    //try against vger db
    if ( new JdbcTemplate( ds ).queryForInt( PATRON_COUNT, new Object[]
        { institutionID.toLowerCase() } ) == 1 )
    {
      System.out.println( "getting patron from ucladb" );
      basicPatron =
          ( SimplePatron ) new JdbcTemplate( ds ).query( PATRON_BY_INSTITUTION,
                                                         new Object[]
            { institutionID.toLowerCase() },
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
          { institutionID.concat( "@ucla.edu" ).toLowerCase() } ) == 1 )
      {
        System.out.println( "getting patron from aeon" );
        basicPatron =
            ( SimplePatron ) new JdbcTemplate( ds ).query( PATRON_BY_BARCODE,
                                                           new Object[]
              { institutionID.concat( "@ucla.edu" ).toLowerCase() },
              new SimplePatronMapper() ).get( 0 );
        basicPatron.setBarcode( institutionID.concat( "@ucla.edu" ) );
        System.out.println( "inst ID = " + basicPatron.getInstitutionID() +
                            "\tbarcode = " + basicPatron.getBarcode() );
        basicPatron.setInvoices( new JdbcTemplate( ds ).query( UNPAID_INVOICE_IDS,
                                                               new Object[]
              { basicPatron.getInstitutionID(), basicPatron.getBarcode() },
              new SimpleHeaderMapper() ) );
      }
    }

    System.out.println( "Patron name = " + basicPatron.getLastName() +
                        ", " + basicPatron.getFirstName() );
    for ( SimpleHeader theInvoice: basicPatron.getInvoices() )
      System.out.println( "\tinvoice = " + theInvoice.getInvoiceNumber() );

    //test against institution ID with passed-in ID
    //look for invoices where patron id matches to institution ID or barcode@ucla.edu
    //test against barcode with passed-in ID@ucla.edu
    //look for invoices where patron id matches to institution ID or barcode@ucla.edu
    //return empty patron
  }

  private static void makeVgerConnection()
  {
    ds = DataSourceFactory.createVgerSource();
  }


  private static void makeBillConnection()
  {
    ds = DataSourceFactory.createBillSource();
  }
}
