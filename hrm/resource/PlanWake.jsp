<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<META HTTP-EQUIV="Refresh" content="300; URL=/hrm/resource/PlanWake.jsp">
</head>

<BODY background="/images_frame/left_bg1_wev8.gif">


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td height=10></td></tr>
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String formatdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String formattime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String fontcolor = "" ;
boolean hasovertime = false ;
	
String querystr = "select a.requestid as id,c.requestname as subject, b.status as status , b.wakedate ,b.waketime ,"+
				"b.enddate , b.endtime ,b.important from workflow_form a, Bill_HrmResourcePlan b ,workflow_requestbase c  "+
				"where a.billformid='6' and a.billid=b.id and a.requestid = c.requestid and b.resourceid = "+user.getUID()+
				" and ((b.wakedate <= '"+formatdate+"' or b.enddate < '"+formatdate+"') and b.status < '3') and ( b.usestatus != '2' or b.usestatus is null) " +
				" order by  b.wakedate desc ,b.waketime desc ,b.important desc " ;
				
RecordSet.executeSql(querystr);
while(RecordSet.next()) {
String id = Util.null2String(RecordSet.getString("id")) ;
String important = Util.null2String(RecordSet.getString("important")) ;
String wakedate= Util.null2String(RecordSet.getString("startdate")) ;
String waketime= Util.null2String(RecordSet.getString("starttime")) ;
String enddate = Util.null2String(RecordSet.getString("enddate")) ;
String endtime = Util.null2String(RecordSet.getString("endtime")) ;
String subject = Util.toScreen(RecordSet.getString("subject"),user.getLanguage()) ;
String status = Util.null2String(RecordSet.getString("status")) ;

if(important.equals("1")) fontcolor="#11AC43" ;
if(important.equals("2")) fontcolor="#0000FF" ;
if(important.equals("3")) fontcolor="#FF0000" ;

if(waketime.length() < 5) waketime = "00:00" ;
else waketime = waketime.substring(0,5) ;
if(endtime.length() < 5) endtime = "00:00" ;
else endtime = endtime.substring(0,5) ;

if((formatdate+" "+formattime).compareTo(wakedate+" "+waketime) <0 || (formatdate+" "+formattime).compareTo(enddate+" "+endtime) >0 ) {
if((formatdate+" "+formattime).compareTo(enddate+" "+endtime) >0)  hasovertime = true ;
continue ;
}
%>
  <tr><td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=id%>"  target="mainFrame"><font color=<%=fontcolor%>><%=subject%></font></A> <font color=<%=fontcolor%>><% if(status.equals("0")) {%><%=SystemEnv.getHtmlLabelName(1979,user.getLanguage())%>
        <%} else if(status.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%>
        <%} else if(status.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1980,user.getLanguage())%>
		<%} else if(status.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>
		<%} else if(status.equals("4")) {%><%=SystemEnv.getHtmlLabelName(1981,user.getLanguage())%><%}%></font></td></tr><tr><td height=5></td></tr>
<%
}
%>
 </table><br>
<% if(hasovertime) {%><%=SystemEnv.getHtmlLabelName(1982,user.getLanguage())%>:<%}%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td height=10></td></tr>
 <%
fontcolor="#82001D" ;
RecordSet.beforFirst() ;
while(RecordSet.next()) {
String id = Util.null2String(RecordSet.getString("id")) ;
String enddate = Util.null2String(RecordSet.getString("enddate")) ;
String endtime = Util.null2String(RecordSet.getString("endtime")) ;
String subject = Util.toScreen(RecordSet.getString("subject"),user.getLanguage()) ;
String status = Util.null2String(RecordSet.getString("status")) ;

if(endtime.length() < 5) endtime = "00:00" ;
else endtime = endtime.substring(0,5) ;

if((formatdate+" "+formattime).compareTo(enddate+" "+endtime) <= 0 ) continue ;
%>
<tr><td>
  <img src="/images/BacoError_wev8.gif" align=absmiddle><a href="/workflow/request/ViewRequest.jsp?requestid=<%=id%>"  target="mainFrame"><font color=<%=fontcolor%>><%=subject%></font></A> <font color=<%=fontcolor%>><% if(status.equals("0")) {%><%=SystemEnv.getHtmlLabelName(1979,user.getLanguage())%>
        <%} else if(status.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%>
        <%} else if(status.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1980,user.getLanguage())%>
		<%} else if(status.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>
		<%} else if(status.equals("4")) {%><%=SystemEnv.getHtmlLabelName(1981,user.getLanguage())%><%}%></font></td></tr><tr><td height=5></td></tr>
<%
}
%>
</table>
 </BODY></HTML>
