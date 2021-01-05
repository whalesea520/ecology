
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util, com.weaver.integration.datesource.*,com.weaver.integration.log.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<%
	String hpid = Util.null2String(request.getParameter("hpid"));
	int content = SAPInterationDateSourceUtil.getMaxSapServiceNum(hpid);
	JSONObject jsa = new JSONObject();	
	jsa.accumulate("content", content);
    out.clear();
    out.println(jsa);
	
%>