
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util, com.weaver.integration.params.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<%
	String type = Util.null2String(request.getParameter("type")).trim();
	String serviceId = Util.null2String(request.getParameter("seviceId")).trim();
	String paramName = Util.null2String(request.getParameter("paramName")).trim();
	String compParamName = Util.null2String(request.getParameter("compParamName")).trim();
	String content = ServiceParamsUtil.isExitsParam(type, serviceId, paramName,compParamName);
	boolean flag = false;
	String message = "";
	if(content != null) {
		flag = true;
		message = content.trim();
	}
	JSONObject jsa = new JSONObject();
	jsa.accumulate("flag", flag);
	jsa.accumulate("message", message);
    out.clear();
    out.println(jsa);
	
%>