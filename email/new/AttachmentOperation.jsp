
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String mailfileid = Util.null2String(request.getParameter("mailfileid"));
	String operation = Util.null2String(request.getParameter("operation"));
	if("getSize".equals(operation)){
		rs.execute("select sum(filesize) from MailResourceFile where id in ("+mailfileid+")");
		
		rs.next();
		out.print(rs.getInt(1));
		return;
		
	}else{
		rs.execute("SELECT id  FROM MailResource WHERE id = ( SELECT mailid  FROM MailResourceFile WHERE id = '"+mailfileid+"')");
		rs.next();
		String info = rs.getString("id");
		out.print(info);
		return;
	}

	
%>