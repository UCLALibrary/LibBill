<?xml version="1.0" ?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table border="1" cellpadding="2" width="800">
  <tr bgcolor="#EEEEEE">
    <td>Last Name</td> 
    <td>First Name</td> 
    <td>User Name</td> 
    <td>Role</td> 
    <td></td> 
  </tr>
  <xsl:for-each select="userRoles/userRole">
  <tr>
<form method="post" action="ShowUser.asp">
    <td valign="top">
    <xsl:value-of select="lastName" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="firstName" /> 
    </td>
    <td valign="top">
    <xsl:value-of select="userName" /> 
    </td>
    <td valign="top">

<xsl:value-of select="role" /> 
</td><td>
    <input type="hidden" name="txtuserUID"><xsl:attribute name="value"> <xsl:value-of select="userUid" /> </xsl:attribute> </input>
    <input type="hidden" name="txtuserName"><xsl:attribute name="value"> <xsl:value-of select="userName" /> </xsl:attribute> </input>
    <input type="submit" value="update user" />
    </td>
</form>
  </tr>
  </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>



