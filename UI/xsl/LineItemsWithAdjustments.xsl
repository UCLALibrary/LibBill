<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">

<table border="1"><tr><td>
<font color="green">Line Items</font>
<table border="0" cellpadding="0" width="950">
  <tr bgcolor="#EEEEEE">
    <td>Line number</td> 
    <td>Service</td> 
    <td>SubType</td> 
    <td>Unit Price</td> 
    <td>Quantity</td> 
    <td>Total Price</td> 
    <td>Adjust Type</td> 
    <td>Adjust Reason (max 200 characters)</td> 
    <td>Adjust Amount</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="singleInvoice/lineItem">
  <tr>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=addAdjustment">
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
    <select name="txtType">
    <option>DISCOUNT</option>
    <option>CORRECTION</option>
    </select>
    </td>
    <td>
    <input align="right" type="text" name="txtReason"> </input>
    </td>
    <td>
    <input align="right" type="text" name="txtAmount"> </input>
    <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
    <input type="hidden" name="txtLineNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
    <input type="submit" value="add adjustment" />
    </td>
    </form>
  </tr>
  </xsl:for-each>
</table>
</td>
</tr>
</table>





</xsl:template>
</xsl:stylesheet>