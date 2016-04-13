<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 

  <%

  if request("action")="AddService" then
    %>
    <!-- #INCLUDE virtual="includes/AddService.asp" --> 
    <%
  end if

  strName=request("txtName")
  strName=replace(strName," ", "+")
  strUnitCode=request("txtCode")
  strLocationID=request("txtID")

  strCryptoKey=session("CryptoKey")
  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/branch_services/" & lcase(strName)

  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)

  strSig=session("IDKey") & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/branch_services/" & lcase(strName)

  'response.write postURL

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "GET", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send 
  'Response.write "<p>" & xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    'response.write "<p>okay so far</p>"
  else
    response.write "<p>" & xmlhttp.status
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  'response.write xmlhttp.responsetext

  set xmlDoc = createObject("MSXML2.DOMDocument")
  xmlDoc.async = False
  xmlDoc.setProperty "ServerHTTPRequest", true

  XMLDOC.LOAD(xmlhttp.responsebody)


  loadXMLFile xmldoc, server.MapPath("xsl/service_list.xsl") 

  set xmlDoc=nothing
  set xmlhttp=nothing

  strName=replace(strName,"+"," ")
  %>
  <p>
  <form name="AddServiceForm" method="post" autocomplete="off" action="GetServices.asp?Action=AddService">
  <table>
  <tr>
  <td>location</td>
  <td>serviceName</td>
  <td>subtypeName</td>
  <td>taxable</td>
  <td>ucPrice</td>
  <td>nonUCPrice</td> 
  <td>ucMinimum</td> 
  <td>nonUCMinimum</td> 
  <td>requireCustomPrice</td> 
  <td>unitMeasure</td> 
  <td>itemCode</td> 
  <td>fau</td> 
  </tr>
  <tr>
  <td><%=strName%></td>
  <td><input type="text" name="txtserviceName"></td>
  <td><input type="text" name="txtsubtypeName"></td>
  <td>
  <select name="txtTaxable">
  <option>false</option>
  <option>true</option>
  </select>
  </td>
  <td><input type="text" name="txtucPrice"></td>
  <td><input type="text" name="txtnonUCPrice"></td>
  <td><input type="text" name="txtucMinimum"></td>
  <td><input type="text" name="txtnonUCMinimum"></td>
  <td>
  <select name="txtRequireCustomPrice">
  <option>false</option>
  <option>true</option>
  </select>
  </td>
  <td>
  <select name="txtUnitMeasure">
  <option>each</option>
  <option>hour</option>
  <option>order</option>
  <option>reel</option>
  <option>mile</option>
  <option>frame</option>
  <option>page</option>
  </select>
  </td>
  <td><input type="text" name="txtitemCode"></td>
  <td><input type="text" name="txtfau"></td>
  <td>
  <input type="hidden" name="txtID" value="<%=strLocationID%>">
  <input type="hidden" name="txtName" value="<%=strName%>">
  <input type="submit" value="Add Service">
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