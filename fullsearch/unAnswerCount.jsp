
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%
int count = 0;
RecordSet.executeSql("select count(1) count from FULLSEARCH_FAQDETAIL where faqStatus = 1");
if(RecordSet.next()){
	count = RecordSet.getInt("count");
}
String data="{\"count\":\""+count+"\"}";
	
	response.getWriter().write(data);
	
%>

