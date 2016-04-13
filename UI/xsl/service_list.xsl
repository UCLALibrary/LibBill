
<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <tr bgcolor="#EEEEEE">
    <td>ID</td> 
    <td>serviceName</td> 
    <td>subtypeName</td> 
    <td>taxable</td> 
    <td>ucPrice</td> 
    <td>nonUCPrice</td> 
    <td>ucMinimum</td> 
    <td>nonUCMinimum</td> 
    <td>requireCustomPrice</td> 
    <td>unitMeasure</td> 
    <td>itemCode</td> 
    <td>fau</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="branchServices/service">
  <tr>
<form method="post" action="ShowService.asp">
    <td valign="top">
    <xsl:value-of select="locSvcKey" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="serviceName" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="subtypeName" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="taxable" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="ucPrice" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="nonUCPrice" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="ucMinimum" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="nonUCMinimum" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="requireCustomPrice" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="unitMeasure" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="itemCode" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="fau" /> 
    </td>
<td>
    <input type="hidden" name="txtserviceName"><xsl:attribute name="value"> <xsl:value-of select="serviceName" /> </xsl:attribute> </input>
    <input type="hidden" name="txtsubtypeName"><xsl:attribute name="value"> <xsl:value-of select="subtypeName" /> </xsl:attribute> </input>
    <input type="hidden" name="txttaxable"><xsl:attribute name="value"> <xsl:value-of select="taxable" /> </xsl:attribute> </input>
    <input type="hidden" name="txtucPrice"><xsl:attribute name="value"> <xsl:value-of select="ucPrice" /> </xsl:attribute> </input>
    <input type="hidden" name="txtnonUCPrice"><xsl:attribute name="value"> <xsl:value-of select="nonUCPrice" /> </xsl:attribute> </input>
    <input type="hidden" name="txtucMinimum"><xsl:attribute name="value"> <xsl:value-of select="ucMinimum" /> </xsl:attribute> </input>
    <input type="hidden" name="txtnonUCMinimum"><xsl:attribute name="value"> <xsl:value-of select="nonUCMinimum" /> </xsl:attribute> </input>
    <input type="hidden" name="txtRequireCustomPrice"><xsl:attribute name="value"> <xsl:value-of select="requireCustomPrice" /> </xsl:attribute> </input>
    <input type="hidden" name="txtunitMeasure"><xsl:attribute name="value"> <xsl:value-of select="unitMeasure" /> </xsl:attribute> </input>
    <input type="hidden" name="txtitemCode"><xsl:attribute name="value"> <xsl:value-of select="itemCode" /> </xsl:attribute> </input>
    <input type="hidden" name="txtFAU"><xsl:attribute name="value"> <xsl:value-of select="fau" /> </xsl:attribute> </input>
    <input type="hidden" name="txtID"><xsl:attribute name="value"> <xsl:value-of select="locSvcKey" /> </xsl:attribute> </input>
    <input type="hidden" name="txtLocationName"><xsl:attribute name="value"> <xsl:value-of select="locationName" /> </xsl:attribute> </input>
    <input type="hidden" name="txtCode"><xsl:attribute name="value"> <xsl:value-of select="locationCode" /> </xsl:attribute> </input>
    <input type="submit" value="  edit  " />
    </td>
</form>



  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



