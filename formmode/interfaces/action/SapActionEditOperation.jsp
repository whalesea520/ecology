
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.formmode.interfaces.action.SapActionManager"%>

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operate = Util.null2String(request.getParameter("operate"));
int actionid = Util.getIntValue(request.getParameter("actionid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
//是否节点后附加操作
int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
//出口id
int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
String actionname = Util.null2String(request.getParameter("actionname"));
int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
String sapoperation = Util.null2String(request.getParameter("sapoperation"));//调用的sap的方法
//out.println("operate = " + operate + "<br>");
//out.println("actionid = " + actionid + "<br>");
SapActionManager sapActionManager = new SapActionManager();
sapActionManager.setActionid(actionid);
sapActionManager.setWorkflowid(workflowid);
sapActionManager.setNodeid(nodeid);
sapActionManager.setNodelinkid(nodelinkid);
sapActionManager.setIspreoperator(ispreoperator);
sapActionManager.setActionname(actionname);
sapActionManager.setActionorder(actionorder);
sapActionManager.setSapoperation(sapoperation);
sapActionManager.setRequest(request);

if("delete".equals(operate)){
	sapActionManager.doDeleteSapAction();
}else if("save".equals(operate)){
	actionid = sapActionManager.doSaveAspAction();
	//out.println("actionid 222 = " + actionid + "<br>");
}
out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");

%>