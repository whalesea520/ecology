<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="customerComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
String currUserId = String.valueOf(user.getUID());
String loginType = user.getLogintype();
String sql = "";

ArrayList crmids=new ArrayList();
ArrayList lastcontactdate=new ArrayList();

ArrayList crmIds = new ArrayList();
ArrayList befores = new ArrayList();

ArrayList contactDates = new ArrayList();

if (!user.getLogintype().equals("2"))
	sql = "SELECT DISTINCT t1.id, t2.before, t2.lastestContactDate FROM CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2"
		+ " WHERE t1.id = t2.customerid AND t1.manager = " + currUserId
		+ " AND t1.deleted <> 1 AND t2.isremind = 0";
else
	sql = "SELECT DISTINCT t1.id, t2.before, t2.lastestContactDate FROM CRM_CustomerInfo t1, CRM_ContacterLog_Remind t2"
		+ " WHERE t1.id = t2.customerid AND t1.agent = " + currUserId
		+ " AND t1.deleted <> 1 AND t2.isremind = 0";

//rs.writeLog(sql);

rs.executeSql(sql);
while (rs.next()) {
	crmIds.add(rs.getString(1));
	befores.add(rs.getString(2));
	contactDates.add(Util.null2String(rs.getString(3)));
}


Calendar currCal = Calendar.getInstance();
Calendar tmpCal = Calendar.getInstance();
int tmpYear = 0;
int tmpMonth = 0;
int tmpDate = 0;

String m_crmId = "";
String m_contactDate = "";
int m_before = 0;


for (int i = 0; i < crmIds.size(); i++) {
	m_crmId = (String) crmIds.get(i);
	m_contactDate = (String) contactDates.get(i);
	if (!m_contactDate.equals("")) {
		
        tmpYear = Util.getIntValue(m_contactDate.substring(0,4));
        tmpMonth = Util.getIntValue(m_contactDate.substring(5,7)) - 1;
        tmpDate = Util.getIntValue(m_contactDate.substring(8,10));

        tmpCal.set(tmpYear, tmpMonth, tmpDate);

        m_before = Util.getIntValue((String) befores.get(i), 0);
		tmpCal.add(Calendar.DATE, m_before);

        if (tmpCal.before(currCal)) {
            crmids.add(m_crmId);
            lastcontactdate.add(m_contactDate);
        }
	} else {
        crmids.add(m_crmId);
        lastcontactdate.add("");
    }
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16403,user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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

		<TABLE class="ListStyle" id=tblReport cellspacing="1">
			<COLGROUP>
			<COL width="60">
			<COL width="40">	
			<TBODY>
			<TR class="Header">
			  <TH><B><%=SystemEnv.getHtmlLabelName(6061,user.getLanguage())%></B></TH>
			  <TD><%=SystemEnv.getHtmlLabelName(15232,user.getLanguage())%></TD>
			</TR>
			<TR class="Line"><TD colSpan="2" style="padding: 0"></TD></TR>
<%
	boolean isLight = false;
	
	for (int i = 0; i < crmids.size(); i++) {
		m_crmId = (String) crmids.get(i);
		m_contactDate = (String) lastcontactdate.get(i);

		isLight = !isLight;

%>
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
		<TD><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=m_crmId%>">
		<%=Util.toScreen(customerComInfo.getCustomerInfoname(m_crmId),user.getLanguage())%></A></TD>
		<TD><%=m_contactDate%></TD>
  </TR>
<%
	}
%>
	</TABLE>
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
</HTML>