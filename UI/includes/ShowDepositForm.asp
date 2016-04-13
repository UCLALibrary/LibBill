
<table border="1">
<tr>
<td colspan="5"><b>Add Deposit</b></td>
</tr>
<tr>
<td>Amount</td><td>Payment Type</td>
<td>Note</td>
</tr>

<tr>

<form method="post" autocomplete="off" action="GetInvoice.asp?action=addDeposit">
<input type="hidden" name="txtInvoiceNum" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtInvoiceTotal" value="<%=strInvoiceTotal%>">
<input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
<input type="hidden" name="txtBalanceDue" value="<%=strBalanceDue%>">
<input type="hidden" name="txtStatusTo" value="Deposit+Paid">
<input type="hidden" name="txtStatusFrom" value="<%=strStatus%>">
<td><input type="text" name="txtAmount">

<td>
<select name="txtpaymentTypeID">
<option value="1">Cash</option">
<option value="2">Check</option">
<option value="3">Credit Card</option">
<option value="4">Debit Card</option">
</select>
</td>
<td>
<input type="text" name="txtCheckNote">
</td>
<td align="right"><input type="submit" value="Apply Deposit"></td>
</form>
</tr>

</table>
