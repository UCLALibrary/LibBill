<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">



<table border="0" cellpadding="2">
  <xsl:for-each select="singleInvoice/patron">
  <tr>
    <td>
    <xsl:value-of select="lastName" />, <xsl:value-of select="firstName" />
    </td>
    <td>Lib Card #
    <xsl:value-of select="barcode" /> 
    </td>
    <td>UC Rate: 
    <xsl:value-of select="ucMember" /> 
    </td>
    <td>institutionID: 
    <xsl:value-of select="institutionID" /> 
    </td>
    <td>email: 
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
<xsl:text>&#38;nameLast=</xsl:text>
<xsl:value-of select="lastName" />
</xsl:attribute>
<u>Patron Invoices</u>
</a>
 

</td>
  </tr>
  </xsl:for-each>
</table>


<xsl:for-each select="singleInvoice/header">



<table border="0" cellpadding="2" bgcolor="#EEEEEE" width="900">
  <tr>
    <td>Invoice</td> 
    <td>Date</td> 
    <td>Taxable</td> 
    <td>Non-Taxable </td> 
    <td>Tax </td> 
    <td>Total </td> 
    <td>Created By</td> 
    <td>Status</td> 
     <td>Amnt Due</td> 
   <td>On-Site (Y/N)</td> 
  </tr>
  <tr>
    <td bgcolor="#EEEEEE" valign="top">
    <b><xsl:value-of select="invoiceNumber" /> </b>
    </td>
    <td valign="top">
    <b><xsl:value-of select="invoiceDate" /> </b>
    </td>
    <td valign="top">$
    <b><xsl:value-of select="format-number(taxableTotal,'#,###.00')" /></b>
    </td>
    <td valign="top">$
    <b><xsl:value-of select="format-number(nontaxableTotal,'#,###.00')" /></b>
    </td>
    <td valign="top">$
    <b><xsl:value-of select="format-number(totalTax,'#,###.00')" /></b>
    </td>
    <td valign="top">$
    <b><xsl:value-of select="format-number(totalAmount,'#,###.00')"/>
    </b>
    </td>
    <td valign="top">
    <b><xsl:value-of select="createdBy" /> </b>
    </td>
    <td>
    <b><xsl:value-of select="status" /> </b>
    </td>
    <td valign="top">
    <b><xsl:value-of select="format-number(balanceDue,'#,###.00')" /> </b>
    </td>
    <td valign="top">
    <b><xsl:value-of select="onPremises" /> </b>
    </td>
  </tr>
<tr>
    <xsl:choose>
      <xsl:when test="status = 'Pending'">

<td>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus" value="Unpaid"> </input>
        <input type="submit" value="Approve" />
</form>
</td>
<td>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus" value="Never+Issued"> </input>
        <input type="submit" value="Cancel" />
</form>
</td>
      </xsl:when>
      <xsl:when test="status = 'Deposit Due'">
<td>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus" value="Canceled"> </input>
        <input type="submit" value="Cancel" />
</form>
</td>

      </xsl:when>
      <xsl:when test="status = 'Deposit Paid'">
<td>
<form method="post" autocomplete="off" action="GetInvoice.asp?action=updateInvoice">
        <input type="hidden" name="txtInvoiceNumber"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input type="hidden" name="txtStatus" value="Final+Payment+Due"> </input>
        <input type="submit" value="Approve" />
</form>
</td>
      </xsl:when>
    </xsl:choose>

</tr>

</table>
  </xsl:for-each>

<table border="0" cellpadding="0">
  <xsl:for-each select="singleInvoice/invoiceNote">
  <tr>
  <xsl:choose>
    <xsl:when test="internal = 'true'"><td></td><td valign="top"><font color="red">Internal Note </font></td>
      <td colspan="3" bgcolor="#FFC1C1" valign="top">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateInvoiceNote">
        <textarea name="txtInvoiceNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#FFC1C1">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteInvoiceNote">
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="delete note" />
        </form>
      </td>
    </xsl:when>
    <xsl:when test="internal = 'false'"><td></td><td valign="top"><font color="green">Public Note </font></td>
      <td colspan="3" bgcolor="#9ACD32" valign="top">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateInvoiceNote">
        <textarea name="txtInvoiceNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#9ACD32">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteInvoiceNote">
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="delete note" />
        </form>
      </td>
    </xsl:when>
  </xsl:choose>
  </tr>
  </xsl:for-each>
</table>

<xsl:for-each select="singleInvoice/header">
<table>
  <tr>
  <td width="120"></td>
  <td>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=AddInvoiceNote">
    <textarea name="txtLineItemNote" cols="70" rows="2">
    </textarea>
    <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
    <select name="txtInternal">
    <option value="false">Public</option>
    <option value="true">Internal</option>
    </select>
    <input type="submit" value="add note" />
    </form>
</td>
  </tr>
</table>
</xsl:for-each>






</xsl:template>
</xsl:stylesheet>



