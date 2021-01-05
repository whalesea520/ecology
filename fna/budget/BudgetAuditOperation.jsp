<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int objId = Util.getIntValue(request.getParameter("objId"));
int flowId = Util.getIntValue(request.getParameter("flowId"));
String syc = Util.null2String(request.getParameter("syc"));
 BudgetHandler.auditMapEdit(syc,objId,flowId);
 response.sendRedirect("AuditSetting.jsp");
%>
