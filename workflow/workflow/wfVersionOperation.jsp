
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%

User user = HrmUserVarify.getUser(request, response) ;
if (user == null ) return ;
//用户对流程有路径维护权限
WfRightManager wfrm = new WfRightManager();
String targetwfid = Util.null2String(request.getParameter("targetwfid"));
boolean haspermission = wfrm.hasPermission3(Integer.parseInt(targetwfid), 0, user, WfRightManager.OPERATION_CREATEDIR);
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}


String versionDesc = URLDecoder.decode(Util.null2String(request.getParameter("versionDesc")), "UTF-8");
System.out.println(targetwfid);
boolean isEdit = "edit".equals(Util.null2String(request.getParameter("src")));
boolean isActive = "true".equals(Util.null2String(request.getParameter("status")));
//System.out.println("保存版本信息isEdit："+isEdit);
//System.out.println("保存版本信息isActive："+isActive);
//System.out.println("保存版本信息versionDesc："+versionDesc);
WorkflowVersion wfversion = new WorkflowVersion(targetwfid);
if (!isEdit) {
	int newwfid = wfversion.saveAsVersion(user, versionDesc, request.getRemoteAddr());
	response.setCharacterEncoding("utf-8");
	response.getWriter().write(newwfid + "");	
} else {
	if (isActive) {
		wfversion.setActiveVersion(wfversion.getWorkflowId(), versionDesc);
		response.setCharacterEncoding("utf-8");
	} else {
		wfversion.updateVersionInfo(wfversion.getWorkflowId(), versionDesc);
	}
	response.getWriter().write("1");
	
}
%>