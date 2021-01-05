
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%
	String workflowId = Util.null2String((String)request.getParameter("wfid"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(workflowId), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String type = Util.null2String(request.getParameter("type"));

	String serverstr=request.getScheme()+"://"+request.getHeader("Host");
	
	String dataurl = serverstr + "/workflow/design/wfdesign_data.jsp;jsessionid=" + session.getId() + "?userid=" + user.getUID() + "&wfid=" + workflowId + "&type=" + type;
	//
	String submiturl = serverstr + "/weaver/weaver.workflow.layout.WorkflowXmlParser";
%>

<!DOCTYPE html PUBLIC "">
<html>
	<head>
	</head>
	<body class="" id="" scroll="no" oncontextmenu="return false" onbeforeunload="" style="width:100%;height:100%;padding:0px!important;margin:0px!important;">
		<iframe id ="wfdesign" src="/workflow/design/wfdesign_readonly.jsp?wfid=<%=workflowId %>&type=<%=type %>"  style="width:100%;height:100%;" frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
	</body>
</html>