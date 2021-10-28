package edu.ucla.library.libservices.invoicing.webservices.patrons.clients;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.AlmaPatron;

public class PatronClient
{
  private AlmaPatron thePatron;
  private Client client;
  private WebResource webResource;
  private String userID;
  private String uriBase;
  private String key;

  public PatronClient()
  {
    super();
    client = null;
    webResource = null;
    userID = null;
  }

  public void setUserID(String userID)
  {
    this.userID = userID;
  }

  private String getUserID()
  {
    return userID;
  }

  public void setUriBase(String uriBase)
  {
    this.uriBase = uriBase;
  }

  private String getUriBase()
  {
    return uriBase;
  }

  public void setKey(String key)
  {
    this.key = key;
  }

  private String getKey()
  {
    return key;
  }

  public AlmaPatron getThePatron()
  {
    if (thePatron == null)
    {
      ClientResponse response;
      client = Client.create();
      webResource = client.resource(getUriBase().concat(getUserID())
                                                .concat("?apikey=")
                                                .concat(getKey()));
      response = webResource.accept("application/json").get(ClientResponse.class);
      if (response.getStatus() == 200)
      {
        //System.out.println(response.getEntity(String.class));
        thePatron = response.getEntity(AlmaPatron.class);
      }
      else
      {
        thePatron = new AlmaPatron();
        thePatron.setFirstName("NOT_FOUND");
        thePatron.setPatronID(" ");
      }
    }
    return thePatron;
  }
}
