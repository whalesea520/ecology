<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.*,java.util.*,org.apache.commons.lang3.*"%>
<%
User user = null ;
try{
	user = HrmUserVarify.getUser (request , response) ;
}catch(Exception e){
}
String uid = user.getUID()+"";
String docid = Util.null2String(request.getParameter("id"));
try{
	weaver.cowork.CoworkDAO cd = new weaver.cowork.CoworkDAO();
	cd.shareCoworkRelateddoc(1,Util.getIntValue(docid),user.getUID());
}catch(Exception e){
	
}
response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid);
return ;
%>