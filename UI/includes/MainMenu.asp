<%

if session("role")="inactive" then

session("userName")=""
session("userUID")=""
session("UnitCode")=""
strSHIBout="https://invoicing-dev.library.ucla.edu/Shibboleth.sso/Logout?return=https://shb.ais.ucla.edu/shibboleth-idp/Logout"
strOut="http://invoicing-dev.library.ucla.edu"

%>

<head>
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=<%=strOut%>">
</head>
<%

end if
%>


<p>
<a href="default.asp"><u>Invoicing </u></a></br>
<%
if session("role")="admin" then
  %>
<a href="GetUsers.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Users</u></a></br>
<a href="GetLocations.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Locations</u></a></br>
<a href="GetTaxRates.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Tax Rates</u></a></br>
  <%
end if
%>
<a href="GetPatron.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Patrons</u></a></br>
<a href="GetInvoice.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Invoices</u></a>
(<a href="GetInvoice.asp?Search=Advanced">Advanced</a>)</br>
<a href="LogOut.asp"><u>Log Out</u></a></br>&nbsp;</br>

