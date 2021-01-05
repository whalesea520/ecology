<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16579,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage());
String needfav ="1"; 
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String startdate1=Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());
String startdate2=Util.fromScreen(request.getParameter("startdate2"),user.getLanguage());
String enddate1=Util.fromScreen(request.getParameter("enddate1"),user.getLanguage());
String enddate2=Util.fromScreen(request.getParameter("enddate2"),user.getLanguage());

String sql="select count(*) count,t2.workflowtype,t1.currentnodetype from workflow_requestbase t1,workflow_base t2"+
			" where t1.workflowid=t2.id and t1.deleted=0";
if(!startdate1.equals(""))	sql+=" and t1.createdate>='"+startdate1+"'";
if(!startdate2.equals(""))	sql+=" and t1.createdate<='"+startdate2+"'";
if(!enddate1.equals(""))	sql+=" and t1.lastoperatedate>='"+enddate1+"'";
if(!enddate2.equals(""))	sql+=" and t1.lastoperatedate<='"+enddate2+"'";

sql+=" group by t2.workflowtype,t1.currentnodetype order by t2.workflowtype,t1.currentnodetype";
%>
<form name=frmmain method=post action="WorkflowTypeRp.jsp">

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


<table class="viewform">
   <tr class="Title"><th colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
   <TR class="Spacing"><TD colspan=4 class=line1></TD></TR>
<tr>
   <td width="15%"><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></td>
   <td width="35%"><BUTTON type='button' class=calendar onclick="getStartDate1()"></BUTTON>&nbsp;
      	<SPAN id=startdatespan1 ><%=startdate1%></SPAN>
      	-&nbsp;&nbsp;<BUTTON type='button' class=calendar onclick="getStartDate2()"></BUTTON>&nbsp;
      	<SPAN id=startdatespan2  ><%=startdate2%></SPAN>
	<input type="hidden" name="startdate1" value=<%=startdate1%>><input type="hidden" name="startdate2" value=<%=startdate2%>>
   </td>
   <td width="15%"><%=SystemEnv.getHtmlLabelName(733,user.getLanguage())%></td>
   <td width="35%"><BUTTON type='button' class=calendar onclick="getEndDate1()"></BUTTON>&nbsp;
      	<SPAN id=enddatespan1 ><%=enddate1%></SPAN>
      	-&nbsp;&nbsp;<BUTTON type='button' class=calendar onclick="getEndDate2()"></BUTTON>&nbsp;
      	<SPAN id=enddatespan2  ><%=enddate2%></SPAN>
	<input type="hidden" name="enddate1" value=<%=enddate1%>><input type="hidden" name="enddate2" value=<%=enddate2%>>
   </td>
</tr>
</table>
<table class=liststyle cellspacing=1  >
   <colgroup>
   <col width="25%">
   <col width="15%">
   <col width="15%">
   <col width="15%">
   <col width="15%">
   <col width="15%">
   <tr class="header"><th colspan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th></tr>
   <tr class="header">
   	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></td>
   	<td><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td>
   </tr>
   <TR class="Line"><TD colspan="6" ></TD></TR>
<%
int wftypeid=0;
int tdnum=0;
String totalcount="";
String curnodetype="";
RecordSet.executeSql(sql);
boolean islight=true;
while(RecordSet.next()){
	int curwftypeid=RecordSet.getInt("workflowtype");
	curnodetype=RecordSet.getString("currentnodetype");
	int curcount=RecordSet.getInt("count");
	if(wftypeid!=curwftypeid){
		wftypeid=curwftypeid;
		totalcount="";
		tdnum=0;
	%>
   <tr <%if(islight){%>class=datalight <%} else {%> class=datadark <%}%>>
	<td><%=Util.toScreen(WorkTypeComInfo.getWorkTypename(curwftypeid+""),user.getLanguage())%></td>
	<%}
	if(tdnum==0&&curnodetype.equals("1")){
		tdnum=1;
	%><td align=right>0</td><%}
	else if(tdnum==0&&curnodetype.equals("2")){
		tdnum=2;
	%><td align="right">0</td><td align="right">0</td><%}
	else if(tdnum==1&&curnodetype.equals("2")){
		tdnum=2;
	%><td align="right">0</td><%}
	else if(tdnum==0&&curnodetype.equals("3")){
		tdnum=3;
	%><td align=right>0</td><td align=right>0</td><td align=right>0</td><%}
	else if(tdnum==1&&curnodetype.equals("3")){
		tdnum=3;
	%><td align=right>0</td><td align=right>0</td><%}
	else if(tdnum==2&&curnodetype.equals("3")){
		tdnum=3;
	%><td align=right>0</td><%}%>
	<%
	String wfid="";
	RecordSet1.executeProc("workflow_base_SelectByType",curwftypeid+"");
	while(RecordSet1.next()){
		wfid+=RecordSet1.getString("id")+",";
	}
	wfid=wfid.substring(0,wfid.length()-1);
	%>
	<td align="right">
	<!--
	<a href="/workflow/search/WFSearchTemp.jsp?workflowid=<%=wfid%>&nodetype=<%=curnodetype%>
	&fromdate=<%=startdate1%>&todate=<%=startdate2%>&lastfromdate=<%=enddate1%>&lasttodate=<%=enddate2%>">
	-->
	<%=curcount%></td><%
	totalcount=Util.getIntValue(totalcount,0)+curcount+"";
	tdnum++;
	if(tdnum==4){
	%>
	<td align=right><%=totalcount%></td>
</tr>
<%	}
	islight=!islight;
}






if(curnodetype.equals("0")){
%><td align="right">0</td><td align="right">0</td><td align="right">0</td><td align="right"><%=totalcount%></td></tr><%}
if(curnodetype.equals("1")){
%><td align="right">0</td><td align="right">0</td><td align="right"><%=totalcount%></td></tr><%}
if(curnodetype.equals("2")){
%><td align="right">0</td><td align="right"><%=totalcount%></td></tr><%}
%>
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

</form>
<script language="javascript">
function submitData()
{
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}

</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>