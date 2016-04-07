package edu.ucla.library.libservices.invoicing.clients.staff;

import edu.ucla.library.libservices.invoicing.webservices.staff.beans.StaffUser;
import edu.ucla.library.libservices.invoicing.webservices.staff.web.StaffService;

public class StaffUserClient
{
  public StaffUserClient()
  {
    super();
  }
  
  public StaffUser getUserByUID(String uid, String dbName)
  {
    StaffUser theUser;
    StaffService service;
    
    service = new StaffService();
    theUser = service.getUserInfo( uid, dbName );
    
    return theUser;
  }
  
  public StaffUser getUserByKey(String key, String dbName)
  {
    StaffUser theUser;
    StaffService service;
    
    service = new StaffService();
    theUser = service.getUserByKey( key, dbName );
    
    return theUser;
  }
}
