<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="java.sql.*"%>
<%@ page import="weaver.general.Util,weaver.interfaces.datasource.*"%>
<%
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
if("".equals(datasourceid))
	out.print("0");
else{
	BaseDataSource BaseDataSource = new BaseDataSource();
	String istest = ""+BaseDataSource.testDataSource(datasourceid,5);
	out.print(istest);
}
%>
