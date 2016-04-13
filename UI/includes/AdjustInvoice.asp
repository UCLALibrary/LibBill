<%
'***ADJUST INVOICE--REMOVE TAXES OR ISSUE REFUND***

strInvoiceNum=request("txtInvoiceNumber")
strBillerID=session("userName")
strDate=date()
strWhoBy=session("userName")
strReason=request("txtReason")
strType=request("txtType")
strStatus=request("txtStatus")
strAmount=request("txtAmount")



if session("role")<>"payment_approver" then
  strGo="No"
  strMessage="Action failed: only payment approver can adjust invoice."
end if

if strStatus="Pending" then
  strGo="No"
  strMessage="Action failed: Invoice adjustments are not allowed on Pending invoices..."
end if

if strType="REFUND" then
  if request("txtBalanceDue")>0 then
    strGo="No"
    strMessage="Action failed: Refund not allowed when balance due is more than zero..."
  end if
end if

if strType="NULLIFY PAYMENT" then
  strReason="Operator Error"
  if not isnumeric(strAmount) then strAmount=0
  if strAmount="" then strAmount=0
  if strAmount=<0 then
    strGo="No"
    strMessage="Action Failed: Nullify Payment Amount must be a positive number."
  end if
end if

if strGo<>"No" then

  strInput="<invoiceAdjustment>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<createdBy>" & strWhoBy & "</createdBy>"
  strInput=strInput & "<createdDate>" & strDate & "</createdDate>"
  strInput=strInput & "<adjustmentType>" & strType & "</adjustmentType>"

  if strType="NULLIFY PAYMENT" then
'    strInput=strInput & "<adjustmentReason>" & strReason & "</adjustmentReason>"
    strInput=strInput & "<adjustmentAmount>" & strAmount & "</adjustmentAmount>"
  end if

  strInput=strInput & "</invoiceAdjustment>"
'response.write "*" & strInput & "*"
  hashURL=session("strBaseHash")
  hashURL=hashURL & "adjustments/add_inv_credit" 
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "adjustments/add_inv_credit"

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    if strType="REFUND" then
      response.write "<p class=GenericMessage>refund applied</p>"
    end if
    if strType="CANCEL TAX" then   
      response.write "<p class=GenericMessage>taxes removed</p>"
    end if
    if strType="NULLIFY PAYMENT" then   
      response.write "<p class=GenericMessage>payment annulled</p>"
    end if
  else
    if xmlhttp.status=500 then
      response.write "<p class=ErrorMessage> Action failed.  </p>"
      strError=xmlhttp.responsetext
      response.write "<p>Status: " & strError & "</p>"
    else
      strError=xmlhttp.responsetext
      response.write "<p>Status: " & strError & "</p>"
    end if
  end if

  set xmlhttp=nothing

else
  response.write "<p class=ErrorMessage>" & strMessage & "</p>"
end if

'response.write "url: " & postURL

%>