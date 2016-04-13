<!-- #include file = "includes/hex_sha1_js.asp" -->

<%

'test for invoice number is valid before continuing
'if not, exit with appropriate error message

strInvoiceNum=request.querystring("Num")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/invoice_by_number/" & strInvoiceNum    

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/invoice_by_number/" & strInvoiceNum    


Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 
'Response.write "<p>" & xmlhttp.responsetext
if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  'response.write "<p>Got user info:</p>"
else
  strGo="No"
  if xmlhttp.status=500 then
  else
    response.write "<p>" & xmlhttp.status
    strError=xmlhttp.responsetext
    'response.write "<p>Status: " & strError & "</p>"
  end if
end if

'

if strGo="No" then
  %>
<h1>
We're sorry.  We had a problem finding that invoice.
Please report the problem to the <a href="mailto:helpdesk@library.ucla.edu">Library Information Technology Helpdesk</a>.
</h1>
  <%

else

strInvoiceNum=request.querystring("Num")
hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/display_invoice/" & strInvoiceNum

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/display_invoice/" & strInvoiceNum

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", postUrl, false
xmlhttp.setRequestHeader "Content-type", "application/x-msdownload"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 

if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  data = xmlhttp.responsebody
  Response.Clear()
  Response.ContentType = "application/pdf"
  Response.BinaryWrite(data)
 Response.End()
else
'  response.write "<p>" & xmlhttp.status
'  response.write "<p>that invoice number not found..." 
  strError=xmlhttp.responsetext
  response.write "<p>Status: " & strError & "</p>"
end if

end if
%>