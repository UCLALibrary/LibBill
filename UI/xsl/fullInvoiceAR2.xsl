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

<table border="0" cellpadding="2" bgcolor="#EEEEEE" width="900">
  <tr>
    <td>Invoice</td> 
    <td>Date</td> 
    <td>Taxable</td> 
    <td>Non-Taxable </td> 
    <td>CA Tax </td> 
    <td>L.A. Tax </td> 
    <td>Total </td> 
    <td>Bal. Due </td> 
    <td>Created By</td> 
    <td>Status</td> 
    <td>On Premises </td> 
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
    <b><xsl:value-of select="format-number(stateTax,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(countyTax,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(totalAmount,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(balanceDue,'#,###.00')" /></b>
    </td>
    <td>
    <b><xsl:value-of select="createdBy" /> </b>
    </td>

    <td>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
    <xsl:choose>
      <xsl:when test="status = 'Pending'"><b>Pending</b></xsl:when>
      <xsl:when test="status = 'Unpaid'">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Paid">Paid</option>
          <option value="Partially+Paid">Partially Paid</option>
        </select>
        <input type="submit" value="update " /></xsl:when>
      <xsl:when test="status = 'Partially Paid'"><b>Partially Paid</b>
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Paid">Paid</option>
          <option value="Unpaid">Unpaid</option>
        </select>
        <input type="submit" value="update " /></xsl:when>
      <xsl:when test="status = 'Paid'">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <select name="txtStatus">
          <option><xsl:attribute name="value"> <xsl:value-of select="status" /> </xsl:attribute> <xsl:value-of select="status" /></option>
          <option value="Canceled">Canceled</option>
          <option value="Partially+Paid">Partially Paid</option>
          <option value="Unpaid">Unpaid</option>
        </select>
        <input type="submit" value="update " /></xsl:when>
      <xsl:when test="status = 'Canceled'"><b>Canceled</b></xsl:when>
      <xsl:when test="status = 'Never Issued'"><b>Never Issued</b>
      </xsl:when>
    </xsl:choose>

    </form>

    </td>
    <td>
    <b><xsl:value-of select="onPremises" /> </b>
    </td>
    <td>


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
  <td width="120"></td>
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
<table border="0" cellpadding="0" width="900">
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
<table border="0" cellpadding="0" width="600">
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
<table border="0" cellpadding="0" width="600">
  <tr bgcolor="#EEEEEE">
    <td>Amount</td> 
    <td>Date</td> 
    <td>Type</td> 
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
    <xsl:value-of select="paymentTypeID" /> 
    </td>
    <td>
    <xsl:value-of select="createdBy" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>
</td></tr></table>

<table border="1"><tr><td>
<font color="green">Adjustments</font>
<table border="0" cellpadding="0" width="600">
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



