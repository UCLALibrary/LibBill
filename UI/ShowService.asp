<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>
  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 


  <%
  select case request("action")
    case "UpdateService"
      %>
      <!-- #INCLUDE virtual="includes/UpdateService.asp" --> 
      <%
    case "DeleteService"
      %>
      <!-- #INCLUDE virtual="includes/DeleteService.asp" --> 
      <%
    case else
  end select

  if request("action")<>"DeleteService" then

    strserviceName=request("txtserviceName")
    strsubtypeName=request("txtsubtypeName")
    strtaxable=request("txttaxable")
    strucPrice=request("txtucPrice")
    strnonUCPrice=request("txtnonUCPrice")
    strucMinimum=request("txtucMinimum")
    strnonUCMinimum=request("txtnonUCMinimum")
    strRequireCustomPrice=request("txtRequireCustomPrice")
    strunitMeasure=request("txtunitMeasure")
    stritemCode=request("txtitemCode")
    strFAU=request("txtFAU")
    strID=request("txtID")
    strLocationName=request("txtLocationName")
    strCode=request("txtCode")
    %>


    <table border="1">
    <tr>
    <td>location</td>
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
    <tr>
    <td><%=strLocationName%></td>
    <td><form method="post" action="ShowService.asp?action=UpdateService">
    <input type="text" name="txtserviceName" value="<%=strserviceName%>"></td>

    <td><input type="text" name="txtsubtypeName" value="<%=strsubtypeName%>"></td>
    <td>
    <select name="txtTaxable">
    <option value="<%=strtaxable%>"><%=strtaxable%></option>
    <option>true</option>
    <option>false</option>
    </select>
    </td>
    <td><input type="text" name="txtucPrice" value="<%=strucPrice%>">
    <td><input type="text" name="txtnonUCPrice" value="<%=strnonUCPrice%>">
    <td><input type="text" name="txtucMinimum" value="<%=strucMinimum%>">
    <td><input type="text" name="txtnonUCMinimum" value="<%=strnonUCMinimum%>">
    <td>
    <select name="txtRequireCustomPrice">
    <option value="<%=strRequireCustomPrice%>"><%=strRequireCustomPrice%></option>
    <option>true</option>
    <option>false</option>
    </select>
    </td>
    <td>
    <select name="txtUnitMeasure">
    <option value="<%=strUnitMeasure%>"><%=strUnitMeasure%></option>
    <option>each</option>
    <option>hour</option>
    <option>order</option>
    <option>reel</option>
    <option>mile</option>
    <option>frame</option>
    <option>page</option>
    </select>
    </td>

    <td><input type="text" name="txtitemCode" value="<%=stritemCode%>">
    <td><input type="text" name="txtfau" value="<%=strfau%>">

    <input type="hidden" name="txtID" value="<%=strID%>">
    <input type="hidden" name="txtLocationName" value="<%=strLocationName%>">

    </td>
 
    <td><input type="submit" value="update"></form></td>
    <td>
    <form method="post" action="showService.asp?action=DeleteService">
    <input type="hidden" name="txtID" value="<%=strID%>">
    <input type="submit" value="delete"></td>
    </form>
    </tr>
    </table>
    <%
  end if
else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
end if %>