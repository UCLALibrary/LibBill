<%
'*** UPDATE INVOICE

strInvoiceNum=request("txtInvoiceNumber")
strStatus=request("txtStatus")
strStatus=trim(ltrim(strStatus))
strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")

strBillerID=session("userName")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/edit_invoice/invoice/" 
hashURL=hashURL & strInvoiceNum & "/status/" & strStatus
hashURL=hashURL & "/whoby/" & strBillerID

strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strbaseURL")
postURL=postURL & "invoices/edit_invoice/invoice/" 
postURL=postURL & strInvoiceNum & "/status/" & strStatus
postURL=postURL & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "PUT", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send strInput

if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  response.write "<p class=GenericMessage>status  updated</p>"
else
  strError=xmlhttp.responsetext
  response.write "<p>Status: " & strError & "</p>"
end if

set xmlhttp=nothing

'response.write "url: " & postURL

%>