
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
%>
<%
	String operate = Util.null2String(request.getParameter("operate"));
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	response.sendRedirect("/workflow/action/WorkflowActionEditSet.jsp?actionid="+actionid);
	return;
%>
