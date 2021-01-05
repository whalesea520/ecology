
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workspace.WorkSpaceNews" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

// declare variables.
WorkSpaceNews workSpaceNews = new WorkSpaceNews(userId, userType);

ArrayList news = new ArrayList();
ArrayList anno = new ArrayList();
ArrayList meet = new ArrayList();
ArrayList docs = new ArrayList();

boolean hasMoreNews = false;
boolean hasMoreAnnos = false;
boolean hasMoreMeets = false;
boolean hasMoreDocs = false;

// set the variables value.
news = workSpaceNews.getLatestNews();
anno = workSpaceNews.getUnreadAnnounce();
meet = workSpaceNews.getMeeting();
docs = workSpaceNews.getDocs();

hasMoreNews = workSpaceNews.hasMoreNews();
hasMoreAnnos = workSpaceNews.hasMoreAnnos();
hasMoreMeets = workSpaceNews.hasMoreMeets();
hasMoreDocs = workSpaceNews.hasMoreDocs();

//Modify by 杨国生 2004-11-3 For TD1308
String imagefilename = "";
String titlename = "<img src='/images_face/ecologyFace_1/toolBarIcon/Home_wev8.gif' align='bottom'> "+SystemEnv.getHtmlLabelName(18437,user.getLanguage())+":&nbsp;"
					+ "<A href='/hrm/resource/HrmResource.jsp?id=" + userId + "'>"
				 + Util.toScreen(resourceComInfo.getResourcename(userId),user.getLanguage()) + "</A>";String needfav ="1";
String needhelp ="";
%>

<BODY>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//Modify by 杨国生 2004-11-3 For TD1314
RCMenu += "{"+SystemEnv.getHtmlLabelName(17560,user.getLanguage())+",javascript:changeStyle(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="frmmain" method="post">
<INPUT type="hidden" name="method" value="changestyle">
<INPUT type="hidden" name="style" value="1">
</FORM>
<TABLE class="ViewForm">
  <COLGROUP>
  <COL width="49%">
  <COL width="2">
  <COL>	  
  <TBODY>
	<TR>
	<TD valign="top">
		<!--Left side-->
		<TABLE class="ListStyle" cellspacing=1>
		<TR height="25" bgcolor="#999999"><TD valign="middle">&nbsp;&nbsp;&nbsp;
		<B><font style="font-size:17"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())+SystemEnv.getHtmlLabelName(316,user.getLanguage())%></font></B></TD></TR>
		<TR height="4" bgcolor="#B5B65A"><TD></TD></TR>
		<TR class="DataLight">
			<TD valign="top">
				<BR>
				<TABLE>
				<COLGROUP>
				  <COL width="3%">
				  <COL width="4%">
				  <COL width="60%">
				  <COL width="30%">	
				  <COL width="3%">
				<%
					String[] data;
					String m_id = "";
					String m_subject = "";
					String m_date = "";

					for (int i = 0; i < news.size(); i++) {
						data = (String[]) news.get(i);

						m_id = data[0];
						m_subject = data[1];
						m_date = data[2];

						m_subject = workSpaceNews.getEllipticalSubject(m_subject);
				%>
				<TR>
				<TD></TD>
				<TD>
					<TABLE  width="5" height="5">
						<TR><TD></TD></TR>
					</TABLE>
				</TD>
				<TD><B><A href="/docs/docs/DocDsp.jsp?id=<%=m_id%>" target="_parent"><%=m_subject%></A></B></TD>
				<TD><B>[<%=m_date%>]</B></TD>
				<TD></TD>
				</TR>
				<TR><TD colspan="5" height="2"></TD></TR>
				<%
					}
					
					if (hasMoreNews) {
				%>
				<TR><TD colspan="5" height="10"></TD></TR>
				<TR><TD colspan="4" align="right"><B><A href="/docs/search/DocSearchTemp.jsp?list=all&docpublishtype=2" target="_parent"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...</A></B></TD><TD></TD></TR>
				<%
					}
				%>
				</TABLE>
				<BR>
				<!--end-->
			</TD>
		</TR>
		<TR height="4" bgcolor="#B5B65A"><TD></TD></TR>
		</TABLE>
	</TD>		
	<TD></TD>
	<TD valign="top">
		<TABLE class="ListStyle" cellspacing=1>
		<TR height="25" bgcolor="#999999"><TD valign="middle">&nbsp;&nbsp;&nbsp;
		<B><font style="font-size:17"><%=SystemEnv.getHtmlLabelName(18438,user.getLanguage())%></font></B></TD></TR>
		<TR height="4" bgcolor="#B5B65A"><TD></TD></TR>
		</TABLE>
		<!--Right side-->
		<!--Unread announces-->
		<TABLE class="ListStyle" cellspacing=1>
		<COLGROUP>
		  <COL width="75%">
		  <COL width="25%">	
		<TR><TD colspan="2" height="7"></TD></TR>
		<TR><TD><B><%=SystemEnv.getHtmlLabelName(18439,user.getLanguage())%></B></TD><TD align="right"><%if (hasMoreAnnos) {%><B><A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&docpublishtype=3" target="_parent"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...</A></B><%}%></TD></TR>
		<TR class=Line>
			<TD colSpan=2></TD>
		</TR>
		<%
			boolean colorFlag=true ;
			for (int i = 0; i < anno.size(); i++) {
				data = (String[]) anno.get(i);

				m_id = data[0];
				m_subject = data[1];
				if(colorFlag) {
		%>
		<TR class="DataLight">
		<%}else{%>
		<TR class="DataDark">
		<%}%>
			<TD colspan="2"><A href="/docs/docs/DocDsp.jsp?id=<%=m_id%>" target="_parent"><%=m_subject%></A></TR>
		<%
			colorFlag = !colorFlag ;
		}
		%>
		<!--end-->
		</TABLE>

		<!--New Meetings-->
		<TABLE class="ListStyle" cellspacing=1>
		<COLGROUP>
		  <COL width="75%">
		  <COL width="25%">	
		<TR><TD colspan="2" height="7"></TD></TR>
		<TR><TD><B><%=SystemEnv.getHtmlLabelName(18440,user.getLanguage())%></B></TD><TD align="right"><%if (hasMoreMeets) {%><B><A href="/meeting/data/NewMeetings.jsp" target="_parent"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...</A></B><%}%></TD></TR>
		<TR class=Line>
			<TD colSpan=2></TD>
		</TR>
		<%
			colorFlag=true ;
			for (int i = 0; i < meet.size(); i++) {
				data = (String[]) meet.get(i);

				m_id = data[0];
				m_subject = data[1];
				if(colorFlag) {
		%>
		<TR class="DataLight">
		<%}else{%>
		<TR class="DataDark">
		<%}%>
			<TD colspan="2"><A href="/meeting/data/ViewMeeting.jsp?meetingid=<%=m_id%>" target="_parent"><%=m_subject%></A></TR>
		<%
			colorFlag = !colorFlag ;
		}
		%>
		</TABLE>
		<!--end-->
		<TABLE class="ListStyle" cellspacing=1>
		<COLGROUP>
		  <COL width="75%">
		  <COL width="25%">	
		<TR><TD colspan="2" height="7"></TD></TR>
		<TR><TD><B><%=SystemEnv.getHtmlLabelName(18441,user.getLanguage())%></B></TD><TD align="right"><%if (hasMoreDocs) {%><B><A href="/docs/search/DocSearchTemp.jsp?list=all&docpublishtype=1&isNew=yes" target="_parent"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>...</A></B><%}%></TD></TR>
		<TR class=Line>
			<TD colSpan=2></TD>
		</TR>
		<%
			colorFlag=true ;
			for (int i = 0; i < docs.size(); i++) {
				data = (String[]) docs.get(i);

				m_id = data[0];
				m_subject = data[1];
				if(colorFlag) {
		%>
		<TR class="DataLight">
		<%}else{%>
		<TR class="DataDark">
		<%}%>
			<TD colspan="2"><A href="/docs/docs/DocDsp.jsp?id=<%=m_id%>" target="_parent"><%=m_subject%></A></TR>
		<%
			colorFlag = !colorFlag ;
		}
		%>
		</TABLE>
		<!--end-->				
</TD>
</TR>
</TABLE>

<SCRIPT language="JavaScript">
function changeStyle() {	
	document.frmmain.action = "WorkSpaceHandler.jsp";
	document.frmmain.target = "workSpaceLeft";
	document.frmmain.submit();
}
</SCRIPT>
</BODY>
</HTML>