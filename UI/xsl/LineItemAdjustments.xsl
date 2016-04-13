<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">




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


</xsl:template>
</xsl:stylesheet>