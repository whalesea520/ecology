<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
String username = user.getUsername() ;

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
<title><%=SystemEnv.getHtmlLabelName(84169,user.getLanguage())%></title>
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">
</head>

<SCRIPT language=javascript>
function mnToggleleft(){
	var f = window.top.MainBottom;
	if (f != null) {
		var c = f.cols;
		if (c == "0,8,*,8") 
			{f.cols = "162,8,*,8"; LeftHideShow.src = "/images_frame/dh/BP_Hide_wev8.gif"; LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"}	
		else 
			{ f.cols = "0,8,*,8"; LeftHideShow.src = "/images_frame/dh/BP_Show_wev8.gif"; LeftHideShow.title = "<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>"}
	}
}
function mnToggletop(){
	var f = window.top.Main;
	if (f != null) {
		var c = f.rows;
		if (c == "0,*") 
			{f.rows = "75,*"; TopHideShow.src = "/images_frame/dh/BP2_Hide_wev8.gif"; TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"}	
		else 
			{ f.rows = "0,*"; TopHideShow.src = "/images_frame/dh/BP2_Show_wev8.gif"; TopHideShow.title = "<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>"}
	}
}
</SCRIPT>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td background="/images_frame/portal/bg_4_wev8.gif" height ="10" colspan="3">
  </tr>
  <tr>
    <td background="/images_frame/portal/bg_3_wev8.gif" style="PADDING-TOP: 3px" vAlign=top height ="27" width = "80">&nbsp; 
    <IMG id=LeftHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggleleft() src="/images_frame/dh/BP_Hide_wev8.gif" >
    <IMG id=TopHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggletop() src="/images_frame/dh/BP2_Hide_wev8.gif"></td>
	<td background="/images_frame/portal/bg_3_wev8.gif" align="left" class="wenhou">
	<%if(user.getLanguage()==7||user.getLanguage()==9){%>
		<%=username%> 
		<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
			<%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		<%} else if(currenthour.compareTo("12") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		<%} else if(currenthour.compareTo("14") <= 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		<%} else if(currenthour.compareTo("18") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		<%}%>
			! <%=SystemEnv.getHtmlLabelName(16645,user.getLanguage())%><%=currentyear%>/<%=currentmonth%>/<%=currentdate%>
	<%}else{%>
		<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
			<%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		<%} else if(currenthour.compareTo("12") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		<%} else if(currenthour.compareTo("14") <= 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		<%} else if(currenthour.compareTo("18") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		<%}%>
			!<%=username%> 
	<%}%>
	</td>
     <td background="/images_frame/portal/bg_3_wev8.gif"  width=232 style="PADDING-TOP: -3px" vAlign=top> 
	 <%if(!logintype.equals("2")){%>
			<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height=27 width=200 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
	 <%}%>
	 </td>
  </tr>
  <tr>
  <td height="5" colspan="3"></td>
  </tr>
</table>
</body>


</html>