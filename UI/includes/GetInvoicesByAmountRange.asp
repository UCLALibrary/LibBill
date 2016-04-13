<%

strAmount1=request("txtInvoiceAmount1")
strAmount2=request("txtInvoiceAmount2")

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/invoice_by_total_range/lower/" & strAmount1 & "/higher/" & strAmount2
'response.write hashURL
strCryptoKey=session("CryptoKey")
'response.write strCryptoKey
strIDKey=session("IDKey")
'response.write strIDKey
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

getInvoiceURL=session("strBaseURL")
getInvoiceURL=getInvoiceURL & "invoices/invoice_by_total_range/lower/" & strAmount1 & "/higher/" & strAmount2

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
'xmlDoc.load(postURL)
XMLDOC.LOAD(xmlhttp.responsebody)
'response.write getInvoiceURL


  set oNodeList=XMLDoc.documentElement.selectNodes("//multipleInvoices/invoice/header") 
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)
  if oNodeList.length=0 then
    response.write "<p>no invoices on file..."
  else


    strLineNum=oNodeList.length+1

    %>
    <p>Invoices with total between $<%=strAmount1%> and $<%=strAmount2%></p>
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

%>
