<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init1.jsp" %>
<jsp:useBean id="hr" class="java.util.Hashtable" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
int inprepId = Util.getIntValue(request.getParameter("inprepId"),0);//调查种类ID
int inputId = Util.getIntValue(request.getParameter("inputId"),0);//调查ID
int mailid = 0 ;
String sqlStr = "" ;
String body = "";
String tempbody = "";
sqlStr = "select mailid from T_SurveyItem where inprepid="+inprepId ;
RecordSet.executeSql(sqlStr) ;
if(RecordSet.next()) mailid = Util.getIntValue(RecordSet.getString("mailid"),0) ;

sqlStr = "select mouldtext from DocMailMould where id = "+mailid;
RecordSet.executeSql(sqlStr);
if(RecordSet.next()){
	body = Util.null2String(RecordSet.getString(1));
}

int pos = body.indexOf("<IMG");
while(pos!=-1){
	pos = body.indexOf("src=",pos);
	int endpos = body.indexOf(">",pos);
	String middlestr = body.substring( pos , endpos ) ;
	if ( middlestr.indexOf( "weaver.file.FileDownload" ) != -1 ) {
		String bodycontent = body.substring(0,pos+5); 
		bodycontent += "http://"+request.getServerName();
		bodycontent += body.substring(pos+5);
		body = bodycontent ;
		endpos = body.indexOf(">",pos);
	}
	pos = body.indexOf("<IMG",endpos);
}

hr.put("Cust_crmid","0");
hr.put("Cust_contactid","0");
hr.put("Cust_inputid",""+inputId);
tempbody = Util.fromBaseEncoding(Util.fillValuesToString(body,hr),language) ;

%>
<%=tempbody%>