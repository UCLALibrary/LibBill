<%
'*****************BEGIN REMOVE TAXES

strInvoiceNum=request("txtInvoiceNumber")
strBillerID=session("userName")

hashURL=session("strBaseHash")
hashURL=hashURL & "adjustments/cancel_tax/invoice/" 
hashURL=hashURL & strInvoiceNum & "/whoby/" & strBillerID
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


postURL=session("strBaseURL")
postURL=postURL & "adjustments/cancel_tax/invoice/"
postURL=postURL & strInvoiceNum & "/whoby/" & strBillerID

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "PUT", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send strInput

if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  response.write "<p>taxes removed</p>"
else
  strError=xmlhttp.responsetext
  response.write "<p>Status: " & strError & "</p>"
end if

set xmlhttp=nothing

'response.write "url: " & postURL

%>