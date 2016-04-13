<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Library Card</td> 
    <td>Last Name</td> 
    <td>First Name</td> 
    <td>UC Rate</td> 
    <td>email</td> 
  </tr>
  <xsl:for-each select="patronList/patron">
  <tr>
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
  <tr bgcolor="#EEEEEE">
    <td>Address</td> 
    <td>City</td> 
    <td>Zip or Mail Code</td> 
    <td></td> 
    <td><font color="red">InstitutionID</font></td> 
  </tr>
  <tr>
    <td>
    <xsl:value-of select="permAddress1" /> 
    </td>
    <td>
    <xsl:value-of select="permCity" /> 
    </td>
    <td>
    <xsl:value-of select="permZip" /> 
    </td>
    <td>
    </td>
    <td><font color="red">
    <xsl:value-of select="institutionID" /> </font>
    </td>
  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



