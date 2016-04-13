<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2">
  <tr>
    <th></th> 
    <th>Barcode</th> 
    <th>Last Name</th> 
    <th>First Name</th> 
    <th>UC Rate</th> 
    <th>email</th> 
  </tr>
  <xsl:for-each select="patronList/patron">
  <tr>
    <td>
    <a>
    <xsl:attribute name="href">GetPatron.asp?PatronBC=<xsl:value-of select="barcode" /> </xsl:attribute> Select
    </a>
    </td>
    <td>
    <xsl:value-of select="barcode" /> 
    </td>
    <td>
    <xsl:value-of select="lastName" /> 
    </td>
    <td>
    <xsl:value-of select="firstName" /> 
    </td>
    <td>
    <xsl:value-of select="ucMember" /> 
    </td>
    <td>
    <xsl:value-of select="email" /> 
    </td>
  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



