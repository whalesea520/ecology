
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String resourceId = Util.null2String(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));


	String targetids = Util.null2String(request.getParameter("targetids"));

	int menuSort=Util.getIntValue(request.getParameter("menuSort"));
	int menuMode=Util.getIntValue(request.getParameter("menuMode"));
	int menuAdd=Util.getIntValue(request.getParameter("menuAdd"));
	int menuRight=Util.getIntValue(request.getParameter("menuRight"));
	int menuSyncType=Util.getIntValue(request.getParameter("menuSyncType"));
	String menuId=Util.null2String(request.getParameter("menuId"));
	
	MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),Util.getIntValue(resourceId),user.getLanguage());
	
	//mm.syncMenu(resourceId,resourceType,targetids);
	if(!("").equals(menuId)){
	    //同步单个菜单
	   mm.syncSingleMenu(menuId,resourceId,targetids,menuSort,menuMode,menuAdd,menuRight,menuSyncType);
	}else{
	   //同步所有菜单 
	   mm.syncMenu(resourceId,targetids,menuSort,menuMode,menuAdd,menuRight,menuSyncType);
	}
	log.setItem("PortalMenu");
	log.setType("update");
	log.setSql("应用当前菜单设置到其他分部"+targetids);
	log.setDesc("应用当前菜单设置到其他分部");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	response.sendRedirect("/page/maint/menu/SyncMenuToSubCompany.jsp?closeDialog=close");



%>