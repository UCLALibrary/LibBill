<%
'****** GET DROP DOWN LIST OF SERVICES
'strUnitCode=session("UnitCode")
strUnitCode=left(strInvoiceNum,2)

%>
<!-- #include virtual = "/includes/hex_sha1_js.asp" -->
<%

if strHasLineItem="Yes" then
  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/branch_services/" & lcase(strUnitCode) & "/for_uc/" & strUCMember & "/code/" & stritemcode

  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/branch_services/" & lcase(strUnitCode)
  postURL=postURL & "/for_uc/" & strUCMember & "/code/" & stritemcode

  Set xmlhttplist = server.Createobject("MSXML2.XMLHTTP")
  xmlhttplist.Open "GET", postUrl, false
  xmlhttplist.setRequestHeader "Content-Type","application/xml"
  xmlhttplist.setRequestHeader "Authorization", strSig
  xmlhttplist.send 

  if (xmlhttplist.status >= 200) and (xmlhttplist.status < 300) then
    'response.write "<p>Got info:</p>"
  else
    if xmlhttplist.status=500 then response.write "500"
    response.write "<p>status is: " & xmlhttplist.status
    strError=xmlhttplist.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if

else


  hashURL=session("strBaseHash")
  hashURL=hashURL & "branches/branch_services/" & lcase(strUnitCode) & "/for_uc/" & strUCMember

  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "branches/branch_services/" & lcase(strUnitCode)
  postURL=postURL & "/for_uc/" & strUCMember

  Set xmlhttplist = server.Createobject("MSXML2.XMLHTTP")
  xmlhttplist.Open "GET", postUrl, false
  xmlhttplist.setRequestHeader "Content-Type","application/xml"
  xmlhttplist.setRequestHeader "Authorization", strSig
  xmlhttplist.send 

  if (xmlhttplist.status >= 200) and (xmlhttplist.status < 300) then
    'response.write "<p>Got info:</p>"
  else
    if xmlhttplist.status=500 then response.write "500"
    response.write "<p>status is: " & xmlhttplist.status
    strError=xmlhttplist.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if


end if

set xmlDocList = createObject("MSXML2.DOMDocument")
xmlDocList.async = False
xmlDocList.setProperty "ServerHTTPRequest", true
XMLDOCList.LOAD(xmlhttplist.responsebody)
 
'response.write postURL

If xmlDocList.parseError.errorCode <> 0 Then
  response.write "handle the parsing error..."
End If
 
set oNodeList=XMLDocList.documentElement.selectNodes("//branchServices/service") 
Set currNode = oNodeList.nextNode
Set curitem = oNodeList.Item(i)

%>
<p>
<hr><p>
<form name="AddItemForm" method="post" autocomplete="off" action="GetInvoice.asp?action=addItem">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<select name="txtServiceID">
<%

For i = 0 To (oNodeList.length - 1)
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)

  Set varServiceID = curitem.selectSingleNode("locSvcKey")
  strServiceID = varServiceID.Text

  Set varServiceName = curitem.selectSingleNode("serviceName")
  strServiceName = varServiceName.Text

  Set varsubtypeName = curitem.selectSingleNode("subtypeName")
  strsubtypeName = varsubtypeName.Text

  Set varPrice = curitem.selectSingleNode("price")
  strPrice = varPrice.Text

  Set varminimumPrice = curitem.selectSingleNode("minimumPrice")
  strMinimumPrice = varminimumPrice.Text

  Set varunitMeasure = curitem.selectSingleNode("unitMeasure")
  strunitMeasure = varunitMeasure.Text

  Set varitem_code = curitem.selectSingleNode("itemCode")
  stritem_code = varitem_code.Text

  Set varFAU = curitem.selectSingleNode("fau")
  strFAU = varFAU.Text

  Set varrequireCustomPrice = curitem.selectSingleNode("requireCustomPrice")
  strrequireCustomPrice = varrequireCustomPrice.Text

'
'  if strServiceID<>"121" AND strServiceID<>"123" then
if left(strServiceName,3)<>"XXX" then
    if strrequireCustomPrice="true" then
      %>
      <option name="txtServiceID" value="<%="T;" & strServiceID & ";" & strPrice & ";" & strMinimumPrice%>"><%=strServiceName & ": " & strsubtypeName%></option>
      <%
    else
      %>
      <option name="txtServiceID" value="<%="F;" & strServiceID & ";" & strPrice & ";" & strMinimumPrice%>"><%=strServiceName & ": " & strsubtypeName & " (" & formatcurrency(strPrice) & ")"%></option>
      <%
    end if

  end if

Next

%>
</select>

Unit Count
<input type="text" name="txtUnitCount">        
Unit Price 
<input type="text" name="txtUnitPrice">        
<input type="hidden" name="txtUCMember" value="<%=strUCMember%>">
<input type="hidden" name="txtOnPremises" value="<%=strOnPremises%>">
<input type="hidden" name="txtLineNum" value="<%=strLineNum%>">
<input type="hidden" name="txtInvoiceNum" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtBillerID" value="<%=strBillerID%>"></br>
<input type="submit" value="Add Line Item">
</form>
</p>
<%
set httpxmllist=nothing
set xmlDocList=nothing
%>
