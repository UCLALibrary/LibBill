<!-- #INCLUDE virtual="includes/TopOnly.asp" -->

<!begin main content>

<%
if session("userName")="" then
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" -->
  <%
else

  strID=request("txtID")
  strBarcode=request("txtBarcode")
  strNameLast=request("txtNameLast")
  strNameFirst=request("txtNameFirst")
  strUnit=request("txtUnit")
  strBillerID=request("txtBillerID")
  'strUCMember=request("txtUCMember")
  strUCMember = session("UCMember")
  strZipCode=request("txtZipCode")

  %>
  <!-- #INCLUDE virtual="includes/MainMenu.asp" -->
  <hr>
  <p>Add Invoice For:
  <%
  response.write strNameLast & ", " & strNameFirst
  %>

  <form action="GetInvoice.asp?action=addInvoice" method="post">
  On Premises?
  <select name="txtOnPremises">
  <option selected value="Y">Yes</option>
  <option value="N">No</option>
  </select></br>
  <input type="hidden" name="txtID" value="<%=strID%>">
  <input type="hidden" name="txtBarcode" value="<%=strBarcode%>">
  <input type="hidden" name="txtNameLast" value="<%=strNameLast%>">
  <input type="hidden" name="txtNameFirst" value="<%=strNameFirst%>">
  <input type="hidden" name="txtUnit" value="<%=strUnit%>">
  <input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
  <input type="hidden" name="txtUCMember" value="<%=strUCMember%>">
  <input type="hidden" name="txtZipCode" value="<%=strZipCode%>">
  </p><p>
  <input type="submit" value="Create Invoice">
  </form>
  </p>
  <%
end if
%>
