
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.HtmlLabelUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LabelInfo" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageMainMenu.jsp");
    return;
}

String labelId=""; 
String menuName="";
String linkAddress ="";
String parentFrame ="mainFrame";

String defaultParentId=""; 
String defaultLevel="";
String defaultIndex = "1";

String needRightToVisible = "";
String rightDetailToVisible = "";
String needRightToView = "";
String rightDetailToView = "";

String needSwitchToVisible = "";
String switchClassNameToVisible = "";
String switchMethodNameToVisible = "";


String needSwitchToView = "";
String switchClassNameToView = "";
String switchMethodNameToView = "";


String systemModuleId=""; 
String descLike ="";




labelId = Util.null2String(request.getParameter("labelId"));
menuName = Util.null2String(request.getParameter("menuName"));
linkAddress = Util.null2String(request.getParameter("linkAddress"));
parentFrame = Util.null2String(request.getParameter("parentFrame"));

defaultParentId = Util.null2String(request.getParameter("defaultParentId"));
defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
defaultIndex = Util.null2String(request.getParameter("defaultIndex"));

needRightToVisible = Util.null2String(request.getParameter("needRightToVisible"));
rightDetailToVisible = Util.null2String(request.getParameter("rightDetailToVisible"));
needRightToView = Util.null2String(request.getParameter("needRightToView"));
rightDetailToView = Util.null2String(request.getParameter("rightDetailToView"));

needSwitchToVisible = Util.null2String(request.getParameter("needSwitchToVisible"));
switchClassNameToVisible = Util.null2String(request.getParameter("switchClassNameToVisible"));
switchMethodNameToVisible = Util.null2String(request.getParameter("switchMethodNameToVisible"));

needSwitchToView = Util.null2String(request.getParameter("needSwitchToView"));
switchClassNameToView = Util.null2String(request.getParameter("switchClassNameToView"));
switchMethodNameToView = Util.null2String(request.getParameter("switchMethodNameToView"));

systemModuleId = Util.null2String(request.getParameter("systemModuleId"));
descLike = Util.null2String(request.getParameter("descLike"));


SystemModuleHandler systemModuleHandler = new SystemModuleHandler();
MainMenuHandler mainMenuHandler = new MainMenuHandler();
MainMenuInfoHandler mainMenuInfoHandler = new MainMenuInfoHandler();
HtmlLabelUtil htmlLabelUtil = new HtmlLabelUtil();

%>

