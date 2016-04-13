<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<p>
<a href="default.asp"><u>Invoicing </u></a></br>
<a href="LogOut.asp"><u>Log Out</u></a></br>
</p>
<%
strTestUID="702759586"

strCryptoKey=session("CryptoKey")
hashURL=session("strBaseHash")
hashURL=hashURL & "users/user_info/" & strtestUID
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)

strSig=session("IDKey") & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "users/user_info/" & strtestUID

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

  set oNodeList=XMLDoc.documentElement.selectNodes("//userRoles/userRole") 
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)
  if oNodeList.length=0 then
    response.write "<p>no user on file..."
  else


    strLineNum=oNodeList.length+1

    %>
    <p><table>
    <tr>
    <td bgcolor="#EEEEEE">User Name</td>
    <td bgcolor="#EEEEEE">Role</td>
    <td>&nbsp;</td>
    </tr>
    <%
    For i = 0 To (oNodeList.length - 1)
      Set currNode = oNodeList.nextNode
      Set curitem = oNodeList.Item(i)

      Set varuserPrivilege = curitem.selectSingleNode("userPrivilege/privilege")
      struserPrivilege = varuserPrivilege.Text


      struserPrivilege4Display=replace(struserPrivilege,"_"," ")


      %>
      <tr>
      <td align="right">
<%=struserPrivilege%>
      </td>




      <tr>
      <%
    Next
    %>
    </table>
    </p>
    <%
end if
    set xmlDoc=nothing
    set xmlhttp=nothing


%>
<p>
<form name="AddUserForm" method="post" autocomplete="off" action="AddUser.asp">
UID: <input type="text" name="txtUID">        
UCLA Login: <input type="text" name="txtName">        
<select name="txtRole">
<option value="invoice_preparer">invoice_preparer</option>
<option value="invoice_approver">invoice_approver</option>
<option value="payment_processor">payment_processor</option>
<option value="admin">admin</option>
<input type="submit" value="Add User">
</select>
</form>
</p>

