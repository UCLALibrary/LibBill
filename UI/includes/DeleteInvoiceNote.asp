
<%
'**********DELETE INVOICE NOTE
%>
<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<%

strInvoiceNum=request.form("txtInvoiceNum")
strSequenceNum=request.form("txtSequenceNum")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/delete_invoice_note/invoice/" 
hashURL=hashURL & strInvoiceNum & "/note/" & strSequenceNum & "/whoby/" & strBillerID
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "DELETE" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL="http://webservices.library.ucla.edu/invoicing/invoices/delete_invoice_note/invoice/"
postURL=postURL & strInvoiceNum & "/note/" & strSequenceNum & "/whoby/" & strBillerID

postURL=session("strBaseURL")
postURL=postURL & "invoices/delete_invoice_note/invoice/"
postURL=postURL & strInvoiceNum & "/note/" & strSequenceNum & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "DELETE", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 


if xmlhttp.status = 200 then
  response.write "<p class=genericMessage>Invoice note deleted:</p>"
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