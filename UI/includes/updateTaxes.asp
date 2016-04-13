<%

strRateName=request("txtRateName")
strRate=request("txtRate")
strStartMonth=request("txtStartMonth")
strStartDay=request("txtStartDay")
strStartYear=request("txtStartYear")
strEndMonth=request("txtEndMonth")
strEndDay=request("txtEndDay")
strEndYear=request("txtEndYear")

response.write "txtRateName: " & strRateName

if len(trim(strStartDay))=1 then strStartDay="0" & strStartDay
if len(trim(strEndDay))=1 then strEndDay="0" & strEndDay


select case strStartMonth
  case "02"
    if strStartYear="2012" or strStartYear="2016" or strStartYear="2020" then
      if strStartDay="30" or strStartDay="31" then strStartDay="29"
    else
      if strStartDay="29" or strStartDay="30" or strStartDay="31" then strStartDay="28"
    end if
  case "04"
    if strStartDay="31" then strStartDay="30"
  case "06"
    if strStartDay="31" then strStartDay="30"
  case "09"
    if strStartDay="31" then strStartDay="30"
  case "11"
    if strStartDay="31" then strStartDay="30"
end select
strStartDate=strStartMonth & "/" & strStartDay & "/" & strStartYear

select case strEndMonth
  case "02"
    if strEndYear="2012" or strEndYear="2016" or strEndYear="2020" then
      if strEndDay="30" or strEndDay="31" then strEndDay="29"
    else
      if strEndDay="29" or strEndDay="30" or strEndDay="31" then strEndDay="28"
    end if
  case "04"
    if strEndDay="31" then strEndDay="30"
  case "06"
    if strEndDay="31" then strEndDay="30"
  case "09"
    if strEndDay="31" then strEndDay="30"
  case "11"
    if strEndDay="31" then strEndDay="30"
end select
strEndDate=strEndMonth & "/" & strEndDay & "/" & strEndYear

strWhoBy=session("UserName")
strID=request("txtID")
strGo="Yes"

strInput="<taxRate>"
strInput=strInput & "<rateID>" & strID & "</rateID>"
strInput=strInput & "<rate>" & strrate & "</rate>"
strInput=strInput & "<rateName>" & strrateName & "</rateName>"
strInput=strInput & "<startDate>" & strstartDate & "</startDate>"
strInput=strInput & "<endDate>" & strendDate & "</endDate>"
strInput=strInput & "<whoBy>" & strWhoBy & "</whoBy>"
strInput=strInput & "</taxRate>"


if len(trim(strrateName))<2  then
  strGo="No"
  strmessage= "name must be at least two characters " 
end if

if not isnumeric(strRate) then
  strGo="No"
  strMessage= "Rate must be a number " 
end if

response.write strInput

if strGo<>"No" then

  hashURL=session("strBaseHash")
  hashURL=hashURL & "taxes/edit_tax"
'response.write hashURL
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "PUT" & Chr(10) & hashURL & Chr(10) & strInput & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "taxes/edit_tax"

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "PUT", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send strInput
  strInvoiceNum=xmlhttp.responsetext
  strInvoiceNumber=xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    response.write "<p class=GenericMessage>Tax rate updated:</p>"
  else
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  set xmlhttp=nothing
else
  response.write "<p class=ErrorMessage>" & strMessage
end if

%>
