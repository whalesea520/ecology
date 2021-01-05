<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String sqlStr = "" ;
String method = Util.null2String(request.getParameter("method"));
if(method.equals("add"))
{
	String name=Util.null2String(request.getParameter("name"));
	String mailDesc=Util.null2String(request.getParameter("mailDesc"));
	name=name.trim();
	mailDesc=mailDesc.trim();
	sqlStr = "insert into webMailList(name,mailDesc) values(";
	sqlStr +="'"+Util.fromScreen2(name,user.getLanguage())+"'," ;
	sqlStr +="'"+Util.fromScreen2(mailDesc,user.getLanguage())+"'" ;
	sqlStr +=")";
	RecordSet.executeSql(sqlStr);	
	response.sendRedirect("/web/mailList/MailList.jsp");

	return;
}

String webIDs[]=request.getParameterValues("webIDs");
if(method.equals("delete"))
{
	if(webIDs != null)
	{
		for(int i=0;i<webIDs.length;i++)
		{
			sqlStr = "DELETE FROM webMailList where id=" + webIDs[i];
            RecordSet.executeSql(sqlStr);			
		}
	}
	response.sendRedirect("/web/mailList/MailList.jsp");
	return;
}

if(method.equals("edit"))
{   
    String id=Util.null2String(request.getParameter("id"));
	String name=Util.null2String(request.getParameter("name"));
	String mailDesc=Util.null2String(request.getParameter("mailDesc"));
	name=name.trim();
	mailDesc=mailDesc.trim();

	sqlStr = "UPDATE webMailList set " ;
	sqlStr += " name = '" + Util.fromScreen2(name,user.getLanguage()) + "' , " ;
	sqlStr += " mailDesc = '" + Util.fromScreen2(mailDesc,user.getLanguage()) + "' " ;
	sqlStr += " where id = " + id ;
	RecordSet.executeSql(sqlStr);	

	response.sendRedirect("/web/mailList/MailList.jsp");

	return;
}

%>
