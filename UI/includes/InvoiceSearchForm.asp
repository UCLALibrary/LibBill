<table>
<tr>
<td valign="top">
<h3>Invoices</h3>
</td>

<td valign="bottom">
<form method="post" autocomplete="off" action="GetInvoice.asp?Search=InvoiceNum">
Enter Invoice Number</br>
<input name="txtInvoiceNum" type="text" length="20" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtUnit" value="<%=strUnit%>">
<input type="hidden" name="txtOperatorID" value="<%=strOperatorID%>">
<input type="submit" value="Search">
</form>
</td>



</tr>
</table>
<hr>
