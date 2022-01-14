package edu.ucla.library.libservices.invoicing.webservices.patrons.converters;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Address;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.AlmaPatron;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Email;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.PatronBean;

import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.Phone;
import edu.ucla.library.libservices.invoicing.webservices.patrons.beans.UserIdentifier;
import edu.ucla.library.libservices.invoicing.webservices.patrons.utility.UcCommunityTypes;

import java.util.ArrayList;
import java.util.List;

public class AlmaVgerConverter
{
  public AlmaVgerConverter()
  {
    super();
  }

  public static PatronBean convertPatron(final AlmaPatron theAlma)
  {
    final PatronBean theVger;

    theVger = new PatronBean();
    theVger.setFirstName(theAlma.getFirstName());
    theVger.setInstitutionID(theAlma.getPatronID());
    theVger.setLastName(theAlma.getLastName());
    theVger.setPatronID(theAlma.getPatronID());
    if (theAlma.getUserGroup() != null)
      theVger.setIsUC(determineCommunity(theAlma.getUserGroup().getValue()));
    if (theAlma.getContactInfo() != null)
    {
      theVger.setEmail(determindEmail(theAlma.getContactInfo().getEmails()));
      setAddresses(theVger, theAlma);
      theVger.setPhoneNumber(setPhone(theAlma.getContactInfo().getPhones()));
    }
    if (theAlma.getUserIdentifiers() != null)
      theVger.setBarcode(determineBarcode(theAlma.getUserIdentifiers()));

    return theVger;
  }

  private static String determineCommunity(final String userGroup)
  {
    String isUC = "N";
    for (UcCommunityTypes theType: UcCommunityTypes.values())
    {
      if (theType.toString().equals(userGroup))
      {
        isUC = "Y";
      }
    }
    return isUC;
  }

  private static String determindEmail(final List<Email> emails)
  {
    if (emails.size() == 0)
    {
      return null;
    }
    else
    {
      String theEmail = null;
      for (Email aMail: emails)
      {
        if (aMail.isPreferred())
        {
          theEmail = aMail.getEmailAddress();
        }
      }
      if (theEmail != null)
      {
        return theEmail;
      }
      else
      {
        return emails.get(0).getEmailAddress();
      }
    }
  }

  private static String determineBarcode(final List<UserIdentifier> identifiers)
  {
    if (identifiers.size() > 0)
    {
      List<UserIdentifier> barcodes = filterBarcodes(identifiers);
      if (barcodes.size() == 0)
      {
        return null;
      }
      if (barcodes.size() == 1)
      {
        return barcodes.get(0).getValue();
      }
      List<UserIdentifier> active = filterActiveBarcodes(identifiers);
      if (active.size() == 0 || active.size() == barcodes.size())
      {
        return barcodes.get(0).getValue();
      }
      else
      {
        return active.get(0).getValue();
      }
    }
    else
    {
      return null;
    }
  }

  private static void setAddresses(final PatronBean theVger, final AlmaPatron theAlma)
  {
    if (theAlma.getContactInfo()
               .getAddresses()
               .size() != 0)
    {
      if (theAlma.getContactInfo()
                 .getAddresses()
                 .size() == 1)
      {
        setPermAddress(theVger, theAlma.getContactInfo()
                                       .getAddresses()
                                       .get(0));
      }
      else
      {
        int preferredCount = 0;
        for (Address address: theAlma.getContactInfo().getAddresses())
        {
          if (address.isPreferred())
          {
            preferredCount += 1;
          }
        }
        if (preferredCount == 0 || preferredCount == theAlma.getContactInfo()
                                                            .getAddresses()
                                                            .size())
        {
          setPermAddress(theVger, theAlma.getContactInfo()
                                         .getAddresses()
                                         .get(0));
          setTempAddress(theVger, theAlma.getContactInfo()
                                         .getAddresses()
                                         .get(1));
        }
        if (preferredCount > 0 && preferredCount < theAlma.getContactInfo()
                                                          .getAddresses()
                                                          .size())
        {
          List<Address> prefeered = filterAddress(theAlma.getContactInfo().getAddresses(), true);
          List<Address> notPrefeered = filterAddress(theAlma.getContactInfo().getAddresses(), false);
          setPermAddress(theVger, prefeered.get(0));
          setTempAddress(theVger, notPrefeered.get(0));
        }
      }
    }
  }

  private static void setPermAddress(PatronBean theVger, Address perm)
  {
    theVger.setPermAddress1(perm.getLine1());
    theVger.setPermAddress2(perm.getLine2());
    theVger.setPermAddress3(perm.getLine3());
    theVger.setPermAddress4(perm.getLine4());
    theVger.setPermAddress5(perm.getLine5());
    theVger.setPermCity(perm.getCity());
    if (perm.getCountry() != null)
      theVger.setPermCountry(perm.getCountry().getValue());
    theVger.setPermState(perm.getState());
    theVger.setPermZip(perm.getZipCode());
  }

  private static void setTempAddress(PatronBean theVger, Address temp)
  {
    theVger.setLocalAddress1(temp.getLine1());
    theVger.setLocalAddress2(temp.getLine2());
    theVger.setLocalAddress3(temp.getLine3());
    theVger.setLocalAddress4(temp.getLine4());
    theVger.setLocalAddress5(temp.getLine5());
    theVger.setLocalCity(temp.getCity());
    theVger.setLocalCountry(temp.getCountry().getValue());
    theVger.setLocalState(temp.getState());
    theVger.setLocalZip(temp.getZipCode());
  }

  private static String setPhone(List<Phone> phones)
  {
    if (phones.size() > 0)
    {
      String thePhone = null;
      for (Phone aPhone: phones)
      {
        if (aPhone.isPreferred())
        {
          thePhone = aPhone.getPhoneNumber();
        }
      }
      if (thePhone != null)
      {
        return thePhone;
      }
      else
      {
        return phones.get(0).getPhoneNumber();
      }

    }
    else
    {
      return null;
    }
  }

  private static List<Address> filterAddress(List<Address> input, boolean isPreferred)
  {
    List<Address> selected = new ArrayList<>();
    for (Address theAddress: input)
    {
      if (theAddress.isPreferred() == isPreferred)
      {
        selected.add(theAddress);
      }
    }
    return selected;
  }

  private static List<UserIdentifier> filterBarcodes(List<UserIdentifier> identifiers)
  {
    final List<UserIdentifier> barcodes = new ArrayList<>();
    for (UserIdentifier theID: identifiers)
    {
      if (theID.getType() != null && theID.getType()
                                          .getValue()
                                          .equalsIgnoreCase("barcode"))
      {
        barcodes.add(theID);
      }
    }
    return barcodes;
  }

  private static List<UserIdentifier> filterActiveBarcodes(List<UserIdentifier> identifiers)
  {
    final List<UserIdentifier> barcodes = new ArrayList<>();
    for (UserIdentifier theID: identifiers)
    {
      if (theID.getStatus().equalsIgnoreCase("active"))
      {
        barcodes.add(theID);
      }
    }
    return barcodes;
  }
}
