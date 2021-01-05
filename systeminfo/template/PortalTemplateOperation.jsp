
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page import="org.apache.commons.fileupload.*" %>

<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String method = Util.null2String(request.getParameter("method"));

	if(method.equals("updateThemeInfo")){
		String id = Util.null2String(request.getParameter("id"));
		String templatetype = Util.null2String(request.getParameter("templatetype"));
		String skin = Util.null2String(request.getParameter("skin"));
		rs.executeSql("update SystemTemplate set skin='"+skin+"', templatetype='"+templatetype+"' where id="+id);
	
	}if(method.equals("savebase")){
		String id = Util.null2String(request.getParameter("id"));
		String templatename = Util.null2String(request.getParameter("templatename"));
		String templatetitle = Util.null2String(request.getParameter("templatetitle"));
		rs.executeSql("update SystemTemplate set templatename='"+templatename+"', templatetitle='"+templatetitle+"' where id="+id);
	}if(method.equals("add")){
		String id = Util.null2String(request.getParameter("id"));
		String templatename = Util.null2String(request.getParameter("templatename"));
		String templatetitle = Util.null2String(request.getParameter("templatetitle"));
		String subCompanyid = Util.null2String(request.getParameter("subCompanyid"));
		String sql =" INSERT INTO SystemTemplate (templatetype,extendtempletid,skin,templateName,templatetitle,companyId,isopen) values('ecology8',0,1,'"+templatename+"','"+templatetitle+"','"+subCompanyid+"',0)";
		rs.executeSql(sql);
	}if(method.equals("updateThemeInfoandenable")){
		String id = Util.null2String(request.getParameter("id"));
		String templatetype = Util.null2String(request.getParameter("templatetype"));
		String skin = Util.null2String(request.getParameter("skin"));
		rs.executeSql("update SystemTemplate set skin='"+skin+"',isopen=1, templatetype='"+templatetype+"' where id="+id);
	}
%>
