
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*" %>
<%
	
	String regServiceId = Util.null2String(request.getParameter("regservice"));
	String sql = "select serdesc　from sap_service where id="+regServiceId;
	RecordSet rs = new RecordSet();
	rs.execute(sql);
	String content = "";
	if(rs.next()) {
		content = rs.getString("serdesc");
	}
	
	JSONObject jsa = new JSONObject();
	jsa.accumulate("content", content);
    out.clear();
    out.println(jsa);
	
%>