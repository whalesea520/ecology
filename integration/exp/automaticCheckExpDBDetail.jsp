<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
String outerdetailtable = Util.null2String(request.getParameter("outerdetailtable"));//外部明细表

RecordSetDataSource rs = new RecordSetDataSource(datasourceid);
String sql = "";
String result = "-1";
sql = "select 1 from "+outermaintable;
boolean issuccess = rs.executeSql(sql);
if(issuccess){
	if(!outerdetailtable.equals(""))
	{
	sql = "select 1 from "+outerdetailtable;
	issuccess = rs.executeSql(sql);
	if(issuccess){

	}else{
		result="1";
	}
	}
}
else
{
	result="0";
}
out.println(""+result);
%>
