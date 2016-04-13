
<%
'**********PUT INVOICE HEADER

strDate=date()
strBranchCode=session("UnitCode")
strInput="<invoice>"
strInput=strInput & "<branchCode>" & strBranchCode & "</branchCode>"
strInput=strInput & "<invoiceDate>" & strDate & "</invoiceDate>"
strInput=strInput & "<status>Pending</status>"
strInput=strInput & "<createdBy>" & strBillerID & "</createdBy>"
strInput=strInput & "<patronID>" & strPatronID & "</patronID>"
strInput=strInput & "<onPremises>" & strOnPremises & "</onPremises>"
strInput=strInput & "</invoice>"

'response.write strInput

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/add_invoice" 

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/add_invoice" 

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "PUT", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send strInput
strInvoiceNum=xmlhttp.responsetext
strInvoiceNumber=xmlhttp.responsetext
'response.write "<p>strInvoiceNum from PutInvoiceHeader.asp: " & strInvoiceNum & "</p>"
if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  'response.write "<p>Invoice created for:</p>"
else
  if xmlhttp.status=500 then
    strError=xmlhttp.responsetext
    response.write "<p>Failed.  Status: 500</p>"
    'response.write "<p>Failed.  Status: " & strError & "</p>"
  else
    response.write "<p>Failed.  Status: not 500</p>"
    'response.write "<p>Failed.  Status: " & strError & "</p>"
  end if
end if
set xmlhttp=nothing
'strInvoiceNum=strGetInvoiceNum
%>