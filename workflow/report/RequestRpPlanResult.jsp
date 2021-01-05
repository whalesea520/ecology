
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String userid =""+user.getUID();

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;

int resourceid = Util.getIntValue(request.getParameter("resourceid"),0);
int accepterid = Util.getIntValue(request.getParameter("accepterid"),0);
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
if(begindate.equals(""))
	begindate = currentdate;
if(enddate.equals(""))
	enddate = currentdate;
	
String beginyear = begindate.substring(0,4);
String beginmontd = begindate.substring(5,7);
String beginday = begindate.substring(8,10);
String endyear = enddate.substring(0,4);
String endmontd = enddate.substring(5,7);
String endday = enddate.substring(8,10);

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15524,user.getLanguage()) ;
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
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">




<TABLE class=viewform cellspacing=1   width=100%>

<tr class="Header">
<td colspan=2 align=center>
<img src="/weaver/weaver.workflow.report.ShowRpPlan?startdate=<%=begindate%>&enddate=<%=enddate%>&resourceid=<%=resourceid%>&accepterid=<%=accepterid%>" border=0>
</td>
</tr><tr><td class="Line"></td></tr>
<tr>
<td colspan=2 align=center><font size = 4><b><%=SystemEnv.getHtmlLabelName(15526,user.getLanguage())%></b></font>
</td>
</tr><tr><td class="Line"></td></tr>
<TR class="Title">
<th width=60%><%=SystemEnv.getHtmlLabelName(15332,user.getLanguage())%>:</th>
<th width=35%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%=beginyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=beginmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=beginday%><%=SystemEnv.getHtmlLabelName(15333,user.getLanguage())%><%=endyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=endmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=endday%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></th>
</tr>
<tr><td class="Line1"></td></tr>
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
