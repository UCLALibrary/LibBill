<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <tr bgcolor="#EEEEEE">
    <td>rateName</td> 
    <td>rate</td> 
    <td>startDate</td> 
    <td>endDate</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="taxRateList/rate">
  <tr>
<form method="post" action="ShowTaxRate.asp">
    <td valign="top">
    <xsl:value-of select="rateName" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="rate" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="startDate" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="endDate" /> 
    </td>
<td>
    <input type="hidden" name="txtRateName"><xsl:attribute name="value"> <xsl:value-of select="rateName" /> </xsl:attribute> </input>
    <input type="hidden" name="txtrate"><xsl:attribute name="value"> <xsl:value-of select="rate" /> </xsl:attribute> </input>
    <input type="hidden" name="txtStartDate"><xsl:attribute name="value"> <xsl:value-of select="startDate" /> </xsl:attribute> </input>
    <input type="hidden" name="txtEndDate"><xsl:attribute name="value"> <xsl:value-of select="endDate" /> </xsl:attribute> </input>
    <input type="hidden" name="txtID"><xsl:attribute name="value"> <xsl:value-of select="rateID" /> </xsl:attribute> </input>
    <input type="submit" value="  edit  " />
    </td>
</form>



  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



