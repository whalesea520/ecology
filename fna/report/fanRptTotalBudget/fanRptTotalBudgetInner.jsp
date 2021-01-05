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

boolean canview = HrmUserVarify.checkUserRight("TotalBudgetTable:qry",user) ;

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();

String sql = "";

String currentdate = TimeUtil.getCurrentDateString();

FnaReport.deleteFnaTmpTbLogTempData(user.getUID());

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

boolean allowCmp = FnaRptRuleSet.allowCmp(user.getUID(), "fanRptTotalBudget");
boolean allowSubCmp = FnaRptRuleSet.allowSubCmp(user.getUID(), "fanRptTotalBudget");
boolean allowDep = FnaRptRuleSet.allowDep(user.getUID(), "fanRptTotalBudget");
boolean allowHrm = FnaRptRuleSet.allowHrm(user.getUID(), "fanRptTotalBudget");
boolean allowFcc = FnaRptRuleSet.allowFcc(user.getUID(), "fanRptTotalBudget");

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

int fnayear=Util.getIntValue(request.getParameter("fnayear"),0);
if(fnayear==0){
	rs.executeSql("select id, fnayear from FnaYearsPeriods order by status desc,fnayear desc");
	if(rs.next()){
		fnayear = Util.getIntValue(rs.getString("fnayear"));
	}
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

String subjectIds = Util.null2String(request.getParameter("subjectIds")).trim();

StringBuffer shownameSubject = new StringBuffer();
if(!"".equals(subjectIds)){
	sql = "select a.id, a.name from FnaBudgetfeeType a where a.id in ("+subjectIds+") ORDER BY a.codename, a.name, a.id ";
	subjectIds = "";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameSubject.length() > 0){
			shownameSubject.append(",");
			subjectIds+=",";
		}
		shownameSubject.append(Util.null2String(rs.getString("name")).trim());
		subjectIds+=Util.null2String(rs.getString("id")).trim();
	}
}

int sumSubOrg=Util.getIntValue(request.getParameter("sumSubOrg"),0);


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

<%@page import="weaver.fna.general.FnaRptRuleSet"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%if(rptViewType == 1){ %>
	<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
	<script type="text/javascript" src="/js/highcharts/modules/exporting_wev8.js"></script>
	<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<%} %>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<body>
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
<form id="form2" name="form2" method="post"  action="/fna/report/fanRptTotalBudget/fanRptTotalBudgetInner.jsp">
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
				<select id="fnayear" name="fnayear" style="width: 60px;">
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
		        <brow:browser viewType="0" name="subjectIds" browserValue='<%=subjectIds %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaType4Report/FnaType4ReportBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="" 
		                browserSpanValue='<%=shownameSubject.toString() %>' width="85%" 
		                _callback="subjectIds_callback" afterDelCallback="subjectIds_callback">
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(23566,user.getLanguage()) %></wea:item><!-- 预算汇总 -->
		    <wea:item>
	            <span id="groupFeeperiod1Span">
					<input id="groupFeeperiod1" name="groupFeeperiod" type="radio" value="1" <%=(groupFeeperiod==0)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(19398,user.getLanguage()) %><!-- 月度 -->
			    </span>
	            <span id="groupFeeperiod2Span">
					<input id="groupFeeperiod2" name="groupFeeperiod" type="radio" value="2" <%=(groupFeeperiod==2)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage()) %><!-- 季度 -->
			    </span>
	            <span id="groupFeeperiod3Span">
					<input id="groupFeeperiod3" name="groupFeeperiod" type="radio" value="3" <%=(groupFeeperiod==3)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(19483,user.getLanguage()) %><!-- 半年度 -->
			    </span>
	            <span id="groupFeeperiod4Span">
					<input id="groupFeeperiod4" name="groupFeeperiod" type="radio" value="4" <%=(groupFeeperiod==4)?"checked":"" %> notBeauty=true />
					<%=SystemEnv.getHtmlLabelName(17138,user.getLanguage()) %><!-- 年度 -->
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
	StringBuffer categoriesStr = new StringBuffer();
	StringBuffer sum_budgetAmt_str = new StringBuffer();
	StringBuffer sum_approvalAmt_str = new StringBuffer();
	StringBuffer sum_actualAmt_str = new StringBuffer();
	StringBuffer sum_availableAmt_str = new StringBuffer();

	StringBuffer categoriesStr2 = new StringBuffer();
	StringBuffer sum_budgetAmt_str2 = new StringBuffer();
	StringBuffer sum_approvalAmt_str2 = new StringBuffer();
	StringBuffer sum_actualAmt_str2 = new StringBuffer();
	StringBuffer sum_availableAmt_str2 = new StringBuffer();


	String tableString="";
	
	if(rptViewType == 0){
		//设置好搜索条件
		String backFields =" * ";
		String fromSql = " from "+rptTbName+" \n";
		String sqlWhere = " where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ";
		String orderBy = "";
		
		String sqlprimarykey = "id";

		//<span>执行比</span><span class="xTable_algorithmdesc" title="执行比=实际发生数/预算数"><img src="/images/tooltip_wev8.png" align="absMiddle" style="vertical-align:top;"></span>
		String titleExecRatio = "<span>"+SystemEnv.getHtmlLabelName(82512,user.getLanguage())+"</span>"+
			"<span class=\"xTable_algorithmdesc\" title=\""+SystemEnv.getHtmlLabelName(82547,user.getLanguage())+"\">"+
			"<img src=\"/images/tooltip_wev8.png\" align=\"Middle\" style=\"vertical-align:top;\">"+
			"</span>";
		
		String _sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
		//out.println(_sql);
		tableString=""+
	       "<table instanceid=\"FNA_FNA_RPT_TOTAL_BUDGET_LIST\" pageId=\""+PageIdConst.FNA_FNA_RPT_TOTAL_BUDGET_LIST+"\" "+
				" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_FNA_RPT_TOTAL_BUDGET_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
	       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
	       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
	       //" sumColumns=\"budgetAmt,actualAmt,availableAmt,execRatio\" decimalFormat=\""+Util.toHtmlForSplitPage("%.2f|%.2f|%.2f|%.2f%%")+"\" "+
	       " />"+
	       "<head>"+
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18748,user.getLanguage())+"\" column=\"orgId\" "+//预算单位
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOrgName\" otherpara=\"column:orgType\" "+
						" />"+
				"<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(18648,user.getLanguage())+"\" column=\"feeperiod\" "+//预算期间
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.feeperiodFullName\" otherpara=\"column:q+column:fnayear+"+user.getLanguage()+"\" "+
						" />"+
				"<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(23577,user.getLanguage())+"\" column=\"budgetAmt\" orderkey=\"budgetAmt\" align=\"right\" "+//预算数
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
						" />"+
				"<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(18769,user.getLanguage())+"\" column=\"approvalAmt\" orderkey=\"approvalAmt\" align=\"right\" "+//审批中费用
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
						" />"+
				"<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(82510,user.getLanguage())+"\" column=\"actualAmt\" orderkey=\"actualAmt\" align=\"right\" "+//实际发生数
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
						" />"+
				"<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(82511,user.getLanguage())+"\" column=\"availableAmt\" orderkey=\"availableAmt\" align=\"right\" "+//可用预算数
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
						" />"+
				"<col width=\"13%\"  text=\""+StringEscapeUtils.escapeXml(titleExecRatio)+"\" column=\"execRatio\" orderkey=\"execRatio\" align=\"right\" "+//执行比
						" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountRatioQuartile\" "+
						" />"+
	       "</head>"+
	       "</table>";
	       
	}else if(rptViewType == 1 && !"TB_NULL".equals(rptTbName)){
	
		if("".equals(rptFnaOrgIds) && !"".equals(orgIds)){
			String[] orgIdsArray = orgIds.split(",");
			for(int i=0;i<orgIdsArray.length && i<20;i++){
				if(i > 0){
					rptFnaOrgIds += ",";
				}
				rptFnaOrgIds += orgIdsArray[i];
			}
		}else if("".equals(rptFnaOrgIds)){
			int idx = 0;
			String strtmp = "select orgId from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' GROUP BY orgId ORDER BY min(id)";
			rs.executeSql(strtmp);
			while(rs.next() && idx < 20){
				if(idx > 0){
					rptFnaOrgIds += ",";
				}
				rptFnaOrgIds += Util.null2String(rs.getString("orgId")).trim();
				idx++;
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
			rs.executeSql(sql);
			while(rs.next()){
				if(shownameRptFnaOrgIds.length() > 0){
					shownameRptFnaOrgIds.append(",");
				}
				shownameRptFnaOrgIds.append(Util.null2String(rs.getString("name")).trim());
			}
		}

		categoriesStr.append("[");
		sum_budgetAmt_str.append("[");
		sum_approvalAmt_str.append("[");
		sum_actualAmt_str.append("[");
		sum_availableAmt_str.append("[");
		int idx1 = 0;
		String sql1 = "select orgType, orgId, fnayear, feeperiod, \n" +
			"	SUM(budgetAmt) sum_budgetAmt, SUM(approvalAmt) sum_approvalAmt, SUM(actualAmt) sum_actualAmt, SUM(availableAmt) sum_availableAmt \n" +
			" from "+rptTbName+" \n" +
			" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' "+
			" and orgId in ("+("".equals(rptFnaOrgIds)?"-1":rptFnaOrgIds)+") \n"+
			" GROUP BY orgType, orgId, fnayear, feeperiod \n"+
			" ORDER BY min(id) ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int _orgType = rs1.getInt("orgType");
			int _orgId = rs1.getInt("orgId");
			int _fnayear = rs1.getInt("fnayear");
			int _feeperiod = rs1.getInt("feeperiod");
			double _sum_budgetAmt = Util.getDoubleValue(rs1.getString("sum_budgetAmt"));
			double _sum_approvalAmt = Util.getDoubleValue(rs1.getString("sum_approvalAmt"));
			double _sum_actualAmt = Util.getDoubleValue(rs1.getString("sum_actualAmt"));
			double _sum_availableAmt = Util.getDoubleValue(rs1.getString("sum_availableAmt"));
			
			String _orgName = fnaSplitPageTransmethod.getOrgName(_orgId+"", _orgType+"");
			
			StringBuffer sub1_categories = new StringBuffer("[");
			StringBuffer sub1_data_budgetAmt = new StringBuffer("[");
			StringBuffer sub1_data_approvalAmt = new StringBuffer("[");
			StringBuffer sub1_data_actualAmt = new StringBuffer("[");
			StringBuffer sub1_data_availableAmt = new StringBuffer("[");
			
			int idx2 = 0;
			String sql2 = "select q, budgetAmt, approvalAmt, actualAmt, availableAmt, execRatio "+
				" from "+rptTbName+" "+
				" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' "+
				" and orgType = "+_orgType+" and fnayear = "+_fnayear+" and feeperiod = "+_feeperiod+" and orgId = "+_orgId+" "+
				" order by q";
			rs2.executeSql(sql2);
			while(rs2.next()){
				int _q = rs2.getInt("q");
				double _budgetAmt = Util.getDoubleValue(rs2.getString("budgetAmt"));
				double _approvalAmt = Util.getDoubleValue(rs2.getString("approvalAmt"));
				double _actualAmt = Util.getDoubleValue(rs2.getString("actualAmt"));
				double _availableAmt = Util.getDoubleValue(rs2.getString("availableAmt"));
				double _execRatio = Util.getDoubleValue(rs2.getString("execRatio"));
				
				String _feeperiodFullName = fnaSplitPageTransmethod.feeperiodFullName(_feeperiod+"", _q+"+"+_fnayear+"+"+user.getLanguage());
				
				if(idx2 > 0){
					sub1_categories.append(",");
					sub1_data_budgetAmt.append(",");
					sub1_data_approvalAmt.append(",");
					sub1_data_actualAmt.append(",");
					sub1_data_availableAmt.append(",");
				}
				
				sub1_categories.append(JSONObject.quote(_feeperiodFullName));
				sub1_data_budgetAmt.append(df.format(_budgetAmt));
				sub1_data_approvalAmt.append(df.format(_approvalAmt));
				sub1_data_actualAmt.append(df.format(_actualAmt));
				sub1_data_availableAmt.append(df.format(_availableAmt));
				
				idx2++;
			}
			sub1_categories.append("]");
			sub1_data_budgetAmt.append("]");
			sub1_data_approvalAmt.append("]");
			sub1_data_actualAmt.append("]");
			sub1_data_availableAmt.append("]");
			
			String sub1_data = "[{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(23577,user.getLanguage()))+",data:"+sub1_data_budgetAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(18769,user.getLanguage()))+",data:"+sub1_data_approvalAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(82510,user.getLanguage()))+",data:"+sub1_data_actualAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(82511,user.getLanguage()))+",data:"+sub1_data_availableAmt.toString()+"}]";
			
			String drilldown = "drilldown:{"+
					"sub1_name:"+JSONObject.quote(_orgName)+","+
					"sub1_categories:"+sub1_categories.toString()+","+
					"sub1_data:"+sub1_data+
				"}";
			
				
			if(idx1 > 0){
				categoriesStr.append(",");
				sum_budgetAmt_str.append(",");
				sum_approvalAmt_str.append(",");
				sum_actualAmt_str.append(",");
				sum_availableAmt_str.append(",");
			}

			categoriesStr.append(JSONObject.quote(_orgName));
			
			sum_budgetAmt_str.append("{y:"+df.format(_sum_budgetAmt)+","+
					drilldown+
				"}");
			sum_approvalAmt_str.append("{y:"+df.format(_sum_approvalAmt)+","+
					drilldown+
				"}");
			sum_actualAmt_str.append("{y:"+df.format(_sum_actualAmt)+","+
					drilldown+
				"}");
			sum_availableAmt_str.append("{y:"+df.format(_sum_availableAmt)+","+
					drilldown+
				"}");
			
			idx1++;
		}
		categoriesStr.append("]");
		sum_approvalAmt_str.append("]");
		sum_budgetAmt_str.append("]");
		sum_actualAmt_str.append("]");
		sum_availableAmt_str.append("]");
		
		
		

		categoriesStr2.append("[");
		sum_budgetAmt_str2.append("[");
		sum_approvalAmt_str2.append("[");
		sum_actualAmt_str2.append("[");
		sum_availableAmt_str2.append("[");
		idx1 = 0;
		sql1 = "select fnayear, q, feeperiod,\n" +
			"	SUM(budgetAmt) sum_budgetAmt, SUM(approvalAmt) sum_approvalAmt, SUM(actualAmt) sum_actualAmt, SUM(availableAmt) sum_availableAmt \n" +
			" from "+rptTbName+" \n" +
			" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' "+
			" and orgId in ("+("".equals(rptFnaOrgIds)?"-1":rptFnaOrgIds)+") \n"+
			" GROUP BY fnayear, q, feeperiod \n" +
			" ORDER BY q ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int _fnayear = rs1.getInt("fnayear");
			int _q = rs1.getInt("q");
			int _feeperiod = rs1.getInt("feeperiod");
			double _sum_budgetAmt = Util.getDoubleValue(rs1.getString("sum_budgetAmt"));
			double _sum_approvalAmt = Util.getDoubleValue(rs1.getString("sum_approvalAmt"));
			double _sum_actualAmt = Util.getDoubleValue(rs1.getString("sum_actualAmt"));
			double _sum_availableAmt = Util.getDoubleValue(rs1.getString("sum_availableAmt"));

			String _feeperiodFullName = fnaSplitPageTransmethod.feeperiodFullName(_feeperiod+"", _q+"+"+_fnayear+"+"+user.getLanguage());

			StringBuffer sub1_categories = new StringBuffer("[");
			StringBuffer sub1_data_budgetAmt = new StringBuffer("[");
			StringBuffer sub1_data_approvalAmt = new StringBuffer("[");
			StringBuffer sub1_data_actualAmt = new StringBuffer("[");
			StringBuffer sub1_data_availableAmt = new StringBuffer("[");
			
			int idx2 = 0;
			String sql2 = "select * \n" +
					" from "+rptTbName+" \n" +
					" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' "+
					" and fnayear="+_fnayear+" and q="+_q+" and feeperiod="+_feeperiod+" \n" +
					" and orgId in ("+("".equals(rptFnaOrgIds)?"-1":rptFnaOrgIds)+") \n"+
					" ORDER BY id";
			rs2.executeSql(sql2);
			while(rs2.next()){
				int _orgType = rs2.getInt("orgType");
				int _orgId = rs2.getInt("orgId");
				double _budgetAmt = Util.getDoubleValue(rs2.getString("budgetAmt"));
				double _approvalAmt = Util.getDoubleValue(rs2.getString("approvalAmt"));
				double _actualAmt = Util.getDoubleValue(rs2.getString("actualAmt"));
				double _availableAmt = Util.getDoubleValue(rs2.getString("availableAmt"));
				double _execRatio = Util.getDoubleValue(rs2.getString("execRatio"));
				
				String _orgName = fnaSplitPageTransmethod.getOrgName(_orgId+"", _orgType+"");
				
				if(idx2 > 0){
					sub1_categories.append(",");
					sub1_data_budgetAmt.append(",");
					sub1_data_approvalAmt.append(",");
					sub1_data_actualAmt.append(",");
					sub1_data_availableAmt.append(",");
				}
				
				sub1_categories.append(JSONObject.quote(_orgName));
				sub1_data_budgetAmt.append(df.format(_budgetAmt));
				sub1_data_approvalAmt.append(df.format(_approvalAmt));
				sub1_data_actualAmt.append(df.format(_actualAmt));
				sub1_data_availableAmt.append(df.format(_availableAmt));
				
				idx2++;
			}
			sub1_categories.append("]");
			sub1_data_budgetAmt.append("]");
			sub1_data_approvalAmt.append("]");
			sub1_data_actualAmt.append("]");
			sub1_data_availableAmt.append("]");
			
			String sub1_data = "[{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(23577,user.getLanguage()))+",data:"+sub1_data_budgetAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(18769,user.getLanguage()))+",data:"+sub1_data_approvalAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(82510,user.getLanguage()))+",data:"+sub1_data_actualAmt.toString()+"},"+
					"{name:"+JSONObject.quote(SystemEnv.getHtmlLabelName(82511,user.getLanguage()))+",data:"+sub1_data_availableAmt.toString()+"}]";
			
			String drilldown = "drilldown:{"+
					"sub1_name:"+JSONObject.quote(_feeperiodFullName)+","+
					"sub1_categories:"+sub1_categories.toString()+","+
					"sub1_data:"+sub1_data+
				"}";
			
				
			if(idx1 > 0){
				categoriesStr2.append(",");
				sum_budgetAmt_str2.append(",");
				sum_approvalAmt_str2.append(",");
				sum_actualAmt_str2.append(",");
				sum_availableAmt_str2.append(",");
			}
			
			categoriesStr2.append(JSONObject.quote(_feeperiodFullName));
			
			sum_budgetAmt_str2.append("{y:"+df.format(_sum_budgetAmt)+","+
					drilldown+
				"}");
			sum_approvalAmt_str2.append("{y:"+df.format(_sum_approvalAmt)+","+
					drilldown+
				"}");
			sum_actualAmt_str2.append("{y:"+df.format(_sum_actualAmt)+","+
					drilldown+
				"}");
			sum_availableAmt_str2.append("{y:"+df.format(_sum_availableAmt)+","+
					drilldown+
				"}");
			
			idx1++;
		}
		categoriesStr2.append("]");
		sum_budgetAmt_str2.append("]");
		sum_approvalAmt_str2.append("]");
		sum_actualAmt_str2.append("]");
		sum_availableAmt_str2.append("]");
		
	}
%>
	<%if(rptViewType == 0){ %>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_FNA_RPT_TOTAL_BUDGET_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
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
			<wea:item attributes="{'isTableList':'true'}">
				<div id="container2" style="min-width:700px;height:300px"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<%} %>
</form>
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>

<script language="javascript">
var _guid1 = "<%=_guid1 %>";

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
	showAbsentDiv2();
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
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(23577, user.getLanguage())) %>,
		data: <%=sum_budgetAmt_str.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(18769, user.getLanguage())) %>,
		data: <%=sum_approvalAmt_str.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(82510, user.getLanguage())) %>,
		data: <%=sum_actualAmt_str.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(82511, user.getLanguage())) %>,
		data: <%=sum_availableAmt_str.toString() %>
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


var chart2 = null;
var container_categories2 = <%=categoriesStr2.toString() %>;
var container_data2 = [{
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(23577, user.getLanguage())) %>,
		data: <%=sum_budgetAmt_str2.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(18769, user.getLanguage())) %>,
		data: <%=sum_approvalAmt_str2.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(82510, user.getLanguage())) %>,
		data: <%=sum_actualAmt_str2.toString() %>
	}, {
		name: <%=JSONObject.quote(SystemEnv.getHtmlLabelName(82511, user.getLanguage())) %>,
		data: <%=sum_availableAmt_str2.toString() %>
	}];

function showAbsentDiv2(){
	chart2 = jQuery("#container2").highcharts({
		plotOptions: {
			column: {
				cursor: 'pointer',
				point: {
					events: {
						click: function() {
							var drilldown = this.drilldown;
							if (drilldown) { // drill down
								setChart1(chart2, drilldown.sub1_categories, drilldown.sub1_data, {text: <%=JSONObject.quote(rptName+rptNameQ) %>}, {text: drilldown.sub1_name});
							} else { // restore
								setChart1(chart2, container_categories2, container_data2, {text: <%=JSONObject.quote(rptName+rptNameQ) %>}, {text: ""});
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
			text: <%=JSONObject.quote(rptName+rptNameQ) %>
		},
		subtitle: {
			text: ""
		},
		xAxis: {
			categories: container_categories2
		},
		yAxis: {
			title: {
				text: ""
			}
		},
		series: container_data2,
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
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?_guid1="+_guid1+"&rptTypeName=fanRptTotalBudget", 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//导出Excel
function doExpExcel(){
	document.getElementById("dwnfrm").src = "/fna/report/fanRptTotalBudget/fanRptTotalBudgetExcel.jsp?_guid1="+_guid1;
}

//科目浏览回调函数
//afterDelCallback(text,fieldid,params)
function subjectIds_callback(event,datas,name,_callbackParams){
	feeperiod_onchange();
}

//切换科目期间类型
function feeperiod_onchange(){
	var groupFeeperiod1Span = jQuery("#groupFeeperiod1Span");
	var groupFeeperiod2Span = jQuery("#groupFeeperiod2Span");
	var groupFeeperiod3Span = jQuery("#groupFeeperiod3Span");
	var groupFeeperiod4Span = jQuery("#groupFeeperiod4Span");

	groupFeeperiod1Span.hide();
	groupFeeperiod2Span.hide();
	groupFeeperiod3Span.hide();
	groupFeeperiod4Span.hide();

	var subjectIds = jQuery("#subjectIds").val();
	
	var _data = "subjectId="+subjectIds+
		"&r="+$System.Math.IntUtil.genGUIDV4();
	jQuery.ajax({
		url : "/fna/report/common/FnaRptGetFeeTypeFeeperiod.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(jsonObj){
			var maxFeeperiod = jsonObj.maxFeeperiod;

			var groupFeeperiod1 = jQuery("#groupFeeperiod1");
			var groupFeeperiod2 = jQuery("#groupFeeperiod2");
			var groupFeeperiod3 = jQuery("#groupFeeperiod3");
			var groupFeeperiod4 = jQuery("#groupFeeperiod4");

			if(maxFeeperiod==1){
				groupFeeperiod1Span.show();
				groupFeeperiod2Span.show();
				groupFeeperiod3Span.show();
				groupFeeperiod4Span.show();

				if(!groupFeeperiod1.attr("checked") && !groupFeeperiod2.attr("checked") && !groupFeeperiod3.attr("checked") && !groupFeeperiod4.attr("checked")){
					groupFeeperiod1.trigger("click");
				}
			}else if(maxFeeperiod==2){
				groupFeeperiod2Span.show();
				groupFeeperiod3Span.show();
				groupFeeperiod4Span.show();

				if(!groupFeeperiod2.attr("checked") && !groupFeeperiod3.attr("checked") && !groupFeeperiod4.attr("checked")){
					groupFeeperiod2.trigger("click");
				}
			}else if(maxFeeperiod==3){
				groupFeeperiod3Span.show();
				groupFeeperiod4Span.show();

				if(!groupFeeperiod3.attr("checked") && !groupFeeperiod4.attr("checked")){
					groupFeeperiod3.trigger("click");
				}
			}else if(maxFeeperiod==4){
				groupFeeperiod4Span.show();

				if(!groupFeeperiod4.attr("checked")){
					groupFeeperiod4.trigger("click");
				}
			}
			
		}
	});	
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
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82522,user.getLanguage()) %>", 
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
		
			var fnayear = jQuery("#fnayear").val();
			var orgType = jQuery("#orgType").val();
			var subId = jQuery("#subId").val();
			var depId = jQuery("#depId").val();
			var hrmId = jQuery("#hrmId").val();
			var fccId = jQuery("#fccId").val();
			var subjectIds = jQuery("#subjectIds").val();
			var sumSubOrg = jQuery("#sumSubOrg").attr("checked")?"1":"";
			
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

			var groupFeeperiod = "1";
			if(groupFeeperiod1.attr("checked")){
				groupFeeperiod = "1";
			}else if(groupFeeperiod2.attr("checked")){
				groupFeeperiod = "2";
			}else if(groupFeeperiod3.attr("checked")){
				groupFeeperiod = "3";
			}else if(groupFeeperiod4.attr("checked")){
				groupFeeperiod = "4";
			}

			jQuery("#rptViewType").val("0");
			jQuery("#rptFnaOrgIds").val("");
			
			var _data = "_guid1="+_guid1+"&fnayear="+fnayear+"&orgType="+orgType+"&subId="+subId+
				"&depId="+depId+"&hrmId="+hrmId+"&fccId="+fccId+"&subjectIds="+subjectIds+
				"&sumSubOrg="+sumSubOrg+"&groupFeeperiod="+groupFeeperiod+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/report/fanRptTotalBudget/fanRptTotalBudgetOp.jsp",
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

</body>
</html>
