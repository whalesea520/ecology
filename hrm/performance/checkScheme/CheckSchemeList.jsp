<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>


<%
String CurrentUser = ""+user.getUID();


//ÅÐ¶ÏµÇÂ½Õß£­£­£­£­//
String sql_10="select hrmid from HrmInfoMaintenance where id =10 ";
RecordSet.executeSql(sql_10);
RecordSet.next();
String hrmid_10= RecordSet.getString("hrmid");
boolean canedit_10=false;
if(CurrentUser.equals(hrmid_10)){
    canedit_10=true;
}
String sql_1="select hrmid from HrmInfoMaintenance where id =1 ";
RecordSet.executeSql(sql_1);
RecordSet.next();
String hrmid_1= RecordSet.getString("hrmid");
boolean canedit_1=false;
if(CurrentUser.equals(hrmid_1)){
    canedit_1=true;
}
String sql_2="select hrmid from HrmInfoMaintenance where id =2 ";
RecordSet.executeSql(sql_2);
RecordSet.next();
String hrmid_2= RecordSet.getString("hrmid");
boolean canedit_2=false;
if(CurrentUser.equals(hrmid_2)){
    canedit_2=true;
}
String sql_3="select hrmid from HrmInfoMaintenance where id =3 ";
RecordSet.executeSql(sql_3);
RecordSet.next();
String hrmid_3= RecordSet.getString("hrmid");
boolean canedit_3=false;
if(CurrentUser.equals(hrmid_3)){
    canedit_3=true;
}
String sql_4="select hrmid from HrmInfoMaintenance where id =4 ";
RecordSet.executeSql(sql_4);
RecordSet.next();
String hrmid_4= RecordSet.getString("hrmid");
boolean canedit_4=false;
if(CurrentUser.equals(hrmid_4)){
    canedit_4=true;
}
String sql_5="select hrmid from HrmInfoMaintenance where id =5 ";
RecordSet.executeSql(sql_5);
RecordSet.next();
String hrmid_5= RecordSet.getString("hrmid");
boolean canedit_5=false;
if(CurrentUser.equals(hrmid_5)){
    canedit_5=true;
}
String sql_6="select hrmid from HrmInfoMaintenance where id =6 ";
RecordSet.executeSql(sql_6);
RecordSet.next();
String hrmid_6= RecordSet.getString("hrmid");
boolean canedit_6=false;
if(CurrentUser.equals(hrmid_6)){
    canedit_6=true;
}
String sql_7="select hrmid from HrmInfoMaintenance where id =7 ";
RecordSet.executeSql(sql_7);
RecordSet.next();
String hrmid_7= RecordSet.getString("hrmid");
boolean canedit_7=false;
if(CurrentUser.equals(hrmid_7)){
    canedit_7=true;
}
String sql_8="select hrmid from HrmInfoMaintenance where id =8 ";
RecordSet.executeSql(sql_8);
RecordSet.next();
String hrmid_8= RecordSet.getString("hrmid");
boolean canedit_8=false;
if(CurrentUser.equals(hrmid_8)){
    canedit_8=true;
}
String sql_9="select hrmid from HrmInfoMaintenance where id =9 ";
RecordSet.executeSql(sql_9);
RecordSet.next();
String hrmid_9= RecordSet.getString("hrmid");
boolean canedit_9=false;
if(CurrentUser.equals(hrmid_9)){
    canedit_9=true;
}
if((HrmUserVarify.checkUserRight("CheckScheme:Performance",user))||canedit_1||canedit_2||canedit_3||canedit_4||canedit_5||canedit_6||canedit_7||canedit_8||canedit_9||canedit_10){//È¨ÏÞÅÐ¶Ï
    		


RecordSet.execute("select * from HrmPerformanceCheckScheme ");


%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(18049,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

if(HrmUserVarify.checkUserRight("CheckScheme:Performance",user)) {	
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CheckSchemeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="55%">
  <COL width="10%">
 
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="3" style="padding:0"></TD></TR> 
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="CheckSchemeEdit.jsp?id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("schemeName"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("memo"),user.getLanguage())%></TD>
		<TD><%
		if ((RecordSet.getString("status")).equals("0")) 
		{
		out.print(SystemEnv.getHtmlLabelName(18095,user.getLanguage()));
		}
		else {
		out.print(SystemEnv.getHtmlLabelName(18096,user.getLanguage()));
		}
		%></TD>
	</TR>
<%
	}
%>
 </TABLE>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</BODY>
</HTML>
    <%}
else{
response.sendRedirect("/notice/noright.jsp");
    		return;
	}%>
