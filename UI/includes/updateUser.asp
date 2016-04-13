<%

strUID=request("txtUserUID")
'response.write strUID
strUserName=request("txtUserName")
strFirstName=request("txtFirstName")
strLastName=request("txtLastName")
strRole=request("txtRole")
strWhoBy=session("UserName")
strGo="Yes"

strInput="<userRole>"
strInput=strInput & "<userName>" & strUserName & "</userName>"
strInput=strInput & "<userUid>" & strUID & "</userUid>"
strInput=strInput & "<firstName>" & strFirstName & "</firstName>"
strInput=strInput & "<lastName>" & strLastName & "</lastName>"
strInput=strInput & "<whoBy>" & strwhoBy & "</whoBy>"
strInput=strInput & "</userRole>"

if len(trim(strUID))<>9 or not isnumeric(strUID) then
  strGo="No"
  strMessage= "<p class=ErrorMessage>problem with UID: " & strUID & "</p>"
end if

if len(trim(strUserName))<2 then
  strGo="No"
  response.write "<p class=ErrorMessage>problem with user name: " & strName & "</p>"
end if
if len(trim(strFirstName))<2 then
  strGo="No"
  response.write "<p class=ErrorMessage>problem with first name: " & strName & "</p>"
end if

if len(trim(strLastName))<2 then
  strGo="No"
  response.write "<p class=ErrorMessage>problem with last name: " & strName & "</p>"
end if

'response.write strInput

if strGo<>"No" then

  hashURL=session("strBaseHash")
  hashURL=hashURL & "users/edit_user"
'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "users/edit_user"

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
  response.write "<p class=ErrorMessage>" & strMessage & "</p>"
end if

%>
