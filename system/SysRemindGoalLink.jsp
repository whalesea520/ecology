
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
String type=Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15148,user.getLanguage()); //计划提交 //报告 //目标 
if(type.equals("3")) titlename=SystemEnv.getHtmlLabelName(18106,user.getLanguage())+titlename;
else if(type.equals("4")) titlename=SystemEnv.getHtmlLabelName(18107,user.getLanguage())+titlename;
else if(type.equals("5")) titlename=SystemEnv.getHtmlLabelName(18108,user.getLanguage())+titlename;
String needfav ="1";
String needhelp ="";
String requestids="-1000";
RecordSetu.execute("select * from SysPoppupInfo where type="+type);
RecordSetu.next();
RecordSetd.execute("select requestid from SysPoppupRemindInfoNew where userid="+user.getUID()+" and type="+type);
while (RecordSetd.next())   requestids=requestids+","+Util.null2String(RecordSetd.getString(1));
if (!requestids.equals(""))
{
RecordSet.execute("select * from HrmPerformanceAlertCheck where objId="+user.getUID()+" and id in ("+requestids+") ");
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="1">
<col width="">
<col width="1">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<form name="planform" method="post" action="PlanOperation.jsp">
<table class=shadow>
<tr><td valign=top>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
  
  <th><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
  
  </tr>
 <TR class=Line><TD colspan="2" ></TD></TR> 
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
		<TD>
		<%
		String urls="";
		String cycle=RecordSet.getString("cycle");
		String planDate=RecordSet.getString("performanceDate");
		if (RecordSet.getString("performanceType").equals("0"))
		{
		urls="/hrm/performance/goal/myGoalFrame.jsp?cycle="+cycle;
		}
		else if (RecordSet.getString("performanceType").equals("1"))
		{
		urls="/hrm/performance/targetPlan/PlanMain.jsp?cycle="+cycle+"&planDate="+planDate+"&objId="+RecordSet.getString("objId");
		}
		else
		{
		urls="/hrm/performance/targetReport/ReportMain.jsp?cycle="+cycle+"&planDate="+planDate+"&objId="+RecordSet.getString("objId");
		}
		
		if (!RecordSet.getString("performanceType").equals("0"))
		{
		if (cycle.equals("0"))
		{
		String years=planDate.substring(0,4);
		urls=urls+"&years="+years;
		}
		else if (cycle.equals("2"))
		{
		String years=planDate.substring(0,4);
		String months=planDate.substring(4,planDate.length());
		urls=urls+"&years="+years+"&months="+months;
		}
		else if (cycle.equals("1"))
		{
		String years=planDate.substring(0,4);
		String quarters=planDate.substring(4,planDate.length());
		urls=urls+"&years="+years+"&quarters="+quarters;
		
		}
		else if (cycle.equals("3"))
		{
		String years=planDate.substring(0,4);
		String weeks=planDate.substring(4,planDate.length());
		urls=urls+"&years="+years+"&weeks="+weeks;
		
		}
		}
		else
		{
		urls=urls+"&goalDate="+planDate+"&objId="+RecordSet.getString("objId")+"&goalType=3";
		}
		
		%>
		<a href="<%=urls%>"><%=Util.toScreen(RecordSet.getString("alertName"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSetu.getString("description"),user.getLanguage())%></TD>
	</TR>
<%
	}
	
	
%>

</td>
</tr>
</TABLE>
</td>
</tr>
</TABLE>
</form>
</td>
<td></td>
</tr>
</TABLE>
</BODY>

</HTML>
    
