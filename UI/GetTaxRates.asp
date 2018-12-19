<%


if session("userName")="" then
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
else
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 

  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 

  <!begin main content>

  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 

  <%
  if request("action")="AddTaxRate" then
    %>
    <!-- #INCLUDE virtual="includes/AddTaxRate.asp" --> 
    <%
  end if

  if request("action")="Update" then
    %>
    <!-- #INCLUDE virtual="includes/UpdateTaxes.asp" --> 
    <%
  end if

  strCryptoKey=session("CryptoKey")
  hashURL=session("strBaseHash")
  hashURL=hashURL & "taxes/rate_list"
  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)

  strSig=session("IDKey") & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "taxes/rate_list" 

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
  '  xmlDoc.load(postURL)
  XMLDOC.LOAD(xmlhttp.responsebody)

  loadXMLFile xmldoc, server.MapPath("xsl/tax_list.xsl") 

  set xmlDoc=nothing
  set xmlhttp=nothing


  %>

  <p>
  <form name="AddtaxRate" method="post" autocomplete="off" action="GetTaxRates.asp?Action=AddTaxRate">
  <table>
  <tr>
  <td>rateName </td>
  <td>rate</td>
  <td>startDate</td>
  <td></td>
  <td></td>
  <td>endDate</td>
  </tr>
  <tr>
  <td>
  <select name="txtRateName">
  <option value="california">california</option>
  <option value="la_county">la_county</option>
  <option value="santa_monica_city">santa_monica_city</option>
  </select>
  </td><td>
  <input type="text" name="txtRate">        
  </td>

  <td>
  <select name="txtStartMonth">
  <option value="01">January</option>
  <option value="02">February</option>
  <option value="03">March</option>
  <option value="04">April</option>
  <option value="05">May</option>
  <option value="06">June</option>
  <option value="07">July</option>
  <option value="08">August</option>
  <option value="09">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
  </select>

  </td>
  <td>
  <select name="txtStartDay">
  <option selected value="1">1</option>

  <%
  intVal=1
  do while intVal<32
    %>
    <option value="<%=intVal%>"><%=intVal%></option>
    <%
    intVal=intVal+1
  loop
  %>

  </select>
  </td>
  <td>
  <select name="txtStartYear">
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
  <option value="2019">2019</option>
  </select>
  </td>
  <td>
  <select name="txtEndMonth">
  <option selected value=""></option>
  <option value="01">January</option>
  <option value="02">February</option>
  <option value="03">March</option>
  <option value="04">April</option>
  <option value="05">May</option>
  <option value="06">June</option>
  <option value="07">July</option>
  <option value="08">August</option>
  <option value="09">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
  </select>
  </td>
  <td>
  <select name="txtEndDay">
  <option selected value=""></option>
  <option value="1">1</option>

  <%
  intVal=1
  do while intVal<32
    %>
    <option value="<%=intVal%>"><%=intVal%></option>
    <%
    intVal=intVal+1
  loop
  %>

  </select>
  </td>
  <td>
  <select name="txtEndYear">
  <option selected value=""></option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
  </select>
  </td>
  <td>
  <input type="submit" value="Add taxRate">
  </td>
  </tr>
  </table>
  </form>


  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <%
end if
%>