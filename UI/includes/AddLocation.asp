<%

strCode=request("txtCode")
strCode=ucase(strCode)
strName=request("txtName")
strDepartment=request("txtDepartment")
strPhone=request("txtPhone")
strWhoBy=session("UserName")
strGo="Yes"

'if location code is already in use, disallow add


strCryptoKey=session("CryptoKey")
hashURL=session("strBaseHash")
hashURL=hashURL & "branches/unit_list"
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)

strSig=session("IDKey") & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "branches/unit_list" 

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 
'Response.write "<p>" & xmlhttp.responsetext
if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  'response.write "<p>Got users info:</p>"
else
  response.write "<p>" & xmlhttp.status
  strError=xmlhttp.responsetext
  response.write "<p>Status: " & strError & "</p>"
end if

set xmlDoc = createObject("MSXML2.DOMDocument")
xmlDoc.async = False
xmlDoc.setProperty "ServerHTTPRequest", true
XMLDOC.LOAD(xmlhttp.responsebody)

set oNodeList=XMLDoc.documentElement.selectNodes("//units/unit") 
Set currNode = oNodeList.nextNode
Set curitem = oNodeList.Item(i)
For i = 0 To (oNodeList.length - 1)
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)
  Set varCodeTest = curitem.selectSingleNode("code")
  strCodeTest = varCodeTest.Text
  if strCodeTest=strCode then 
    strGo="No"
    strMessage="That code already in use..."
  end if
Next

set xmlDoc=nothing
set xmlhttp=nothing




if len(trim(strCode))<>2  then
  strGo="No"
  strMessage= "Branch code must be two characters " 
end if


'strGo="No"

if strGo<>"No" then

  strInput="<branch>"
  strInput=strInput & "<code>" & strCode & "</code>"
  strInput=strInput & "<name>" & strName & "</name>"
  strInput=strInput & "<department>" & strDepartment & "</department>"
  strInput=strInput & "<phone>" & strPhone & "</phone>"
  strInput=strInput & "<whoBy>" & strWhoBy & "</whoBy>"
  strInput=strInput & "</branch>"

  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/add_unit"
  'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"

  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/add_unit"
  'response.write postURL
  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>location added:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Error Status: " & xmlhttp.status & " Please file a help desk ticket</p>"
    'response.write "<p>Error Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  response.write "<p class=ErrorMessage>" & strMessage & "</p>"
end if
%>


