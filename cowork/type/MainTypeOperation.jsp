
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String id = Util.null2String(request.getParameter("id"));
String typename = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String sequence = Util.fromScreen(request.getParameter("sequence"),user.getLanguage());
String mypath = Util.null2String(request.getParameter("mypath"));
String sql="";
char flag = 2;
String Proc="";

if(operation.equals("add")){
	
	
	sql="insert into cowork_maintypes(typename,category , sequence) values ('"+Util.fromScreen2(typename,user.getLanguage())+"','"+mypath+"',"+sequence+")";
	RecordSet.executeSql(sql);
	
	
	RecordSet.execute("select id from cowork_maintypes where sequence = "+sequence+" and typename ! = '"+typename+"'");
	while(RecordSet.next()){
		// RecordSet.execute("update cowork_maintypes set sequence = sequence+1 where sequence >= "+sequence+" and typename != '"+typename+"'");
	}
	
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}
else if(operation.equals("edit")){
	sql="update cowork_maintypes set typename='"+Util.fromScreen2(typename,user.getLanguage())+"',category='"+mypath+"' , sequence = "+sequence+" where id="+id;
	RecordSet.executeSql(sql);
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}
else if(operation.equals("delete")){
	RecordSet.executeSql("delete from cowork_maintypes where id in ("+id+")");
} 
CoMainTypeComInfo.removeCoMainTypeCache();

//response.sendRedirect("/cowork/type/CoworkMainType.jsp");
%>