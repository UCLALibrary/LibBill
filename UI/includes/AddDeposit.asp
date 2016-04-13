<%
'***** ADD PAYMENT *****

strInvoiceNum=request("txtInvoiceNum")
strInvoiceTotal=request("txtInvoiceTotal")
strCreatedBy=request("txtBillerID")
strAmount=request("txtAmount")
strBalanceDue=request("txtBalanceDue")
strBillerID=session("userName")
strStatusTo=request("txtStatusTo")
strPaymentTypeID=request("txtPaymentTypeID")
strStatusFrom=request("txtStatusFrom")
strStatusFrom=replace(strStatusFrom," ","+")
strCheckNote=request("txtCheckNote")
strCheckNote=left(strCheckNote,20)

if strAmount="" then
  strGo="No"
  strErrorMessage="Action failed: Amount must be a positive number"
end if
if not isnumeric(strAmount) then
  strGo="No"
  strErrorMessage="Action failed: Amount must be a positive number"
else
  if strAmount<=0 then
    strGo="No"
    strErrorMessage="Action failed: Amount must be a positive number"
  end if
end if

if strGo="No" then
  response.write "<p class=ErrorMessage>" & strErrorMessage & "</p>"
else
  strInput=strInput & "<payment>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<amount>" & strAmount & "</amount>"
  strInput=strInput & "<createdBy>" & strCreatedBy & "</createdBy>"
  strInput=strInput & "<paymentTypeID>" & strPaymentTypeID & "</paymentTypeID>"

  if len(trim(strCheckNote))<>0 then
    strInput=strInput & "<checkNote>" & strCheckNote & "</checkNote>"
  end if
  strInput=strInput & "</payment>"

'response.write strInput

  hashURL=session("strBaseHash")
  hashURL=hashURL & "payments/add_payment" 
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strbaseURL")
  postURL=postURL & "payments/add_payment" 

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>payment added</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  set xmlhttp=nothing

  if strAmount>strBalanceDue then
    response.write "<p class=ErrorMessage>Warning: Overpayment</p>"
  end if

    hashURL=session("strBaseHash")
    hashURL=hashURL & "invoices/edit_invoice/invoice/"
    hashURL=hashURL & strInvoiceNum & "/status/" & strStatusTo
    hashURL=hashURL & "/whoby/" & strBillerID
    strCryptoKey=session("CryptoKey")
    strIDKey=session("IDKey")
    strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
    strHash = b64_hmac_sha1(strCryptoKey, strAuth)
    strSig=strIDKey & ":" & strHash

    postURL=session("strBaseURL")
    postURL=postURL & "invoices/edit_invoice/invoice/"
    postURL=postURL & strInvoiceNum & "/status/" & strStatusTo
    postURL=postURL & "/whoby/" & strBillerID
'response.write postURL
    Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
    xmlhttp.Open "PUT", postUrl, false
    xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
    xmlhttp.send strInput

    if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
      response.write "<p class=GenericMessage>status  updated</p>"
    else
      if xmlhttp.status=500 then
        'strError=xmlhttp.responsetext
        response.write "<p>Status: " & strError & "</p>"
        response.write "<p class=ErrorMessage>error updating status (500--rights issue)</p>"
      else
        strError=xmlhttp.responsetext
        response.write "<p>Status: " & strError & "</p>"
      end if
    end if
  set xmlhttp=nothing

end if

%>