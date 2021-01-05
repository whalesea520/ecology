<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<% 
DecimalFormat df = new DecimalFormat("####################################################0.00");

boolean canview = HrmUserVarify.checkUserRight("costSummary:qry",user) ;

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo(); 

String sql = "";

String currentdate = TimeUtil.getCurrentDateString();

FnaReport.deleteFnaTmpTbLogTempData(user.getUID());

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
int enableDispalyAll=0;
String separator ="";
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
	enableDispalyAll = rs.getInt("enableDispalyAll");
	separator = Util.null2String(rs.getString("separator"));
}

boolean allowCmp = FnaRptRuleSet.allowCmp(user.getUID(), "costSummary");
boolean allowSubCmp = FnaRptRuleSet.allowSubCmp(user.getUID(), "costSummary");
boolean allowDep = FnaRptRuleSet.allowDep(user.getUID(), "costSummary");
boolean allowHrm = FnaRptRuleSet.allowHrm(user.getUID(), "costSummary");
boolean allowFcc = FnaRptRuleSet.allowFcc(user.getUID(), "costSummary");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);


int qryFunctionType = Util.getIntValue(request.getParameter("qryFunctionType"),0);//0：尚未进行查询；1：已经进行过了查询；
String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
int rptViewType = Util.getIntValue(request.getParameter("rptViewType"),0);//0：列表；1：图表；


if(!"".equals(_guid1)){
	HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(_guid1, user.getUID());

	boolean isView = "true".equals(retHm.get("isView"));//查看
	boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
	boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
	if(!isView && !isEdit && !isFull) {
		response.sendRedirect("/notice/noright.jsp") ;  
		return ; 
	}
}


String createdateselect = "6";
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
if(!createdateselect.equals("") && !createdateselect.equals("0") && !createdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(createdateselect,"0");
	todate = TimeUtil.getDateByOption(createdateselect,"1");
}

if(createdateselect.equals("6") && "".equals(fromdate)){
	fromdate = currentdate;
}



int fnayear=Util.getIntValue(request.getParameter("fnayear"),0);
if(fnayear==0){
	rs.executeSql("select id, fnayear from FnaYearsPeriods order by status desc,fnayear desc");
	if(rs.next()){
		fnayear = Util.getIntValue(rs.getString("fnayear"));
	}
}

StringBuffer fnayear_year_array = new StringBuffer();
StringBuffer fnayear_startdate_array = new StringBuffer();
StringBuffer fnayear_enddate_array = new StringBuffer();

rs.executeSql("select fnayear, startdate, enddate from FnaYearsPeriods");
while(rs.next()){
	if(fnayear_year_array.length() > 0){
		fnayear_year_array.append(",");
		fnayear_startdate_array.append(",");
		fnayear_enddate_array.append(",");
	}
	fnayear_year_array.append("\""+Util.null2String(rs.getString("fnayear")).trim()+"\"");
	fnayear_startdate_array.append("\""+Util.null2String(rs.getString("startdate")).trim()+"\"");
	fnayear_enddate_array.append("\""+Util.null2String(rs.getString("enddate")).trim()+"\"");
}

int orgType = Util.getIntValue(request.getParameter("orgType"), 1);
String subId = Util.null2String(request.getParameter("subId")).trim();
String depId = Util.null2String(request.getParameter("depId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
String fccId = Util.null2String(request.getParameter("fccId")).trim();

StringBuffer shownameSub = new StringBuffer();
StringBuffer shownameDep = new StringBuffer();
StringBuffer shownameHrm = new StringBuffer();
StringBuffer shownameFcc = new StringBuffer();

String orgIds = "";
String orgTypeName = "";

if(orgType == 1){
	sql = "select a.id, a.subcompanyname name from HrmSubCompany a where a.id in ("+subId+") ORDER BY a.showorder, a.subcompanycode, a.subcompanyname";
	orgIds = subId;
	orgTypeName = SystemEnv.getHtmlLabelName(140, user.getLanguage());
}else if(orgType == 2){
	sql = "select a.id, a.departmentname name from HrmDepartment a where a.id in ("+depId+") ORDER BY a.showorder, a.departmentcode, a.departmentname";
	orgIds = depId;
	orgTypeName = SystemEnv.getHtmlLabelName(141, user.getLanguage());
}else if(orgType == 3){
	sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+hrmId+") ORDER BY a.dsporder, a.workcode, a.lastname";
	orgIds = hrmId;
	orgTypeName = SystemEnv.getHtmlLabelName(124, user.getLanguage());
}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
	sql = "select a.id, a.name name from FnaCostCenter a where a.id in ("+fccId+") ORDER BY a.code, a.name";
	orgIds = fccId;
	orgTypeName = SystemEnv.getHtmlLabelName(515, user.getLanguage());
}

subId="";depId="";hrmId="";fccId="";

if(!"".equals(orgIds)){
	rs.executeSql(sql);
	while(rs.next()){
		if(orgType == 1){
			if(shownameSub.length() > 0){
				shownameSub.append(",");
				subId+=",";
			}
			shownameSub.append(Util.null2String(rs.getString("name")).trim());
			subId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == 2){
			if(shownameDep.length() > 0){
				shownameDep.append(",");
				depId+=",";
			}
			shownameDep.append(Util.null2String(rs.getString("name")).trim());
			depId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == 3){
			if(shownameHrm.length() > 0){
				shownameHrm.append(",");
				hrmId+=",";
			}
			shownameHrm.append(Util.null2String(rs.getString("name")).trim());
			hrmId+=Util.null2String(rs.getString("id")).trim();
		}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
			if(shownameFcc.length() > 0){
				shownameFcc.append(",");
				fccId+=",";
			}
			shownameFcc.append(Util.null2String(rs.getString("name")).trim());
			fccId+=Util.null2String(rs.getString("id")).trim();
		}
	}
}


int groupFeeperiod=Util.getIntValue(request.getParameter("groupFeeperiod"),0);

String subjectId = Util.null2String(request.getParameter("subjectId")).trim();

StringBuffer shownameSubject = new StringBuffer();
if(!"".equals(subjectId)){
	sql = "select a.id, a.name from FnaBudgetfeeType a where a.id in ("+subjectId+") ORDER BY a.codename, a.name, a.id ";
	subjectId = "";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameSubject.length() > 0){
			shownameSubject.append(",");
			subjectId+=",";
		}
		shownameSubject.append(Util.null2String(rs.getString("name")).trim());
		subjectId+=Util.null2String(rs.getString("id")).trim();
	}
}

int sumSubOrg=Util.getIntValue(request.getParameter("sumSubOrg"),0);

String[] mQArray = new String[12];
for(int i=0;i<12;i++){
	mQArray[i] = Util.getIntValue(request.getParameter("mQ"+(i+1)), 0)+"";
}
String[] qQArray = new String[4];
for(int i=0;i<4;i++){
	qQArray[i] = Util.getIntValue(request.getParameter("qQ"+(i+1)), 0)+"";
}
String[] hQArray = new String[2];
for(int i=0;i<2;i++){
	hQArray[i] = Util.getIntValue(request.getParameter("hQ"+(i+1)), 0)+"";
}
String[] yQArray = new String[1];
if(true){
	yQArray[0] = Util.getIntValue(request.getParameter("yQ1"), 0)+"";
}


int isTemp = -1;
String rptTbName = "TB_NULL";
String rptName = "";
if(qryFunctionType==1){
	rs.executeSql("select * from fnaTmpTbLog where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'");
	if(rs.next()){
		rptTbName = Util.null2String(rs.getString("tbDbName")).trim();
		rptName = Util.null2String(rs.getString("tbName")).trim();
		isTemp = Util.getIntValue(rs.getString("isTemp"), -1);
	}
}

String rptNameOrg="（"+SystemEnv.getHtmlLabelNames("18748,82531",user.getLanguage())+"）";//预算单位维度
String rptNameQ="（"+SystemEnv.getHtmlLabelNames("18648,82531",user.getLanguage())+"）";//预算期间维度

boolean isTempConfirm = true;
if(isTemp==1){
	rptName = "";
	isTempConfirm = !"".equals(Util.null2String((String)request.getSession().getAttribute("fnaRpt_"+_guid1)));
}
request.getSession().setAttribute("fnaRpt_"+_guid1, _guid1);

String defaultExpand = "";
if(qryFunctionType!=1){
	defaultExpand = "_defaultExpand=\"true\"";
}

String rptFnaOrgIds = Util.null2String(request.getParameter("rptFnaOrgIds")).trim();
StringBuffer shownameRptFnaOrgIds = new StringBuffer();
%>

<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.general.FnaRptRuleSet"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%if(rptViewType == 1){ %>
	<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
	<script type="text/javascript" src="/js/highcharts/modules/exporting_wev8.js"></script>
	<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<%}else{ %>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
	
	<link rel="stylesheet" type="text/css" href="/fna/js/ext-all_fna_wev8.css" />
	
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/iconMgr_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/CardLayout_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/Wizard_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/showmethod_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/Card_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/Header_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/TreeCheckNodeUI_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
<%} %>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<body style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isTemp==0 || isTemp==1){
	RCMenu += "{"+((rptViewType == 0)?SystemEnv.getHtmlLabelName(82509,user.getLanguage()):SystemEnv.getHtmlLabelName(82532,user.getLanguage()))+",javascript:doChangeView(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
}
if(isTemp==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82508,user.getLanguage())+",javascript:doSaveResult(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
}
if(isTemp==0 || isTemp==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:doExpExcel(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/report/costSummary/costSummaryInner.jsp">
<input id="qryFunctionType" name="qryFunctionType" value="0" type="hidden" />
<input id="_guid1" name="_guid1" value="<%=_guid1 %>" type="hidden" />
<input id="rptViewType" name="rptViewType" value="<%=rptViewType %>" type="hidden" />


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(isTemp==0 || isTemp==1){ %>
				<input type="button" value="<%=((rptViewType == 0)?SystemEnv.getHtmlLabelName(82509,user.getLanguage()):SystemEnv.getHtmlLabelName(82532,user.getLanguage())) %>" 
					class="e8_btn_top" onclick="doChangeView()"/><!-- 图表视图 -->
			<%} %>
			<%if(isTemp==1){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82508,user.getLanguage()) %>" class="e8_btn_top" onclick="doSaveResult()"/><!-- 保存查询结果 -->
			<%} %>
			<%if(isTemp==0 || isTemp==1){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="e8_btn_top" onclick="doExpExcel()"/><!-- 导出Excel -->
			<%} %>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" <%=defaultExpand %>><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'><!-- 常用条件 -->
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18748,user.getLanguage())%></wea:item><!-- 预算单位 -->
		    <wea:item>
				<select id="orgType" name="orgType" onchange="orgType_onchange();" style="width: 80px;float: left;">
				<%if(fnaBudgetOAOrg){ %>
				<%if(allowCmp){ %>
					<option value="0" <%=(orgType==0)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(140, user.getLanguage()) %></option><!-- 总部 -->
				<%} %>
				<%if(allowSubCmp){ %>
					<option value="1" <%=(orgType==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141, user.getLanguage()) %></option><!-- 分部 -->
				<%} %>
				<%if(allowDep){ %>
					<option value="2" <%=(orgType==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124, user.getLanguage()) %></option><!-- 部门 -->
				<%} %>
				<%if(allowHrm){ %>
					<option value="3" <%=(orgType==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(6087, user.getLanguage()) %></option><!-- 个人 -->
				<%} %>
				<%} %>
				<%if(fnaBudgetCostCenter && allowFcc){ %>
					<option value="<%=FnaCostCenter.ORGANIZATION_TYPE %>" 
						<%=(orgType==FnaCostCenter.ORGANIZATION_TYPE)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(515, user.getLanguage()) %></option><!-- 成本中心 -->
				<%} %>
				</select>
			
			<%if(fnaBudgetOAOrg){ %>
	            <span id="spanSubId" style="display: none;">
			        <brow:browser viewType="0" name="subId" browserValue='<%=subId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
			                browserSpanValue='<%=shownameSub.toString() %>' width="60%" 
			                >
			        </brow:browser>
			    </span>
	            <span id="spanDepId" style="display: none;">
			        <brow:browser viewType="0" name="depId" browserValue='<%=depId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
			                browserSpanValue='<%=shownameDep.toString() %>' width="60%" 
			                >
			        </brow:browser>
			    </span>
	            <span id="spanHrmId" style="display: none;">
			        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId %>' 
			                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
			                browserSpanValue='<%=shownameHrm.toString() %>' width="60%" 
			                >
			        </brow:browser>
			    </span>
			<%} %>
			<%if(fnaBudgetCostCenter){ %>
	            <span id="spanFccId" style="display: none;">
			        <brow:browser viewType="0" name="fccId" browserValue='<%=fccId %>' 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
			                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
			                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
			                browserSpanValue='<%=shownameFcc.toString() %>' width="60%" 
			               	>
			        </brow:browser>
			    </span>
			<%} %>
				
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></wea:item><!-- 预算年度 -->
		    <wea:item>
				<select id="fnayear" name="fnayear" style="width: 60px;" onchange="setMaxMinDate();">
				<%
				rs.executeSql("select id, fnayear from FnaYearsPeriods order by fnayear desc");
				while(rs.next()){
					int _fnayear = Util.getIntValue(rs.getString("fnayear"));
				%>
					<option value="<%=_fnayear %>" <%=(_fnayear==fnayear)?"selected":"" %>><%=_fnayear %></option>
				<%
				}
				%>
				</select>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("1462",user.getLanguage())%></wea:item><!-- 预算科目 -->
		    <wea:item>
		        <brow:browser viewType="0" name="subjectId" browserValue='<%=subjectId %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaType4Report/FnaType4ReportBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaBudgetfeeTypeMultiByGroupCtrl" 
		                temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>'
		                browserSpanValue='<%=shownameSubject.toString() %>' width="85%" 
		                _callback="subjectId_callback" afterDelCallback="subjectId_callback">
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("23566",user.getLanguage()) %></wea:item><!-- 预算汇总 -->
		    <wea:item>
	            <span id="groupFeeperiod1Span">
					<input id="groupFeeperiod1" name="groupFeeperiod" onclick="groupFeeperiod_click();" type="radio" value="1" <%=(groupFeeperiod==0)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(19398,user.getLanguage()) %><!-- 月度 -->
			    </span>
	            <span id="groupFeeperiod2Span">
					<input id="groupFeeperiod2" name="groupFeeperiod" onclick="groupFeeperiod_click();" type="radio" value="2" <%=(groupFeeperiod==2)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage()) %><!-- 季度 -->
			    </span>
	            <span id="groupFeeperiod3Span">
					<input id="groupFeeperiod3" name="groupFeeperiod" onclick="groupFeeperiod_click();" type="radio" value="3" <%=(groupFeeperiod==3)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(19483,user.getLanguage()) %><!-- 半年度 -->
			    </span>
	            <span id="groupFeeperiod4Span">
					<input id="groupFeeperiod4" name="groupFeeperiod" onclick="groupFeeperiod_click();" type="radio" value="4" <%=(groupFeeperiod==4)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(17138,user.getLanguage()) %><!-- 年度 -->
			    </span>
	            <span id="groupFeeperiod5Span">
					<input id="groupFeeperiod5" name="groupFeeperiod" onclick="groupFeeperiod_click();" type="radio" value="-1" <%=(groupFeeperiod==-1)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(97,user.getLanguage()) %><!-- 按日期 -->
			    </span>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(82526,user.getLanguage())%></wea:item><!-- 递归统计下级费用 -->
		    <wea:item>
				<input id="sumSubOrg" name="sumSubOrg" type="checkbox" value="1" tzCheckbox="true" <%=(sumSubOrg==1)?"checked":"" %> />
				<span class="xTable_algorithmdesc" 
					 title="<%=SystemEnv.getHtmlLabelName(82550,user.getLanguage())%>&#13;<%=SystemEnv.getHtmlLabelName(82548,user.getLanguage())%>">
					 <img src="/images/tooltip_wev8.png" align="Middle" style="vertical-align:top;">
				</span><!-- 开启：则报表查询结果中统计的费用包含当前显示的预算单位及其下级单位的费用；关闭：则报表查询结果中统计的费用仅为当前显示的预算单位本身的数值； -->
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("18648",user.getLanguage())%></wea:item><!-- 预算期间 -->
		    <wea:item>
		    	<span id="spanMQ" style="display: none;">
			    	<input id="mQ1" name="mQ1" value="1" <%="1".equals(mQArray[0])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130051,user.getLanguage())%>
			    	<input id="mQ2" name="mQ2" value="1" <%="1".equals(mQArray[1])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130052,user.getLanguage())%>
			    	<input id="mQ3" name="mQ3" value="1" <%="1".equals(mQArray[2])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130053,user.getLanguage())%>
			    	<input id="mQ4" name="mQ4" value="1" <%="1".equals(mQArray[3])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130054,user.getLanguage())%>
			    	<input id="mQ5" name="mQ5" value="1" <%="1".equals(mQArray[4])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130055,user.getLanguage())%>
			    	<input id="mQ6" name="mQ6" value="1" <%="1".equals(mQArray[5])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130056,user.getLanguage())%>
			    	<br />
			    	<input id="mQ7" name="mQ7" value="1" <%="1".equals(mQArray[6])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130057,user.getLanguage())%>
			    	<input id="mQ8" name="mQ8" value="1" <%="1".equals(mQArray[7])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130058,user.getLanguage())%>
			    	<input id="mQ9" name="mQ9" value="1" <%="1".equals(mQArray[8])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130059,user.getLanguage())%>
			    	<input id="mQ10" name="mQ10" value="1" <%="1".equals(mQArray[9])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130060,user.getLanguage())%>
			    	<input id="mQ11" name="mQ11" value="1" <%="1".equals(mQArray[10])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130061,user.getLanguage())%>
			    	<input id="mQ12" name="mQ12" value="1" <%="1".equals(mQArray[11])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(130062,user.getLanguage())%>
		    	</span>
		    	<span id="spanQQ" style="display: none;">
			    	<input id="qQ1" name="qQ1" value="1" <%="1".equals(qQArray[0])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(28287,user.getLanguage())%>
			    	<input id="qQ2" name="qQ2" value="1" <%="1".equals(qQArray[1])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(28288,user.getLanguage())%>
			    	<input id="qQ3" name="qQ3" value="1" <%="1".equals(qQArray[2])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(28289,user.getLanguage())%>
			    	<input id="qQ4" name="qQ4" value="1" <%="1".equals(qQArray[3])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(28290,user.getLanguage())%>
		    	</span>
		    	<span id="spanHQ" style="display: none;">
			    	<input id="hQ1" name="hQ1" value="1" <%="1".equals(hQArray[0])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(82520,user.getLanguage())%>
			    	<input id="hQ2" name="hQ2" value="1" <%="1".equals(hQArray[1])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(82521,user.getLanguage())%>
		    	</span>
		    	<span id="spanYQ" style="display: none;">
			    	<input id="yQ1" name="yQ1" value="1" <%="1".equals(yQArray[0])?"checked":"" %> type="checkbox" /><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%>
		    	</span>
		    	<span id="spanDate" style="display: none;">
					<input id="createdateselect" name="createdateselect" value="6" type="hidden" />
					<span id="createdate" style="<%=createdateselect.equals("6")?"":"display:none;" %>">
						<input class=wuiDate  type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>" _minDate="" _maxDate="" />
						-&nbsp;&nbsp; 
						<input class=wuiDate  type="hidden" id="todate" name="todate" value="<%=todate%>" _minDate="" _maxDate="" />
					</span>
		    	</span>
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="resetCondtion();"
	    			value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/><!-- 重置 -->
	    		<input class="e8_btn_cancel" type="button" id="cancel" 
	    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>

<%
	List colList = new ArrayList();
	StringBuffer storeFields = new StringBuffer("");
	StringBuffer columns = new StringBuffer("");
	StringBuffer storeData = new StringBuffer("");

	StringBuffer categoriesStr = new StringBuffer();
	StringBuffer sum_amt_str = new StringBuffer();


	if(rptViewType == 0){
		rs.executeSql("select * from fnaTmpTbLogColInfo a where a.guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ORDER BY id");
		while(rs.next()){
			String colDbName = Util.null2String(rs.getString("colDbName")).trim();
			String colType = Util.null2String(rs.getString("colType")).trim();
			int colValueInt = Util.getIntValue(rs.getString("colValueInt"));
			
			colList.add(colDbName);
			
			if(storeFields.length() > 0){
				storeFields.append(",");
				columns.append(",");
			}

			if(SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage()).equals(colType)){
				storeFields.append(JSONObject.quote(colDbName));
				columns.append("{\"header\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(1462,user.getLanguage()))+","+
					"\"id\":"+JSONObject.quote(colDbName)+","+
					"\"dataIndex\":"+JSONObject.quote(colDbName)+","+
					"\"width\":280,\"locked\":true}");
				
			}else{
				
				String _orgType = "";
				if(SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage()).equals(colType)){
					_orgType = "";
				}else if((SystemEnv.getHtmlLabelName(140, user.getLanguage())+"id").equals(colType)){
					_orgType = "0";
				}else if((SystemEnv.getHtmlLabelName(141, user.getLanguage())+"id").equals(colType)){
					_orgType = "1";
				}else if((SystemEnv.getHtmlLabelName(124, user.getLanguage())+"id").equals(colType)){
					_orgType = "2";
				}else if((SystemEnv.getHtmlLabelName(6087, user.getLanguage())+"id").equals(colType)){
					_orgType = "3";
				}else if((SystemEnv.getHtmlLabelName(515, user.getLanguage())+"id").equals(colType)){
					_orgType = FnaCostCenter.ORGANIZATION_TYPE+"";
				}

				String colShowName = fnaSplitPageTransmethod.getOrgName(colValueInt+"", _orgType);
				
				storeFields.append(JSONObject.quote(colDbName));
				columns.append("{\"header\":"+JSONObject.quote(colShowName)+","+
						"\"id\":"+JSONObject.quote(colDbName)+","+
						"\"dataIndex\":"+JSONObject.quote(colDbName)+","+
						"\"width\":100}");
			}
		}
		
		if(storeFields.length()==0){
			colList.add("subject");
			
			storeFields.append(JSONObject.quote("subject"));
			columns.append("{\"header\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(1462,user.getLanguage()))+","+
				"\"id\":"+JSONObject.quote("subject")+","+
				"\"dataIndex\":"+JSONObject.quote("subject")+","+
				"\"width\":100,"+"\"locked\":true}");
		}

		int colListLen = colList.size();
		

		String backFields =" * ";
		String fromSql = " from "+rptTbName+" \n";
		String sqlWhere = " where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ";
		String orderBy = "id";
		
		String sqlprimarykey = "id";

		HashMap<String, String> sumAmtHm = new HashMap<String, String>();
		int idx = 1;
		String _sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
		//out.println(_sql);
		rs.executeSql(_sql);
		while(rs.next()){
			storeData.append("[");
			for(int i=0;i<colListLen;i++){
				String colDbName = (String)colList.get(i);
				String _val = Util.null2String(rs.getString(colDbName)).trim();
				String _showVal = "";
				if(i==0){
					_showVal = "";
					if(enableDispalyAll==1){
						_showVal = budgetfeeTypeComInfo.getSubjectFullName(_val, separator);
					}else{
						_showVal = fnaSplitPageTransmethod.getSubjectNames(_val);
					}
				}else{
					_showVal = fnaSplitPageTransmethod.fmtAmount(_val);
					FnaReport.sumAmount(colDbName, Util.getDoubleValue(_showVal, 0.0), sumAmtHm, df);
				}
				if(i>0){
					storeData.append(",");
				}
				if(i>=1){
					_showVal = fnaSplitPageTransmethod.fmtAmountQuartile(_showVal);
				}
				storeData.append(JSONObject.quote(_showVal));
			}
			storeData.append("],");
			idx++;
		}

		storeData.append("[");
		storeData.append(JSONObject.quote(SystemEnv.getHtmlLabelName(358,user.getLanguage())));//合计
		for(int i=1;i<colListLen;i++){
			String colDbName = (String)colList.get(i);
			String _showVal = sumAmtHm.get(colDbName);
			storeData.append(","+JSONObject.quote(fnaSplitPageTransmethod.fmtAmountQuartile(_showVal)));
		}
		storeData.append("],");

		storeData.append("[");
		storeData.append("null");
		for(int i=1;i<colListLen;i++){
			String colDbName = (String)colList.get(i);
			storeData.append(",null");
		}
		storeData.append("]");
		
	}else if(rptViewType == 1 && !"TB_NULL".equals(rptTbName)){
		
		String colType = "";
		if("0".equals(orgType+"")){
			colType = SystemEnv.getHtmlLabelName(140, user.getLanguage())+"id";
		}else if("1".equals(orgType+"")){
			colType = SystemEnv.getHtmlLabelName(141, user.getLanguage())+"id";
		}else if("2".equals(orgType+"")){
			colType = SystemEnv.getHtmlLabelName(124, user.getLanguage())+"id";
		}else if("3".equals(orgType+"")){
			colType = SystemEnv.getHtmlLabelName(6087, user.getLanguage())+"id";
		}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(orgType+"")){
			colType = SystemEnv.getHtmlLabelName(515, user.getLanguage())+"id";
		}
	
		List rptFnaOrgId_list = new ArrayList();
		if("".equals(rptFnaOrgIds) && !"".equals(orgIds)){
			String[] orgIdsArray = orgIds.split(",");
			for(int i=0;i<orgIdsArray.length && i<20;i++){
				if(i > 0){
					rptFnaOrgIds += ",";
				}
				rptFnaOrgIds += orgIdsArray[i];
				rptFnaOrgId_list.add(orgIdsArray[i]);
			}
		}else if("".equals(rptFnaOrgIds)){
			int idx = 0;
			String strtmp = "select colValueInt from fnaTmpTbLogColInfo \n" +
					" where colType not in ('"+SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage())+"')\n" +
					" and guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
			rs.executeSql(strtmp);
			while(rs.next() && idx < 20){
				String _orgId = Util.null2String(rs.getString("colValueInt")).trim();
				if(idx > 0){
					rptFnaOrgIds += ",";
				}
				rptFnaOrgIds += _orgId;
				rptFnaOrgId_list.add(_orgId);
				idx++;
			}
		}else if(!"".equals(rptFnaOrgIds)){
			String[] orgIdsArray = rptFnaOrgIds.split(",");
			for(int i=0;i<orgIdsArray.length && i<20;i++){
				rptFnaOrgId_list.add(orgIdsArray[i]);
			}
		}
		
		//new BaseBean().writeLog("rptFnaOrgIds>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+rptFnaOrgIds);
		
		if(!"".equals(rptFnaOrgIds)){
			if(orgType == 1){
				sql = "select a.id, a.subcompanyname name from HrmSubCompany a where a.id in ("+rptFnaOrgIds+") ORDER BY a.showorder, a.subcompanycode, a.subcompanyname";
			}else if(orgType == 2){
				sql = "select a.id, a.departmentname name from HrmDepartment a where a.id in ("+rptFnaOrgIds+") ORDER BY a.showorder, a.departmentcode, a.departmentname";
			}else if(orgType == 3){
				sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+rptFnaOrgIds+") ORDER BY a.dsporder, a.workcode, a.lastname";
			}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
				sql = "select a.id, a.name name from FnaCostCenter a where a.id in ("+rptFnaOrgIds+") ORDER BY a.code, a.name";
			}
			//new BaseBean().writeLog("rptFnaOrgIds sql>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+sql);
			rs.executeSql(sql);
			while(rs.next()){
				if(shownameRptFnaOrgIds.length() > 0){
					shownameRptFnaOrgIds.append(",");
				}
				shownameRptFnaOrgIds.append(Util.null2String(rs.getString("name")).trim());
			}
		}

		//new BaseBean().writeLog("shownameRptFnaOrgIds>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+shownameRptFnaOrgIds);

		categoriesStr.append("[");
		sum_amt_str.append("[");
		
		for(int i=0;i<rptFnaOrgId_list.size();i++){
			int _orgId = Util.getIntValue((String)rptFnaOrgId_list.get(i));
			double sumAmt = 0.00;//总费用
			
			String colDbName = "";
			String sql1 = "select colDbName from fnaTmpTbLogColInfo "+
				" where colValueInt = "+_orgId+" and colType = '"+StringEscapeUtils.escapeSql(colType)+"' "+
				" and guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
			rs1.executeSql(sql1);
			if(rs1.next()){
				colDbName = Util.null2String(rs1.getString("colDbName")).trim();
			}
			
			sql1 = "select SUM("+colDbName+") sumAmt \n" +
				" from "+rptTbName+" \n" +
				" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
			rs1.executeSql(sql1);
			if(rs1.next()){
				sumAmt = Util.getDoubleValue(rs1.getString("sumAmt"), 0.00);
			}
			
			String _orgName = fnaSplitPageTransmethod.getOrgName(_orgId+"", orgType+"");
			
			StringBuffer sub1_categories = new StringBuffer("[");
			StringBuffer sub1_data_amt = new StringBuffer("[");
			
			int idx2 = 0;
			String sql2 = "select subject, "+colDbName+" amt "+
				" from "+rptTbName+" "+
				" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' "+
				" order by id";
			rs2.executeSql(sql2);
			while(rs2.next()){
				int _subject = rs2.getInt("subject");
				double _amt = Util.getDoubleValue(rs2.getString("amt"), 0.0);
				
				String _subjectName = "";
				if(enableDispalyAll==1){
					_subjectName = budgetfeeTypeComInfo.getSubjectFullName(_subject+"", separator);
				}else{
					_subjectName = fnaSplitPageTransmethod.getSubjectNames(_subject+"");
				}
				
				if(idx2 > 0){
					sub1_categories.append(",");
					sub1_data_amt.append(",");
				}
				
				sub1_categories.append(JSONObject.quote(_subjectName));
				sub1_data_amt.append(df.format(_amt));
				
				idx2++;
			}
			sub1_categories.append("]");
			sub1_data_amt.append("]");
			
			String sub1_data = "[{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(1026,user.getLanguage()))+",data:"+sub1_data_amt.toString()+"}]";//总费用
			
			String drilldown = "drilldown:{"+
					"sub1_name:"+JSONObject.quote(_orgName)+","+
					"sub1_categories:"+sub1_categories.toString()+","+
					"sub1_data:"+sub1_data+
				"}";
			
				
			if(i > 0){
				categoriesStr.append(",");
				sum_amt_str.append(",");
			}

			categoriesStr.append(JSONObject.quote(_orgName));
			
			sum_amt_str.append("{y:"+df.format(sumAmt)+","+
					drilldown+
				"}");
		}
		categoriesStr.append("]");
		sum_amt_str.append("]");
		
	}
%>
	<%if(rptViewType == 0){ %>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="orgGrid" style="width:100%;height:100%;"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<%}else{ %>
	<wea:layout type="2col">
		<%if(orgType != 0){ %>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(82544,user.getLanguage())%>'><!-- 数据过滤 -->
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18748,user.getLanguage())%></wea:item><!-- 预算单位 -->
	    	<wea:item>
	    		<!-- 这边需要做一个可选择所有被统计的预算机构的浏览按钮 -->
		        <brow:browser viewType="0" name="rptFnaOrgIds" browserValue='<%=rptFnaOrgIds %>' 
		                browserUrl='<%=FnaReport.MUTI_FNA_RPT_BROWSER+"%3F_guid1="+_guid1+"%26selectedids=#id#" %>'
		                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl='<%="/data.jsp?type=MUTI_FNA_RPT_BROWSER%26_guid1="+_guid1 %>'
		                temptitle='<%= SystemEnv.getHtmlLabelName(18748,user.getLanguage())%>'
		                browserSpanValue='<%=shownameRptFnaOrgIds.toString() %>' width="90%" 
		                _callback="rptFnaOrgIds_callback" afterDelCallback="rptFnaOrgIds_callback">
		        </brow:browser>
	    	</wea:item>
		</wea:group>
		<%} %>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="container1" style="min-width:700px;height:300px"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<%} %>
</form>
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>

<%if(rptViewType == 0){ %>
<style>
.x-grid3-col-subject{
	text-align: left !important;
	font-weight: bold;
}
</style>
<%} %>

<script language="javascript">
var _guid1 = "<%=_guid1 %>";

<%if(rptViewType == 0){ %>
var ext_grid = null;
var ext_gen8=null

Ext.onReady(function(){
	ext_gen8=Ext.get("ext-gen8");
	
	var data=[<%=storeData %>]; 
	var store=new Ext.data.SimpleStore({data:data,fields:[<%=storeFields %>]}); 
	
	ext_grid = new Ext.grid.LockingEditorGridPanel({
		columns:[<%=columns.toString() %>], 
		width:ext_gen8.getComputedWidth(),
		height:ext_gen8.getComputedHeight(),
		store:store,
		stripeRows: true,
		renderTo:"orgGrid"
	}); 
	setExtGridColumnWidth(ext_grid, 1);
}); 

window.onresize=function(){
	extGrid_onresize(ext_grid, _ext_gen8);
};  
<%} %>

jQuery(document).ready(function(){
	orgType_onchange();
	feeperiod_onchange();

<%if(!isTempConfirm){ %>
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82525,user.getLanguage()) %>", 
		function(){
			doSaveResult();
		},function(){}
	);
<%} %>


<%if(rptViewType == 1){ %>
	showAbsentDiv1();
<%} %>
});

<%if(rptViewType == 1){ %>

function rptFnaOrgIds_callback(event,datas,name,_callbackParams){
	doChangeView("1");
}

function setChart1(_char, _categories, _seriesDateArray, _title, _subtitle) {
	if(_title!=null && _subtitle!=null){
		_char.setTitle(_title, _subtitle, false);
	}
	_char.xAxis[0].setCategories(_categories, false);
	while(_char.series.length>0){
		_char.series[0].remove(false);
	}
	for(var i=0;i<_seriesDateArray.length;i++){
		_char.addSeries(_seriesDateArray[i], false);
	}
	_char.redraw();
}

var chart = null;
var container_categories = <%=categoriesStr.toString() %>;
var container_data = [{
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(1026, user.getLanguage())) %>,
		data: <%=sum_amt_str.toString() %>
	}];
	
function showAbsentDiv1(){
	chart = jQuery("#container1").highcharts({
		plotOptions: {
			column: {
				cursor: 'pointer',
				point: {
					events: {
						click: function() {
							var drilldown = this.drilldown;
							if (drilldown) { // drill down
								setChart1(chart, drilldown.sub1_categories, drilldown.sub1_data, {text: <%=JSONObject.quote(rptName+rptNameOrg) %>}, {text: drilldown.sub1_name});
							} else { // restore
								setChart1(chart, container_categories, container_data, {text: <%=JSONObject.quote(rptName+rptNameOrg) %>}, {text: ""});
							}
						}
					}
				}
			}
		},
		chart: {
			type: "column"
		},
		title: {
			text: <%=JSONObject.quote(rptName+rptNameOrg) %>
		},
		subtitle: {
			text: ""
		},
		xAxis: {
			categories: container_categories
		},
		yAxis: {
			title: {
				text: ""
			}
		},
		series: container_data,
		credits: {
			enabled: false
		},
		exporting: {
			enabled: false
		},
		lang: {
			printChart: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(257, user.getLanguage())) %>,
			downloadJPEG: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(258, user.getLanguage())+"JPEG"+SystemEnv.getHtmlLabelName(74, user.getLanguage())) %>,
			downloadPDF: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(258, user.getLanguage())+"PDF"+SystemEnv.getHtmlLabelName(58, user.getLanguage())) %>,
			downloadPNG: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(258, user.getLanguage())+"PNG"+SystemEnv.getHtmlLabelName(74, user.getLanguage())) %>,
			downloadSVG: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(258, user.getLanguage())+"SVG"+SystemEnv.getHtmlLabelName(82530, user.getLanguage())) %>,
			exportButtonTitle: <%=JSONObject.quote(SystemEnv.getHtmlLabelNames("17416,74", user.getLanguage())) %>
		}
	}).highcharts();
}
<%} %>

function setMaxMinDate(){
	var fnayear_year_array = [<%=fnayear_year_array.toString() %>];
	var fnayear_startdate_array = [<%=fnayear_startdate_array.toString() %>];
	var fnayear_enddate_array = [<%=fnayear_enddate_array.toString() %>];
	
	var createdateselect = jQuery("#createdateselect").val();
	if(createdateselect=="6"){
		var fnayear = jQuery("#fnayear").val();
		var fromdateObj = jQuery("#fromdate");
		var todateObj = jQuery("#todate");

		for(var i=0;i<fnayear_year_array.length;i++){
			if(fnayear_year_array[i]==fnayear){
				fromdateObj.attr("_minDate", fnayear_startdate_array[i]);
				fromdateObj.attr("_maxDate", fnayear_enddate_array[i]);
				todateObj.attr("_minDate", fnayear_startdate_array[i]);
				todateObj.attr("_maxDate", fnayear_enddate_array[i]);
				
				if(fromdateObj.val() < fnayear_startdate_array[i] || fromdateObj.val() > fnayear_enddate_array[i]){
					fromdateObj.val("");
					jQuery("#fromdateReleSpan_Autogrt").html("");
				}
				if(todateObj.val() < fnayear_startdate_array[i] || todateObj.val() > fnayear_enddate_array[i]){
					todateObj.val("");
					jQuery("#todateReleSpan_Autogrt").html("");
				}
				
				return;
			}
		}
		fromdateObj.attr("_minDate", "9999-12-31");
		fromdateObj.attr("_maxDate", "9999-12-31");
		todateObj.attr("_minDate", "9999-12-31");
		todateObj.attr("_maxDate", "9999-12-31");
	}
}

function hiddenSaveBtn(){
	jQuery("#qryFunctionType").val("1");
	jQuery("#_guid1").val(_guid1);
	form2.submit();
}

//切换报表视图
function doChangeView(_type){
	jQuery("#qryFunctionType").val("1");
	jQuery("#_guid1").val(_guid1);
	var rptViewType = jQuery("#rptViewType").val();
	if(_type==null||_type==""){
		if(rptViewType=="0"){//当前是报表视图
			jQuery("#rptViewType").val("1");
		}else{//当前是图表视图
			jQuery("#rptViewType").val("0");
		}
	}else{
		jQuery("#rptViewType").val(_type);
	}
	form2.submit();
}

//保存查询结果
function doSaveResult(){
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?_guid1="+_guid1+"&rptTypeName=costSummary", 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//导出Excel
function doExpExcel(){
	document.getElementById("dwnfrm").src = "/fna/report/costSummary/costSummaryExcel.jsp?_guid1="+_guid1;
}

//科目浏览回调函数
//afterDelCallback(text,fieldid,params)
function subjectId_callback(event,datas,name,_callbackParams){
	feeperiod_onchange();
}

//预算汇总 click事件
function groupFeeperiod_click(){
	var spanMQObj = jQuery("#spanMQ");
	var spanQQObj = jQuery("#spanQQ");
	var spanHQObj = jQuery("#spanHQ");
	var spanYQObj = jQuery("#spanYQ");
	var spanDateObj = jQuery("#spanDate");

	spanMQObj.hide();
	spanQQObj.hide();
	spanHQObj.hide();
	spanYQObj.hide();
	spanDateObj.hide();

	var groupFeeperiod1 = jQuery("#groupFeeperiod1");
	var groupFeeperiod2 = jQuery("#groupFeeperiod2");
	var groupFeeperiod3 = jQuery("#groupFeeperiod3");
	var groupFeeperiod4 = jQuery("#groupFeeperiod4");
	var groupFeeperiod5 = jQuery("#groupFeeperiod5");
	
	if(groupFeeperiod1.attr("checked")){
		spanMQObj.show();
	}else if(groupFeeperiod2.attr("checked")){
		spanQQObj.show();
	}else if(groupFeeperiod3.attr("checked")){
		spanHQObj.show();
	}else if(groupFeeperiod4.attr("checked")){
		spanYQObj.show();
	}else if(groupFeeperiod5.attr("checked")){
		spanDateObj.show();
	}
	
	setMaxMinDate();
}

//切换科目期间类型
function feeperiod_onchange(){
	var groupFeeperiod1Span = jQuery("#groupFeeperiod1Span");
	var groupFeeperiod2Span = jQuery("#groupFeeperiod2Span");
	var groupFeeperiod3Span = jQuery("#groupFeeperiod3Span");
	var groupFeeperiod4Span = jQuery("#groupFeeperiod4Span");
	var groupFeeperiod5Span = jQuery("#groupFeeperiod5Span");

	var maxFeeperiod = 1;

	var groupFeeperiod1 = jQuery("#groupFeeperiod1");
	var groupFeeperiod2 = jQuery("#groupFeeperiod2");
	var groupFeeperiod3 = jQuery("#groupFeeperiod3");
	var groupFeeperiod4 = jQuery("#groupFeeperiod4");
	var groupFeeperiod5 = jQuery("#groupFeeperiod5");

	if(maxFeeperiod==1){
		groupFeeperiod1Span.show();
		groupFeeperiod2Span.show();
		groupFeeperiod3Span.show();
		groupFeeperiod4Span.show();
		groupFeeperiod5Span.show();

		if(!groupFeeperiod1.attr("checked") && !groupFeeperiod2.attr("checked") && !groupFeeperiod3.attr("checked") && !groupFeeperiod4.attr("checked") && !groupFeeperiod5.attr("checked")){
			groupFeeperiod1.trigger("click");
		}
	}
	
	groupFeeperiod_click();

}

//切换费用单位类型
function orgType_onchange(){
	var spanSubIdObj = jQuery("#spanSubId");
	var spanDepIdObj = jQuery("#spanDepId");
	var spanHrmIdObj = jQuery("#spanHrmId");
	var spanFccIdObj = jQuery("#spanFccId");

	spanSubIdObj.hide();
	spanDepIdObj.hide();
	spanHrmIdObj.hide();
	spanFccIdObj.hide();
	
	var orgType = jQuery("#orgType").val();
	if(orgType=="1"){
		spanSubIdObj.show();
	}else if(orgType=="2"){
		spanDepIdObj.show();
	}else if(orgType=="3"){
		spanHrmIdObj.show();
	}else if(orgType=="<%=FnaCostCenter.ORGANIZATION_TYPE %>"){
		spanFccIdObj.show();
	}
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){

	var fnayear = jQuery("#fnayear").val();
	var orgType = jQuery("#orgType").val();
	var subId = jQuery("#subId").val();
	var depId = jQuery("#depId").val();
	var hrmId = jQuery("#hrmId").val();
	var fccId = jQuery("#fccId").val();
	var subjectId = jQuery("#subjectId").val();
	var sumSubOrg = jQuery("#sumSubOrg").attr("checked")?"1":"";
	var createdateselect = jQuery("#createdateselect").val();
	var fromdate = jQuery("#fromdate").val();
	var todate = jQuery("#todate").val();
	
	if(orgType=="0"){
		subId = "";depId = "";hrmId = "";fccId = "";
		jQuery("#subId").val("");
		jQuery("#depId").val("");
		jQuery("#hrmId").val("");
		jQuery("#fccId").val("");
	}else if(orgType=="1"){
		depId = "";hrmId = "";fccId = "";
		jQuery("#depId").val("");
		jQuery("#hrmId").val("");
		jQuery("#fccId").val("");
	}else if(orgType=="2"){
		subId = "";hrmId = "";fccId = "";
		jQuery("#subId").val("");
		jQuery("#hrmId").val("");
		jQuery("#fccId").val("");
	}else if(orgType=="3"){
		subId = "";depId = "";fccId = "";
		jQuery("#subId").val("");
		jQuery("#depId").val("");
		jQuery("#fccId").val("");
	}else if(orgType=="<%=FnaCostCenter.ORGANIZATION_TYPE %>"){
		subId = "";depId = "";hrmId = "";
		jQuery("#subId").val("");
		jQuery("#depId").val("");
		jQuery("#hrmId").val("");
	}
	
	var groupFeeperiod1 = jQuery("#groupFeeperiod1");
	var groupFeeperiod2 = jQuery("#groupFeeperiod2");
	var groupFeeperiod3 = jQuery("#groupFeeperiod3");
	var groupFeeperiod4 = jQuery("#groupFeeperiod4");
	var groupFeeperiod5 = jQuery("#groupFeeperiod5");

	var groupFeeperiod = "1";
	if(groupFeeperiod1.attr("checked")){
		groupFeeperiod = "1";
	}else if(groupFeeperiod2.attr("checked")){
		groupFeeperiod = "2";
	}else if(groupFeeperiod3.attr("checked")){
		groupFeeperiod = "3";
	}else if(groupFeeperiod4.attr("checked")){
		groupFeeperiod = "4";
	}else if(groupFeeperiod5.attr("checked")){
		groupFeeperiod = "-1";
	}
	

	var qAll = "";
	var urlQAll = "&urlQAll=";
	
	if(groupFeeperiod=="1"){
		for(var i=1;i<=12;i++){
			var _q = jQuery("#mQ"+i).attr("checked")?"1":"";
			if(_q=="1"){
				if(qAll!=""){
					qAll += ",";
				}
				qAll += i;
			}
			urlQAll += ("&mQ"+i+"="+_q);
		}
	}else if(groupFeeperiod=="2"){
		for(var i=1;i<=4;i++){
			var _q = jQuery("#qQ"+i).attr("checked")?"1":"";
			if(_q=="1"){
				if(qAll!=""){
					qAll += ",";
				}
				qAll += i;
			}
			urlQAll += ("&qQ"+i+"="+_q);
		}
	}else if(groupFeeperiod=="3"){
		for(var i=1;i<=2;i++){
			var _q = jQuery("#hQ"+i).attr("checked")?"1":"";
			if(_q=="1"){
				if(qAll!=""){
					qAll += ",";
				}
				qAll += i;
			}
			urlQAll += ("&hQ"+i+"="+_q);
		}
	}else if(groupFeeperiod=="4"){
		var _q = jQuery("#yQ1").attr("checked")?"1":"";
		if(_q=="1"){
			qAll = "1";
		}
		urlQAll += ("&yQ1="+_q);
	}else if(groupFeeperiod=="-1"){
		if(createdateselect!="" && createdateselect!="0" && createdateselect!="6"){
		}else if(jQuery("#fromdate").val()==""){
			alert("<%=SystemEnv.getHtmlLabelNames("18648,18019",user.getLanguage())%>");
			return;
		}
	}
	
	if(qAll=="" && groupFeeperiod!="-1"){
		alert("<%=SystemEnv.getHtmlLabelNames("18214,18648",user.getLanguage())%>");
		return;
	}

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82522,user.getLanguage()) %>", 
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);

			jQuery("#rptViewType").val("0");
			jQuery("#rptFnaOrgIds").val("");
			
			var _data = "_guid1="+_guid1+"&fnayear="+fnayear+"&orgType="+orgType+"&subId="+subId+
				"&depId="+depId+"&hrmId="+hrmId+"&fccId="+fccId+"&subjectId="+subjectId+
				"&createdateselect="+createdateselect+"&fromdate="+fromdate+"&todate="+todate+
				"&sumSubOrg="+sumSubOrg+"&groupFeeperiod="+groupFeeperiod+"&qAll="+qAll+
				urlQAll+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/report/costSummary/costSummaryOp.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "html",
				success: function do4Success(_html){
				}
			});	
		},function(){}
	);
}




function getErrorInfoAjax(resultJson){
	if(resultJson.flag){
		jQuery("#qryFunctionType").val("1");
		jQuery("#_guid1").val(_guid1);
		form2.submit();
	}else{
		_guid1 = $System.Math.IntUtil.genGUIDV4();
		jQuery("#_guid1").val(_guid1);
		alert(resultJson.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
	}
}

var intervalTdTable = "";
//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	clearTimeout(intervalTdTable);
	jQuery.ajax({
		url : "/fna/FnaLoadingAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "guid="+_guid1+"&r="+$System.Math.IntUtil.genGUIDV4(),
		dataType : "json",
		success: function do4Success(_jsonObj){
		    try{
	    		if(_jsonObj.flag){
	    			clearTimeout(intervalTdTable);
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					getErrorInfoAjax(_jsonObj.resultJson);
	    		}else{
		    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
			    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=null2String(_jsonObj.infoStr);
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		intervalTdTable = setInterval("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}else{
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		intervalTdTable = setInterval("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				alert(e1.message);
		    }
		}
	});	
}

//关闭
function doClose1(){
	window.closeDialog();
}

//切换美化checkbox是否选中
function changeCheckboxStatus4tzCheckBox(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (obj.checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}
//切换美化radio是否选中
function changeRadioStatus4tzRadio(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	alert(obj.checked);
	if (obj.checked) {
		jQuery(obj).next("span.jNiceRadio").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.jNiceRadio").removeClass("jNiceChecked");
	}
}

</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
