<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.proj.Maint.ProjectInfoComInfo"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
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
CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
ProjectInfoComInfo projectInfoComInfo = new ProjectInfoComInfo();
DecimalFormat df = new DecimalFormat("####################################################0.00");

boolean canview = HrmUserVarify.checkUserRight("TheCostOfQueryStatistics:query",user) ;

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

boolean allowCmp = FnaRptRuleSet.allowCmp(user.getUID(), "fanRptCost");
boolean allowSubCmp = FnaRptRuleSet.allowSubCmp(user.getUID(), "fanRptCost");
boolean allowDep = FnaRptRuleSet.allowDep(user.getUID(), "fanRptCost");
boolean allowHrm = FnaRptRuleSet.allowHrm(user.getUID(), "fanRptCost");
boolean allowFcc = FnaRptRuleSet.allowFcc(user.getUID(), "fanRptCost");

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();

String sql = "";

String currentdate = TimeUtil.getCurrentDateString();

FnaReport.deleteFnaTmpTbLogTempData(user.getUID());

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);


int qryFunctionType = Util.getIntValue(request.getParameter("qryFunctionType"),0);//0：尚未进行查询；1：已经进行过了查询；
String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();


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

String creater = Util.null2String(request.getParameter("creater"));
StringBuffer shownameCreater = new StringBuffer();
if(!"".equals(creater)){
	sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+creater+") ORDER BY a.dsporder, a.workcode, a.lastname";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameCreater.length() > 0){
			shownameCreater.append(",");
		}
		shownameCreater.append(Util.null2String(rs.getString("name")).trim());
	}
}

String requestmark = Util.null2String(request.getParameter("requestmark"));
String requestname = Util.null2String(request.getParameter("requestname"));


String fromOccurDate = Util.null2String(request.getParameter("fromOccurDate")) ;
String toOccurDate = Util.null2String(request.getParameter("toOccurDate")) ;

String receivedateselect = Util.getIntValue(request.getParameter("receivedateselect"), 6)+"";
if(receivedateselect.equals("")){
	receivedateselect="0";
}
String fromReceivedate = Util.null2String(request.getParameter("fromReceivedate")) ;
String toReceivedate = Util.null2String(request.getParameter("toReceivedate")) ;
if(!receivedateselect.equals("") && !receivedateselect.equals("0") && !receivedateselect.equals("6")){
	fromReceivedate = TimeUtil.getDateByOption(receivedateselect,"0");
	toReceivedate = TimeUtil.getDateByOption(receivedateselect,"1");
}

String createdateselect = Util.getIntValue(request.getParameter("createdateselect"), 6)+"";
if(createdateselect.equals("")){
	createdateselect="0";
}
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
if(!createdateselect.equals("") && !createdateselect.equals("0") && !createdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(createdateselect,"0");
	todate = TimeUtil.getDateByOption(createdateselect,"1");
}

String feeType = Util.null2String(request.getParameter("feeType")).trim();

String sumAmt1 = Util.null2String(request.getParameter("sumAmt1")).trim();
String sumAmt2 = Util.null2String(request.getParameter("sumAmt2")).trim();


int fnayear=Util.getIntValue(request.getParameter("fnayear"),0);
if(fnayear==0){
	rs.executeSql("select id, fnayear from FnaYearsPeriods order by status desc,fnayear desc");
	if(rs.next()){
		fnayear = Util.getIntValue(rs.getString("fnayear"));
	}
}

int orgType = Util.getIntValue(request.getParameter("orgType"), -1);
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

String crmids = Util.null2String(request.getParameter("crmids")).trim();
StringBuffer crmname = new StringBuffer();
if(!"".equals(crmids)){
	String st[]=crmids.split(",");
	for(int i=0;i<st.length;i++){
		String str01=""+st[i];
		if(!str01.equals("")){
			if(crmname.length() > 0){
				crmname.append(",");
			}
	  		crmname.append(customerInfoComInfo.getCustomerInfoname(str01));
  		}
 	}
}



String prjids = Util.null2String(request.getParameter("prjids")).trim();
StringBuffer prjname = new StringBuffer();
if(!"".equals(prjids)){
	String st[]=prjids.split(",");
	for(int i=0;i<st.length;i++){
		String str01=""+st[i];
		if(!str01.equals("")){
			if(prjname.length() > 0){
				prjname.append(",");
			}
			prjname.append(projectInfoComInfo.getProjectInfoname(str01));
  		}
 	}
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
%>

<%@page import="weaver.fna.general.FnaRptRuleSet"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
<form id="form2" name="form2" method="post"  action="/fna/report/fanRptCost/fanRptCostInner.jsp">
<input id="qryFunctionType" name="qryFunctionType" value="0" type="hidden" />
<input id="_guid1" name="_guid1" value="<%=_guid1 %>" type="hidden" />


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
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
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item><!-- 流程编号 -->
		    <wea:item>
				<input class="inputstyle" id="requestmark" name="requestmark" value="<%=FnaCommon.escapeHtml(requestmark) %>" maxlength="100" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item><!-- 流程名称 -->
		    <wea:item>
				<input class="inputstyle" id="requestname" name="requestname" value="<%=FnaCommon.escapeHtml(requestname) %>" maxlength="100" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item><!-- 创建人 -->
		    <wea:item>
		        <brow:browser viewType="0" name="creater" browserValue='<%=creater %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fresourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
		                browserSpanValue='<%=shownameCreater.toString() %>' width="85%" 
		                >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(27767,user.getLanguage())%></wea:item><!--  费用日期  -->
		    <wea:item>
				<input class=wuiDate  type="hidden" id="fromOccurDate" name="fromOccurDate" value="<%=fromOccurDate%>" />
				-&nbsp;&nbsp; 
				<input class=wuiDate  type="hidden" id="toOccurDate" name="toOccurDate" value="<%=toOccurDate%>" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item><!-- 创建日期 -->
		    <wea:item>
				<select style="width:80px;" name="createdateselect" id="createdateselect" onchange="changeDate(this,'createdate');">
					<option value="1" <%=createdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %></option><!-- 今天 -->
					<option value="2" <%=createdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %></option><!-- 本周 -->
					<option value="3" <%=createdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %></option><!-- 本月 -->
					<option value="4" <%=createdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %></option><!-- 本季 -->
					<option value="5" <%=createdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %></option><!-- 本年 -->
					<option value="6" <%=createdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage()) %></option><!-- 指定日期范围 -->
				</select>
				<span id="createdate" style="<%=createdateselect.equals("6")?"":"display:none;" %>">
					<input class=wuiDate  type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>" />
					-&nbsp;&nbsp; 
					<input class=wuiDate  type="hidden" id="todate" name="todate" value="<%=todate%>" />
				</span>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item><!-- 归档日期 -->
		    <wea:item>
				<select style="width:80px;" name="receivedateselect" id="receivedateselect" onchange="changeDate(this,'receivedate');">
					<option value="1" <%=createdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %></option><!-- 今天 -->
					<option value="2" <%=createdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %></option><!-- 本周 -->
					<option value="3" <%=createdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %></option><!-- 本月 -->
					<option value="4" <%=createdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %></option><!-- 本季 -->
					<option value="5" <%=createdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %></option><!-- 本年 -->
					<option value="6" <%=createdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage()) %></option><!-- 指定日期范围 -->
				</select>
				<span id="receivedate" style="<%=receivedateselect.equals("6")?"":"display:none;" %>">
					<input class=wuiDate  type="hidden" id="fromReceivedate" name="fromReceivedate" value="<%=fromReceivedate%>" />
					-&nbsp;&nbsp; 
					<input class=wuiDate  type="hidden" id="toReceivedate" name="toReceivedate" value="<%=toReceivedate%>" />
				</span>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(82606,user.getLanguage())%></wea:item><!-- 费用状态 -->
		    <wea:item>
				<select style="width:80px;" name="feeType" id="feeType">
					<option value="" <%="".equals(feeType)?"selected":"" %>></option>
					<option value="0" <%="0".equals(feeType)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(19134, user.getLanguage()) %></option><!-- 审批中 -->
					<option value="1" <%="1".equals(feeType)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(27958, user.getLanguage()) %></option><!-- 已发生 -->
				</select>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(1447,user.getLanguage())%></wea:item><!-- 总金额 -->
		    <wea:item>
				<input class="inputstyle" type="text" id="sumAmt1" name="sumAmt1" value="<%=sumAmt1 %>" style="text-align: right;width: 90px;" />
				-&nbsp;&nbsp; 
				<input class="inputstyle" type="text" id="sumAmt2" name="sumAmt2" value="<%=sumAmt2 %>" style="text-align: right;width: 90px;" />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18748,user.getLanguage())%></wea:item><!-- 预算单位 -->
		    <wea:item>
				<select id="orgType" name="orgType" onchange="orgType_onchange();" style="width: 80px;float: left;">
				<%if(fnaBudgetOAOrg){ %>
				<%if(allowDep){ %>
					<option value="2" <%=(orgType==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124, user.getLanguage()) %></option><!-- 部门 -->
				<%} %>
				<%if(allowSubCmp){ %>
					<option value="1" <%=(orgType==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141, user.getLanguage()) %></option><!-- 分部 -->
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
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("1462",user.getLanguage())%></wea:item><!-- 预算科目 -->
		    <wea:item>
		        <brow:browser viewType="0" name="subjectId" browserValue='<%=subjectId %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaType4Report/FnaType4ReportBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaFeetypeWfBtnSetting" 
		                temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>'
		                browserSpanValue='<%=shownameSubject.toString() %>' width="85%" >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%></wea:item><!-- 相关客户 -->
		    <wea:item>
				<brow:browser viewType="0" name="crmids" browserValue='<%=crmids %>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp%3Fresourceids=#id#"
						hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
						completeUrl="/data.jsp?type=7" 
		        		temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(783,user.getLanguage()) %>'
		        		browserSpanValue='<%=crmname.toString() %>' width="85%" >
		        </brow:browser>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("782",user.getLanguage())%></wea:item><!-- 相关项目 -->
		    <wea:item>
				<brow:browser viewType="0" name="prjids" browserValue='<%=prjids %>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp%3Fprojectids=#id#"
						hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
						completeUrl="/data.jsp?type=135" 
		        		temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(782,user.getLanguage()) %>'
		        		browserSpanValue='<%=prjname.toString() %>' width="85%" >
		        </brow:browser>
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
	String tableString="";
	
	//设置好搜索条件
	String backFields =" * ";
	String fromSql = " from "+rptTbName+" \n";
	String sqlWhere = " where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ";
	String orderBy = "";
	
	String sqlprimarykey = "id";

	String _sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
	//out.println(_sql);
	tableString=""+
       "<table instanceid=\"FNA_FNA_RPT_COST_LIST\" pageId=\""+PageIdConst.FNA_FNA_RPT_COST_LIST+"\" "+
			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_FNA_RPT_COST_LIST,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
       " sumColumns=\"sumAmt\" decimalFormat=\""+Util.toHtmlForSplitPage("%1$,.2f")+"\" "+
       " />"+
       "<head>"+
			"<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"orderNum\" orderkey=\"orderNum\" "+//序号
					" />"+
			"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" "+//流程名称
					" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\" otherpara=\"column:requestid+column:workflowid+999+0+"+user.getLanguage()+"\" "+
					" />"+
			"<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(19502,user.getLanguage())+"\" column=\"requestmark\" orderkey=\"requestmark\" "+//流程编号
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getReqLink\" otherpara=\"column:requestid\" "+
					" />"+
			"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(18748,user.getLanguage())+"\" column=\"orgJsonStr\" "+//预算单位
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOrgNameByJsonStr\" otherpara=\""+user.getLanguage()+"\" "+
					" />"+
			"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(1462,user.getLanguage())+"\" column=\"fnaSubjects\" "+//预算科目
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getSubjectNames\" "+
					" />"+
			"<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" "+//创建人
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getHrmNameLink\" "+
					" />"+
			"<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(783,user.getLanguage())+"\" column=\"crmIds\" "+//相关客户
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getCrmNames\" "+
					" />"+
			"<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(782,user.getLanguage())+"\" column=\"prjIds\" "+//相关项目
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getPrjNames\" "+
					" />"+
			"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" "+//创建日期
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getFullDateTime\" otherpara=\"column:createtime\" "+
					" />"+
			"<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(1447,user.getLanguage())+"\" column=\"sumAmt\" orderkey=\"sumAmt\" align=\"right\" "+//总金额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
       "</head>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_FNA_RPT_COST_LIST %>" />
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>

<script language="javascript">
var _guid1 = "<%=_guid1 %>";

jQuery(document).ready(function(){
	orgType_onchange();

	controlNumberCheck_jQuery("sumAmt1", true, 2, true, 18);
	controlNumberCheck_jQuery("sumAmt2", true, 2, true, 18);
	
<%if(!isTempConfirm){ %>
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82525,user.getLanguage()) %>", 
		function(){
			doSaveResult();
		},function(){}
	);
<%} %>

});

function hiddenSaveBtn(){
	jQuery("#qryFunctionType").val("1");
	jQuery("#_guid1").val(_guid1);
	form2.submit();
}

//保存查询结果
function doSaveResult(){
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?_guid1="+_guid1+"&rptTypeName=fanRptCost", 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//导出Excel
function doExpExcel(){
	document.getElementById("dwnfrm").src = "/fna/report/fanRptCost/fanRptCostExcel.jsp?_guid1="+_guid1;
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
	var createdateselect = jQuery("#createdateselect").val();
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82522,user.getLanguage()) %>", 
		function(){
			_guid1 = $System.Math.IntUtil.genGUIDV4();
			jQuery("#_guid1").val(_guid1);
			
			openNewDiv_FnaBudgetViewInner1("<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage())%>");
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
			
		
			var requestmark = jQuery("#requestmark").val();
			var requestname = jQuery("#requestname").val();
			var creater = jQuery("#creater").val();
			var fromdate = jQuery("#fromdate").val();
			var todate = jQuery("#todate").val();
			var feeType = jQuery("#feeType").val();
			var sumAmt1 = jQuery("#sumAmt1").val();
			var sumAmt2 = jQuery("#sumAmt2").val();
			var orgType = jQuery("#orgType").val();
			var subId = jQuery("#subId").val();
			var depId = jQuery("#depId").val();
			var hrmId = jQuery("#hrmId").val();
			var fccId = jQuery("#fccId").val();
			var subjectId = jQuery("#subjectId").val();
			var crmids = jQuery("#crmids").val();
			var prjids = jQuery("#prjids").val();

			var fromOccurDate = jQuery("#fromOccurDate").val();
			var toOccurDate = jQuery("#toOccurDate").val();
			var fromReceivedate = jQuery("#fromReceivedate").val();
			var toReceivedate = jQuery("#toReceivedate").val();
			var receivedateselect = jQuery("#receivedateselect").val();
			
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
			
			var _data = "_guid1="+_guid1+
				"&requestmark="+encodeURI(requestmark)+"&requestname="+encodeURI(requestname)+"&creater="+creater+
				"&createdateselect="+createdateselect+"&fromdate="+fromdate+"&todate="+todate+"&feeType="+feeType+
				"&sumAmt1="+sumAmt1+"&sumAmt2="+sumAmt2+"&orgType="+orgType+"&subId="+subId+
				"&depId="+depId+"&hrmId="+hrmId+"&fccId="+fccId+
				"&subjectId="+subjectId+"&crmids="+crmids+"&prjids="+prjids+
				"&fromOccurDate="+fromOccurDate+"&toOccurDate="+toOccurDate+
				"&fromReceivedate="+fromReceivedate+"&toReceivedate="+toReceivedate+"&receivedateselect="+receivedateselect+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/report/fanRptCost/fanRptCostOp.jsp",
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
