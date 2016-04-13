
<%
'**********DELETE LINE ITEM NOTE

strLineNum=request.form("txtLineEditNum")
strInvoiceNum=request.form("txtInvoiceNum")
strSequenceNum=request.form("txtSequenceNum")
strBillerID=session("userName")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/delete_line_note/invoice/" 
hashURL=hashURL & strInvoiceNum & "/line/" & strLineNum & "/note/" & strSequenceNum & "/whoby/" & strBillerID
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "DELETE" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/delete_line_note/invoice/"
postURL=postURL & strInvoiceNum & "/line/" & strLineNum & "/note/" & strSequenceNum & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "DELETE", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 


if xmlhttp.status = 200 then
  response.write "<p class=GenericMessage>Line Item note deleted:</p>"
else
  if xmlhttp.status = 404 then
    response.write "<p class=ErrorMessage>404-problem with line number or invoice number or sequence number; delete process halted</p>"
    response.write "<p class=ErrorMessage>" & postURL & "</p>"
  else
    if xmlhttp.status = 406 then
      response.write "<p class=ErrorMessage>406-invoice not pending; delete process halted</p>"
    else
      strError=xmlhttp.responsetext
      response.write "<p class=ErrorMessage>Status: " & strError & "</p>"
    end if
  end if
end if
set xmlhttp=nothing

%>