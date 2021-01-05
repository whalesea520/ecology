<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.docs.docs.CustomFieldManager,weaver.interfaces.workflow.browser.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.util.html.*,weaver.hrm.*,weaver.hrm.settings.*,weaver.systeminfo.*"%>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,org.json.JSONObject"%>
<%@page import="weaver.systeminfo.SystemEnv"%>

<%
	int isIncludeToptitle = 0;
	User user = HrmUserVarify.getUser (request , response) ;
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>