
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="wpRemind" class="weaver.WorkPlan.WorkPlanRemind" scope="page"/>

<%

Calendar cal = Calendar.getInstance();
String currDate = Util.add0(cal.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(cal.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(cal.get(Calendar.DAY_OF_MONTH), 2);

String currUserId = String.valueOf(user.getUID());

String userId = Util.null2String(request.getParameter("selectUser"));
String userLanguage = String.valueOf(user.getLanguage());
if (userId.equals(""))
	userId = currUserId;

String userType = "";
if (userType.equals(""))
    userType = user.getLogintype();

String setDate = "";
String selectDate =  Util.null2String(request.getParameter("selectdater"));
if (selectDate.equals(""))
	selectDate = currDate;

String moveDate = Util.null2String(request.getParameter("movedater"));
int viewType = Util.getIntValue(request.getParameter("viewtyper"),2);

Calendar calSet = Calendar.getInstance();
int selectYear = Util.getIntValue(selectDate.substring(0,4));
int selectMonth = Util.getIntValue(selectDate.substring(5,7))-1;
int selectDay = Util.getIntValue(selectDate.substring(8,10));

calSet.set(selectYear,selectMonth,selectDay);
switch (viewType) {
	case 1:
		if (moveDate.equals("1"))
			calSet.add(Calendar.DATE,1) ;

		if (moveDate.equals("-1"))
			calSet.add(Calendar.DATE,-1) ;

		break ;
	case 2:
		Date thedate = calSet.getTime() ;
		int diffdate = (-1)*thedate.getDay() ;//thedate.getDay()为当星期的第几天由于西方星期的第一天为星期日再-1
		calSet.add(Calendar.DATE,diffdate) ;
		if (moveDate.equals("1"))
			calSet.add(Calendar.WEEK_OF_YEAR,1) ;

		if (moveDate.equals("-1"))
			calSet.add(Calendar.WEEK_OF_YEAR,-1) ;

		calSet.add(Calendar.DATE,1);
		break ;
	case 3:
		calSet.set(selectYear,selectMonth,1) ;
		if (moveDate.equals("1"))
			calSet.add(Calendar.MONTH,1) ;

		if (moveDate.equals("-1"))
			calSet.add(Calendar.MONTH,-1) ;

		break;
}
setDate = Util.add0(calSet.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(calSet.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(calSet.get(Calendar.DAY_OF_MONTH), 2) ;
ArrayList reminds = wpRemind.getRemindWorkPlan(userId, userType, 3);
boolean hasMore = wpRemind.hasMore();
%>
<HTML xmlns:IE>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<TITLE>Calendar</TITLE>
<STYLE>
@media all
{
<%if(userLanguage.equals("8")){%>
  IE\:Calendar
  {
	behavior: url(/htc/calendarEng.htc) ; //引入calendar的html组件
  }
<%}else{%>
  IE\:Calendar
  {
	behavior: url(/htc/calendarForWorkplan.htc) ; //引入calendar的html组件
  }
<%}%>
}
</STYLE>
</HEAD>

<BODY scroll="no" onload="doSetCalendar('<%=setDate%>')">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM name="frmmain" action="WorkPlanView.jsp" method="post" target="workSpaceLeft">
<INPUT type="hidden" name="selectdate" value="<%=currDate%>">
<INPUT type="hidden" name="selectUser" value="<%=userId%>">
<INPUT type="hidden" name="viewtype" value="<%=viewType%>">
<INPUT type="hidden" name="method" value="">

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#E3E3E3">
<COLGROUP>
<COL width="">
<COL width="5">
<TR bgcolor="#B3B3B3">
	<TD height="5" colspan="2"></TD>
</TR>
<TR>
	<TD valign="top">


			<TABLE width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="ListStyle">
			<TR>
			<TD valign="top" height="140">
				<IE:Calendar id="cal" style="height:140;width:195;border:0px solid black;" >
				</IE:Calendar><BR>
				<BUTTON class="WorkPlan" onclick="doMonth()"><%=SystemEnv.getHtmlLabelName(16654,user.getLanguage())%></BUTTON>&nbsp;&nbsp<BUTTON class="WorkPlan" onclick="doWeek()" ><%=SystemEnv.getHtmlLabelName(16655,user.getLanguage())%></BUTTON>&nbsp;&nbsp<BUTTON class="WorkPlan" onclick="doDay()" ><%=SystemEnv.getHtmlLabelName(16656,user.getLanguage())%></BUTTON>
			</TD>
			</TR>

			<TR class="Header" height="20" align="left">
				<TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;
				<BUTTON class="Browser" id="SelectUserID" onClick="onShowHrmID()"></BUTTON>
				<SPAN id="selectuserspan"><%=resourceComInfo.getResourcename(userId)%></SPAN></TD>
			</TR>

			<TR><TD height="1"></TD></TR>
			 <TR class="Header" height="20" align="left">
				<TD>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(17498,user.getLanguage())%></B></TD>
			 </TR>

			 <TR height="20">
				 <TD valign="top">

				 <TABLE>
				 <TR>
				 <TD><INPUT type="text" name="note" class="InputStyle"></TD>
				<TD><A href="#" onclick="doAdd()"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></A>
				</TD>
				</TR>
				</TABLE>

				</TD>
			</TR>

			<TR><TD height="2"></TD></TR>


			<TR class="Header" height="20" align="left">
				<TD>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(17497,user.getLanguage())%></B></TD>
			</TR>

			<TR height="20">
				<TD valign="top">
					<TABLE class="ListStyle" border="0" cellspacing="1">
						<%
					boolean isLight = false;
					String m_id = "";
					String m_name = "";
					for (int i = 0; i < reminds.size(); i++) {
						m_id = ((String[]) reminds.get(i))[0];
						m_name = ((String[]) reminds.get(i))[1];
						isLight = !isLight;
					%>
					<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
					<TD><A href="/workplan/data/WorkPlanDetail.jsp?workid=<%=m_id%>" target="workSpaceLeft"><%=m_name%></A></TD>
					</TR>
					<%}%>
					<%if (hasMore) {%>
					<TR>
					<TD align="right"><A href="/workplan/data/WorkPlanRemind.jsp" target="_parent"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...</A></TD>
					</TR>
					<%}%>
					</TABLE>
				</TD>
			</TR>


			<TR align="left">
			<TD></TD>
			</TR>
			</TABLE>
		</FORM>

      </TD>
	  <TD bgcolor="#B3B3B3"></TD>
      </TR>
	</TABLE>


<SCRIPT language="JavaScript">
function doSetCalendar(date) {
	day = date.substring(8,10);
	month = date.substring(5,7);
	cal.year = date.substring(0,4);

	if (month=="08") cal.month = 08;  //？？非常奇怪当为08号或09号就不行
	else if (month=="09") cal.month = 09;
		 else cal.month = month;

	if (day=="08") cal.day = 08;  //？？非常奇怪当为08号或09号就不行
	else if (day=="09") cal.day = 09;
		 else cal.day = day;

	document.frmmain.selectdate.value=date;
}

function doSubmit() {
	themonth = cal.month;
	theday = cal.day;
	if (themonth < 10)
		themonth = "0" + themonth;

	if (theday < 10)
		theday = "0" + theday;

	document.frmmain.selectdate.value = cal.year + '-' + themonth + '-' + theday;
	document.frmmain.submit();

}

function doMyWork() {
	document.frmmain.selectUser.value = "<%=currUserId%>";
	document.all("selectuserspan").innerHTML = "";
	doSubmit();
}

function doDay() {
	document.frmmain.viewtype.value = "1";
	doSubmit();
}

function doWeek() {
	document.frmmain.viewtype.value = "2";
	doSubmit();
}

function doMonth() {
	document.frmmain.viewtype.value = "3";
	doSubmit();
}

function doAdd() {
	if (check_form(document.frmmain, "note")) {
        document.frmmain.action = "WorkSpaceHandler.jsp";
        document.frmmain.target = "workSpaceLeft";
        document.all("method").value = "addnote";
		document.frmmain.submit();
        document.frmmain.note.value = "";
        document.frmmain.action = "WorkPlanView.jsp";
        document.all("method").value = "";
    }
}


</SCRIPT>

<SCRIPT language="VBS">
sub onShowHrmID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		selectuserspan.innerHtml = id(1)
		frmmain.selectUser.value = id(0)
		doSubmit()
	else
		selectuserspan.innerHtml = ""
		frmmain.selectUser.value = ""
	end if
	end if
end sub
</SCRIPT>
</BODY>
</HTML>