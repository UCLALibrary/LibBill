<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Code</td> 
    <td>Name</td> 
    <td>Department</td> 
    <td>Phone</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="units/unit">
  <tr>
<form method="post" action="ShowLocation.asp">
    <td valign="top">
    <xsl:value-of select="code" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="name" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="department" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="phone" /> 
    </td>
<td>
    <input type="hidden" name="txtCode"><xsl:attribute name="value"> <xsl:value-of select="code" /> </xsl:attribute> </input>
    <input type="hidden" name="txtName"><xsl:attribute name="value"> <xsl:value-of select="name" /> </xsl:attribute> </input>
    <input type="hidden" name="txtDepartment"><xsl:attribute name="value"> <xsl:value-of select="department" /> </xsl:attribute> </input>
    <input type="hidden" name="txtPhone"><xsl:attribute name="value"> <xsl:value-of select="phone" /> </xsl:attribute> </input>
    <input type="hidden" name="txtID"><xsl:attribute name="value"> <xsl:value-of select="id" /> </xsl:attribute> </input>
    <input type="submit" value="  edit  " />
    </td>
</form>

<td><form method="post" action="GetServices.asp">
    <input type="hidden" name="txtID"><xsl:attribute name="value"> <xsl:value-of select="id" /> </xsl:attribute> </input>
    <input type="hidden" name="txtName"><xsl:attribute name="value"> <xsl:value-of select="name" /> </xsl:attribute> </input>
    <input type="hidden" name="txtCode"><xsl:attribute name="value"> <xsl:value-of select="code" /> </xsl:attribute> </input>
    <input type="submit" value="  services  " />
</form>
</td>

  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



