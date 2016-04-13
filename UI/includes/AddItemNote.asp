<%
'***************** ADD LINE ITEM NOTE

strInvoiceNum=request.form("txtInvoiceNum")
strLineNum=request.form("txtLineEditNum")
strNote=request.form("txtLineItemNote")
strNote=replace(strNote,"&","&#38;")
strInternal=request.form("txtInternal")

if strNote="" then
  response.write "<p>no text...</p>"
  strAbort="Y"
end if

if strAbort<>"Y" then
strBillerID=session("userName")
  'dim strInput
  strInput=strInput & "<lineNote>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<lineNumber>" & strLineNum & "</lineNumber>"
  strInput=strInput & "<internal>" & strInternal & "</internal>"
  strInput=strInput & "<createdBy>" & strBillerID & "</createdBy>"
  strInput=strInput & "<note>" & strNote & "</note>"
  strInput=strInput & "</lineNote>"

  'response.write "<p>" & strinput & "</p>"

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/add_line_note" 
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

  postURL=session("strbaseURL")
  postURL=postURL & "invoices/add_line_note" 

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>line item note added</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  set xmlhttp=nothing

end if 'strAbort


%>