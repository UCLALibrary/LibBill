<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">


<table border="1" bgcolor="#EEEEEE"><tr><td>
<table border="0" cellpadding="0">
  <xsl:for-each select="singleInvoice/patron">
  <tr>
    <td>
    <b><xsl:value-of select="lastName" />, <xsl:value-of select="firstName" /></b>
    </td>
    <td>
    <xsl:value-of select="barcode" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>

<table border="0" cellpadding="2" bgcolor="#EEEEEE" width="800">
  <tr>
    <td>Invoice</td> 
    <td>Date</td> 
    <td>Taxable</td> 
    <td>Non-Taxable </td> 
    <td>Tax </td> 
    <td>Total </td> 
    <td>Bal. Due </td> 
    <td>Created By</td> 
    <td>On Site </td> 
    <td></td> 
  </tr>
  <xsl:for-each select="singleInvoice/header">
  <tr>
   <td bgcolor="#EEEEEE">
    <b><xsl:value-of select="invoiceNumber" /> </b>
    </td>
    <td>
    <b><xsl:value-of select="invoiceDate" /> </b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(taxableTotal,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(nontaxableTotal,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(totalTax,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(totalAmount,'#,###.00')" /></b>
    </td>
    <td bgcolor="#FFFFFF">$
    <b><font color="red"><xsl:value-of select="format-number(balanceDue,'#,###.00')" /></font></b>
    </td>
    <td>
    <b><xsl:value-of select="createdBy" /> </b>
    </td>

    <td>
    <b><xsl:value-of select="onPremises" /> </b>
    </td>

</tr><tr>

    <td colspan="2">
    <xsl:choose>
      <xsl:when test="status = 'Pending'"><b>Pending</b></xsl:when>
      <xsl:when test="status = 'Deposit Paid'"><b>Deposit Paid</b>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus"><xsl:attribute name="value"> Canceled </xsl:attribute> </input>
        <input type="submit" value="cancel " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Deposit Due'"><b>Deposit Due</b>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus"><xsl:attribute name="value"> Canceled </xsl:attribute> </input>
        <input type="submit" value="cancel " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Final Payment Due'"><b>Final Payment Due</b>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus"><xsl:attribute name="value"> Canceled </xsl:attribute> </input>
        <input type="submit" value="cancel " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Unpaid'"><b>Unpaid</b>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus"><xsl:attribute name="value"> Canceled </xsl:attribute> </input>
        <input type="submit" value="cancel " />
        </form>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Paid">Paid</option>
        </select>
        <input type="submit" value="update " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Partially Paid'"><b>Partially Paid</b>
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Canceled">Canceled</option>
          <option value="Unpaid">Unpaid</option>
          <option value="Deposit+Paid">Deposit Paid</option>
        </select>
        <input type="submit" value="update " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Paid'">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Partially+Paid">Partially Paid</option>
          <option value="Unpaid">Unpaid</option>
          <option value="Canceled">Canceled</option>
        </select>
        <input type="submit" value="update " />
        </form>
      </xsl:when>
      <xsl:when test="status = 'Canceled'"><b>Canceled</b></xsl:when>
      <xsl:when test="status = 'Never Issued'"><b>Never Issued</b>
      </xsl:when>
    </xsl:choose>


</td><td colspan="6">
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=AdjInv">
<select name="txtType">
<option value="CANCEL TAX">Cancel Tax</option>
<option value="REFUND">Refund</option>
<option value="NULLIFY PAYMENT">Nullify Payment</option>
</select>
    <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
    <input type="hidden" name="txtBalanceDue"><xsl:attribute name="value"> <xsl:value-of select="balanceDue" /> </xsl:attribute> </input>
    <input type="hidden" name="txtStatus"><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> </input>
    <input type="submit" value="Adjust" />
(Nullify Payment) Amount: <input type="text" name="txtAmount" />
    </form>

    </td>
  </tr>
  </xsl:for-each>
</table>
</td>
</tr>
</table>


<table border="0" cellpadding="0">
  <xsl:for-each select="singleInvoice/invoiceNote">
  <tr>
  <xsl:choose>
    <xsl:when test="internal = 'true'"><td></td><td valign="top"><font color="red">Internal Note </font></td>
      <td colspan="3" bgcolor="#FFC1C1" valign="top">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateInvoiceNote">
        <textarea name="txtInvoiceNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#FFC1C1">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteInvoiceNote">
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="delete note" />
        </form>
      </td>
    </xsl:when>
    <xsl:when test="internal = 'false'"><td></td><td valign="top"><font color="green">Public Note </font></td>
      <td colspan="3" bgcolor="#9ACD32" valign="top">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateInvoiceNote">
        <textarea name="txtInvoiceNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#9ACD32">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteInvoiceNote">
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="delete note" />
        </form>
      </td>
    </xsl:when>
  </xsl:choose>
  </tr>
  </xsl:for-each>
</table>

<xsl:for-each select="singleInvoice/header">
<table>
  <tr>
  <td>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=AddInvoiceNote">
    <textarea name="txtLineItemNote" cols="70" rows="2">
    </textarea>
    <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
    <select name="txtInternal">
    <option value="false">Public</option>
    <option value="true">Internal</option>
    </select>
    <input type="submit" value="add note" />
    </form>
</td>
  </tr>
</table>
</xsl:for-each>





<table border="1"><tr><td>
<font color="green">Line Items</font>
<table border="0" cellpadding="0" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Line number</td> 
    <td>Service</td> 
    <td>SubType</td> 
    <td>Unit Price</td> 
    <td>Quantity</td> 
    <td>Total</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="singleInvoice/lineItem">
  <tr>
    <td>
    <xsl:value-of select="lineNumber" /> 
    </td>
    <td>
    <xsl:value-of select="service" /> 
    </td>
    <td>
    <xsl:value-of select="serviceSubtype" /> 
    </td>
    <td>
    $<xsl:value-of select="format-number(unitPrice,'#,###.00')" />
    </td>
    <td>
    <xsl:value-of select="quantity" /> 
    </td>
    <td>
    $<xsl:value-of select="format-number(totalPrice,'#,###.00')" />
    </td>
    <td>
    </td>
  </tr>
  </xsl:for-each>
</table>
</td></tr></table>


<table border="1"><tr><td>
<font color="green">Line Item Adjustments</font>
<table border="0" cellpadding="0" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Line Number</td> 
    <td>Amount</td> 
    <td>Date</td> 
    <td>Type</td> 
    <td>Reason</td> 
    <td>By</td> 
  </tr>
  <xsl:for-each select="singleInvoice/lineAdjustment">
  <tr>
    <td>
    <xsl:value-of select="lineNumber" /> 
    </td>
    <td>$
    <xsl:value-of select="format-number(amount,'#,###.00')" />
    </td>
    <td>
    <xsl:value-of select="createdDate" /> 
    </td>
    <td>
    <xsl:value-of select="adjustmentType" /> 
    </td>
    <td>
    <xsl:value-of select="adjustmentReason" /> 
    </td>
    <td>
    <xsl:value-of select="createdBy" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>
</td></tr></table>

<table border="1"><tr><td>
<font color="green">Payments</font>
<table border="0" cellpadding="0" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Amount</td> 
    <td>Date</td> 
    <td>Type</td> 
    <td>Check Note</td> 
    <td>By</td> 
  </tr>
  <xsl:for-each select="singleInvoice/payment">
  <tr>
    <td>$
    <xsl:value-of select="format-number(amount,'#,###.00')" />
    </td>
    <td>
    <xsl:value-of select="paymentDate" /> 
    </td>
    <td>
    <xsl:choose>
      <xsl:when test="paymentTypeID = '1'"><b>Cash</b></xsl:when>
      <xsl:when test="paymentTypeID = '2'"><b>Check</b></xsl:when>
      <xsl:when test="paymentTypeID = '3'"><b>Credit</b></xsl:when>
      <xsl:when test="paymentTypeID = '4'"><b>Debit</b></xsl:when>
      <xsl:when test="paymentTypeID = '5'"><b>Dept Recharge</b></xsl:when>
    </xsl:choose>
    </td>
    <td>
    <xsl:value-of select="checkNote" /> 
    </td>
    <td>
    <xsl:value-of select="createdBy" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>
</td></tr></table>

<table border="1"><tr><td>
<font color="green">Invoice Level Adjustments</font>
<table border="0" cellpadding="0" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Amount</td> 
    <td>Type</td> 
    <td>Reason</td> 
    <td>By</td> 
  </tr>
  <xsl:for-each select="singleInvoice/invoiceAdjustment">
  <tr>
    <td>$
    <xsl:value-of select="format-number(adjustmentAmount,'#,###.00')" />
    </td>
    <td>
    <xsl:value-of select="adjustmentType" /> 
    </td>
    <td>
    <xsl:value-of select="adjustmentReason" /> 
    </td>
    <td>
    <xsl:value-of select="createdBy" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>


</td></tr></table>
</xsl:template>
</xsl:stylesheet>



