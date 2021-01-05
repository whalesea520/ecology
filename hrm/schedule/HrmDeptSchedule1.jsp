<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(369,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmDeptScheduleAdd:Add", user);
int dept_id=Util.getIntValue(request.getParameter("id"),0);
char separator = Util.getSeparator() ;
String id="";
RecordSet.executeProc("HrmSchedule_Select_CheckExist",""+dept_id+separator+"1");
if(RecordSet.next()){
	id=RecordSet.getString("id");
	response.sendRedirect("/hrm/schedule/HrmDeptSchedule2.jsp?id="+id);
	return;
}

String dept_name=DepartmentComInfo.getDepartmentname(dept_id+"");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmDeptScheduleAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(516,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<table class="Viewform">
	<TR class=Title> 
          <TH width="30%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
          <TH width="70%"><%=Util.toScreen(dept_name,user.getLanguage())%></TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1 colspan=2></TD>
        </TR>
        <tr>
          <td colspan=2><%=SystemEnv.getHtmlLabelName(400,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(369,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>.<a href="HrmDefaultSchedule.jsp"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(369,user.getLanguage())%></a></td>
        </tr>
</table>
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
</body>
</html>