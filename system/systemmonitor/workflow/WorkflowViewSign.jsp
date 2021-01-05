 <script language="javascript">
function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()>全部</a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()>部分</a>";
			WorkFlowDiv.style.display = "";
		}
	}
</SCRIPT>
 
  
  <table class=form>
    <colgroup> <col width="100%"> 
    <tr class=Section> 
      <th>流转</th>
    </tr>
    <tr class=separator> 
      <td class=Sep1></td>
    </tr>
    <tr> 
      <td valign=top> 
        <table class=ListShort>
          <colgroup> <col width="35%"> <col width="20%"> <col width="20%"> <col width="20%"> 
          <tbody> 
          <tr class=Header> 
            <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></th>
            <th>操作</th>
            <th>操作<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
          </tr>
          <%
boolean isLight = false;
int nLogCount=0;
RecordSet.executeProc("workflow_RequestLog_SNSRemark",""+requestid );
while(RecordSet.next())
{
	nLogCount++;
if (nLogCount==3) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListShort>
    <colgroup> <col width="35%"> <col width="20%"> <col width="25%"> <col width="15%"> 
    <tbody> 
<%}%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>> 
            <td><%=Util.toScreen(RecordSet.getString("operatedate"),user.getLanguage())%> 
              &nbsp<%=Util.toScreen(RecordSet.getString("operatetime"),user.getLanguage())%></td>
            <td>
            <%if(RecordSet.getString("operatortype").equals("0")){%>
	<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("operator")%>"> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("operator")),user.getLanguage())%></a>
              
<%}else if(RecordSet.getString("operatortype").equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("operator")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("operator")),user.getLanguage())%></a>
<%}else{%>
系统
<%}%>
            </td>
            <td><%=Util.toScreen(RecordSet.getString("nodename"),user.getLanguage())%> 
            </td>
            <td> 
              <%
	String logtype = RecordSet.getString("logtype");
	if(logtype.equals("9"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%> 
              <%
	}
	else if(logtype.equals("2"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%> 
              <%
	}
	else if(logtype.equals("3"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%> 
              <%
	}
	else if(logtype.equals("4"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%> 
              <%
	}
	else if(logtype.equals("5"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> 
              <%
	}
	else if(logtype.equals("6"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%> 
              <%
	}
%>
            </td>
          </tr>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>> 
            <td colspan="4"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="15%"><font color="#FF0000">签字</font></td>
                  <td width="85%"> 
                    <%if(RecordSet.getString("remark").equals("")){%>
                    &nbsp 
                    <%}%>
                    <%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="4" height=8></td>
          </tr>
          <%
	isLight = !isLight;
}
%>
</tbody></table>
<% if (nLogCount>=3) { %> </div> <%}%>
        <table class=ListShort>
          <colgroup> <col width="35%"> <col width="20%"> <col width="25%"> <col width="15%"> 
          <tbody> 
          <tr> 
            <td> </td>
            <td> </td>
            <% if (nLogCount>=3) { %>
            <td align=right><SPAN id=WorkFlowspan><a href='#' onClick="displaydiv_1()">全部</a></span></td>
            <%}%>
          </tr>
         </tbody> 
        </table>
      </td>
    </tr>
  </table>