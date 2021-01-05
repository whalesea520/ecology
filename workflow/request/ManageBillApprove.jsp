

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<form name="frmmain" method="post" action="BillApproveOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>

<%
	RecordSet.executeProc("Bill_Approve_SelectByID",billid+"");
	RecordSet.next();
	String approveid=RecordSet.getString("approveid");
	String approvetype=RecordSet.getString("approvetype");
	
%>
	  <TABLE class="ViewForm" cellpadding="0" cellspacing="0" border="0">
	  <COLGROUP> 
	  <COL width="21%"> 
	  <COL width="79%"> 
	  <tr>
	  <td>
	  <%
	  String approvename = "" ;
		if (approvetype.equals("9")) 		
		approvename=SystemEnv.getHtmlLabelName(857,user.getLanguage()) ;
		if (approvetype.equals("10")) 		
		approvename=SystemEnv.getHtmlLabelName(783,user.getLanguage()) ;
		if (approvetype.equals("11")) 		
		approvename=SystemEnv.getHtmlLabelName(782,user.getLanguage()) ;
	  out.print(approvename); 
	  %>
	  </td>
	  <td class=Field>
	  <%
	  if (approvetype.equals("9")) 	{%>	
		  <span id="approveSpan" name="approveSpan" ><A href="/docs/docs/DocDsp.jsp?id=<%=approveid%>&isrequest=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"  target='_new'><%=DocComInfo.getDocname(approveid)%></A></span>
	  <%}
	  	  if (approvetype.equals("10")) 	{%>	
		  <span id="approveSpan" name="approveSpan" ><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=approveid%>&isrequest=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"  target='_new'><%=CustomerInfoComInfo.getCustomerInfoname(approveid)%></A></span>
	  <%}
		  if (approvetype.equals("11")) 	{%>	
		  <span id="approveSpan" name="approveSpan" ><A href="/proj/data/ViewProject.jsp?ProjID=<%=approveid%>&isrequest=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"  target='_new'><%=ProjectInfoComInfo.getProjectInfoname(approveid)%></A></span>
	  <%}%>
	  <input type="hidden" id="approveid" name="approveid" value="<%=approveid%>">
      <input type="hidden" id="approvetype" name="approvetype" value="<%=approvetype%>">
	  </td>
	  </tr>
	  <TR  style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
	  </table>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
<script language="VBS">
sub onShowApprove(approvetype)
	if (approvetype="9") then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>")
	end if
	if (approvetype="10") then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>")
	end if
	if (approvetype="11") then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>")
	end if

	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		if (approvetype="9") then
			approveSpan.innerHtml = "<A href='/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id="&id(0)&"'>"&id(1)&"</A>"
		end if
		if (approvetype="10") then
			approveSpan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&CustomerID="&id(0)&"'>"&id(1)&"</A>"
		end if
		if (approvetype="11") then
			approveSpan.innerHtml = "<A href='/proj/data/ViewProject.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&ProjID="&id(0)&"'>"&id(1)&"</A>"
		end if
		frmmain.approveid.value=id(0)		
	else 
	approveSpan.innerHtml = ""
	frmmain.approveid.value=""
	end if
	end if

end sub
</script>