
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.HtmlLabelUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LabelInfo" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageLeftMenu.jsp");
    return;
}

String parentId=""; 
String systemModuleId=""; 
String descLike ="";
String iconUrl=""; 
String labelId=""; 
String linkAddress ="";
String defaultIndex = "1";

String menuLevel = Util.null2String(request.getParameter("menuLevel"));
parentId = Util.null2String(request.getParameter("parentId"));
systemModuleId = Util.null2String(request.getParameter("systemModuleId"));
descLike = Util.null2String(request.getParameter("descLike"));
iconUrl = Util.null2String(request.getParameter("iconUrl"));
labelId = Util.null2String(request.getParameter("labelId"));
linkAddress = Util.null2String(request.getParameter("linkAddress"));
defaultIndex = Util.null2String(request.getParameter("defaultIndex"));

SystemModuleHandler systemModuleHandler = new SystemModuleHandler();
LeftMenuHandler leftMenuHandler = new LeftMenuHandler();
LeftMenuInfoHandler leftMenuInfoHandler = new LeftMenuInfoHandler();
HtmlLabelUtil htmlLabelUtil = new HtmlLabelUtil();
%>

