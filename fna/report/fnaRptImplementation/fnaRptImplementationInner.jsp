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

boolean canview = HrmUserVarify.checkUserRight("fnaRptImplementation:qry",user) ;

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
int enableDispalyAll=0;
String separator ="";
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
	enableDispalyAll = rs.getInt("enableDispalyAll");
	separator = Util.null2String(rs.getString("separator"));
}

boolean allowCmp = FnaRptRuleSet.allowCmp(user.getUID(), "fnaRptImplementation");
boolean allowSubCmp = FnaRptRuleSet.allowSubCmp(user.getUID(), "fnaRptImplementation");
boolean allowDep = FnaRptRuleSet.allowDep(user.getUID(), "fnaRptImplementation");
boolean allowHrm = FnaRptRuleSet.allowHrm(user.getUID(), "fnaRptImplementation");
boolean allowFcc = FnaRptRuleSet.allowFcc(user.getUID(), "fnaRptImplementation");

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


int subjectType = Util.getIntValue(request.getParameter("subjectType"), 1);
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
<form id="form2" name="form2" method="post"  action="/fna/report/fnaRptImplementation/fnaRptImplementationInner.jsp">
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
				<select id="subjectType" name="subjectType" onchange="subjectType_onchange();" style="width: 80px;float: left;">
					<option value="1" <%=(subjectType==1)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("19398,585", user.getLanguage()) %></option><!-- 月度科目 -->
					<option value="2" <%=(subjectType==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("17495,585", user.getLanguage()) %></option><!-- 季度科目 -->
					<option value="3" <%=(subjectType==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("19483,585", user.getLanguage()) %></option><!-- 半年度科目 -->
					<option value="4" <%=(subjectType==4)?"selected":"" %>><%=SystemEnv.getHtmlLabelNames("17138,585", user.getLanguage()) %></option><!-- 年度科目 -->
				</select>
		        <brow:browser viewType="0" name="subjectId" browserValue='<%=subjectId %>' 
		                getBrowserUrlFn="getSubjectId_browserUrl"
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="javascript:getSubjectId_completeUrl()" 
		                temptitle='<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>'
		                browserSpanValue='<%=shownameSubject.toString() %>' width="60%" >
		        </brow:browser>
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
	String titleBudgetAmt2 = "<span>"+SystemEnv.getHtmlLabelName(82645,user.getLanguage())+"</span>"+
		"<span class=\"xTable_algorithmdesc\" title=\""+SystemEnv.getHtmlLabelName(82646,user.getLanguage())+"\">"+
		"<img src=\"/images/tooltip_wev8.png\" align=\"Middle\" style=\"vertical-align:top;\">"+
		"</span>";
	titleBudgetAmt2 = SystemEnv.getHtmlLabelName(82645,user.getLanguage());

	String tableString="";
	
	//设置好搜索条件
	String backFields =" * ";
	String fromSql = " from "+rptTbName+" \n";
	String sqlWhere = " where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ";
	String orderBy = "";
	
	String sqlprimarykey = "id";

	String _sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
	//out.println(_sql);
	
	String subjectId_column = "";
	if(enableDispalyAll==1){
		subjectId_column = "<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(1462,user.getLanguage())+"\" column=\"subjectId\" "+//预算科目
			" transmethod=\"weaver.fna.maintenance.BudgetfeeTypeComInfo.getSubjectFullName\" otherpara=\""+separator+"\" "+
			" />";
	}else{
		subjectId_column = "<col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(1462,user.getLanguage())+"\" column=\"subjectId\" "+//预算科目
			" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getSubjectNames\" "+
			" />";
	}
	
	tableString=""+
       "<table instanceid=\"FNA_RPT_IMPLEMENTATION\" pageId=\""+PageIdConst.FNA_RPT_IMPLEMENTATION+"\" "+
			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_RPT_IMPLEMENTATION,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
       " />"+
       "<head>"+
			"<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(18748,user.getLanguage())+"\" column=\"orgId\" "+//预算单位
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getOrgName\" otherpara=\"column:orgType\" "+
					" />"+
			"<col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(18648,user.getLanguage())+"\" column=\"feeperiod\" "+//预算期间
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.feeperiodFullName\" otherpara=\"column:q+column:fnayear+"+user.getLanguage()+"\" "+
					" />"+
			subjectId_column+			
			"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(82644,user.getLanguage())+"\" column=\"budgetAmt1\" align=\"right\" "+//上期结余预算数
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"9%\"  text=\""+StringEscapeUtils.escapeXml(titleBudgetAmt2)+"\" column=\"budgetAmt2\" align=\"right\" "+//本期原预算数
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(82616,user.getLanguage())+"\" column=\"budgetAmt\" align=\"right\" "+//本期预算总数
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(18769,user.getLanguage())+"\" column=\"approvalAmt\" align=\"right\" "+//审批中费用
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(82510,user.getLanguage())+"\" column=\"actualAmt\" align=\"right\" "+//实际发生数
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(82511,user.getLanguage())+"\" column=\"availableAmt\" align=\"right\" "+//可用预算数
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
       "</head>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_RPT_IMPLEMENTATION %>" />
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
	subjectType_onchange(true);
	
<%if(!isTempConfirm){ %>
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82525,user.getLanguage()) %>", 
		function(){
			doSaveResult();
		},function(){}
	);
<%} %>

});

function subjectType_onchange(_keepValue){
	if(_keepValue==null || !_keepValue){
		jQuery("#subjectId").val("");
		jQuery("#subjectIdspan").html("");
	}

	var spanMQObj = jQuery("#spanMQ");
	var spanQQObj = jQuery("#spanQQ");
	var spanHQObj = jQuery("#spanHQ");
	var spanYQObj = jQuery("#spanYQ");

	spanMQObj.hide();
	spanQQObj.hide();
	spanHQObj.hide();
	spanYQObj.hide();

	var subjectType = jQuery("#subjectType").val();
	if(subjectType=="1"){
		spanMQObj.show();
	}else if(subjectType=="2"){
		spanQQObj.show();
	}else if(subjectType=="3"){
		spanHQObj.show();
	}else if(subjectType=="4"){
		spanYQObj.show();
	}
}

function getSubjectId_completeUrl(){
	var subjectType = jQuery("#subjectType").val();
	return "/data.jsp?type=FnaBudgetfeeTypeMultiByGroupCtrl&feeperiod="+subjectType;
}

function getSubjectId_browserUrl(){
	var subjectType = jQuery("#subjectType").val();
	var selectids = jQuery("#subjectId").val();
	//return "/systeminfo/BrowserMain.jsp?url=/fna/browser/feeTypeByGroupCtrl/FnaBudgetfeeTypeByGroupCtrlBrowserMulti.jsp%3Fselectids="+selectids+"%26feeperiod="+subjectType;
	return "/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaType4Report/FnaType4ReportBrowserMulti.jsp%3Fselectids="+selectids+"%26feeperiod="+subjectType;
}


function hiddenSaveBtn(){
	jQuery("#qryFunctionType").val("1");
	jQuery("#_guid1").val(_guid1);
	form2.submit();
}

//保存查询结果
function doSaveResult(){
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?_guid1="+_guid1+"&rptTypeName=fnaRptImplementation", 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//导出Excel
function doExpExcel(){
	document.getElementById("dwnfrm").src = "/fna/report/fnaRptImplementation/fnaRptImplementationExcel.jsp?_guid1="+_guid1;
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

	var qAll = "";
	var urlQAll = "&urlQAll=";
	var subjectType = jQuery("#subjectType").val();
	
	if(subjectType=="1"){
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
	}else if(subjectType=="2"){
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
	}else if(subjectType=="3"){
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
	}else if(subjectType=="4"){
		var _q = jQuery("#yQ1").attr("checked")?"1":"";
		if(_q=="1"){
			qAll = "1";
		}
		urlQAll += ("&yQ1="+_q);
	}
	
	if(qAll==""){
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
			
		
			var orgType = jQuery("#orgType").val();
			var subId = jQuery("#subId").val();
			var depId = jQuery("#depId").val();
			var hrmId = jQuery("#hrmId").val();
			var fccId = jQuery("#fccId").val();
			var subjectId = jQuery("#subjectId").val();
			var fnayear = jQuery("#fnayear").val();
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
			
			var _data = "_guid1="+_guid1+
				"&orgType="+orgType+"&subId="+subId+
				"&depId="+depId+"&hrmId="+hrmId+"&fccId="+fccId+
				"&subjectId="+subjectId+"&fnayear="+fnayear+"&subjectType="+subjectType+
				"&qAll="+qAll+"&sumSubOrg="+sumSubOrg+
				urlQAll+
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/report/fnaRptImplementation/fnaRptImplementationOp.jsp",
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
