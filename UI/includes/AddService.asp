<%

strName=request("txtName")
strserviceName=request("txtserviceName")
strsubtypeName=request("txtsubtypeName")
strtaxable=request("txttaxable")
strucPrice=request("txtucPrice")
strnonUCPrice=request("txtnonUCPrice")
strucMinimum=request("txtucMinimum")
strnonUCMinimum=request("txtnonUCMinimum")
strRequireCustomPrice=request("txtrequireCustomPrice")
strunitMeasure=request("txtunitMeasure")
stritemCode=request("txtitemCode")
strFAU=request("txtFAU")
strLocationID=request("txtID")

'response.write "ID: " & strLocationID
strWhoBy=session("UserName")
strGo="Yes"

if len(trim(strServiceName))<2  then
  strGo="No"
  strErrorMessage= "Service name must be at least two characters "
end if

if not isnumeric(strUCPrice) then
  strGo="No"
  strErrorMessage= "UC Price must be a number " 
end if

if not isnumeric(strNonUCPrice) then
  strGo="No"
  strErrorMessage= "Non-UC Price must be a number " 
end if

if not isnumeric(ucMinimum) then
  strGo="No"
  strErrorMessage= "UC Minimum must be a number " 
end if

if not isnumeric(ucnonMinimum) then
  strGo="No"
  strErrorMessage= "Non-UC Minimum must be a number " 
end if

if len(trim(strItemCode))=0 then
  strGo="No"
  strErrorMessage= "Item code can not be blank " 
end if

if len(trim(strFAU))=0 then
  strGo="No"
  strErrorMessage= "FAU can not be blank " 
end if
if strGo<>"No" then


  strInput="<branchService>"
  strInput=strInput & "<serviceName>" & strserviceName & "</serviceName>"
  strInput=strInput & "<subtypeName>" & strsubtypeName & "</subtypeName>"
  strInput=strInput & "<taxable>" & strtaxable & "</taxable>"
  strInput=strInput & "<ucPrice>" & strucPrice & "</ucPrice>"
  strInput=strInput & "<nonUCPrice>" & strnonUCPrice & "</nonUCPrice>"
  strInput=strInput & "<ucMinimum>" & strucMinimum & "</ucMinimum>"
  strInput=strInput & "<nonUCMinimum>" & strnonUCMinimum & "</nonUCMinimum>"
  strInput=strInput & "<requireCustomPrice>" & strRequireCustomPrice & "</requireCustomPrice>"
  strInput=strInput & "<unitMeasure>" & strunitMeasure & "</unitMeasure>"
  strInput=strInput & "<itemCode>" & stritemCode & "</itemCode>"
  strInput=strInput & "<fau>" & strFAU & "</fau>"
  strInput=strInput & "<locationID>" & strlocationID & "</locationID>"
  strInput=strInput & "<whoBy>" & strWhoBy & "</whoBy>"
  strInput=strInput & "</branchService>"

  'response.write strInput

  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/add_service"
  'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"

  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/add_service"

  'response.write postURL

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>service added:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  response.write "<p class=ErrorMessage>" & strErrorMessage & "</p>"
end if
%>


