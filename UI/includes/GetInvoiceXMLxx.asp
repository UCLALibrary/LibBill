
<!-- #include virtual = "/includes/hex_sha1_js.asp" -->



<%

hashURL=session("strBaseHash")
hashURL=hashURL & "invoices/invoice_by_number/" & strInvoiceNum    

strCryptoKey=session("CryptoKey")
strIDKey=session("IDKey")
strAuth= "GET" & Chr(10) & hashURL & Chr(10) & "-30-"
strHash = b64_hmac_sha1(strCryptoKey, strAuth)
strSig=strIDKey & ":" & strHash

postURL=session("strBaseURL")
postURL=postURL & "invoices/invoice_by_number/" & strInvoiceNum    


Set xmlhttp = server.Createobject("MSXML2.XMLHTTP")
xmlhttp.Open "GET", postUrl, false
xmlhttp.setRequestHeader "Content-Type","application/xml"
xmlhttp.setRequestHeader "Authorization", strSig
xmlhttp.send 
'Response.write "<p>" & xmlhttp.responsetext
if (xmlhttp.status >= 200) and (xmlhttp.status < 300) then
  'response.write "<p>Got user info:</p>"
else
  if xmlhttp.status=500 then
  else
    response.write "<p>" & xmlhttp.status
    strError=xmlhttp.responsetext
    response.write "<p>Status: " & strError & "</p>"
  end if
end if


set xmlDoc = createObject("MSXML2.DOMDocument")
xmlDoc.async = False
xmlDoc.setProperty "ServerHTTPRequest", true
'xmlDoc.load(postURL)
XMLDOC.LOAD(xmlhttp.responsebody)

if xmlDoc.parseError.errorCode <> 0 Then
  if xmlDoc.parseError.errorCode="-2146697208" then
    response.write "<p class=ErrorMessage>No results on that invoice number...(-214...)</p>"
  else
    if xmlDoc.parseError.errorCode="500" then
      response.write "<p class=ErrorMessage>No results on that invoice number...</p>"
    else
      response.write "<p class=ErrorMessage>No results on that invoice number...</p>"
    end if
  end if
else

  set oNodeList=XMLDoc.documentElement.selectNodes("//singleInvoice/header") 
  Set currNode = oNodeList.nextNode
  Set curitem = oNodeList.Item(i)

  if oNodeList.length=0 then
    response.write "<p class=ErrorMessage>No results on that invoice number search...</p>"
  else

    Set varInvoiceStatus = curitem.selectSingleNode("status")
    strStatus = varInvoiceStatus.Text
    strStatus=replace(strStatus," ","+")

    Set varInvoiceTotal = curitem.selectSingleNode("totalAmount")
    strInvoiceTotal = varInvoiceTotal.Text

    Set varInvoiceDate = curitem.selectSingleNode("invoiceDate")
    strInvoiceDate = varInvoiceDate.Text

    Set varOnPremises = curitem.selectSingleNode("onPremises")
    strOnPremises = varOnPremises.Text

    Set varBalanceDue = curitem.selectSingleNode("balanceDue")
    strBalanceDue = varBalanceDue.Text

    Set varTotalTax = curitem.selectSingleNode("totalTax")
    strTotalTax = varTotalTax.Text

    set oNodeList=XMLDoc.documentElement.selectNodes("//singleInvoice/invoiceAdjustment") 
    Set currNode = oNodeList.nextNode
    Set curitem = oNodeList.Item(i)

    if oNodeList.length=0 then'
      strShowRemoveTax="Yes"
      'response.write "<p class=ErrorMessage>No results on that invoice number search...</p>"
    else
      strShowRemoveTax="No"
    end if

    set oNodeList=XMLDoc.documentElement.selectNodes("//singleInvoice/lineItem") 
    Set currNode = oNodeList.nextNode
    Set curitem = oNodeList.Item(i)

    if oNodeList.length=0 then'
      strHasLineItem="No"
    else
      strHasLineItem="Yes"
      Set varitemCode = curitem.selectSingleNode("itemCode")
      stritemCode = varitemCode.Text
    end if

'response.write "Code: " & stritemCode

    set oNodeList=XMLDoc.documentElement.selectNodes("//singleInvoice/patron") 
    Set currNode = oNodeList.nextNode
    Set curitem = oNodeList.Item(i)

    Set varUCMember = curitem.selectSingleNode("ucMember")
    strUCMember = varUCMember.Text

    Set varUCMember = curitem.selectSingleNode("ucMember")
    strUCMember = varUCMember.Text

    Set varPatronID = curitem.selectSingleNode("patronID")
    strPatronID = varPatronID.Text

    select case left(strInvoiceNum,2)
      case "SC"
        strUnitEmailAddress="rmontoya@library.ucla.edu"
        strUnitEmailCC="wongbat@library.ucla.edu; bforlivas@library.ucla.edu"
      case "PA"
        strUnitEmailAddress="jgraham@library.ucla.edu"
        strUnitEmailCC="rmontoya@library.ucla.edu; bforlivas@library.ucla.edu"
      case "UA"
        strUnitEmailAddress="cbbrown@library.ucla.edu@library.ucla.edu"
        strUnitEmailCC="rmontoya@library.ucla.edu; bforlivas@library.ucla.edu"
      case "BC"
        strUnitEmailAddress="tgj@library.ucla.edu"
        strUnitEmailCC="rmontoya@library.ucla.edu; bforlivas@library.ucla.edu"
      case "OH"
        strUnitEmailAddress="astevens@library.ucla.edu"
        strUnitEmailCC="rmontoya@library.ucla.edu; bforlivas@library.ucla.edu"
      case "SR"
        strUnitEmailAddress="cbar@library.ucla.edu"
        'strUnitEmailCC="wongbat@library.ucla.edu; bforlivas@library.ucla.edu"
      case "LI"
        strUnitEmailAddress="cnishiji@library.ucla.edu"
        'strUnitEmailCC="wongbat@library.ucla.edu; bforlivas@library.ucla.edu"
      case "MP"
        strUnitEmailAddress="majankowska@library.ucla.edu"
        'strUnitEmailCC="wongbat@library.ucla.edu; bforlivas@library.ucla.edu"
      case else
        strUnitEmailAddress="rmontoya@library.ucla.edu"
        strUnitEmailCC="wongbat@library.ucla.edu; bforlivas@library.ucla.edu"
    end select

    strUnitEmailSubject="PAID: " & strInvoiceNum
    strUnitEmailBody="Invoice Paid."
    strMailTo=strUnitEmailAddress 

    if strUnitEmailCC<>"" then
      strMailTo=strMailTo & "?CC=" & strUnitEmailCC 
    end if

    strMailTo=strMailTo & "&body=" & strUnitEmailBody
    strMailTo=strMailTo & "&subject=" & strUnitEmailSubject

    strURLtoEmailPDF=session("strBaseURL")
    strURLtoEmailPDF=strURLtoEmailPDF & "invoices/mail_invoice/" & strInvoiceNum

    %>
    <p>
    <a href="View_PDF.asp?Num=<%=strInvoiceNum%>" target="_blank">View PDF</a> 
    <%
    if session("role")="payment_processor" or session("role")="payment_approver" then
      %>
      / <a href="mailto:<%=strMailTo%>">Send Payment Confirmation Email To Unit</a>
      <%
    else
    end if
    %>

    <p>
    <%

    select case session("role")
      case "admin"
        loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceAdmin.xsl") 'header
        loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/lineitemadjustments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/payments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/adjustments.xsl")
      case "invoice_preparer"
        loadXMLFile xmldoc, server.MapPath("xsl/fullInvoicePreparer.xsl") 'header
        if strStatus="Pending" OR strStatus="Deposit+Paid" then
          %>
          <!-- #INCLUDE virtual="/includes/AddLineItemForm.asp" --> 
          <%
          loadXMLFile xmldoc, server.MapPath("xsl/LineItemsWithUpdate.xsl")
        else
          loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
        end if
        loadXMLFile xmldoc, server.MapPath("xsl/lineitemadjustments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/payments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/adjustments.xsl")
      case "invoice_prep_app"
        loadXMLFile xmldoc, server.MapPath("xsl/fullInvoicePrepApp.xsl") 'header
        if strStatus="Pending" OR strStatus="Deposit Paid" OR strStatus="Deposit+Paid" then
          %>
          <!-- #INCLUDE virtual="/includes/AddLineItemForm.asp" --> 
          <%
          loadXMLFile xmldoc, server.MapPath("xsl/LineItemsWithUpdate.xsl")
        else
          if strStatus="Unpaid" OR strStatus="Final+Payment+Due" OR strStatus="Final Payment Due" then
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItemsWithAdjustments.xsl")
          else          
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          end if
        end if
        loadXMLFile xmldoc, server.MapPath("xsl/lineitemadjustments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/payments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/adjustments.xsl")
      case "invoice_approver"

        select case strStatus
          case "Final+Payment+Due"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItemsWithAdjustments.xsl")
          case "Final Payment Due"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Deposit+Paid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Deposit Paid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Deposit+Due"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Deposit Due"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Pending"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Paid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Unpaid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItemsWithAdjustments.xsl")
          case "Canceled"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Never+Issued"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Never Issued"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Partially Paid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case "Partially+Paid"
            loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceApprover.xsl") 'header
            loadXMLFile xmldoc, server.MapPath("xsl/LineItems.xsl")
          case else
            response.write "trouble with status: " & strStatus
        end select
        loadXMLFile xmldoc, server.MapPath("xsl/lineitemadjustments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/payments.xsl")
        loadXMLFile xmldoc, server.MapPath("xsl/adjustments.xsl")

      case "payment_processor"
        select case strStatus
          case "Canceled"
          case "Deposit+Due"
            %>

            <!-- #INCLUDE virtual="includes/ShowDepositForm.asp" --> 
            <%
          case else
            %>

            <!-- #INCLUDE virtual="includes/ShowPaymentForm.asp" --> 
            <%
        end select

          loadXMLFile xmldoc, server.MapPath("xsl/fullInvoicePP.xsl")

      case "payment_approver"
           %>

            <!-- #INCLUDE virtual="includes/ShowPaymentForm.asp" --> 
            <%
        loadXMLFile xmldoc, server.MapPath("xsl/fullInvoiceAR.xsl")
      case else
    end select
    %>
    </p>
    <%
  end if
end if

set xmlDoc=nothing
set xmlhttp=nothing

%>









