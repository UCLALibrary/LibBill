<table>
<tr>
<td valign="top">
<h3>Invoices</h3>
</td>

<td valign="top">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceNum">
Invoice Number</br>
<input name="txtInvoiceNum" type="text" length="20" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>


<td valign="bottom">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceAmount">
Invoice Amount</br>
<input name="txtInvoiceAmount" type="text" length="20" value="<%=strInvoiceAmount%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceAmountRange">
Invoice Amount Range</br>
From&nbsp;<input name="txtInvoiceAmount1" type="text" length="20" value="<%=strInvoiceAmount1%>">
To&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="txtInvoiceAmount2" type="text" length="20" value="<%=strInvoiceAmount2%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>

<td valign="top">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceNote">
Invoice Note String</br>
<input name="txtInvoiceNote" type="text" length="20" value="<%=strInvoiceNote%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>

<td valign="top">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=LineNote">
Line Item Note String</br>
<input name="txtLineNote" type="text" length="20" value="<%=strLineNote%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>

<td valign="top">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceDate">
Date (YYYY-MM-DD)</br>
<input name="txtDate" type="text" length="20" value="<%=strDate%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceDateRange">
Date Range (YYYY-MM-DD)</br>
From&nbsp;<input name="txtDateRange1" type="text" length="20" value="<%=strDateRange1%>">
To&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="txtDateRange2" type="text" length="20" value="<%=strDateRange2%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>

</tr>
</table>
<hr>
