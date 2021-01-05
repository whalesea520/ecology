
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_operator" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_requestlog" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
//权限判断，确定菜单 Start
boolean canView = false;
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
boolean shouldReturn = false;
int operatorid = 0;
int request_status = 0;
int operator_optstatus = 0;
int operator_type = 0;
if(requestid != 0){
	recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
	if(recordSet_requestbase.next()){
		wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
		request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
		int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
		if(deleted == 1){
			shouldReturn = true;
		}
		int liableperson_tmp = Util.getIntValue(recordSet_requestbase.getString("liableperson"), 0);//非单责任人，则把operatorid清为0
		if(liableperson_tmp!=0 && operatorid==0 && request_status>=6){
			recordSet_operator.execute("select * from worktask_operator where type=1 and userid="+liableperson_tmp+" and requestid="+requestid);
			if(recordSet_operator.next()){
				int operatorid_tmp = Util.getIntValue(recordSet_operator.getString("id"), 0);
				operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
				operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
				operatorid = operatorid_tmp;
			}else{
				shouldReturn = true;
			}
		}
	}else{
		shouldReturn = true;
	}
}else{
	shouldReturn = true;
}
if(shouldReturn == true){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
int needcheck = Util.getIntValue(recordSet_requestbase.getString("needcheck"), 0);
int checkor = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0);
if(needcheck == 0){
	checkor = 0;
}
int creater = Util.getIntValue(recordSet_requestbase.getString("creater"), 0);
int approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"), 0);
Hashtable checkRight_hs = wtRequestManager.checkRight(requestid, request_status, operator_optstatus, creater, checkor, approverequest);
canView = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
if(canView == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int usertype = 1;
if("1".equals(user.getLogintype())){
	usertype = 0;
}else if("2".equals(user.getLogintype())){
	usertype = 1;
}
String trmOperatorId = Util.null2String(request.getParameter("trmoperatorid"));			//操作人
String trmStartDate = Util.null2String(request.getParameter("trmstartdate"));			//开始日期
String trmEndDate = Util.null2String(request.getParameter("trmenddate"));				//结束日期

String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage())+": "+SystemEnv.getHtmlLabelName(15275, user.getLanguage());
String imagefilename = "/images/hdReport_wev8.gif";
%>

<BODY id="taskbody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:doSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>

<TR>
	<TD valign="top">
	<FORM id="frmmain" name="frmmain" method="post" action="RequestLog.jsp">
		<INPUT type="hidden" name="wtid" value="<%=wtid%>">
		<INPUT type="hidden" name="requestid" value="<%=requestid%>">
		<INPUT type="hidden" name="isRefash" value="<%=isRefash%>">
		<INPUT type="hidden" name="operationType" value="">
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
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
		<TD class="field">

			<brow:browser viewType="0" name="trmoperatorid" browserValue='<%=trmOperatorId%>' temptitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="150px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%=Util.toScreen(resourceComInfo.getResourcename(trmOperatorId), user.getLanguage())%>'></brow:browser>
		</TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>
		<TD class="field"><BUTTON  type="button" class="Calendar" id="SelectStartDate" onclick="getDate(trmstartdatespan,trmstartdate)"></BUTTON>
		  <SPAN id="trmstartdatespan"><%=trmStartDate%></SPAN>
		  <INPUT type="hidden" name="trmstartdate" value="<%=trmStartDate%>">&nbsp;-&nbsp;&nbsp;
		  <BUTTON  type="button" class="Calendar" id="SelectEndDate" onclick="getDate(trmenddatespan,trmenddate)"></BUTTON>
		  <SPAN id="trmenddatespan"><%=trmEndDate%></SPAN>
		  <INPUT type="hidden" name="trmenddate" value="<%=trmEndDate%>"></TD>
		<TD colSpan="3"></TD>
		</TR>
		<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>					
	  </TBODY>
	</TABLE>
<%
int perpage = 20;
String tableString = "";
String backfields=" t1.logid as logid, t1.fieldid as field, t1.optuserid as optuserid, t1.optdate as optdate, t1.opttime, t1.ipaddress as ipaddress, t1.oldvalue, t1.newvalue, t2.fieldhtmltype, t2.type, t2.description, t3.crmname ";

String  fromSql = " worktask_requestlog t1 left join worktask_fielddict t2 on t2.id=t1.fieldid left join worktask_taskfield t3 on t3.fieldid=t1.fieldid and t3.taskid="+wtid+" ";

String sqlWhere = " where t1.requestid="+requestid+" ";
String orderby=" logid ";
	if(!trmStartDate.equals("")){
		sqlWhere=sqlWhere+" and  t1.optdate >='" + trmStartDate + "' ";
	}
	if(!trmEndDate.equals("")){
		sqlWhere+=" and t1.optdate <='" + trmEndDate + "'";
	}
	 if(!"-1".equals(trmOperatorId) && !"".equals(trmOperatorId)){
		 sqlWhere+=" and t1.optuserid ='" + trmOperatorId + "' ";
	 }

	tableString =   " <table instanceid=\"worktaskOptLogListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
				"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"logid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
				"       <head>"+
				"			<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"crmname\" otherpara=\"column:description\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getFieldName\"/>"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17485,user.getLanguage())+"\" column=\"oldvalue\" otherpara=\"column:fieldhtmltype+column:type+column:field\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getFieldValue\" />"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17486,user.getLanguage())+"\" column=\"newvalue\" otherpara=\"column:fieldhtmltype+column:type+column:field\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getFieldValue\" />"+
				"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"optuserid\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getResourName\" orderkey=\"optuserid\" />"+
				"           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage())+"\" column=\"ipaddress\" />"+
				"           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(2061,user.getLanguage())+"\" column=\"optdate\" otherpara=\"column:opttime\" transmethod=\"weaver.splitepage.transform.SptmForWorktask.getOptTime\" orderkey=\" optdate, opttime \" />"+
				"       </head>"+
				" </table>";

%>

            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />


</BODY>
<SCRIPT language="VBS">
sub onSelectRequest(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/sales/SalesOrderBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0) <> "" then
	spanname.innerHtml = "<A href='/workflow/request/ViewRequest.jsp?requestid="&id(0)&"'>"&id(1)&"</A>"
	inputname.value = id(0)
	else
	spanname.innerHtml = ""
	inputname.value = ""
	end if
	end if
end sub

sub onSelectOperator(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0) <> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value = id(0)
	else
	spanname.innerHtml = ""
	inputname.value = ""
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function doSearch() {
    document.all("operationType").value = "search";
	document.frmmain.submit();
}

function goBack() {
	location.href="/worktask/request/ViewWorktask.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>&isRefash=<%=isRefash%>";
}


</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
