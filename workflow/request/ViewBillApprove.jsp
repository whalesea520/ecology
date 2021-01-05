<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillApproveOperation.jsp">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>
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
		  <span id="approveSpan" name="approveSpan" ><A href="/docs/docs/DocDsp.jsp?id=<%=approveid%>&isrequest=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"   target='_new'><%=DocComInfo.getDocname(approveid)%></A></span>
	  <%}
	  	  if (approvetype.equals("10")) 	{%>			  
		  <span id="approveSpan" name="approveSpan" ><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=approveid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"  target='_new'><%=CustomerInfoComInfo.getCustomerInfoname(approveid)%></A></span>
	  <%}
		  if (approvetype.equals("11")) 	{%>			  
		  <span id="approveSpan" name="approveSpan" ><A href="/proj/data/ViewProject.jsp?ProjID=<%=approveid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>"  target='_new'><%=ProjectInfoComInfo.getProjectInfoname(approveid)%></A></span>
	  <%}%>
	  </td>
	  </tr>
	  <TR><TD class=Line2 colSpan=2></TD></TR> 
	  </table>
<br>
<br>
            <jsp:include page="WorkflowViewSignAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="usertype" value="<%=usertype%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />	
				<jsp:param name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid%>" />	
				<jsp:param name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype%>" />	


            </jsp:include>
</form>

</body>
</html>
