<!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
<%

'session("strBaseURL")="https://webservices.library.ucla.edu/invoicing-test/"
'session("strBaseHash")="/invoicing-test/"

'session("strBaseURL")="http://webservices.library.ucla.edu/invoicing-dev/"
'session("strBaseHash")="/invoicing-dev/"

session("strBaseURL")="https://webservices.library.ucla.edu/invoicing/"
session("strBaseHash")="/invoicing/"

'refuse access (have no userUID; shib problem or timed out
'or get shib info, and show select unit form (got userUID and no name; authenticated, not logged in)
'or show main menu (aready have userUID and name; authenticated and logged in)


if session("UserUID")="" then
  session("UserUID") = Request.ServerVariables("HTTP_SHIBUCLAUNIVERSITYID")
end if

if session("UserUID")="" then
  'refuse access (timed out or shib problem)
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
else
  %>
  <!-- #INCLUDE virtual="includes/AppData.asp" --> 
  <!-- #include file = "includes/hex_sha1_js.asp" -->
  <%

  if session("UserName")="" then

    strUID=session("UserUID")

    'strUID="702759586"
    'session("userUID")=strUID

    'get info w/ ID and ws

    hashURL=session("strBaseHash")
    hashURL=hashURL & "users/user_info/" 
    hashURL=hashURL & strUID

    strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
    strHash = b64_hmac_sha1(VACryptoKey, strAuth)
    strSig=VAIDKey & ":" & strHash

    postURL=session("strBaseURL")
    postURL=postURL & "users/user_info/" 
    postURL=postURL & strUID

    Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
    xmlhttp.Open "GET", postUrl, false
    xmlhttp.setRequestHeader "Content-Type","application/xml"
    xmlhttp.setRequestHeader "Authorization", strSig
    xmlhttp.send 
    'Response.write "<p>" & xmlhttp.responsetext

    if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
      'response.write "<p>Got user info:</p>"
    else
      strGo="No"
      if xmlhttp.status=500 then
        strErrorMessage="<p><table width=500><tr><td>"
        strErrorMessage=strErrorMessage & "You need an account in the Invoicing system to use this application.  If you have an account, please report the problem to helpdesk@library.ucla.edu.  If you do not have an account but need one, please contact your supervisor, or Library Business Services."
        strErrorMessage=strErrorMessage & "</td></tr></table></p>"
        response.write strErrorMessage
      else
        response.write "<p>" & xmlhttp.status
        strError=xmlhttp.responsetext
        response.write "<p>Status: " & strError & "</p>"
      end if
    end if


    if strGo<>"No" then

      'set xmlhttp=nothing

      'response.write postURL

      set xmlDoc = createObject("MSXML2.DOMDocument")
      xmlDoc.async = False
      xmlDoc.setProperty "ServerHTTPRequest", true
      XMLDOC.LOAD(xmlhttp.responsebody)
      set oNodeList=XMLDoc.GetElementsByTagName("user")
      Set currNode = oNodeList.nextNode
      Set curitem = oNodeList.Item(i)

      if oNodeList.length=0 then
        response.write "<p>no results for that UID number...</p>"
      else

        if oNodeList.length=1 then

          Set varUserName = curitem.selectSingleNode("userName")
          strUserName = varUserName.Text
          Set varIDKey = curitem.selectSingleNode("idKey")
          strIDKey = varIDKey.Text
          Set varCryptoKey = curitem.selectSingleNode("cryptoKey")
          strCryptoKey = varCryptoKey.Text
          Set varRole = curitem.selectSingleNode("role")
          strRole = varRole.Text
 
          session("userName")=strUserName
          session("IDKey")=strIDKey
          session("CryptoKey")=strCryptoKey
          session("Role")=strRole
        end if

        'show select unit form
        %>
        <!-- #INCLUDE virtual="includes/SelectUnit.asp" --> 
        <%
      end if

    end if

  else
    if request("txtUnit")="" then
      'response.write "got here"
    else

      if request("txtRole")<>"" then
        'response.write "got here"
        session("role")=request("txtRole")
      end if

      'get unit info
      session("unit")=request("txtUnit")
      select case trim(session("unit"))
        case "Accounts+Receivable"
          session("UnitCode")="AR"
        case "Orion+Express"
          session("UnitCode")="OE"
        case "InterLibrary+Loans"
          session("UnitCode")="IL"
        case "Special+Collections"
          session("UnitCode")="SC"
        case "Biomedical+Library+History+And+Special+Collections"
          session("UnitCode")="BC"
        case "Maps"
          session("UnitCode")="MP"
        case "University+Archives"
          session("UnitCode")="UA"
        case "Performing+Arts+Special+Collections"
          session("UnitCode")="PA"
        case "Library+Business+Services"
          session("UnitCode")="LB"
        case "Digital+Collections+Services"
          session("UnitCode")="DC"
        case "Oral+History"
          session("UnitCode")="OH"
        case "Southern+Library+Regional+Facility"
          session("UnitCode")="SR"
      end select
      'response.write "unit code: " & session("UnitCode")
    end if
    'show main menu
      %>
      <!-- #INCLUDE virtual="includes/GetVersion.asp" --> 
      <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 
<%
  end if
end if

%>




</body>
</html>