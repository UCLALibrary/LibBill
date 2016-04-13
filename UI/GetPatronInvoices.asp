<!-- #INCLUDE virtual="includes/TopOnly.asp" --> 

<!begin main content>

<%
if session("userName")="" then
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
else
  %>
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 
  <%

  strNameLast=request.form("txtNameLast")
  strNameFirst=request.form("txtNameFirst")

  strPatronID=request("txtID")

  if request.querystring("PatronID")<>"" then strPatronID=request.querystring("PatronID")
  if request.querystring("nameLast")<>"" then strNameLast=request.querystring("nameLast")

  %>
    <!-- #include file = "includes/hex_sha1_js.asp" -->
  <%
hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/invoice_by_patron/" & strPatronID

'  hashURL="/invoicing-test/invoices/invoice_by_patron/" & strPatronID
  strCryptoKey=session("CryptoKey")
  strIDKey=session("IDKey")
  strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
  strHash = b64_hmac_sha1(strCryptoKey, strAuth)
  strSig=strIDKey & ":" & strHash

  postURL=session("strBaseURL")
  postURL=postURL & "invoices/invoice_by_patron/" & strPatronID  

  Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
  xmlhttp.Open "GET", postUrl, false
  xmlhttp.setRequestHeader "Content-Type","application/xml"
  xmlhttp.setRequestHeader "Authorization", strSig
  xmlhttp.send 
  'Response.write "<p>" & xmlhttp.responsetext
  if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
    'response.write "<p>Got user info:</p>"
  else
    response.write "<p>" & xmlhttp.status
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
  getInvoiceURL=session("strBaseURL")
  getInvoiceURL=getInvoiceURL & "invoices/invoice_by_patron/" & strPatronID  

  set xmlDoc = createObject("MSXML2.DOMDocument")
  xmlDoc.async = False
  xmlDoc.setProperty "ServerHTTPRequest", true
  XMLDOC.LOAD(xmlhttp.responsebody)

  set oNodeList=XMLDoc.documentElement.selectNodes("//multipleInvoices/invoice/header") 
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)
  if oNodeList.length=0 then
    response.write "<p class=ErrorMessage>No invoices on file...</p>"
  else


    'strLineNum=oNodeList.length+1

    %>
    <p>Invoices for <%=trim(strNameLast) & ", " & strNameFirst%></p>
    <p><table>
    <tr>
    <td bgcolor="#EEEEEE">Invoice Number</td>
    <td bgcolor="#EEEEEE">Date</td>
    <td bgcolor="#EEEEEE">Amount</td>
    <td bgcolor="#EEEEEE">Status</td>
    <td>&nbsp;</td>
    </tr>
    <%
    For i = 0 To (oNodeList.length - 1)
      Set currNode = oNodeList.nextNode
      Set curitem = oNodeList.Item(i)

      Set varinvoiceNumber = curitem.selectSingleNode("invoiceNumber")
      strinvoiceNumber = varinvoiceNumber.Text

      Set varinvoiceDate = curitem.selectSingleNode("invoiceDate")
      strinvoiceDate = varinvoiceDate.Text

      Set vartotalAmount = curitem.selectSingleNode("totalAmount")
      strtotalAmount = vartotalAmount.Text

      Set varstatus = curitem.selectSingleNode("status")
      strstatus = varstatus.Text

      %>
      <tr>
      <td valign="top"><%=strinvoiceNumber%></td>
      <td valign="top"><%=strinvoiceDate%></td>
      <td valign="top" align="right"><%=formatcurrency(strtotalAmount)%></td>
      <td valign="top" align="right"><%=strStatus%></td>
      <td align="right">
      <form method="post" action="GetInvoice.asp?Search=InvoiceNum">
      <input type="hidden" name="txtinvoicenum" value="<%=strInvoiceNumber%>">
      <input type="submit" value="Details">
      </form>
      </td>
      <tr>
      <%
    Next
    %>
    </table>
    </p>
    <%

    set xmlDoc=nothing
    set xmlhttp=nothing
  end if
end if 'LOGGED IN
%>
</body>
</html>