<!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
<%

'session("strBaseURL")="https://webservices.library.ucla.edu/invoicing-test/"
'session("strBaseHash")="/invoicing-test/"

'session("strBaseURL")="https://webservices.library.ucla.edu/invoicing-dev/"
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
  session("UserUID")=request("txtUID")
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
        strErrorMessage=strErrorMessage & strUID & "<p class=ErrorMessage>You need an account in the Invoicing system to use this application.  If you have an account, please report the problem to helpdesk@library.ucla.edu.  If you do not have an account but need one, please contact your supervisor, or Library Business Services.</p>"
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
        response.write "<p class=ErrorMessage>No results for that UID number...</p>"
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

        if session("role")="admin" then
          session("UnitCode")="AR"
          %>
          <!-- #INCLUDE virtual="includes/GetVersion.asp" --> 
          <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 
          <%
        else
          'show unit list

          hashURL=session("strBaseHash")
          hashURL=hashURL & "branches/unit_list" 
          strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
          strHash = b64_hmac_sha1(session("CryptoKey"), strAuth)
          strSig=session("IDKey") & ":" & strHash

          postURL=session("strBaseURL")
          postURL=postURL & "branches/unit_list" 
          Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
          xmlhttp.Open "GET", postUrl, false
          xmlhttp.setRequestHeader "Content-Type","application/xml"
          xmlhttp.setRequestHeader "Authorization", strSig
          xmlhttp.send 

          set xmlDoc = createObject("MSXML2.DOMDocument")
          xmlDoc.async = False
          xmlDoc.setProperty "ServerHTTPRequest", true
          XMLDOC.LOAD(xmlhttp.responsebody)
          set oNodeList=XMLDoc.documentElement.selectNodes("//units/unit") 
          Set currNode = oNodeList.nextNode
          Set curitem = oNodeList.Item(i)

          if oNodeList.length=0 then
            response.write "<p class=ErrorMessage>No results for unit list...</p>"
          else
            %>
            <p><b>Select Unit</b></br>
            <form method="post" autocomplete="off">
            <%

            For i = 0 To (oNodeList.length - 1)
              Set currNode = oNodeList.nextNode
              Set curitem = oNodeList.Item(i)

              Set varCode = curitem.selectSingleNode("code")
              strCode = varCode.Text

              Set varName = curitem.selectSingleNode("name")
              strName = varName.Text

if strCode="UA" or strCode="BC" or strCode="OH" then
else
            %>
            <input TYPE="RADIO" NAME="txtUnit" value="<%=strCode%>"><%=strName%></input></br>
            <%
end if

            Next

            %>
            </br><input type="submit" value="Continue">
            </form></p>
            <%
          end if
        end if
      end if

    end if

  else
    if request("txtUnit")="" then
      'response.write "got here"
    else

      if request("txtRole")<>"" then
        session("role")=request("txtRole")
      end if

      'get unit info
      session("unitCode")=request("txtUnit")
    end if
    'show main menu



      %>
      <!-- #INCLUDE virtual="includes/GetVersion.asp" --> 
      <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 
      <%
  end if
end if

%>



...
</body>
</html>