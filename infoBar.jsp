<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String username = user.getUsername() ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;
%>
<html>
<head>
<title>高效源于协同</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/Weaver_wev8.css" type="text/css">
</head>
<body>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
	<td  background = "/images_face/ecologyFace_1/TopMenuBg_2_wev8.gif" width="70%" height="27">
	</td>
	<td  background = "/images_face/ecologyFace_1/TopMenuBg_3_wev8.gif" width="30%">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="31" valign="top"><img src="/images_face/ecologyFace_1/TopMenuImg_1_wev8.gif" border="0">
			</td>
			<td>
				<%=username%> 
				<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%><%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
				<%} else if(currenthour.compareTo("12") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
				<%} else if(currenthour.compareTo("14") <= 0 ) {%><%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
				<%} else if(currenthour.compareTo("18") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%><%}%>! <%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%><%=currentyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=currentmonth%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=currentdate%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>

</body>
</html>
