

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<form name="frmmain" method="post" action="BillApproveCustomerOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

<%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>

<%
	RecordSet.executeSql("select approveid from bill_ApproveCustomer where id="+billid);
	RecordSet.next();
	String approveid=RecordSet.getString("approveid");

%>
	  <TABLE class="ViewForm" cellpadding="0" cellspacing="0" border="0">
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
	  <tr>
	  <td>
	  <%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>
	  </td>
	  <td class=Field>

      <span id="approveSpan" name="approveSpan" ><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=approveid%>&isrequest=1&requestid=<%=requestid%>" target="_blank"><%=CustomerInfoComInfo.getCustomerInfoname(approveid)%></A></span>

	  <input type="hidden" id="approveid" name="approveid" value="<%=approveid%>">

	  </td>
	  </tr>
	  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
	  </table>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
<script language="VBS">
sub onShowApprove()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")

	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            approveSpan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
            frmmain.approveid.value=id(0)
        else
        approveSpan.innerHtml = ""
        frmmain.approveid.value=""
        end if
	end if

end sub
</script>