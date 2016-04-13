<!-- #include file = "hex_sha1_js.asp" -->

<%

strInvoiceNum=request.querystring("Num")
hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/mail_invoice/" & strInvoiceNum

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/mail_invoice/" & strInvoiceNum

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", postUrl, false
'xmlhttp.setRequestHeader "Content-type", "application/x-msdownload"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 

if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  strMessage= "<p>invoice mailed..." 
else
  response.write "<p>" & xmlhttp.status
  strMessage= "<p>that invoice number not found... (or some other problem)" 
'  strError=xmlhttp.responsetext
'  response.write "<p>Status: " & strError & "</p>"
end if
%>
<p class="GenericMessage"><%=strMessage%></p>
