<%
'*****************UPDATE INVOICE NOTE

strInvoiceNum=request("txtInvoiceNum")
strSequenceNum=request("txtSequenceNum")
strInternal=request("txtInternal")
strCreatedBy=request("txtCreatedBy")
strCreatedBy=session("username")
strNote=request("txtInvoiceNote")


strNote=replace(strNote,"&","&#38;")

  strInput=strInput & "<invoiceNote>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<sequenceNumber>" & strSequenceNum & "</sequenceNumber>"
  strInput=strInput & "<internal>" & strInternal & "</internal>"
  strInput=strInput & "<note>" & strNote & "</note>"
  strInput=strInput & "<createdBy>" & strCreatedBy & "</createdBy>"
  strInput=strInput & "</invoiceNote>"

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/edit_invoice_note" 
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


'  response.write strInput
  'postURL="http://webservices.library.ucla.edu/invoicing/invoices/edit_invoice_note" 
  postURL=session("strBaseURL")
  postURL=postURL & "invoices/edit_invoice_note" 
'response.write postURL
  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p>invoice note updated</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & xmlhttp.status & strError & "</p>"
  end if

  set xmlhttp=nothing


%>