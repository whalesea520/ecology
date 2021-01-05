
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	RecordSet.executeProc("Prj_PlanSort_SelectAll","");
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=FindData");
		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(407,user.getLanguage())+SystemEnv.getHtmlLabelName(455,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%
if(HrmUserVarify.checkUserRight("AddPlanSort:add", user)){
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/proj/Maint/AddPlanSort.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%}
%>
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
		
<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  </tr>
  <tr><th class="line1"></th><th class="line1"></th></tr>
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
		<TD><a href="/proj/Maint/EditPlanSort.jsp?id=<%=Util.toScreen(RecordSet.getString(1),user.getLanguage())%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%></TD>
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
</table>


</FORM>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
