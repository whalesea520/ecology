
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.ArrayList" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));

MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());


String customName = Util.null2String(request.getParameter("customName"));
String customName_e = Util.null2String(request.getParameter("customName_e"));
String customName_t = Util.null2String(request.getParameter("customName_t"));
String basetarget = Util.null2String(request.getParameter("basetarget"));
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

mm.updateMenu(id,use,customName,customName_e,customName_t);
if ("left".equalsIgnoreCase(type)) {
	rs.executeSql("update leftmenuinfo set basetarget='"+basetarget+"'  where id="+id);
} else if ("top".equalsIgnoreCase(type)) {
	rs.executeSql("update mainmenuinfo set basetarget='"+basetarget+"'  where id="+id);
}

if(use==1){  //自定义
	out.println("<input type='hidden' value=\""+customName+"\" id='sText'/>");	
} else { //非自定义
	MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(id);
	out.println("<input type='hidden' value=\""+ SystemEnv.getHtmlLabelName(mcb.getMenuInfoBean().getLabelId(),7)+"\" id='sText'/>");	
}
out.println("<input type='hidden' value=\"\" id='iconUrl'/>");	
out.println("<script language=javaScript>parent.closeDialogAndRefreshWin(false);</script>");
%>