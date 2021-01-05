
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.BaseBean" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalModifyFieldComInfo" class="weaver.cpt.capital.CapitalModifyFieldComInfo" scope="page"/>

<%
String tablename = Util.null2String(request.getParameter("tablename"));
String ffname = Util.null2String(request.getParameter("ffname"));
String fflabel = Util.fromScreen2(request.getParameter("fflabel"),user.getLanguage());
String ffuse = Util.null2String(request.getParameter("ffuse"));
int whereid = 28;

if(ffname.indexOf("dff") != -1 || ffname.indexOf("nff") != -1 || ffname.indexOf("tff") != -1 || ffname.indexOf("bff") != -1){
	if (ffname.indexOf("dff") != -1) whereid +=0;
	if (ffname.indexOf("nff") != -1) whereid +=5;
	if (ffname.indexOf("tff") != -1) whereid +=10;
	if (ffname.indexOf("bff") != -1) whereid +=15;
	whereid = whereid + (Util.getIntValue(ffname.substring(3,5),0) - 1);
}else if(ffname.indexOf("docff") != -1 || ffname.indexOf("depff") != -1 || ffname.indexOf("crmff") != -1 || ffname.indexOf("reqff") != -1){
	if (ffname.indexOf("docff") != -1) whereid +=28;
	if (ffname.indexOf("depff") != -1) whereid +=33;
	if (ffname.indexOf("crmff") != -1) whereid +=38;
	if (ffname.indexOf("reqff") != -1) whereid +=43;
	whereid = whereid + (Util.getIntValue(ffname.substring(5,7),0) - 1);	
}

//out.print(whereid);
if("cp".equalsIgnoreCase(tablename)){
	RecordSet.executeSql("update CptCapitalModifyField set name = '" + fflabel + "' where field = " + whereid);
	CapitalModifyFieldComInfo.removeCapitalModifyFieldCache();
}



RecordSet.executeSql("update Base_FreeField set "+ffname+"name='"+fflabel+"',"+ffname+"use="+ffuse+" where tablename='"+tablename+"'");

response.sendRedirect("/base/ffield/ListFreeField.jsp?tablename="+tablename);
%>