
<% 
'*** Load loc_serv data into memory array
'*** for making AddLineItemForm.asp drop down menu
'*** and UpdateItem.asp (require_custom_pricing y/n)

'response.write "got here"

%>
<!-- #include virtual = "includes/hex_sha1_js.asp" -->
<%

hashURL=session("strBaseHash")
hashURL=hashURL & "appinfo/version" 

'response.write hashURL

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "appinfo/version" 

'response.write "<p>url: " & postURL

Set xmlhttplist = server.Createobject("MSXML2.XMLHTTP")
xmlhttplist.Open "GET", postUrl, false
xmlhttplist.setRequestHeader "Content-Type","application/xml"
xmlhttplist.setRequestHeader "Authorization", strSig
xmlhttplist.send 

'Response.write "<p>" & xmlhttplist.status

if (xmlhttplist.status >= 200) and (xmlhttplist.status < 300) then
  session("AppVersion")=xmlhttplist.responsetext
  'response.write "<p>Got info:</p>" & xmlhttplist.responsetext
else
  if xmlhttplist.status=500 then response.write "500"
  response.write "<p>status is: " & xmlhttplist.status
  strError=xmlhttplist.responsetext
  response.write "<p>Status: " & strError & "</p>"
end if

set httpxmllist=nothing

%>
