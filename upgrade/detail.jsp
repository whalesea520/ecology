
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
</HEAD>
<%
String message = request.getParameter("message");
String id = request.getParameter("id");
String values = "";
if("content".equals(message)) {
	RecordSet.execute(" select content from ecologyuplist where id="+id);
	if(RecordSet.next()) {
		values = RecordSet.getString("content");
	}
	
} else {
	RecordSet.execute(" select configcontent from ecologyuplist where id="+id);
	if(RecordSet.next()) {
		values = RecordSet.getString("configcontent");
	}
	
}


values = values.replaceAll("<p>","");
values = values.replaceAll("</p>","");
values = values.replaceAll("<br>","\n");
values = values.replaceAll("<","&lt;");
values = values.replaceAll(">","&gt;");
//System.out.println("values:"+values); 
%>

<BODY>
<pre>
<code>
<%=values %>
</code>
</pre>
</BODY>
</HTML>

