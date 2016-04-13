<%
session("userName")=""
session("userUID")=""
session("UnitCode")=""
strSHIBout="https://invoicing.library.ucla.edu/Shibboleth.sso/Logout?return=https://shb.ais.ucla.edu/shibboleth-idp/Logout"
%>

<head>
<META HTTP-EQUIV="Refresh" CONTENT="0; URL=<%=strSHIBout%>">
</head>

