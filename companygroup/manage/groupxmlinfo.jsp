
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String groupid = Util.null2String(request.getParameter("groupid"));

String xmlContent="";
if(groupid.equals("")){
	rs.execute("select * from CPCOMPANYINFO where companyid='"+groupid+"'");
}else{
	rs.execute("select * from CPCOMPANYINFO where company");
}
rs.execute("select * from ");
%>
<?xml version="1.0" encoding="utf-8"?>
<root>
	<companyinfo>
		<name><![CDATA[上海泛微]]></name>
	</companyinfo>
</root>
