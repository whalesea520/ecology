
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.conn.*,com.weaver.integration.params.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*" %>
<%
	
	String servID = Util.null2String(request.getParameter("servID"));
	JSONObject jsa = new JSONObject();
	boolean flag = ServiceParamsUtil.isExitsLocalParams(servID);
	jsa.accumulate("flag", flag);
    out.clear();
    out.println(jsa);
	
%>