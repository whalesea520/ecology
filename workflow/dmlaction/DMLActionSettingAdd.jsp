<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />

<%
	int workflowId = Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	//数据源
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";
	//操作类型
	String dmltype = Util.null2String(request.getParameter("dmltype"));
	//节点id
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	//是否节点后附加操作
	String ispreoperator = Util.null2String(request.getParameter("ispreoperator"));
	//节点出口id
	String nodelinkid = Util.null2String(request.getParameter("nodelinkid"));
	//workflowId=&nodeid=&nodelinkid=&ispreoperator=0
	if(!nodelinkid.equals(""))
		triggermothod = "0";
	else if(!nodeid.equals(""))
	{
		triggermothod = "1";
	}
	response.sendRedirect("/workflow/action/WorkflowActionEditSet.jsp?workflowid="+workflowId+"&fromintegration=0&typename="+typename+"&nodeid="+nodeid+"&ispreoperator="+ispreoperator+"&nodelinkid="+nodelinkid+"&triggermothod="+triggermothod);
	return;
%>