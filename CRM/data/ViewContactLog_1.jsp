
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<%
String crmId = Util.null2String(request.getParameter("CustomerID"));
int viewType = Util.getIntValue(request.getParameter("viewtype"), 0);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();
userType="1";  //表WorkPlanShareDetail usertype字段都是为1，所以，如果客户门户登陆的话，永远查询不到数据

String sql = "" ;

if (rs.getDBType().equals("oracle"))
	sql = " SELECT id, begindate, begintime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else if (rs.getDBType().equals("db2"))
	sql = " SELECT id, begindate, begintime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else
	sql = "SELECT id, begindate , begintime, resourceid, description, name, status, urgentLevel, createrid, createrType, taskid, crmid, requestid, docid " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid" 
		+ " AND (',' + a.crmid + ',') LIKE '%," + crmId + ",%'" 
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";

if (viewType == 0 ) sql += " ORDER BY begindate DESC, begintime DESC";
if (viewType == 1 ) sql += " ORDER by urgentLevel DESC";
if (viewType == 2 ) sql += " ORDER by resourceid";
rs.executeSql(sql);
%>


<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6082,user.getLanguage())
					+ " - " + SystemEnv.getHtmlLabelName(136,user.getLanguage())
					+ ":&nbsp;<A href='/CRM/data/ViewCustomer.jsp?CustomerID=" + crmId + "'>"
					+ Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())+"</A>";

String needfav ="1";
String needhelp ="";
String currentvalue = "";
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCustomerCardBack(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%
}
%>
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
		<%if(!isfromtab){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

<FORM id=weaver action="ViewContactLog.jsp" method=post >
<%=SystemEnv.getHtmlLabelName(455,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>

<select class=InputStyle  size="1" name="viewtype" onchange = "doSubmit()">
			<option value="0" <%if (viewType==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1275,user.getLanguage())%></option>
			<option value="1" <%if (viewType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></option>
			</select>
</FORM>	
</DIV>

  <TABLE class="ListStyle">
		<COLGROUP>
		<COL width="5%">
  	<COL width="17%">
		<COL width="7%">
		<COL width="5%">
		<COL width="17%">
		<COL width="12%">
		<COL width="12%">
		<COL width="13%">
		<COL width="12%">

        <TBODY>
	    <TR class=Header>
	      <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
	      <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></th>	      
	      <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></th>
	      <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></th>
	      <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
		    <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></th>
		    <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></th>
		    <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></th>
		    <th style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></th>
	    </TR>
<TR class=Line><TD colSpan=9 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
String m_id = "";
String m_name = "";
String m_beginDate = "";
String m_beginTime = "";
String m_memberIds = "";
String m_createrType = "";
String m_description = "";
String m_urgentLevel = "";
String m_status = "";
while (rs.next()) {
	m_id = Util.null2String(rs.getString("id"));
	m_name = Util.null2String(rs.getString("name"));
	m_beginDate = Util.null2String(rs.getString("begindate"));
	m_beginTime = Util.null2String(rs.getString("begintime"));
	m_memberIds = Util.null2String(rs.getString("resourceid"));
	m_createrType = Util.null2String(rs.getString("createrType"));
	m_urgentLevel = Util.null2String(rs.getString("urgentLevel"));	
	m_description = Util.null2String(rs.getString("description"));
	m_status = Util.null2String(rs.getString("status"));
	String relatedprj = Util.null2String(rs.getString("taskid"));
	String relatedcus = Util.null2String(rs.getString("crmid"));
	String relatedwf = Util.null2String(rs.getString("requestid"));
	String relateddoc = Util.null2String(rs.getString("docid"));
	ArrayList relatedprjList = Util.TokenizerString(relatedprj, ",");
	ArrayList relatedcusList = Util.TokenizerString(relatedcus, ",");
	ArrayList relatedwfList = Util.TokenizerString(relatedwf, ",");
	ArrayList relateddocList = Util.TokenizerString(relateddoc, ",");

	switch (viewType) {
	case 1: if (!currentvalue.equals(m_urgentLevel)) {%><tr class=datadark><%
			switch (Integer.parseInt(m_urgentLevel)) {
			case 1: %><td colspan = 9><span id = contacttypename class ="fontred"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></span></td><% break;
			case 2: %><td colspan = 9><span id = contacttypename class ="fontred"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></span></td><% break;
			case 3: %><td colspan = 9><span id = contacttypename class ="fontred"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></span></td><% break;			
			default: %><td colspan = 9><span id = contacttypename class ="fontred">&nbsp;</span></td><% break;
			}%></tr><%} break;
	default: %><% break;
	}
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>

<%
	if (m_status.equals("0")) {
%>
	      <TD class=fontred><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></TD>
<%
	} else if (m_status.equals("1")) {
%>
<TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
<%
	} else if (m_status.equals("2")) {	
%>
<TD><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></TD>
<%	
	}
%>
<TD><A href="/workplan/data/WorkPlan.jsp?workid=<%=m_id%>"><%=Util.toScreen(m_name,user.getLanguage())%></A></TD>
		 
<%
	switch (Integer.parseInt(m_urgentLevel)) {
	case 1: %><td><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></td><% break;
	case 2: %><td><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></td><% break;
	case 3: %><td><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></td><% break;
	default: %><td>&nbsp;</td><% break;
	}
%>	      
	 <TD>
<%
	if (!userType.equals("2")) {
		if (m_createrType.equals("1")) {
			if (!m_memberIds.equals("")) {
				ArrayList members = Util.TokenizerString(m_memberIds, ",");
				for (int i = 0; i < members.size(); i++) {
%>
			<A href="/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>">
			<%=ResourceComInfo.getResourcename(""+members.get(i))%></A>&nbsp;
<%
				}
			}
		} else {
			if (!m_memberIds.equals("")) {
				ArrayList members = Util.TokenizerString(m_memberIds, ",");
				for (int i = 0; i < members.size(); i++) {
%>
			<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+members.get(i)%>">
			<%=CustomerInfoComInfo.getCustomerInfoname(""+members.get(i))%></A>&nbsp;
<%
				}
			}
		}
	} else {
		if (m_createrType.equals("1")) {
			if (!m_memberIds.equals("")) {
				ArrayList members = Util.TokenizerString(m_memberIds, ",");
				for (int i = 0; i < members.size(); i++) {
%>
		<%=ResourceComInfo.getResourcename(""+members.get(i))%>
<%
				}
			}
		} else {
			if (!m_memberIds.equals("")) {
				ArrayList members = Util.TokenizerString(m_memberIds, ",");
				for (int i = 0; i < members.size(); i++) {
%>
			<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+members.get(i)%>">
			<%=CustomerInfoComInfo.getCustomerInfoname(""+members.get(i))%></A>
<%
				}
			}
		}
	}
%>
	</TD>
	<TD><%=m_beginDate%>&nbsp;&nbsp;<%=m_beginTime%></TD>
    <td>
		<%for(int i=0;i<relateddocList.size();i++){%>
			<a href="/docs/docs/DocDsp.jsp?id=<%=relateddocList.get(i).toString()%>">
			<%=DocComInfo.getDocname(relateddocList.get(i).toString())%><br>
			</a>
		<%}%>
		</td>
    <td>
		<%for(int i=0;i<relatedprjList.size();i++){%>
			<a href="/proj/process/ViewTask.jsp?taskrecordid=<%=relatedprjList.get(i).toString()%>">
			<%=ProjectTaskApprovalDetail.getTaskSuject(relatedprjList.get(i).toString())%><br>
			</a>
		<%}%>
		</td>
    <td>
		<%for(int i=0;i<relatedcusList.size();i++){%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=relatedcusList.get(i).toString()%>">
			<%=CustomerInfoComInfo.getCustomerInfoname(relatedcusList.get(i).toString())%><br>
			</a>
		<%}%>		
		</td>
    <td>
		<%for(int i=0;i<relatedwfList.size();i++){%>
			<a href="/workflow/request/ViewRequest.jsp?requestid=<%=relatedwfList.get(i).toString()%>">
			<%=RequestComInfo.getRequestname(relatedwfList.get(i).toString())%><br>
			</a>
		<%}%>		
		</td>
    </TR>
		<%if(isLight)
				{%>	
			<TR CLASS=DataLight>
		<%		}else{%>
			<TR CLASS=DataDark>
		<%		}%>
		  <TD></TD>
	      <TD colspan=9><%=m_description%></TD>
	    </TR>
	    <TR><TD class=Line colSpan=9 style="padding: 0px"></TD></TR>

<%		
	switch (viewType) {
	case 1: currentvalue = m_urgentLevel; break;
	default: %><% break;
	}
	isLight = !isLight;
}
%>
	  </TBODY>
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
<SCRIPT language="JavaScript">
function doAdd() {
	document.location.href = "/workplan/data/WorkPlan.jsp?add=1&crmid=<%=crmId%>&isfromtab=<%=isfromtab%>";
}

function doSubmit() {
	weaver.action="/CRM/data/ViewContactLog.jsp?CustomerID=<%=crmId%>";
	weaver.submit();
}

function goCustomerCardBack(){
   document.location.href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmId%>";
}
</SCRIPT>
</BODY>
</HTML>