
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanReportData" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanValuate" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="report" class="weaver.WorkPlan.WorkPlanReport" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
<STYLE>
	.vis0	{ visibility:"hidden" }
	.vis1	{ visibility:"visible" }
</STYLE>
</HEAD>

<%
String userId = String.valueOf(user.getUID());
String type = Util.null2String(request.getParameter("type"));
String term1 = Util.null2String(request.getParameter("term1"));
String viewType = Util.null2String(request.getParameter("viewtype"));	// 1:我的计划, 2:我安排的计划, 3:我下属的计划
String status = Util.null2String(request.getParameter("status"));

int pageNum = Util.getIntValue(request.getParameter("pagenum"), 1);

String valuated = Util.null2String(request.getParameter("valuated"));

String needRemind = Util.null2String(request.getParameter("needremind"));
if (needRemind.equals(""))
	needRemind = "1";

String flag = Util.null2String(request.getParameter("flag"));

String term2 = "";
String underling = "";

String checker = "";

if (viewType.equals(""))
	viewType = "v1";

String viewTypeValue = viewType;

if (viewType.equals("v3")) {
	underling = Util.null2String(request.getParameter("underling"));
	viewTypeValue = underling;
}

if (type.equals(""))		// 1:日报, 2:周报, 3:月报, 4:季报, 5:年报
	type = "1";

Calendar cal = Calendar.getInstance();
String currDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2) ;

int currYear = cal.get(Calendar.YEAR);
int currWeek = cal.get(Calendar.WEEK_OF_YEAR);
int currMonth = cal.get(Calendar.MONTH) + 1;
int currQuarter = (currMonth + 2) / 3;

int lowerYear = 2000;
int upperYear = currYear + 1;
String[] years = new String[upperYear - lowerYear];
for (int i = 0; i < upperYear-lowerYear; i++)
	years[i] = String.valueOf(lowerYear + i);

int weekAmount = 52;

ArrayList uIds = new ArrayList();
rs.executeProc("HrmResource_SelectByManagerID", userId);
while (rs.next())
	uIds.add(Util.null2String(rs.getString("id")));

ArrayList reportData = new ArrayList();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";

boolean hasNextPage = false;
boolean canValuate = false;
String params[];
if (type.equals("1")) {			// 日报
	titlename = SystemEnv.getHtmlLabelName(16428,user.getLanguage());
	if (term1.equals("") && flag.equals(""))
		term1 = currDate;

	params = new String[] {userId, term1, viewTypeValue, status, String.valueOf(pageNum)};
	reportData = report.getDailyReport(params);

	hasNextPage = report.hasNextPage();
	canValuate = report.canValuate();

} else if (type.equals("2")) {	// 周报
	titlename = SystemEnv.getHtmlLabelName(16429,user.getLanguage());
	term2 = Util.null2String(request.getParameter("term2"));
	if (term1.equals("") && flag.equals(""))
		term1 = String.valueOf(currYear);

	if (term2.equals("") && flag.equals(""))
		term2 = String.valueOf(currWeek);

	params = new String[] {userId, term1, term2, viewTypeValue, status, String.valueOf(pageNum)};
	reportData = report.getWeekReport(params);

	hasNextPage = report.hasNextPage();
	canValuate = report.canValuate();

} else if (type.equals("3")) {	// 月报
	titlename = SystemEnv.getHtmlLabelName(16430,user.getLanguage());
	term2 = Util.null2String(request.getParameter("term2"));
	if (term1.equals("") && flag.equals(""))
		term1 = String.valueOf(currYear);

	if (term2.equals("") && flag.equals(""))
		term2 = String.valueOf(currMonth);

	params = new String[] {userId, term1, term2, viewTypeValue, status, String.valueOf(pageNum)};
	reportData = report.getMonthReport(params);

	hasNextPage = report.hasNextPage();
	canValuate = report.canValuate();

} else if (type.equals("4")) {	// 季报
	titlename = SystemEnv.getHtmlLabelName(16431,user.getLanguage());
	term2 = Util.null2String(request.getParameter("term2"));
	if (term1.equals("") && flag.equals(""))
		term1 = String.valueOf(currYear);

	if (term2.equals("") && flag.equals(""))
		term2 = String.valueOf(currQuarter);

	params = new String[] {userId, term1, term2, viewTypeValue, status, String.valueOf(pageNum)};
	reportData = report.getQuarterReport(params);

	hasNextPage = report.hasNextPage();
	canValuate = report.canValuate();

} else if (type.equals("5")) {	// 年报
	titlename = SystemEnv.getHtmlLabelName(16432,user.getLanguage());
	if (term1.equals("") && flag.equals(""))
		term1 = String.valueOf(currYear);

	params = new String[] {userId, term1, viewTypeValue, status, String.valueOf(pageNum)};
	reportData = report.getYearReport(params);

	hasNextPage = report.hasNextPage();
	canValuate = report.canValuate();

} else if (type.equals("6")) {	// 动态报告
	titlename = SystemEnv.getHtmlLabelName(16433,user.getLanguage());

	term2 = Util.null2String(request.getParameter("term2"));
	checker = Util.null2String(request.getParameter("checker"));

	if (!flag.equals("")) {
		params = new String[] {userId, term1, term2, viewTypeValue, status, String.valueOf(pageNum), checker};
		reportData = report.getDynamicReport(params);

		hasNextPage = report.hasNextPage();
		canValuate = report.canValuate();
	}

} else							// undefined
	titlename = SystemEnv.getHtmlLabelName(400,user.getLanguage());

if (!canValuate)
	needRemind = "0";

String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15329,user.getLanguage())+",javascript:doGenerateReport(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

/*if (canValuate) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}*/

RCMenu += "{"+SystemEnv.getHtmlLabelName(17488,user.getLanguage())+",javascript:setRecordCount(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

if (pageNum > 1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:goBackPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if (hasNextPage) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:goNextPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanReport.jsp">
		<INPUT type="hidden" name="type" value="<%=type%>">
		<INPUT type="hidden" name="pagenum" value="<%=pageNum%>">
		<INPUT type="hidden" name="method" value="search">
		<INPUT type="hidden" name="flag" value="1">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">
	<TABLE class="ViewForm">
	  <COLGROUP>
	  <COL width="10%">
	  <COL width="37%">
	  <COL width="6%">
	  <COL width="10%">
	  <COL width="37%">
	  <TBODY>
	  <%
		if (type.equals("1")) {	//日报
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
		<TD class="Field"><BUTTON class="Calendar" id="SelectDate" onclick="getDate('term1span','term1')"></BUTTON>
		  <SPAN id="term1span"><%=term1%></SPAN>
		  <INPUT type="hidden" name="term1" value="<%=term1%>"></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype" onChange="viewTypeChanged()">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17492,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17493,user.getLanguage())%></OPTION>
		</SELECT>&nbsp;&nbsp;&nbsp;
		<SPAN id="underlingspan" <%if (viewType.equals("v3")) {%>class="vis1"<%} else {%>class="vis0"<%}%>>
		<SELECT name="underling">
		<OPTION value="" <%if (underling.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></OPTION>
		<%for (int i = 0; i < uIds.size(); i++) {%>
		<OPTION value="<%=uIds.get(i)%>" <%if (underling.equals((String)uIds.get(i))) 			{%>selected<%}%>><%=resourceComInfo.getResourcename((String)uIds.get(i))%></OPTION><%}%>
		</SELECT></SPAN></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>

		<TD colSpan="3"></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD colSpan="3"></TD></TR>

	  <%
		} else if (type.equals("2")) {	//周报
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term1">
		<% for (int i = 0; i < years.length; i ++) {%>
		<OPTION value="<%=years[i]%>" <%if (years[i].equals(term1)) {%>selected<%}%>><%=years[i]%></OPTION>
		<%}%>
		</SELECT></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term2">
		<% for (int i = 1; i <= 52; i ++) {%>
		<OPTION value="<%=i%>" <%if (String.valueOf(i).equals(term2)) {%>selected<%}%>><%=i%></OPTION>
		<%}%>
		</SELECT></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype" onChange="viewTypeChanged()">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17492,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17493,user.getLanguage())%></OPTION>
		</SELECT>&nbsp;&nbsp;&nbsp;
		<SPAN id="underlingspan" <%if (viewType.equals("v3")) {%>class="vis1"<%} else {%>class="vis0"<%}%>>
		<SELECT name="underling">
		<OPTION value="" <%if (underling.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></OPTION>
		<%for (int i = 0; i < uIds.size(); i++) {%>
		<OPTION value="<%=uIds.get(i)%>" <%if (underling.equals((String)uIds.get(i))) 			{%>selected<%}%>><%=resourceComInfo.getResourcename((String)uIds.get(i))%></OPTION><%}%>
		</SELECT></SPAN></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>		

	  <%
		} else if (type.equals("3")) {	//月报
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term1">
		<% for (int i = 0; i < years.length; i ++) {%>
		<OPTION value="<%=years[i]%>" <%if (years[i].equals(term1)) {%>selected<%}%>><%=years[i]%></OPTION>
		<%}%>
		</SELECT></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term2">
		<% for (int i = 1; i <= 12; i ++) {%>
		<OPTION value="<%=i%>" <%if (String.valueOf(i).equals(term2)) {%>selected<%}%>><%=i%></OPTION>
		<%}%>
		</SELECT></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype" onChange="viewTypeChanged()">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17492,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17493,user.getLanguage())%></OPTION>
		</SELECT>&nbsp;&nbsp;&nbsp;
		<SPAN id="underlingspan" <%if (viewType.equals("v3")) {%>class="vis1"<%} else {%>class="vis0"<%}%>>
		<SELECT name="underling">
		<OPTION value="" <%if (underling.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></OPTION>
		<%for (int i = 0; i < uIds.size(); i++) {%>
		<OPTION value="<%=uIds.get(i)%>" <%if (underling.equals((String)uIds.get(i))) 			{%>selected<%}%>><%=resourceComInfo.getResourcename((String)uIds.get(i))%></OPTION><%}%>
		</SELECT></SPAN></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>
		
	  <%
		} else if (type.equals("4")) {	//季报
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term1">
		<% for (int i = 0; i < years.length; i ++) {%>
		<OPTION value="<%=years[i]%>" <%if (years[i].equals(term1)) {%>selected<%}%>><%=years[i]%></OPTION>
		<%}%>
		</SELECT></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term2">
		<% for (int i = 1; i <= 4; i ++) {%>
		<OPTION value="<%=i%>" <%if (String.valueOf(i).equals(term2)) {%>selected<%}%>><%=i%></OPTION>
		<%}%>
		</SELECT></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype" onChange="viewTypeChanged()">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17492,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17493,user.getLanguage())%></OPTION>
		</SELECT>&nbsp;&nbsp;&nbsp;
		<SPAN id="underlingspan" <%if (viewType.equals("v3")) {%>class="vis1"<%} else {%>class="vis0"<%}%>>
		<SELECT name="underling">
		<OPTION value="" <%if (underling.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></OPTION>
		<%for (int i = 0; i < uIds.size(); i++) {%>
		<OPTION value="<%=uIds.get(i)%>" <%if (underling.equals((String)uIds.get(i))) 			{%>selected<%}%>><%=resourceComInfo.getResourcename((String)uIds.get(i))%></OPTION><%}%>
		</SELECT></SPAN></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>
		
	  <%
		} else if (type.equals("5")) {	//年报
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
		<TD class="Field"><SELECT name="term1">
		<% for (int i = 0; i < years.length; i ++) {%>
		<OPTION value="<%=years[i]%>" <%if (years[i].equals(term1)) {%>selected<%}%>><%=years[i]%></OPTION>
		<%}%>
		</SELECT></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype" onChange="viewTypeChanged()">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2101,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17492,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17493,user.getLanguage())%></OPTION>
		</SELECT>&nbsp;&nbsp;&nbsp;
		<SPAN id="underlingspan" <%if (viewType.equals("v3")) {%>class="vis1"<%} else {%>class="vis0"<%}%>>
		<SELECT name="underling">
		<OPTION value="" <%if (underling.equals("")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></OPTION>
		<%for (int i = 0; i < uIds.size(); i++) {%>
		<OPTION value="<%=uIds.get(i)%>" <%if (underling.equals((String)uIds.get(i))) 			{%>selected<%}%>><%=resourceComInfo.getResourcename((String)uIds.get(i))%></OPTION><%}%>
		</SELECT></SPAN></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>
		
		<TD colSpan="3"></TD>
		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD colSpan="3"></TD></TR>

	  <%
		} else if (type.equals("6")) {				// 动态报告
	  %>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
		<TD class="Field"><BUTTON class="Calendar" id="SelectBeginDate" onclick="getDate('term1span','term1')"></BUTTON>
		  <SPAN id="term1span"><%=term1%></SPAN>
		  <INPUT type="hidden" name="term1" value="<%=term1%>">&nbsp;-&nbsp;&nbsp;
		  <BUTTON class="Calendar" id="SelectEndDate" onclick="getDate('term2span','term2')"></BUTTON>
		  <SPAN id="term2span"><%=term2%></SPAN>
		  <INPUT type="hidden" name="term2" value="<%=term2%>"></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17520,user.getLanguage())%></TD>
		<TD class="Field"><BUTTON class="Browser" id="SelectHrmResource" onclick="onShowHrmResource('checker','checkerspan')"></BUTTON>
		  <SPAN id="checkerspan"><%=resourceComInfo.getLastname(checker)%></SPAN>
		  <INPUT type="hidden" name="checker" value="<%=checker%>"></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17524,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="status">
		<OPTION value="" <%if (status.equals("")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if (status.equals("0")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></OPTION>
		<OPTION value="1" <%if (status.equals("1")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if (status.equals("2")) {%> selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>
		</SELECT></TD>

		<TD></TD>

		<TD><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
		<TD class="Field">
		<SELECT name="viewtype">
		<OPTION value="v1" <%if (viewType.equals("") || viewType.equals("v1")) 	{%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17522,user.getLanguage())%></OPTION>
		<OPTION value="v2" <%if (viewType.equals("v2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17521,user.getLanguage())%></OPTION>
		<OPTION value="v3" <%if (viewType.equals("v3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17523,user.getLanguage())%></OPTION>
		</SELECT></TD>

		</TR>
		<TR><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>
		
	  <%
		}
	  %>
	  </TBODY>
	</TABLE>
	<TABLE class="ListStyle" cellspacing="1" id="result">
    <COLGROUP>
	<COL width="8%">
    <COL width="20%">
    <COL width="20%">
    <COL width="16%">
    <COL width="16%">
    <COL width="10%">
	<COL width="5%">
	<COL width="5%">
    <TBODY>
    <TR class="Header">
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(16134,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>	  
    </TR>
	<TR class="Line"><TD colspan="8"></TD></TR>
<%
	boolean isLight = false;
	boolean isFirst = true;
	WorkPlanReportData data;
	String m_workPlanId;
	String m_urgent;
	String m_name;
	String m_begin;
	String m_end;
	String m_status;
	String m_statusValue;
	String m_createrId;
	String m_description = "";

	ArrayList members;
	ArrayList createrScores;
	ArrayList managerScores;
	ArrayList canCreaterValuates;
	ArrayList canManagerValuates;

	String m_member = "";
	String m_createrSocre = "";
	String m_managerScore = "";

	boolean canCreaterValuate = false;
	boolean canManagerValuate = false;

	for (int i = 0; i < reportData.size(); i++) {
		isFirst = true;
		canCreaterValuate = false;
		canManagerValuate = false;

		data = (WorkPlanReportData) reportData.get(i);

		m_workPlanId = data.getWorkPlanId();
		m_name = data.getWorkPlanName();
		m_urgent = data.getUrgentLevel();
		m_status = data.getStatus();
		m_begin = data.getBeginDate();
		m_end = data.getEndDate();
		m_createrId = data.getCreaterId();
		m_description = data.getDescription();

        members = data.getMembers();
		createrScores = data.getCreaterScores();
		managerScores = data.getManagerScores();
        canCreaterValuates = data.getCanCreaterValuates();
        canManagerValuates = data.getCanManagerValuates();

		if (m_urgent.equals("1"))
			m_urgent = SystemEnv.getHtmlLabelName(154,user.getLanguage());
		else if (m_urgent.equals("2"))
			m_urgent = SystemEnv.getHtmlLabelName(15533,user.getLanguage());
		else if (m_urgent.equals("3"))
			m_urgent = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
		else
			m_urgent = "undefined";

		if (m_status.equals("0"))
			m_statusValue = SystemEnv.getHtmlLabelName(732,user.getLanguage());
		else if (m_status.equals("1"))
			m_statusValue = SystemEnv.getHtmlLabelName(1961,user.getLanguage());
		else if (m_status.equals("2"))
			m_statusValue = SystemEnv.getHtmlLabelName(251,user.getLanguage());
		else
			m_statusValue = "undefined";

		isLight = !isLight;

		for (int j = 0; j < members.size(); j++) {
			m_member = (String) members.get(j);
			m_createrSocre = (String) createrScores.get(j);
			m_managerScore = (String) managerScores.get(j);
            canCreaterValuate = ((((String) canCreaterValuates.get(j)).equals("1")) ? true : false);
            canManagerValuate = ((((String) canManagerValuates.get(j)).equals("1")) ? true : false);

			if (isFirst) 
			{
				isFirst = false;
%>
<INPUT type="hidden" name="plan<%=i%>" value="<%=m_workPlanId%>">
<TR class="DataDark">
<TD><%=m_urgent%></TD>
<TD><A href="#" onclick=openFullWindow("/workplan/data/WorkPlanDetail.jsp?workid=<%=m_workPlanId%>&from=1") title="<%=Util.toScreenToEdit(m_description, user.getLanguage())%>"><%=m_name%></A></TD>
<TD><%=m_description%></TD>
<TD><%=m_begin%></TD>
<TD><%=m_end%></TD>
<TD><%=m_statusValue%></TD>
<TD><%=resourceComInfo.getResourcename(m_member)%></TD>
<TD><%=resourceComInfo.getResourcename(m_createrId)%></TD>

<%
			}
			else 
			{
%>
<TR class="DataDark">
<TD></TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD></TD>
<TD><%=resourceComInfo.getResourcename(m_member)%></TD>
<TD></TD>
<%
			}
		}
	}
%>
	</TABLE>

	  </TD>
		</TR>
		</TABLE></FORM>

	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</BODY>
<SCRIPT language="VBS" src="/js/browser/DateBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/js/browser/HrmResourceBrowser.vbs"></SCRIPT>

<SCRIPT language="JavaScript">
function doGenerateReport() {
    document.all("pagenum").value = 1;
	document.frmmain.submit();
}

function setRecordCount() {
	document.location.href = "WorkPlanSetup.jsp?type=<%=type%>";
}

function doSubmit() {
	if (confirm("<%=SystemEnv.getHtmlNoteName(58,user.getLanguage())%>")) {
		document.frmmain.action = "WorkPlanReportHandler.jsp";
		//document.all("method").value = "submit";
		document.frmmain.submit();
	}
}

function goNextPage() {
    document.all("pagenum").value = <%=pageNum+1%>;
    document.frmmain.submit();
}

function goBackPage() {
	document.all("pagenum").value = <%=pageNum-1%>;
    document.frmmain.submit();
}

function viewTypeChanged() {
	var selectedValue = document.all("viewtype").value;
	if (selectedValue == "v3")
		document.all("underlingspan").className = "vis1";
	else
		document.all("underlingspan").className = "vis0";
}
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>