<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">

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
    <xsl:choose>
      <xsl:when test="paymentTypeID = '1'">Cash
      </xsl:when>

      <xsl:when test="paymentTypeID = '2'">Check
      </xsl:when>
      <xsl:when test="paymentTypeID = '3'">Credit Card
      </xsl:when>
      <xsl:when test="paymentTypeID = '4'">Debit Card
      </xsl:when>
      <xsl:when test="paymentTypeID = '5'">Dept Recharge
      </xsl:when>
    </xsl:choose>
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