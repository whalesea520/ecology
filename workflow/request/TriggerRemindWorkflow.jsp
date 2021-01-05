<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="sysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response); 
	String remark = Util.null2String(request.getParameter("remark"));
	String details = Util.null2String(request.getParameter("details"));
	if(StringUtils.isNotEmpty(details)){
	    remark = WorkflowRequestMessage.resolveSystemwfInfo(details) + remark;
	}
	int requestid = Util.getIntValue(request.getParameter("requestid"),0);
	int loginuserid = Util.getIntValue(request.getParameter("loginuserid"));
	rs.executeSql("select requestname from workflow_requestbase where requestid  = "+ requestid);
	String requestname = "";
	if(rs.next()){
	    requestname = "："+Util.null2String(rs.getString(1));
	}
	//QC249991 新建流程工作流初始化错误，这个时候requestname还没有，这种情况就不触发系统提醒工作流了，触发出来的流程看不到问题流程的标题，莫名其妙
	if(!"".equals(requestname.trim())){
	    sysRemindWorkflow.make(SystemEnv.getHtmlLabelName(129382, user.getLanguage())+requestname,0,0,0,0,loginuserid,"1",remark,requestid);
	}
%>
