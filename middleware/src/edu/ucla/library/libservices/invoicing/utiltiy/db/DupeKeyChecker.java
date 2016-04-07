package edu.ucla.library.libservices.invoicing.utiltiy.db;

import org.springframework.jdbc.core.JdbcTemplate;

public class DupeKeyChecker
{
  private static final String ID_KEY_QUERY = "SELECT count(user_name) FROM invoice_owner.staff_user WHERE id_key = ?";
  private static final String CRYPTO_KEY_QUERY = "SELECT count(user_name) FROM invoice_owner.staff_user WHERE crypto_key = ?";
  private static final int ID_KEY = 1;
  
  public DupeKeyChecker()
  {
    super();
  }
  
  public static boolean isDupeKey(String key, String dbName, int keyType)
  {
    JdbcTemplate sql;
    int copies;
    
    sql = new JdbcTemplate( DataSourceFactory.createDataSource( dbName ) );    
    //sql = new JdbcTemplate( DataSourceFactory.createBillSource() );    
    
    if ( keyType == ID_KEY )
      copies = sql.queryForInt( ID_KEY_QUERY, new Object[]{key} );
    else
      copies = sql.queryForInt( CRYPTO_KEY_QUERY, new Object[]{key} );
    
    return (copies != 0);
  }
}
