<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 

  <%

  if request("action")="AddLocation" then
    %>
    <!-- #INCLUDE virtual="includes/AddLocation.asp" --> 
    <%
  end if

  strCryptoKey=session("CryptoKey")
  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/unit_list"
  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)

  strSig=session("IDKey") & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/unit_list" 

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "GET", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send 
  'Response.write "<p>" & xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    'response.write "<p>Got users info:</p>"
  else
    response.write "<p>" & xmlhttp.status
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  set xmlDoc = createObject("MSXML2.DOMDocument")
  xmlDoc.async = False
  xmlDoc.setProperty "ServerHTTPRequest", true
  XMLDOC.LOAD(xmlhttp.responsebody)

  loadXMLFile xmldoc, server.MapPath("xsl/location_list.xsl") 

  set xmlDoc=nothing
  set xmlhttp=nothing


  %>
  <p>
  <form name="AddLocationForm" method="post" autocomplete="off" action="GetLocations.asp?Action=AddLocation">
  <table>
  <tr>
  <td>Code </td>
  <td>Name</td>
  <td>Department</td>
  <td>Phone</td>
  <td></td>
  </tr>
  <tr>
  <td>
  <input type="text" name="txtCode">        
  </td><td>
  <input type="text" name="txtName">        
  </td><td>
  <input type="text" name="txtDepartment">        
  </td><td>
  <input type="text" name="txtPhone">        
  </td><td>
  <input type="submit" value="Add Location">
  </td>
  </tr>
  </table>
  </form>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
<%
else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
end if 

%>