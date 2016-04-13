<%

strInvoiceNum=request("txtInvoiceNumber")
strLineEditNum=request("txtLineNum")
strCreatedBy=session("userName")
strAmount=request("txtAmount")
'response.write "Session ID : " & session("billerID")

'response.write "<p>" & strAmount & "</p>"

strType=request("txtType")
strReason=request("txtReason")
strGo="Yes"

if len(trim(strReason))>199 then
  strMessage="Action failed: The reason must be under 200 characters. Click your browser's back button to see your text."
  strGo="No"
end if

if len(trim(strReason))<1 then
  strMessage="Action failed: The reason can't be blank."
  strGo="No"
end if

if not isnumeric(strAmount) or isnull(strAmount) then
  strMessage="Action failed: Amount must be a number..."
  strGo="No"
end if

if strGo<>"Yes" then
  response.write "<p class=ErrorMessage>" & strMessage & "</p>"
else

  if strAmount>0 then
  response.write "<p class=ErrorMessage>Action failed: Adjustment amount must be a negative number.</p>"
  else
  
  strInput=strInput & "<lineItemAdjustment>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<lineNumber>" & strlineEditNum & "</lineNumber>"
  strInput=strInput & "<createdBy>" & strCreatedBy & "</createdBy>"
  strInput=strInput & "<amount>" & strAmount & "</amount>"
  strInput=strInput & "<adjustmentType>" & strType & "</adjustmentType>"
  strInput=strInput & "<adjustmentReason>" & strReason & "</adjustmentReason>"
  strInput=strInput & "</lineItemAdjustment>"

'response.write strInput

hashURL=session("strBaseHash")
hashURL=hashURL & "adjustments/add_line_credit" 
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


postURL=session("strbaseURL")
postURL=postURL & "adjustments/add_line_credit" 

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>line item adjustment added</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  set xmlhttp=nothing
end if

end if
%>