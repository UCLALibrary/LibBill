<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1"><tr><td>
<font color="green">Invoice Adjustments</font>
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


