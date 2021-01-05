<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String sqlStr = "" ;
String method = Util.null2String(request.getParameter("method"));

if(method.equals("add"))
{
	String newsid = Util.null2String(request.getParameter("newsid"));
	String docid = Util.null2String(request.getParameter("docid"));
	String languageid = Util.null2String(request.getParameter("languageid"));
	String isTime = Util.null2String(request.getParameter("isTime"));
	String simple = Util.null2String(request.getParameter("simple"));

	String name=Util.null2String(request.getParameter("name"));
	String mail=Util.null2String(request.getParameter("mail"));
	String comment=Util.null2String(request.getParameter("comment"));
	
	name=name.trim();
	mail=mail.trim();
	comment=comment.trim();
	sqlStr = "insert into DocWebComment(docId,name,mail_1,comment_1,createDate,createTime) values(" + docid ;
	sqlStr +=",'"+name+"'" ;
	sqlStr +=",'"+mail+"'" ;
	sqlStr +=",'"+comment+"'" ;
	sqlStr +=",'"+CurrentDate+"'" ;
	sqlStr +=",'"+CurrentTime+"'" ;
	sqlStr +=")";
	RecordSet.executeSql(sqlStr);	response.sendRedirect("/web/WebDetailDsp.jsp?newsid="+newsid+"&id="+docid+"&languageid="+languageid+"&isTime="+isTime+"&simple="+simple+"&fromComment=1");
	return;
}

String commentIDs[]=request.getParameterValues("commentIDs");
if(method.equals("delete"))
{
	if(commentIDs != null)
	{
		for(int i=0;i<commentIDs.length;i++)
		{
			sqlStr = "DELETE FROM DocWebComment where id=" + commentIDs[i];
            RecordSet.executeSql(sqlStr);			
		}
	}
	response.sendRedirect("/web/comment/CommentList.jsp?isSearch=1");
	return;
}

%>
