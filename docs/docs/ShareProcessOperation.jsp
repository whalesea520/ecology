
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");		
//String sessionkey = "ShareManageDocOperation_" + user.getLoginid() + "_" + operatedate + "_" + operatetime;
String secid =Util.null2String(request.getParameter("secid"));
ShareManageDocOperation manager = new ShareManageDocOperation();
    manager.setRequest(request);		
	manager.setUserid(user.getUID());
	manager.setUser(user);	
	manager.DoSynchronousDocShareBySec(secid);
	
	Thread.sleep(1000);
	
//session.setAttribute(sessionkey,manager);
//session.removeAttribute(sessionkey);

%>
