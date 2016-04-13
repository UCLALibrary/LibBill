<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="0" cellpadding="0" width="700">
  <tr bgcolor="#EEEEEE">
    <td>Service</td> 
    <td>SubType</td> 
    <td>Unit Price</td> 
    <td>Quantity</td> 
    <td>Line Item Total</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="singleInvoice/lineItem">
  <tr>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateItem">
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
    </form>
  </tr>


  </xsl:for-each>

</table>


</xsl:template>
</xsl:stylesheet>


