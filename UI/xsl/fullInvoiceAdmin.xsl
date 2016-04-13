<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">

<table border="1" bgcolor="#EEEEEE"><tr><td>

<table border="0" cellpadding="0">
  <xsl:for-each select="singleInvoice/patron">
  <tr>
    <td>
    <b><xsl:value-of select="lastName" />, <xsl:value-of select="firstName" /></b>
    </td>
    <td>Barcode: 
    <xsl:value-of select="barcode" /> 
    </td>
    <td>UC Rate: 
    <xsl:value-of select="ucMember" /> 
    </td>
<td>
<a>
<xsl:attribute name="href">
<xsl:text>mailto:</xsl:text>
<xsl:value-of select="email"/>
</xsl:attribute>
<u><xsl:value-of select="email"/></u>

</a>
</td><td>
<a>
<xsl:attribute name="href">
<xsl:text>https://invoicing.library.ucla.edu/GetPatronInvoices.asp?PatronID=</xsl:text>
<xsl:value-of select="patronID"/>
</xsl:attribute>
<u>Patron Invoices</u>
</a>    
</td>

  </tr>
  </xsl:for-each>
</table>

<table border="0" cellpadding="2" bgcolor="#EEEEEE" width="900">
  <tr>
    <td>Invoice</td> 
    <td>Date</td> 
    <td>Taxable</td> 
    <td>Non-Taxable </td> 
    <td>Tax </td> 
    <td>Total </td> 
    <td>Bal. Due </td> 
    <td>Created By</td> 
    <td>Status</td> 
    <td>On Site </td> 
    <td></td> 
  </tr>
  <xsl:for-each select="singleInvoice/header">
  <tr>
   <td bgcolor="#EEEEEE">
    <b><xsl:value-of select="invoiceNumber" /> </b>
    </td>
    <td>
    <b><xsl:value-of select="invoiceDate" /> </b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(taxableTotal,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(nontaxableTotal,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(totalTax,'#,###.00')" /></b>
    </td>
    <td>$
    <b><xsl:value-of select="format-number(totalAmount,'#,###.00')" /></b>
    </td>
    <td bgcolor="#FFFFFF">$
    <b><font color="red"><xsl:value-of select="format-number(balanceDue,'#,###.00')" /></font></b>
    </td>
    <td>
    <b><xsl:value-of select="createdBy" /> </b>
    </td>
    <td>
    <b><xsl:value-of select="status" /> </b>
    </td>

    <td>
    <b><xsl:value-of select="onPremises" /> </b>
    </td>
    <td>
    </td>
  </tr>
  </xsl:for-each>
</table>
</td>
</tr>
</table>

<table border="0" cellpadding="0">
  <xsl:for-each select="singleInvoice/invoiceNote">
  <tr>
  <xsl:choose>
    <xsl:when test="internal = 'true'"><td></td><td valign="top"><font color="red">Internal Note </font></td>
      <td colspan="3" bgcolor="#FFC1C1" valign="top"><xsl:value-of select="note" /> (<xsl:value-of select="createdBy" />) 
      </td>
      <td bgcolor="#FFC1C1">
      </td>
    </xsl:when>
    <xsl:when test="internal = 'false'"><td></td><td valign="top"><font color="green">Public Note </font></td>
      <td colspan="3" bgcolor="#9ACD32" valign="top"><xsl:value-of select="note" /> 
      </td>
      <td bgcolor="#9ACD32">
      </td>
    </xsl:when>
  </xsl:choose>
  </tr>
  </xsl:for-each>
</table>




</xsl:template>
</xsl:stylesheet>



