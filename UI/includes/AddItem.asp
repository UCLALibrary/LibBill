<%
'*** ADD LINE ITEM

'if request.servervariables("http_referer")<>"" then
'  response.write "<p>referer: " & request.servervariables("http_referer") & "</p>"
'end if

strServiceID=request.form("txtServiceID")
strQuantity=request.form("txtUnitCount")

'get strRequireCustomPrice, strPrice, StrMiminmumPrice


My_Array=split(strServiceID,";")
strRequireCustomPrice=My_Array(0)
strServiceID=My_Array(1)
strUnitPrice=My_Array(2)
strMinimumPrice=My_Array(3)
strUnitPrice=1 * strUnitPrice
strMinimumPrice=1 * strMinimumPrice

'response.write strRequireCustomPrice & "; " & strServiceID & " ;" &  strUnitPrice & "; " &  strMinimumPrice

'get unit price and service ID from option selected from drop down menu

'if left(strServiceID,1)="T" then
'  strRequireCustomPrice="T"
'else
'  strRequireCustomPrice="F"
'end if

'strServiceID=mid(strServiceID,2)

'if mid(strServiceID,2,1)="," then
'  strUnitPrice=mid(strServiceID,3)
'  strServiceID=left(strServiceID,1)
'end if

'if mid(strServiceID,3,1)="," then
'  strUnitPrice=mid(strServiceID,4)
'  strServiceID=left(strServiceID,2)
'end if

'if mid(strServiceID,4,1)="," then
'  strUnitPrice=mid(strServiceID,5)
'  strServiceID=left(strServiceID,3)
'end if

if isnull(strUnitPrice) then strUnitPrice=1
if strUnitPrice=0 then strUnitPrice=1
'strUC=request.form("txtUC")

'strUCRate=request("UCRate")
'strOnPremises=request.form("txtOnPremises")


if  not isnumeric(strQuantity) then
  'response.write "non-numeric"
  strQuantity="1"
end if
if strQuantity="" or not isnumeric(strQuantity) then
   strQuantity="1"
end if

if strQuantity=0 then strQuantity=1

if strQuantity<0 then
    strAbort="Y"
    strerrorMessage="Acion Failed: Quantity must be a positive number..."
end if

if strRequireCustomPrice="T" then
  strQuantity=1
  strUnitPrice=request("txtUnitPrice")

  if not isnumeric(strUnitPrice) then
    strAbort="Y"
    strerrorMessage="Action Failed: A price is required to add that line item..."
  else
    if strUnitPrice<0 then
      strAbort="Y"
      strerrorMessage="Action Failed: Price must be a positive number..."
    end if
  end if
end if


if strMinimumPrice > strUnitPrice*strQuantity then
  strQuantity=(strMinimumPrice / strUnitPrice)
else
end if



if strAbort<>"Y" then
  strBillerID=session("UserName")
  'dim strInput
  strInput=strInput & "<lineItem>"
  strInput=strInput & "<invoiceNumber>" & strInvoiceNum & "</invoiceNumber>"
  strInput=strInput & "<branchServiceID>" & strServiceID & "</branchServiceID>"
  strInput=strInput & "<quantity>" & strquantity & "</quantity>"
  if strRequireCustomPrice="T" then
    strInput=strInput & "<unitPrice>" & strunitPrice & "</unitPrice>"
  end if
  strInput=strInput & "<ucMember>" & strUCMember & "</ucMember>"
  strInput=strInput & "<createdBy>" & strBillerID & "</createdBy>"
  strInput=strInput & "</lineItem>"


hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/add_line_item" 
strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash


postURL=session("strBaseURL")
postURL=postURL & "invoices/add_line_item" 


  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput

  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>line item added</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

  set xmlhttp=nothing
else
  response.write "<p class=ErrorMessage>" & strErrorMessage & "</p>"
end if 'strAbort

%>