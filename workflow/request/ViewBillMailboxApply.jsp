
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillMailboxApplyOperation.jsp">
<%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>
    <tr><td colspan=2>&nbsp;</td></tr>
	<tr><td colspan=2>
	<table class=liststyle cellspacing=1   border=1 width="80%">
	<tr> 
      <td colspan=2 align=center bgcolor="lightblue"><b><%=SystemEnv.getHtmlLabelName(1022,user.getLanguage())%></b></td>
    </tr>  
    <tr> 
      <td colspan=2>
<b><%=SystemEnv.getHtmlLabelName(16659,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16661,user.getLanguage())%><p>
<b><%=SystemEnv.getHtmlLabelName(16660,user.getLanguage())%></b><p>
<%=SystemEnv.getHtmlLabelName(16662,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16663,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16664,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16665,user.getLanguage())%><p>
<%=SystemEnv.getHtmlLabelName(16666,user.getLanguage())%><p>

      </td>
    </tr>
    </table>
    <!--delete by xhheng @20041229 for TD 1470-->
  <br>
  <br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>
</body>
</html>
