<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
	String rsstype = Util.null2String(request.getParameter("rsstype"));
	String refreshTime = Util.null2String(request.getParameter("refreshTime"));
	String needRefresh = Util.null2String(request.getParameter("needRefresh"));
	String showlasthp = Util.null2String(request.getParameter("showlasthp"));
	//out.print("update SystemSet set rsstype='"+rsstype+"',refreshTime='"+refreshTime+"',needRefresh='"+needRefresh+"'");
	String strSql = "update SystemSet set showlasthp = '"+showlasthp+"',defUseNewHomepage='1', rsstype='"+rsstype+"',refreshMins='"+refreshTime+"',needRefresh='"+needRefresh+"'";
	RecordSet.executeSql(strSql);
	SystemComInfo.removeSystemCache() ;
	log.setItem("PortalSetting");
	log.setType("update");
	log.setSql(strSql);
	log.setDesc("修改门户应用设置");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	response.sendRedirect("PortalSetting.jsp");
	
%>
