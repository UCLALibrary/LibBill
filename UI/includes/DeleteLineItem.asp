
<%
'**********DELETE LINE ITEM

strLineNumber=request.form("txtLineEditNum")
strInvoiceNum=request.form("txtInvoiceNum")
strBillerID=session("UserName")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/delete_line/invoice/" & strInvoiceNum & "/line/" & strLineNumber
hashURL=hashURL & "/whoby/" & strBillerID

'response.write hashURL
strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "DELETE" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


postURL=session("strBaseURL")
postURL=postURL & "invoices/delete_line/invoice/" & strInvoiceNum & "/line/" & strLineNumber
postURL=postURL & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "DELETE", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 

if xmlhttp.status = 200 then
  response.write "<p class=GenericMessage>Line Item deleted:</p>"
else
  if xmlhttp.status = 404 then
    response.write "<p class=ErrorMessage>404-problem with line number or invoice number; delete process halted</p>"
    response.write "<p>" & postURL & "</p>"
  else
    if xmlhttp.status = 406 then
      response.write "<p class=ErrorMessage>406-invoice not pending; delete process halted</p>"
    else
      strError=xmlhttp.responsetext
      response.write "<p>Status: " & strError & "</p>"
    end if
  end if
end if
set xmlhttp=nothing

%>