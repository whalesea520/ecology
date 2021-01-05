
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="java.util.ArrayList" %>
<%
int id = Util.getIntValue(request.getParameter("id"));
int systemId = Util.getIntValue(request.getParameter("systemId"));

String customName = Util.null2String(request.getParameter("customName"));
int use = Util.getIntValue(request.getParameter("useCustom"));

if(use!=1)
	use = 0;

int userid=0;
userid=user.getUID();


MainMenuHandler mainMenuHandler = new MainMenuHandler();

mainMenuHandler.updateMainMenu(id,use,customName);
response.sendRedirect("MainMenuConfig.jsp?id="+systemId+"&saved=true");
%>