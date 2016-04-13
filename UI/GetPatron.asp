<!-- #INCLUDE virtual="includes/TopOnly.asp" --> 

<!begin main content>

<%
if session("userName")="" then
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
else
  %>
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <%
  dim strUnit
  strUnit=session("Unit")

  dim strBillerID
  strBillerID=session("userName")
  dim strSearch1
  strSearch1=""

  if request("PatronBC")<>"" then
    strSearch1=request("PatronBC")
  end if

  if request("txtBarcode")<>"" then
    strSearch1=request("txtBarcode")
  end if

  dim strSearch2
  strSearch2=request.form("txtUserNameFirst")

  dim strSearch3
  strSearch3=request.form("txtUserNameLast")

'  num1=len(trim(strSearch2))

'  num2=len(trim(strSearch2))
'  if num1>num2 then
'    strHalt="Y"
'  else
'  end if

  %>
  <table cellpadding="0">
  <tr>
  <td valign="top">
  <h3>Patrons</h3>

  </td>
  <td>
  <%
  if strSearch1<>"" then
    %>
    <form method="post" autocomplete="off" action="GetPatron.asp">
    Enter Library Card Barcode<br>
    <input name="txtBarcode" type="text" length="20" value="<%=strSearch1%>"><br>
    <b>OR</b> </br>Enter Name String (First and/or Last)</br>First:
    <input name="txtUserNameFirst" type="text" length="20" value="">&nbsp;Last:&nbsp;
    <input name="txtUserNameLast" type="text" length="20" value="">
    <input type="submit" value="Search">
    </form>
  <%
  else
  %>
  <form method="post" autocomplete="off" action="GetPatron.asp">
    Enter Library Card Barcode<br>
    <input name="txtBarcode" type="text" length="20" value="<%=strSearch1%>"><br>
    <b>OR</b> </br>Enter Name String (First and/or Last)</br>First:
    <input name="txtUserNameFirst" type="text" length="20" value="<%=strSearch2%>">&nbsp;Last:&nbsp;
    <input name="txtUserNameLast" type="text" length="20" value="<%=strSearch3%>">
    <input type="submit" value="Search">
  </form>
  <%
  end if

  'deal with for blank spaces
  strSearch2=replace(strSearch2," ","+")
  strSearch3=replace(strSearch3," ","+")

  %>

  </td>
  </tr>
  </table>
  <%

  if strSearch1<>"" then 'LIBRARY CARD NUMBER SEARCH
    %>
    <!-- #include file = "includes/hex_sha1_js.asp" -->
    <%

    hashURL=session("strBaseHash")
    hashURL=hashURL & "patrons/patron_record/" & strSearch1

    strCryptoKey=session("CryptoKey")
    strIDKey=session("IDKey")
    strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
    strHash = b64_hmac_sha1(strCryptoKey, strAuth)
    strSig=strIDKey & ":" & strHash

    postURL=session("strBaseURL")
    postURL=postURL & "patrons/patron_record/" & strSearch1


'response.write strCryptoKey & ","
'response.write strIDKey

    Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
    xmlhttp.Open "GET", postUrl, false
    xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
    xmlhttp.send 
    'Response.write "<p>" & xmlhttp.responsetext
    if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
      'response.write "<p>Got user info:</p>"
    else

      if xmlhttp.status = 500 then
      else
        response.write "<p>" & xmlhttp.status
        strError=xmlhttp.responsetext
        response.write "<p>Status: " & strError & "</p>"

      end if
    end if

    Response.Write "<p>Results: </p>"
    set xmlDoc = createObject("MSXML2.DOMDocument")
    xmlDoc.async = False
    xmlDoc.setProperty "ServerHTTPRequest", true
    'xmlDoc.load(postURL)
    XMLDOC.LOAD(xmlhttp.responsebody)

    set oNodeList=XMLDoc.GetElementsByTagName("patron")
    Set currNode = oNodeList.nextNode
    Set curitem = oNodeList.Item(i)

    if oNodeList.length=0 then
      response.write "<p class=ErrorMessage>No results for that Library Card number......</p>"
    else

      if oNodeList.length=1 then 'got one and only one record


        Set varPatronID = curitem.selectSingleNode("patronID")
        strID = varPatronID.Text
        Set varPatronNameLast = curitem.selectSingleNode("lastName")
        strNameLast = varPatronNamelast.Text
'        Set varPatronNameFirst = curitem.selectSingleNode("firstName")
'        strNameFirst = varPatronNameFirst.Text
        Set varUCMember = curitem.selectSingleNode("ucMember")
        strUCMember = varUCMember.Text
        Set varInstitutionID = curitem.selectSingleNode("institutionID")
        strInstitutionID = varInstitutionID.Text
        %>
        <p>
        <%
        loadXMLFile xmldoc, server.MapPath("xsl/one_patron.xsl")
        %>
        </p><p>


<%

        if session("role")="invoice_preparer" or session("role")="invoice_prep_app" or session("role")="OMNITEST" then
        %>

          <form action="AddInvoice.asp" method="post">
          <input type="hidden" name="txtID" value="<%=strID%>">
          <input type="hidden" name="txtBarcode" value="<%=strSearch1%>">
          <input type="hidden" name="txtNameLast" value="<%=strNameLast%>">
          <input type="hidden" name="txtNameFirst" value="<%=strNameFirst%>">
          <input type="hidden" name="txtUnit" value="<%=strUnit%>">
          <input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
          <input type="hidden" name="txtUCMember" value="<%=strUCMember%>">
          <input type="hidden" name="txtInstitutionID" value="<%=strInstitutionID%>">
          <input type="submit" value="Create Invoice">
          </form>
        <%
        else
        end if


%>

        <form action="GetPatronInvoices.asp" method="POST">
        <input type="hidden" name="txtBarcode" value="<%=strSearch1%>">
        <input type="hidden" name="txtID" value="<%=strID%>">
        <input type="hidden" name="txtNameLast" value="<%=strNameLast%>">
        <input type="hidden" name="txtNameFirst" value="<%=strNameFirst%>">
        <input type="hidden" name="txtUnit" value="<%=strUnit%>">
        <input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
        <input type="submit" value=" See Invoices ">
        </form>
        </p>
        <%
      else
        'more than one match on Library Card #
        response.write "<p class=ErrorMessage>more than one match on barcode...</p>"
      end if
    end if
  Else
    'NAME STRING SEARCH
    If Request.ServerVariables("REQUEST_METHOD") = "POST" and (len(strSearch2)>2 OR len(strSearch3)>2) and strHalt<>"Y" Then

      %>
      <!-- #include file = "includes/hex_sha1_js.asp" -->
      <%



      hashURL=session("strBaseHash")
      hashURL=hashURL & "patrons/patron_list/"
      if len(trim(strSearch3))>2 and len(trim(strSearch2))>2 then 'first and last
        hashURL=hashURL & "last/" & strSearch3
        hashURL=hashURL & "/first/" & strSearch2
      end if
      if len(trim(strSearch3))>2 and len(trim(strSearch2))<2 then 'last
        hashURL=hashURL & "/last/" & strSearch3
      end if
      if len(trim(strSearch3))<2 and len(trim(strSearch2))>2 then 'first
        hashURL=hashURL & "/first/" & strSearch2
      end if

      if len(trim(strSearch3))=2 and len(trim(strSearch2))>2 then 'first and last
        hashURL=hashURL & "last/" & strSearch3
        hashURL=hashURL & "/first/" & strSearch2
      end if


      strCryptoKey=session("CryptoKey")
      strIDKey=session("IDKey")
      strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
      strHash = b64_hmac_sha1(strCryptoKey, strAuth)
      strSig=strIDKey & ":" & strHash

      postURL=session("strBaseURL")
      postURL=postURL & "patrons/patron_list/"
      if len(trim(strSearch3))>2 and len(trim(strSearch2))>2 then 'first and last
        postURL=postURL & "last/" & strSearch3
        postURL=postURL & "/first/" & strSearch2
      end if
      if len(trim(strSearch3))>2 and len(trim(strSearch2))<2 then 'last
        postURL=postURL & "/last/" & strSearch3
      end if
      if len(trim(strSearch3))<2 and len(trim(strSearch2))>2 then 'first
        postURL=postURL & "/first/" & strSearch2
      end if

      if len(trim(strSearch3))=2 and len(trim(strSearch2))>2 then 'first and last
        postURL=postURL & "last/" & strSearch3
        postURL=postURL & "/first/" & strSearch2
      end if

      Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
      xmlhttp.Open "GET", postUrl, false
      xmlhttp.setRequestHeader "Content-Type","application/xml"
      xmlhttp.setRequestHeader "Authorization", strSig
      xmlhttp.send 
      'Response.write "<p>" & xmlhttp.responsetext
      if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
        'response.write "<p>Got user info:</p>"
        'response.write "<p>" & xmlhttp.status
      else
        response.write "<p>" & xmlhttp.status
        strError=xmlhttp.responsetext
        response.write "<p>Status: " & strError & "</p>"
      end if

      postURL=session("strBaseURL")
      postURL=postURL & "patrons/patron_list/" & strSearch2
      set xmlDoc = createObject("MSXML2.DOMDocument")
      xmlDoc.async = False
      xmlDoc.setProperty "ServerHTTPRequest", true
'      xmlDoc.load(postURL)
      XMLDOC.LOAD(xmlhttp.responsebody)

      If xmlDoc.parseError.errorCode <> 0 Then
        'response.write "handle the parsing error..."
         response.write "handle the parsing error..." & xmlDoc.parseError.errorCode & "</p>"
     End If
 
      set oNodeList=XMLDoc.documentElement.selectNodes("//patronList/patron") 
      Set currNode = oNodeList.nextNode
      Set curitem = oNodeList.Item(i)

      if oNodeList.length=0 then
        response.write "<p class=ErrorMessage>No results for that string...</p>"
      else
        %>
        <p>
        <%
        loadXMLFile xmldoc, server.MapPath("xsl/patron_list.xsl")
        %>
        </p>
        <%
      end if
    Else
      if strSearch2="" and strSearch1="" then
      else 
        response.write "<p class=ErrorMessage>Name Search string must be 2 or more characters with no blank spaces in last or first name...</p>"
      end if
    End if
  End If
  set xmlDoc=nothing
  set nodelist=nothing
  set oNodelist=nothing
end if

%>

<!end main content>
</body>
</html>

