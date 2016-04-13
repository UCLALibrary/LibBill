<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<!-- #INCLUDE virtual="includes/Functions.asp" --> 



<p>
<a href="default.asp"><u>Invoicing </u></a></br>
<a href="GetPatron.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Patrons</u></a></br>
<a href="GetInvoice.asp">&nbsp;&nbsp;&nbsp;&nbsp;*<u>Invoices</u></a>
(<a href="GetInvoice.asp?Search=Advanced">Advanced</a>)</br>
<a href="LogOut.asp"><u>Log Out</u></a></br>




<%


strCryptoKey=session("CryptoKey")
hashURL=session("strBaseHash")
hashURL=hashURL & "users/all_users"
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)

strSig=session("IDKey") & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "users/all_users" 

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

loadXMLFile xmldoc, server.MapPath("xsl/user_list.xsl") 

set xmlDoc=nothing
set xmlhttp=nothing


%>
<p>
<form name="AddUserForm" method="post" autocomplete="off" action="AddUser.asp">
<table>
<tr>
<td>UID </td>
<td>UCLA Login</td>
<td>First Name</td>
<td>Last Name</td>
<td>Role</td>
</tr>
<tr>
<td>
<input type="text" name="txtUID">        
</td><td>
<input type="text" name="txtUserName">        
</td><td>
<input type="text" name="txtFirstName">        
</td><td>
<input type="text" name="txtlastName">        
</td><td>
<select name="txtRole">
<option value="invoice_preparer">invoice_preparer</option>
<option value="invoice_approver">invoice_approver</option>
<option value="payment_processor">payment_processor</option>
<option value="payment_approver">payment_approver</option>
<option value="admin">admin</option>
<input type="submit" value="Add User">
</select>
</td>
</tr>
</table>
</form>

<p>&nbsp;</p>
<p>&nbsp;</p>