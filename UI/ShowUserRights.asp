<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<p>
<a href="default.asp"><u>Invoicing </u></a></br>
<a href="LogOut.asp"><u>Log Out</u></a></br>
</p>
<%
strUID=request.form("txtUID")
strCryptoKey=session("CryptoKey")
hashURL=session("strBaseHash")
hashURL=hashURL & "users/user_info/" & strUID
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)

strSig=session("IDKey") & ":" & strHash

response.write strSig

  postURL=session("strBaseURL")
  postURL=postURL & "users/user_info/" & strUID

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

  set oNodeList=XMLDoc.documentElement.selectNodes("//user/userPrivilege") 
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

      Set varuserPrivilege = curitem.selectSingleNode("privilege")
      struserPrivilege = varuserPrivilege.Text


      struserPrivilege4Display=replace(struserPrivilege,"_"," ")


      %>
      <tr>
      <td align="right">
<%=struserPrivilege4Display%>
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

