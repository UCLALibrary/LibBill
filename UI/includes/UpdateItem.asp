<%
'*****************UPDATE ITEM


strInvoiceNum=request("txtInvoiceNum")
strLineEditNum=request("txtLineEditNum")
strbranchServiceID=request("txtBranchServiceID")
strQuantity=request("txtQuantity")
'response.write "strQuantity: " & strQuantity
strUnitPrice=request("txtUnitPrice")
'response.write "strUnitPrice: " & strUnitPrice
strUnitPriceOriginal=request("txtUnitPriceOriginal")
strRequireCustomPrice=request("txtRequireCustomPrice")

'response.write "Require: " & strRequireCustomPrice

strMinimum=request("txtMinimum")
 'response.write "minimum: " & strMinimum

if strRequireCustomPrice="true" then
 'response.write "require is true " 
 strQuantity=1

  if not isnumeric(strUnitPrice) then
    strErrorMessage="Action Failed: Unit Price must be a number"
    strAbort="Y"
  end if
  if strUnitPrice ="" then
    strErrorMessage="Action Failed: Unit Price must be a number"
    strAbort="Y"
  end if
  if strAbort<>"Y" then
    if strUnitPrice = 0 then
      strErrorMessage="Action failed: Unit Price must not be zero"
      strAbort="Y"
    end if
  end if

else
  strUnitPrice=strUnitPriceOriginal

  if not isnumeric(strQuantity) then
    strErrorMessage="Action Failed: Quantity must be a number"
    strAbort="Y"
  end if
  if strQuantity ="" then
    strErrorMessage="Action Failed: Quantity must not be blank"
    strAbort="Y"
  end if
  if strQuantity =0 then
    strErrorMessage="Action Failed: Price is not updatable, and quantity must not be zero"
    strAbort="Y"
  end if
end if

if strAbort="Y" then
    response.write "<p class=ErrorMessage>" & strErrorMessage & "</p>"
else
'response.write "strUnitPrice: " & strUnitPrice

  if strMinimum<>"0.0" then

    strMinimum=CSng(strMinimum)
    strPrice=CSng(strUnitPrice*strQuantity)

    if strMinimum > strPrice then
      strQuantity=(strMinimum / strUnitPrice)
      strHint="Yes"
    else
    end if
  end if

  strInput=strInput & "<lineItem>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<branchServiceID>" & strbranchServiceID & "</branchServiceID>"
  strInput=strInput & "<lineNumber>" & strlineEditNum & "</lineNumber>"
  strInput=strInput & "<quantity>" & strquantity & "</quantity>"
  if strRequireCustomPrice="true" then
    strInput=strInput & "<unitPrice>" & strUnitPrice & "</unitPrice>"
  else
    strInput=strInput & "<unitPrice></unitPrice>"
  end if
  strInput=strInput & "<ucMember>" & strUCMember & "</ucMember>"
  strInput=strInput & "<createdBy>" & strBillerID & "</createdBy>"
  strInput=strInput & "</lineItem>"

  hashURL=session("strBaseHash")
  hashURL=hashURL & "invoices/edit_line_item" 
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strbaseURL")
  postURL=postURL & "invoices/edit_line_item" 

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>line item updated</p>"

    if strHint="Yes" then
      response.write "<p class=GenericMessage>Quantity modified to reflect Minimum Price. </p>"
    end if
  
  else
    strError=xmlhttp.responsetext
    response.write "<p class=ErrorMessage>Status: " & strError & "</p>"
  end if

  set xmlhttp=nothing
end if

%>