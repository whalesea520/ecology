
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.ArrayList" %>
<%
int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),1);

String customName = Util.null2String(request.getParameter("customName"));
int use = Util.getIntValue(request.getParameter("useCustom"));

if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if("1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if("2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}

if(use!=1)
	use = 0;

LeftMenuHandler leftMenuHandler = new LeftMenuHandler();

leftMenuHandler.updateLeftMenu(id,resourceId,resourceType,use,customName);


if(resourceType.equalsIgnoreCase("3")){
	response.sendRedirect("LeftMenuConfig.jsp?saved=true");
} else {
	response.sendRedirect("LeftMenuMaintenanceList.jsp?resourceId="+resourceId+"&resourceType="+resourceType+"&saved=true&sync="+sync);
}
%>