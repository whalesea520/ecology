<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillApproveOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>
<!--	<%
		//System.out.println("billid = "+billid);
		RecordSet.executeSql("select * from Bill_ApproveProj where id = "+billid);
		String approveid ="";
		if(RecordSet.next())
			 approveid=RecordSet.getString("approveid");
	%>
 <TABLE class="ViewForm" cellpadding="0" cellspacing="0" border="0">
	  <COLGROUP> 
	  <COL width="20%"> 
	  <COL width="80%"> 
	  <TR>
		<td><%=SystemEnv.getHtmlLabelName(16409,user.getLanguage())%></td>
		<td class="Field"><span id="approveSpan" name="approveSpan" ><A href="/proj/data/ViewProject.jsp?ProjID=<%=approveid%>"><%=ProjectInfoComInfo.getProjectInfoname(approveid)%></A></span></td>  
	  </TR>
	   <TR><TD class=Line2 colSpan=2></TD></TR> 
	  </Table>
-->
	  	
	 
<br>
<br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

</body>
</html>
