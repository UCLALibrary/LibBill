<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<a href="default.asp"><u>Invoicing </u></a></br>
<%

strUID=left(request("txtUID"),9)
strUserName=left(request("txtUserName"),20)
strFirstName=left(request("txtFirstName"),20)
strLastName=left(request("txtLastName"),20)
strRole=request("txtRole")
strWhoBy=session("UserName")
strGo="Yes"

if len(trim(strUID))<>9 or not isnumeric(strUID) then
  strGo="No"
  response.write "<p class=ErrorMessage>problem with UID: " & strUID & "</p>"
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

'strGo="No"

if strGo<>"No" then

  strInput="<userRole>"
  strInput=strInput & "<userName>" & strUserName & "</userName>"
  strInput=strInput & "<role>" & strRole & "</role>"
  strInput=strInput & "<userUid>" & strUID & "</userUid>"
  strInput=strInput & "<firstName>" & strFirstName & "</firstName>"
  strInput=strInput & "<lastName>" & strLastName & "</lastName>"
  strInput=strInput & "<whoBy>" & strWhoBy & "</whoBy>"
  strInput=strInput & "</userRole>"

  hashURL=session("strBaseHash")
  hashURL=hashURL & "users/add_user"
  'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"

  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "users/add_user"
  'response.write postURL
  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p>user added:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  'response.write "<p>" & strGo
end if
%>


