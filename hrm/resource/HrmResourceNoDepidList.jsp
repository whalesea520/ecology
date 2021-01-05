
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(83708,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  </COLGROUP>
  <TBODY>
  <TR class=Header><TH colSpan=5><%=SystemEnv.getHtmlLabelName(83708,user.getLanguage()) %></TH></TR>
  <TR class=Header>
	<TD><%=SystemEnv.getHtmlLabelName(81787,user.getLanguage()) %></TD>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage()) %></TD>
    <TD><%=SystemEnv.getHtmlLabelName(83710,user.getLanguage()) %></TD>
	<TD><%=SystemEnv.getHtmlLabelName(30585,user.getLanguage()) %></TD>
  </TR>

<%
String sql = "select id,loginid,account,lastname,subcompanyid1,departmentid from HrmResource where (subcompanyid1 is null or subcompanyid1=0) or (departmentid is null or departmentid=0)";
rs.executeSql(sql);
int i=0;
while(rs.next()){
	String trclass = i%2==0?"datalight":"datadark";
	int id = Util.getIntValue(rs.getString("id"),0);
	String loginid = Util.null2String(rs.getString("loginid"));
	String account = Util.null2String(rs.getString("account"));
	String lastname = Util.null2String(rs.getString("lastname"));
	int subcompanyid1 = Util.getIntValue(rs.getString("subcompanyid1"),0);
	int departmentid = Util.getIntValue(rs.getString("departmentid"),0);
	String outstring = "";
	if(subcompanyid1==0){
		outstring = ""+SystemEnv.getHtmlLabelName(83711,user.getLanguage());
	}
	if(departmentid==0){
		if(!outstring.equals("")){
			outstring = outstring + ",";
		}
		outstring = outstring + ""+SystemEnv.getHtmlLabelName(83714,user.getLanguage());
	}
%>

    <TR class="<%=trclass%>">
<%

%>
		<TD><%=account%></TD>
		<TD><%=lastname%></TD>
		<TD><%=outstring%></TD>
		<TD><a href="/hrm/resource/HrmResource.jsp?1=1&id=<%=id%>" target="_blank"><%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %></a></TD>
	</TR>
<%
}
%>
 </TBODY></TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>


</BODY></HTML>
