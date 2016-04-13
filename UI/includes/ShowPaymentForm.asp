<%
if strStatus="Deposit Due" or strStatus="Deposit+Due" then

%>
<table border="1">
<tr>
<td colspan="5"><b>Add Deposit</b></td>
</tr>
<tr>
<td>Amount</td><td>Payment Type</td>
<td>Note</td>
</tr>

<tr>

<form method="post" autocomplete="off" action="GetInvoice.asp?action=addPayment">
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
<option value="5">Dept Recharge</option">
</select>
</td>
<td>
<input type="text" name="txtCheckNote">
</td>
<td align="right"><input type="submit" value="Apply Deposit"></td>
</form>
</tr>

</table>
<%
end if

if strStatus="Final Payment Due" or strStatus="Pending" OR strStatus="Final+Payment+Due" or strStatus="Partially Paid" or strStatus="Partially+Paid" or strStatus="Unpaid" then

%>

<table border="1">
<tr>
<td colspan="3" bgcolor="#00FF00"><b>Add Payment In Full</b></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td>
<td colspan="4" bgcolor="#FF00FF"><b>Add Partial Payment</b></td>
</tr>

<tr>
<td bgcolor="#00FF00">Payment Type</td><td bgcolor="#00FF00">Note</td>
<td bgcolor="#00FF00"></td>
<td></td>
<td bgcolor="#FF00FF">Amount</td>
<td bgcolor="#FF00FF">Payment Type</td>
<td bgcolor="#FF00FF">Note</td>
<td bgcolor="#FF00FF"></td>
</tr>

<tr>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=addPaymentInFull">
<input type="hidden" name="txtInvoiceNum" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtInvoiceTotal" value="<%=strInvoiceTotal%>">
<input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
<input type="hidden" name="txtBalanceDue" value="<%=strBalanceDue%>">
<input type="hidden" name="txtStatusTo" value="Paid">
<input type="hidden" name="txtStatusFrom" value="<%=strStatus%>">

<td bgcolor="#00FF00">
<select name="txtpaymentTypeID">
<option value="1">Cash</option">
<option value="2">Check</option">
<option value="3">Credit Card</option">
<option value="4">Debit Card</option">
<option value="5">Dept Recharge</option">
</select>
</td>
<td bgcolor="#00FF00">
<input type="text" name="txtCheckNote">
</td>
<td align="right" bgcolor="#00FF00"><input type="submit" value="Paid In Full"></td>
</form>
<td>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=addPayment">
<input type="hidden" name="txtInvoiceNum" value="<%=strInvoiceNum%>">
<input type="hidden" name="txtInvoiceTotal" value="<%=strInvoiceTotal%>">
<input type="hidden" name="txtBillerID" value="<%=strBillerID%>">
<input type="hidden" name="txtBalanceDue" value="<%=strBalanceDue%>">
<input type="hidden" name="txtStatusTo" value="Partially+Paid">
<input type="hidden" name="txtStatusFrom" value="<%=strStatus%>">
<input type="hidden" name="txtTotalTax" value="<%=strTotalTax%>">
<td bgcolor="#FF00FF"><input type="text" name="txtAmount">
</td>
<td bgcolor="#FF00FF">
<select name="txtpaymentTypeID">
<option value="1">Cash</option">
<option value="2">Check</option">
<option value="3">Credit Card</option">
<option value="4">Debit Card</option">
</select>
</td>
<td bgcolor="#FF00FF">
<input type="text" name="txtCheckNote">
</td>
<td align="right" bgcolor="#FF00FF"><input type="submit" value="Partial Payment"></td>
</tr>
</table>
</form>
</p>

<%
end if



%>


