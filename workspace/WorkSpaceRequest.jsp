<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workspace.WorkSpaceRequest" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>

<BASE target="_blank"/>

</HEAD>

<%
String type = Util.null2String(request.getParameter("type"));
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

int pageNum = Util.getIntValue(request.getParameter("pagenum"), 1);

WorkSpaceRequest workSpaceRequest = new WorkSpaceRequest(userId, userType);

ArrayList results = new ArrayList();
if (type.equals("11"))
    workSpaceRequest.getPendingRequests();
else if (type.equals("12"))
    workSpaceRequest.getDefaultRequests();
else if (type.equals("13"))
    workSpaceRequest.getPendingUnreadRequests();
else if (type.equals("14"))
    workSpaceRequest.getDefaultUnreadRequests();
else if (type.equals("51"))
    workSpaceRequest.getMyRequests();
else if (type.equals("52"))
    workSpaceRequest.getMyDefaultRequest();
else if (type.equals("53"))
    workSpaceRequest.getMyFeedBackRequest();
else if (type.equals("54"))
    workSpaceRequest.getMyDefaultFeedBackRequest();
else
    return;

results = workSpaceRequest.getResultRequests(pageNum);

boolean hasNextPage = workSpaceRequest.hasNextPage();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
if (type.equals("1"))
    titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage()) + SystemEnv.getHtmlLabelName(1207,user.getLanguage());
else
    titlename = SystemEnv.getHtmlLabelName(17500,user.getLanguage());

String needfav = "1";
String needhelp = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
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
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">
		<FORM id="frmmain" name="frmmain" method="post" action="WorkSpaceRequest.jsp">
		<INPUT type="hidden" name="type" value="<%=type%>">
		<INPUT type="hidden" name="pagenum" value="<%=pageNum%>">
		</FORM>
	<TABLE class="ListStyle" cellspacing="1" id="result">
    <COLGROUP>
    <COL width="40%">
    <COL width="30%">
    <COL width="30%">
    <TBODY>
    <TR class="Header">
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TD>
    </TR>
	<TR class="Line"><TD colspan="3"></TD></TR>
<%
	boolean isLight = false;
    String[] data;
	String m_id = "";
    String m_name = "";
    String m_creater = "";
    String m_createDate = "";
	for (int i = 0; i < results.size(); i++) {
		data = (String[]) results.get(i);
        m_id = data[0];
        m_name = data[1];
        m_creater = data[2];
        m_createDate = data[3];

		isLight = !isLight;
%>
<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
<TD><A href="/workflow/request/ViewRequest.jsp?requestid=<%=m_id%>"><%=m_name%></A></TD>
<TD><%=resourceComInfo.getLastname(m_creater)%></TD>
<TD><%=m_createDate%></TD>
</TR>
<%
	}
%>
	</TBODY></TABLE>

	  </TD>
		</TR>
		</TABLE>

	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</BODY>
<SCRIPT language="JavaScript">
function goNextPage() {
	document.all("pagenum").value = <%=pageNum+1%>;
    document.frmmain.submit();
}

function goBackPage() {
	document.all("pagenum").value = <%=pageNum-1%>;
    document.frmmain.submit();
}

function goBack() {
    doSearchAgain();
}
</SCRIPT>
</HTML>