<html>
<head>
<script language="javascript"
  type="text/javascript">

<!-- hide script from older browsers
function validateForm(AddItemForm)
{

if(""==document.forms.AddItemForm.txtUnitCount.value)
{
alert("Please enter a quantity.");
return false;
}


}
 stop hiding script -->
</script>

</head>
<body>

<!-- #INCLUDE virtual="includes/TopOnly.asp" -->

<!begin main content>

<%


if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #INCLUDE virtual="includes/MainMenu.asp" -->
  <%

  %>
  <!-- #INCLUDE virtual="includes/Functions.asp" -->
  <%
'  dim vArrPassThrough(10)
  dim strBillerID
  strBillerID=session("userName")

  strUnit=session("Unit")
  strUnitCode=session("UnitCode")

  strPatronID=request("txtID")
  strInvoiceNum=ucase(request("txtInvoiceNum"))

  strAction=request("action")

  strOnPremises=request("txtOnPremises")
  strZipCode=request("txtZipCode")

  strDate=request("txtDate")
  strInvoiceAmount=request("txtInvoiceAmount")
  strLineNote=request("txtLineNote")
  strInvoiceNote=request("txtInvoiceNote")
  strDateRange1=request("txtDateRange1")
  strDateRange2=request("txtDateRange2")
  strInvoiceAmount1=request("txtInvoiceAmount1")
  strInvoiceAmount2=request("txtInvoiceAmount2")

  select case strAction
    case "MailPDF"
      %>
      <!-- #INCLUDE virtual="includes/MailPDF.asp" -->
      <%
    case "addInvoice"
      %>
      <!-- #INCLUDE virtual="includes/PutInvoiceHeader.asp" -->
      <%
    case "addDeposit"
      %>
      <!-- #INCLUDE virtual="includes/AddDeposit.asp" -->
      <%
    case "addPayment"
      %>
      <!-- #INCLUDE virtual="includes/AddPayment.asp" -->
      <%
    case "addPaymentInFull"
      %>
      <!-- #INCLUDE virtual="includes/AddPaymentInFull.asp" -->
      <%
    case "updateItem"
      %>
      <!-- #INCLUDE virtual="includes/updateItem.asp" -->
      <%
    case "updateInvoice"
      %>
      <!-- #INCLUDE virtual="includes/UpdateInvoice.asp" -->
      <%
    case "addItem"
      %>
      <!-- #INCLUDE virtual="includes/AddItem.asp" -->
      <%
    case "DeleteLineItem"
      %>
      <!-- #INCLUDE virtual="includes/DeleteLineItem.asp" -->
      <%
    case "UpdateLineItemNote"
      %>
      <!-- #INCLUDE virtual="includes/UpdateLineItemNote.asp" -->
      <%
    case "DeleteLineItemNote"
      %>
      <!-- #INCLUDE virtual="includes/DeleteLineItemNote.asp" -->
      <%
    case "AddLineItemNote"
      %>
      <!-- #INCLUDE virtual="includes/AddItemNote.asp" -->
      <%
    case "UpdateInvoiceNote"
      %>
      <!-- #INCLUDE virtual="includes/UpdateInvoiceNote.asp" -->
      <%
    case "DeleteInvoiceNote"
      %>
      <!-- #INCLUDE virtual="includes/DeleteInvoiceNote.asp" -->
      <%
    case "AddInvoiceNote"
      %>
      <!-- #INCLUDE virtual="includes/AddInvoiceNote.asp" -->
      <%
    case "addAdjustment"
      %>
      <!-- #INCLUDE virtual="includes/AddAdjustment.asp" -->
      <%
    case "AdjInv"
      %>
      <!-- #INCLUDE virtual="includes/adjustInvoice.asp" -->
      <%
  end select


  if request("Search")="InvoiceNum" or request("Search")="" then
    %>
    <!-- #INCLUDE virtual="includes/InvoiceSearchForm.asp" -->
    <%
  else
    %>
    <!-- #INCLUDE virtual="includes/InvoiceSearchFormAdvanced.asp" -->
    <%
  end if


  if request("action")<>"" then
    if strInvoiceNum<>"" and len(trim(strInvoiceNum))<>8 then

      response.write "<p class=ErrorMessage>Invoice Numbers must be 8 characters long...</p>"
    else
      if strInvoiceNum="" then
        else
        %>
        <!-- #INCLUDE virtual="includes/GetInvoiceXML.asp" -->
        <%
      end if
    end if
    set xmlDoc=nothing
  end if

  if request("Search")="InvoiceNum" then
    if strInvoiceNum<>"" and len(trim(strInvoiceNum))<>8 then

      response.write "<p class=ErrorMessage>Invoice Numbers must be 8 characters long...</p>"
    else
      if strInvoiceNum="" then
        else
        %>
        <!-- #INCLUDE virtual="includes/GetInvoiceXML.asp" -->
        <%
      end if
    end if
    set xmlDoc=nothing
  end if

  if request("Search")="InvoiceAmount" then
    strInvoiceAmount=request("txtInvoiceAmount")
    'response.write "number"
    if strInvoiceAmount<>"" and isnumeric(strInvoiceAmount) then
      'response.write "amount search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByAmount.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>Amount must be a number...</p>"
    end if
  end if

  if request("Search")="InvoiceAmountRange" then
    strInvoiceAmount1=request("txtInvoiceAmount1")
    strInvoiceAmount2=request("txtInvoiceAmount2")
    'response.write "number"
    if strInvoiceAmount1<>"" and strInvoiceAmount2<>"" and isnumeric(strInvoiceAmount1) and isnumeric(strInvoiceAmount2) then
      'response.write "amount search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByAmountRange.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>Amount must be a number...</p>"
    end if
  end if

  if request("Search")="InvoiceNote" then
    strInvoiceNote=request("txtInvoiceNote")
    'response.write "note"
    if strInvoiceNote<>"" then
      'response.write "invoice note search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByNote.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>The note string was empty...</p>"
    end if
  end if

  if request("Search")="LineNote" then
    strLineNote=request("txtLineNote")
    'response.write "note"
    if strLineNote<>"" then
      'response.write "line note search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByLineNote.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>The note string was empty...</p>"
    end if
  end if

  if request("Search")="InvoiceDate" then
    strDate=request("txtDate")
    'response.write "date"
    if strDate<>"" then
      'response.write "invoice date note search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByDate.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>The date string was empty...</p>"
    end if
  end if

  if request("Search")="InvoiceDateRange" then
    strDateRange1=request("txtDateRange1")
    strDateRange2=request("txtDateRange2")
    'response.write "date"
    if strDate<>"" or strDate2="" then
      'response.write "invoice date note search..."
        %>
        <!-- #INCLUDE virtual="includes/GetInvoicesByDateRange.asp" -->
        <%
    else
      response.write "<p class=ErrorMessage>The date string was empty...</p>"
    end if
  end if
    set xmlDoc=nothing





else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" -->
  <%
end if


%>

</body>
</html>
