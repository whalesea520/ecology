<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.online.HrmUserOnlineMap" %>
<%@page import="weaver.general.Util"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="weaver.login.LicenseCheckLogin"%>
<%@page import="weaver.general.BaseBean"%>

<%

	String type = Util.null2String(request.getParameter("type")) ;

	if("userOffline".equals(type)){
		// uid
		String uid = Util.null2String(request.getParameter("uid")) ;
		if(StringUtils.isNotBlank(uid)){
			new LicenseCheckLogin().userOffline(uid);
			Map userSessions = application == null ? null : (Map) application.getAttribute("userSessions");
			List<HttpSession> slist = (userSessions != null && userSessions.containsKey(uid)) ? (List<HttpSession>)userSessions.get(uid) : null;
			int lsize = slist == null ? 0 : slist.size();
			for(int i=0; i<lsize; i++){
				try{slist.get(i).setAttribute("userOffline","1");}catch(IllegalStateException e){}
			}
		}
		new BaseBean().writeLog("强制下线【"+uid+"】>>>"+uid) ;
		out.println("0");
		return ;
	}else{
		//out.clearBuffer();
		String jsonStr = HrmUserOnlineMap.getInstance().getCacheMapJSON();
		out.println(jsonStr);
	}
%>
