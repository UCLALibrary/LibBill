<%
strUserName=request("txtUserName")
strLastName=request("txtLastName")
strFirstName=request("txtFirstName")
strRole=request("txtRole")
strWhoBy=session("UserName")
strGo="Yes"



if strGo<>"No" then

  hashURL=session("strBaseHash")
  hashURL=hashURL & "users/set_role/name/" & strUserName
  hashURL=hashURL & "/role/" & strRole 
  hashURL=hashURL & "/whoby/" & strWhoBy
'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "users/set_role/name/" & strUserName
  postURL=postURL & "/role/" & strRole 
  postURL=postURL & "/whoby/" & strWhoBy

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p>user updated:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  response.write "<p>" & strGo
end if

%>
