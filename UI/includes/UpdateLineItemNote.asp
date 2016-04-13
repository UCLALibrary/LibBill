<%
'*****************UPDATE LINE ITEM NOTE

strInvoiceNum=request("txtInvoiceNum")
strLineEditNum=request("txtLineEditNum")
strSequenceNum=request("txtSequenceNum")
strInternal=request("txtInternal")
strCreatedBy=request("txtCreatedBy")
strNote=request("txtLineItemNote")
strNote=replace(strNote,"&","&#38;")

'if strNote contains <a href then
'strGo="No"
'response.write "<p class=ErrorMessage>notes cannot contain html links...</p>

if strGo<>"No" then

strInput=strInput & "<lineNote>"
strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
strInput=strInput & "<lineNumber>" & strLineEditNum & "</lineNumber>"
strInput=strInput & "<sequenceNumber>" & strSequenceNum & "</sequenceNumber>"
strInput=strInput & "<internal>" & strInternal & "</internal>"
strInput=strInput & "<createdBy>" & strCreatedBy & "</createdBy>"
strInput=strInput & "<note>" & strNote & "</note>"
strInput=strInput & "</lineNote>"
'response.write strInput

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/edit_line_note" 
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strbaseURL")
postURL=postURL & "invoices/edit_line_note" 

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "PUT", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send strInput

if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  response.write "<p class=GenericMessage>line item note updated</p>"
else
  strError=xmlhttp.responsetext
  response.write "<p class=ErrorMessage>Status: " & strError & "</p>"
end if

set xmlhttp=nothing

end if
%>