<%

  strDate=request("txtDate")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/invoice_by_date/" & strDate
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

    getInvoiceURL=session("strBaseURL")
    getInvoiceURL=getInvoiceURL & "invoices/invoice_by_date/" & strDate

'YYYY-MM-DD format

if not isnumeric(mid(strDate,1,4)) then
  strValidDate="N"
end if
if not isnumeric(mid(strDate,6,2)) then
  strValidDate="N"
end if
if not isnumeric(mid(strDate,9,2)) then
  strValidDate="N"
end if


if mid(strDate,5,1)<>"-" then
  strValidDate="N5"
end if
if mid(strDate,8,1)<>"-" then
  response.write mid(strDate,8,1)
  strValidDate="N8"
end if
if len(trim(strDate))<>10 then
  strValidDate="NL"
end if


'response.write getInvoiceURL
'response.write strValidDate


if left(strValidDate,1)="N" then
  response.write "<p class=ErrorMessage>not a valid date</p>"
else

Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", getInvoiceUrl, false
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

  set xmlDoc = createObject("MSXML2.DOMDocument")
  xmlDoc.async = False
  xmlDoc.setProperty "ServerHTTPRequest", true
 ' xmlDoc.load(getInvoiceURL)
XMLDOC.LOAD(xmlhttp.responsebody)

  set oNodeList=XMLDoc.documentElement.selectNodes("//multipleInvoices/invoice/header") 
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)
  if oNodeList.length=0 then
    response.write "<p class=ErrorMessage>No matching invoices on file...</p>"
  else


    strLineNum=oNodeList.length+1

    %>
    <p>Invoices created on <%=strDate%></p>
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

end if
  end if

%>