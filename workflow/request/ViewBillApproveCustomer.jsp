
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.math.*,weaver.conn.*" %>
<%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillApproveCustomerOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>
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

      <span id="approveSpan" name="approveSpan" ><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=approveid%>" target="_blank"><%=CustomerInfoComInfo.getCustomerInfoname(approveid)%></A></span>

	  <input type="hidden" id="approveid" name="approveid" value="<%=approveid%>">

	  </td>
	  </tr>
	  <TR><TD class=Line2 colSpan=2></TD></TR>
	  </table>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
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