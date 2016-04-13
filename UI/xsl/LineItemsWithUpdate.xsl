<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="0" cellpadding="0" width="700">
  <tr bgcolor="#EEEEEE">
    <td>Service</td> 
    <td>SubType</td> 
    <td>RCP</td> 
    <td>Unit Price</td> 
    <td>Quantity</td> 
    <td align="center">Total </td> 
    <td align="center"> </td> 
  </tr>
  <xsl:for-each select="singleInvoice/lineItem">
  <tr>
    <td valign="top">
    <xsl:value-of select="service" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="serviceSubtype" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="requireCustomPrice" /> 
    </td>
    <td valign="bottom">
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=updateItem">
      <input align="right" type="text" name="txtUnitPrice"><xsl:attribute name="value"><xsl:value-of select="format-number(unitPrice,'#,###.00')" /> </xsl:attribute> </input>
      <input type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
      <input type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
      <input type="hidden" name="txtbranchServiceID"><xsl:attribute name="value"> <xsl:value-of select="branchServiceID" /> </xsl:attribute> </input>
      <input type="hidden" name="txtUnitPriceOriginal"><xsl:attribute name="value"> <xsl:value-of select="unitPrice" /> </xsl:attribute> </input>
      <input type="hidden" name="txtQuantity"><xsl:attribute name="value"> <xsl:value-of select="quantity" /> </xsl:attribute> </input>
      <input type="hidden" name="txtRequireCustomPrice"><xsl:attribute name="value"> <xsl:value-of select="requireCustomPrice" /> </xsl:attribute> </input>
      <input type="hidden" name="txtMinimum"><xsl:attribute name="value"> <xsl:value-of select="nonUcMinimum" /> </xsl:attribute> </input>
      <input type="submit" value="update price" />
    </form>
    </td>
    <td>    

<form method="post" autocomplete="off" action="GetInvoice.asp?action=updateItem">
    <input align="right" type="text" name="txtQuantity"><xsl:attribute name="value"> <xsl:value-of select="quantity" /> </xsl:attribute> </input>
      <input type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
      <input type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
      <input type="hidden" name="txtbranchServiceID"><xsl:attribute name="value"> <xsl:value-of select="branchServiceID" /> </xsl:attribute> </input>
      <input type="hidden" name="txtUnitPrice"><xsl:attribute name="value"> <xsl:value-of select="unitPrice" /> </xsl:attribute> </input>
      <input type="hidden" name="txtUnitPriceOriginal"><xsl:attribute name="value"> <xsl:value-of select="unitPrice" /> </xsl:attribute> </input>
      <input type="hidden" name="txtRequireCustomPrice"><xsl:attribute name="value"> <xsl:value-of select="requireCustomPrice" /> </xsl:attribute> </input>
      <input type="hidden" name="txtMinimum"><xsl:attribute name="value"> <xsl:value-of select="nonUcMinimum" /> </xsl:attribute> </input>
      <input type="submit" value="update quantity" />
</form>
</td>
    <td valign="top" align="center">
    $<xsl:value-of select="format-number(totalPrice,'#,###.00')" />
    </td>

    <td>
    <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteLineItem">

      <input type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
      <input type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
      <input type="submit" value="delete line item" />
    </form>
    </td>
  </tr>



<xsl:variable name="lineNumber" select="./lineNumber" />
<xsl:if test="count(//lineNote[lineNumber=$lineNumber]) > 0">
        
<xsl:for-each select="//lineNote[lineNumber=$lineNumber]">
          


<tr>
  <xsl:choose>
    <xsl:when test="internal = 'true'"><td></td><td><font color="red">Internal Note </font>(<xsl:copy-of select="createdBy" />
)</td>
      <td colspan="3" bgcolor="#FFC1C1" valign="top">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateLineItemNote">
        <textarea name="txtLineItemNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#FFC1C1">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteLineItemNote">
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input type="submit" value="delete note" />
        </form>
      </td>
    </xsl:when>
    <xsl:when test="internal = 'false'"><td></td><td><font color="green">Public Note </font>(<xsl:copy-of select="createdBy" />
)</td>
      <td colspan="3" bgcolor="#9ACD32">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=UpdateLineItemNote">
        <textarea name="txtLineItemNote" cols="70" rows="2">
        <xsl:value-of select="note" /> 
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtSequenceNum"><xsl:attribute name="value"> <xsl:value-of select="sequenceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtInternal"><xsl:attribute name="value"> <xsl:value-of select="internal" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtCreatedBy"><xsl:attribute name="value"> <xsl:value-of select="createdBy" /> </xsl:attribute> </input>
        <input type="submit" value="update note" />
        </form>
      </td>
      <td bgcolor="#9ACD32">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=DeleteLineItemNote">
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
      
</xsl:if>


<tr>
<td></td>
<td></td><td colspan="3">
        <form method="post" autocomplete="off" action="GetInvoice.asp?action=AddLineItemNote">
        <textarea name="txtLineItemNote" cols="70" rows="2">
        </textarea>
        <input align="right" type="hidden" name="txtInvoiceNum"><xsl:attribute name="value"> <xsl:value-of select="invoiceNumber" /> </xsl:attribute> </input>
        <input align="right" type="hidden" name="txtLineEditNum"><xsl:attribute name="value"> <xsl:value-of select="lineNumber" /> </xsl:attribute> </input>

<select name="txtInternal">
<option value="false">Public</option>
<option value="true">Internal</option>
</select>

        <input type="submit" value="add note" />
        </form>

</td>
<td></td>
</tr>


  </xsl:for-each>

</table>





</xsl:template>
</xsl:stylesheet>


