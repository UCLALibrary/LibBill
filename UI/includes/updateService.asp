<%



'The service uses the same XML format as Invoicing WS - Add Branch Service--with 
'the addition of <locSvcKey> field; only <locSvcKey> and <whoBy> are required.

  strserviceName=request("txtserviceName")
  strsubtypeName=request("txtsubtypeName")
  strtaxable=request("txttaxable")
  strucPrice=request("txtucPrice")
  strnonUCPrice=request("txtnonUCPrice")
  strucMinimum=request("txtucMinimum")
  strnonUCMinimum=request("txtnonUCMinimum")
  strRequireCustomPrice=request("txtRequireCustomPrice")
  strunitMeasure=request("txtunitMeasure")
  stritemCode=request("txtitemCode")
  strFAU=request("txtFAU")
  strID=request("txtID")
  strLocationName=request("txtLocationName")
  strCode=request("txtCode")
strWhoBy=session("UserName")

'response.write "ID: " & strID
strGo="Yes"


strInput="<branchService>"
strInput=strInput & "<locSvcKey>" & strID & "</locSvcKey>"
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
strInput=strInput & "<whoBy>" & strWhoBy & "</whoBy>"
strInput=strInput & "</branchService>"


'if len(trim(strCode))<>2  then
'  strGo="No"
'  response.write "<p class=ErrorMessage>Branch code must be two characters " & strUID & "</p>"
'end if



'response.write strInput

if strGo<>"No" then

  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/edit_service"
'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/edit_service"

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>service updated:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  response.write "<p class=ErrorMessage>" & strMessage
end if

%>
