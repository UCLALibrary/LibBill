<%
if not session("userName")="" then 'USER IS LOGGED IN...
  %>

  <!-- #include virtual = "/includes/hex_sha1_js.asp" -->
  <!-- #INCLUDE virtual="includes/Functions.asp" --> 
  <!-- #INCLUDE virtual="includes/TopOnly.asp" --> 
  <!-- #INCLUDE virtual="includes/MainMenu.asp" --> 


  <%
  select case request("action")
    case "UpdateTaxRate"
      strUpdate="True"
      %>
      <!-- #INCLUDE virtual="includes/UpdateTaxes.asp" --> 
      <%
    case else
  end select

'if request("action")<>"DeleteTaxRate" then

  strRateName=request("txtRateName")
  strRate=request("txtrate")
  if strUpdate<>"True" then
    strStartDate=request("txtstartDate")
    strEndDate=request("txtendDate")
  else
  end if

  strID=request("txtID")

  strStartMonth=left(strStartDate,2)
  select case strStartMonth
    case "01"
      strStartMonthText="January"
    case "02"
      strStartMonthText="February"
    case "03"
      strStartMonthText="March"
    case "04"
      strStartMonthText="April"
    case "05"
      strStartMonthText="May"
    case "06"
      strStartMonthText="June"
    case "07"
      strStartMonthText="July"
    case "08"
      strStartMonthText="August"
    case "09"
      strStartMonthText="September"
    case "10"
      strStartMonthText="October"
    case "21"
      strStartMonthText="November"
    case "12"
      strStartMonthText="December"
  end select

  strStartDay=mid(strStartDate,4,2)
  strStartYear=right(strStartdate,4)
  strEndMonth=left(strEndDate,2)

  select case strEndMonth
    case "01"
      strEndMonthText="January"
    case "02"
      strEndMonthText="February"
    case "03"
      strEndMonthText="March"
    case "04"
      strEndMonthText="April"
    case "05"
      strEndMonthText="May"
    case "06"
      strEndMonthText="June"
    case "07"
      strEndMonthText="July"
    case "08"
      strEndMonthText="August"
    case "09"
      strEndMonthText="September"
    case "10"
      strEndMonthText="October"
    case "21"
      strEndMonthText="November"
    case "12"
      strEndMonthText="December"
  end select

  strEndDay=mid(strEndDate,4,2)
  strEndYear=right(strEnddate,4)

  %>
  <p>Note: endDate means the tax rate ends when that day starts</p>

  <p>
  <form name="UpdatetaxRate" method="post" autocomplete="off" action="showtaxRate.asp?action=UpdateTaxRate">
  <table>
  <tr>
  <td>rateName </td>
  <td>rate</td>
  <td>startDate</td>
  <td></td>
  <td></td>
  <td>endDate</td>
  </tr>
  <tr>
  <td>
  <select name="txtRateName">
  <option value="<%=strRateName%>"><%=strRateName%></option>
  <option value="california">california</option>
  <option value="la_county">la_county</option>
  <option value="santa_monica_city">santa_monica_city</option>
  </select>
  </td><td>
  <input type="text" name="txtRate" value="<%=strRate%>">        
  </td>

  <td>
  <select name="txtStartMonth">
  <option selected value="<%=strStartMonth%>"><%=strStartMonthText%></option>
  <option value="01">January</option>
  <option value="02">February</option>
  <option value="03">March</option>
  <option value="04">April</option>
  <option value="05">May</option>
  <option value="06">June</option>
  <option value="07">July</option>
  <option value="08">August</option>
  <option value="09">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
  </select>

  </td>
  <td>
  <select name="txtStartDay">
  <option selected value="<%=strStartDay%>"><%=strStartDay%></option>

  <%
  intVal=1
  do while intVal<32
    %>
    <option value="<%=intVal%>"><%=intVal%></option>
    <%
    intVal=intVal+1
  loop
  %>

  </select>
  </td>
  <td>

  <select name="txtStartYear">
  <option selected value="<%=strStartYear%>"><%=strStartYear%></option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
  <option value="2019">2019</option>
  <option value="2020">2020</option>
  <option value="2021">2021</option>
  <option value="2022">2022</option>
  </select>

  </td>

  <td>
  <select name="txtEndMonth">
  <option selected value="<%=strEndMonth%>"><%=strEndMonthText%></option>
  <option value="01">January</option>
  <option value="02">February</option>
  <option value="03">March</option>
  <option value="04">April</option>
  <option value="05">May</option>
  <option value="06">June</option>
  <option value="07">July</option>
  <option value="08">August</option>
  <option value="09">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
  </select>

  </td>
  <td>
  <select name="txtEndDay">
  <option selected value="<%=strEndDay%>"><%=strEndDay%></option>

  <%
  intVal=1
  do while intVal<32
    %>
    <option value="<%=intVal%>"><%=intVal%></option>
    <%
    intVal=intVal+1
  loop
  %>

  </select>
  </td>
  <td>

  <select name="txtEndYear">
  <option selected value="<%=strEndYear%>"><%=strEndYear%></option>
  <option value="2016">2016</option>
  <option value="2017">2017</option>
  <option value="2018">2018</option>
  <option value="2019">2019</option>
  <option value="2020">2020</option>
  <option value="2021">2021</option>
  <option value="2022">2022</option>
  </select>

  </td>

  <td>
  <input type="hidden" name="txtID" value="<%=strID%>">
  <input type="submit" value="Update taxRate">
  </td>
  </tr>
  </table>
  </form>

  <%
else 'USER IS NOT LOGGED IN, SO...
  %>
  <!-- #INCLUDE virtual="includes/NotAuthenticated.asp" --> 
  <%
end if
%>