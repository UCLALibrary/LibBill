<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 


  <%
  select case request("action")
    case "UpdateUser"
      %>
      <!-- #INCLUDE virtual="includes/UpdateUser.asp" --> 
      <%
      strUserUID=request("txtUIDOld")
    case "UpdateUserRole"
      %>
      <!-- #INCLUDE virtual="includes/UpdateUserRole.asp" --> 
      <%
      strUserUID=request("txtUserUID")
    case else
      strUserUID=request("txtUserUID")
  end select

  strRole=request("txtRole")
  strLastName=request("txtlastName")
  strFirstName=request("txtfirstName")
  strUserName=request("txtuserName")
  strUserUID=request("txtUserUID")

  %>

  <table border="1">
  <tr>
  <td>Last Name</td>
  <td>First Name</td>
  <td>User Name</td>
  <td>UID</td>
  </tr>
  <tr>
  <form method="post" action="showuser.asp?action=UpdateUser">
  <td><input type="text" name="txtLastName" value="<%=strLastName%>"></td>
  <td><input type="text" name="txtFirstName" value="<%=strFirstName%>"></td>
  <td><input type="text" name="txtUserName" value="<%=strUserName%>"></td>
  <td><input type="text" name="txtUserUID" value="<%=strUserUID%>">
  <input type="hidden" name="txtUIDOld" value="<%=strUserUID%>">
  <input type="hidden" name="txtRole" value="<%=strRole%>">

  </td>

  <td><input type="submit" value="update"></td>
  </form>
  </tr>
  </table>

  <form method="post" action="showuser.asp?action=UpdateUserRole">
  <td valign="top">
  <select name="txtRole">
  <option value="<%=strRole%>"><%=strRole%></option>
  <option value="invoice_preparer">invoice preparer</option>
  <option value="invoice_approver">invoice approver</option>
  <option value="payment_processor">payment processor</option>
  <option value="payment_approver">payment approver</option>
  <option value="invoice_prep_app">invoice_prep_app</option>
  <option value="inactive">inactive</option>
  <option value="view_only">view_only</option>
  <option value="admin">admin</option>

  </select>
  </td>
  <td align="right">
  <input type="hidden" name="txtLastName" value="<%=strLastName%>">
  <input type="hidden" name="txtFirstName" value="<%=strFirstName%>">
  <input type="hidden" name="txtuserName" value="<%=struserName%>">
  <input type="hidden" name="txtUserUID" value="<%=struserUID%>">
  <input type="submit" value="Update">
  </td>
  </form>

<%
else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
end if 

%>