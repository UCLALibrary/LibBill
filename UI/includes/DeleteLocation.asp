
<%
'**********DELETE LOCATION




strID=request.form("txtID")
strBillerID=session("UserName")

hashURL=session("strBaseHash")
hashURL=hashURL & "branches/delete_unit/unit/" & strID 
hashURL=hashURL & "/whoby/" & strBillerID

'response.write hashURL
strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "DELETE" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


postURL=session("strBaseURL")
postURL=postURL & "branches/delete_unit/unit/" & strID 
postURL=postURL & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "DELETE", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 

if xmlhttp.status = 200 then
  response.write "<p class=GenericMessage>Location deleted:</p>"
else
  if xmlhttp.status = 404 then
    response.write "<p class=ErrorMessage>404; delete process halted</p>"
    response.write "<p>" & postURL & "</p>"
  else
    if xmlhttp.status = 406 then
      response.write "<p class=ErrorMessage>406; delete process halted</p>"
    else
      strError=xmlhttp.responsetext
      response.write "<p>Status: " & strError & "</p>"
    end if
  end if
end if
set xmlhttp=nothing

%>