<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="wpRemind" class="weaver.WorkPlan.WorkPlanRemind" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();
ArrayList reminds = wpRemind.getRemindWorkPlan(userId, userType);

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17497,user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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

		<TABLE class="ListStyle" cellspacing="1">
		<COLGROUP>
		<COL width="20%">
        <COL width="16%">
        <COL width="16%">
        <COL width="16%">
        <COL width="16%">
        <COL width="16%">
        <TBODY>
    <TR class="Header">
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(842,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
    </TR>
	<TR class="Line"><TD colspan="6"></TD></TR>
<%
		boolean isLight = false;
		String m_id = "";
		String m_name = "";
        String m_urgent = "";
        String m_type = "";
        String m_creater = "";
		String m_createrType = "";
        String m_begin = "";
        String m_end = "";
		for (int i = 0; i < reminds.size(); i++) {
			m_id = ((String[]) reminds.get(i))[0];
			m_name = ((String[]) reminds.get(i))[1];
			m_type = ((String[]) reminds.get(i))[2];
            m_urgent = ((String[]) reminds.get(i))[3];            
            m_creater = ((String[]) reminds.get(i))[4];
			m_createrType = ((String[]) reminds.get(i))[5];
            m_begin = ((String[]) reminds.get(i))[6];
            m_end = ((String[]) reminds.get(i))[7];

            if (m_urgent.equals("1"))
                m_urgent = SystemEnv.getHtmlLabelName(154,user.getLanguage());
            else if (m_urgent.equals("2"))
                m_urgent = SystemEnv.getHtmlLabelName(15533,user.getLanguage());
            else if (m_urgent.equals("3"))
                m_urgent = SystemEnv.getHtmlLabelName(2087,user.getLanguage());
            else
                m_urgent = "undefined";

            if (m_type.equals("0"))
                m_type = SystemEnv.getHtmlLabelName(15090,user.getLanguage());
            else if (m_type.equals("1"))
                m_type = SystemEnv.getHtmlLabelName(1038,user.getLanguage());
            else if (m_type.equals("2"))
                m_type = SystemEnv.getHtmlLabelName(16095,user.getLanguage());
            else if (m_type.equals("3"))
                m_type = SystemEnv.getHtmlLabelName(6082,user.getLanguage());
            else if (m_type.equals("4"))
                m_type = SystemEnv.getHtmlLabelName(17487,user.getLanguage());
            else
                m_type = "undefined";
			
			if (m_createrType.equals("1"))
				m_creater = resourceComInfo.getResourcename(m_creater);
			else
				m_creater = customerComInfo.getCustomerInfoname(m_creater);

			isLight = !isLight;
%>
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
		<TD><A href="/workplan/data/WorkPlan.jsp?workid=<%=m_id%>"><%=m_name%></A></TD>
        <TD><%=m_urgent%></TD>
        <TD><%=m_type%></TD>
        <TD><%=m_creater%></TD>
        <TD><%=m_begin%></TD>
        <TD><%=m_end%></TD>
		</TR>
		<%}%>
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
function goBack() {
	history.back();
}
</SCRIPT>
</HTML>