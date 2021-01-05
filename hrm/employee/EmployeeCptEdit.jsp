
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
String method ="cpt";
String id=request.getParameter("id");//此项目的id
String edit=request.getParameter("edit");//登陆者是否能编辑
String hrmid=request.getParameter("hrmid");

String Sql=("select lastname from HrmResource where id="+hrmid);
RecordSet.executeSql(Sql);
RecordSet.next();
String name = RecordSet.getString("lastname");


String cptmark="";
String cptname="";
RecordSet.executeProc("Employee_CptSelectByID",hrmid);

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/employee/EmployeeManage.jsp?hrmid="+hrmid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(edit.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",/hrm/employee/EmployeeOperation.jsp?hrmid="+hrmid+"&method="+method+"&id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1378,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp?hrmid="+hrmid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<table class=viewform>
  <colgroup>
  <col width="10%">
  <col width="30%">
  <col width="70%">
<TR>
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <td class=field>
       <%=name%>
      <input type=hidden name=hrmid value="<%=hrmid%>">
       </td>
       <td>&nbsp</td>
</TR>

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="40%">
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%	
	while(RecordSet.next()){
%>
<TR CLASS=DataDark>
<TD><%=Util.toScreen(RecordSet.getString("mark"),user.getLanguage())%></TD>
<TD><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
<TD><%=Util.toScreen(RecordSet.getString("cptnum"),user.getLanguage())%></TD>
</TR>
<%}%>
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
</table>
</BODY>
</HTML>