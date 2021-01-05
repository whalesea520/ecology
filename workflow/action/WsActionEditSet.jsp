
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.workflow.action.WSActionManager" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(request.getParameter("actionid"),0);
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	if(actionid <= 0){
		operate = "addws";
	}

	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
	if(nodelinkid>0)
		triggermothod = "0";
	else if(nodeid>0)
	{
		triggermothod = "1";
	}
	response.sendRedirect("/workflow/action/WorkflowActionEditSet.jsp?workflowid="+workflowid+"&actionid="+actionid+"&fromintegration=0&typename="+typename+"&nodeid="+nodeid+"&ispreoperator="+ispreoperator+"&nodelinkid="+nodelinkid+"&triggermothod="+triggermothod);
	return;
%>