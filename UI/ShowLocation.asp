<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 


  <%
  select case request("action")
    case "UpdateLocation"
      %>
      <!-- #INCLUDE virtual="includes/UpdateLocation.asp" --> 
      <%
      'if strGo="No" then
      'end if
    case "DeleteLocation"
      %>
      <!-- #INCLUDE virtual="includes/DeleteLocation.asp" --> 
      <%
    case else
  end select

  if request("action")<>"DeleteLocation" then
    strCode=request("txtCode")
    strName=request("txtName")
    strDepartment=request("txtDepartment")
    strPhone=request("txtPhone")
    strID=request("txtID")

    strName=replace(strName," ", "+")

    'check for deleteableness (no services)
    strCryptoKey=session("CryptoKey")
    hashURL=session("strBaseHash")
    hashURL=hashURL & "branches/branch_services/" & lcase(strName)

    strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
    strHash = b64_hmac_sha1(strCryptoKey, strAuth)

    strSig=session("IDKey") & ":" & strHash

    postURL=session("strBaseURL")
    postURL=postURL & "branches/branch_services/" & lcase(strName)

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

    set xmlDoc = createObject("MSXML2.DOMDocument")
    xmlDoc.async = False
    xmlDoc.setProperty "ServerHTTPRequest", true
    XMLDOC.LOAD(xmlhttp.responsebody)
    set oNodeList=XMLDoc.GetElementsByTagName("serviceName")
    Set currNode = oNodeList.nextNode
    Set curitem = oNodeList.Item(i)

    if oNodeList.length=0 then
      'response.write "<p class=ErrorMessage>No services</p>"
      strServicesYN="N"
    else
      'response.write "<p class=ErrorMessage>Has services</p>"
      strServicesYN="Y"
    end if

    set xmldoc=nothing
    set xmlhttp=nothing

    strName=replace(strName,"+", " ")
if strGo<>"No" then
    %>

    <table border="1">
    <tr>
    <td>Code</td>
    <td>Name</td>
    <td>Department</td>
    <td>Phone</td>
    </tr>
    <tr>
    <td><form method="post" action="showLocation.asp?action=UpdateLocation">
    <input type="text" name="txtCode" value="<%=strCode%>"></td>
    <td><input type="text" name="txtName" value="<%=strName%>"></td>
    <td><input type="text" name="txtDepartment" value="<%=strDepartment%>"></td>
    <td><input type="text" name="txtPhone" value="<%=strPhone%>">
    <input type="hidden" name="txtID" value="<%=strID%>">
    </td>

    <td><input type="submit" value="update"></form></td>
    <td>
    <form method="post" action="showLocation.asp?action=DeleteLocation">
    <input type="hidden" name="txtID" value="<%=strID%>">
    <%
    if strServicesYN<>"Y" then
      %>
      <input type="submit" value="delete"></td>
      <%
    end if
    %>

    </form>
    </tr>
    </table>
    <%
end if

  end if
else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
end if 
%>