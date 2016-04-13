<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <xsl:for-each select="paymentTypes">
  <tr>
    <td valign="top">
    <xsl:value-of select="paymentType" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="paymentType_ID" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



