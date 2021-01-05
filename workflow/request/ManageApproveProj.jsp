

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<form name="frmmain" method="post" action="BillApproveProjOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
	<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>
<!--
<%
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
	  	<br/>
	 
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
<script language="VBS">

</script>