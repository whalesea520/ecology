
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" /> 
	
<%
	int docId= Util.getIntValue(request.getParameter("docId"),0);
	
	DocManager.resetParameter();
	DocManager.setId(docId);
	DocManager.getDocInfoById();
	
	String docsubject=DocManager.getDocsubject();
	
	rs.executeSql("select imagefileid from DocImageFile where docid="+docId+" and imagefilename like '%"+docsubject+"%' ");
	if(rs.next()){
		out.println(rs.getString(1));
	} else {
		rs.executeSql("select imagefileid from DocImageFile where docid="+docId );
		if(rs.next()){
			out.println(rs.getString(1));
		}	
	}
%>	
