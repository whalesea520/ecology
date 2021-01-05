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
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.resource.*" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<% 

boolean canview = HrmUserVarify.checkUserRight("LoanRepaymentAnalysis:qry",user) ;

CustomerInfoComInfo customerInfoComInfo = new CustomerInfoComInfo();
ProjectInfoComInfo projectInfoComInfo = new ProjectInfoComInfo();
DecimalFormat df = new DecimalFormat("####################################################0.00");

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();

ResourceComInfo resourceComInfo = new ResourceComInfo();
DepartmentComInfo departmentComInfo = new DepartmentComInfo();
SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();

String sql = "";

String currentdate = TimeUtil.getCurrentDateString();

FnaReport.deleteFnaTmpTbLogTempData(user.getUID());

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String createdateselect = Util.getIntValue(request.getParameter("createdateselect"), 6)+"";
if(createdateselect.equals("")){
	createdateselect="0";
}
int datetype = Util.getIntValue(Util.null2String(request.getParameter("datetype")), 2) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
if(!createdateselect.equals("") && !createdateselect.equals("0") && !createdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(createdateselect,"0");
	todate = TimeUtil.getDateByOption(createdateselect,"1");
}

if(createdateselect.equals("6") && "".equals(fromdate)){
	fromdate = currentdate;
}

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

String subId = Util.null2String(request.getParameter("subId")).trim();
String deptId = Util.null2String(request.getParameter("deptId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();

StringBuffer shownameSub = new StringBuffer();
StringBuffer shownameDep = new StringBuffer();
StringBuffer shownameHrm = new StringBuffer();

String userSubcompany = user.getUserSubCompany1() + "";
String userSubcompanyName = subCompanyComInfo.getSubCompanyname(userSubcompany);
String userDepartment = user.getUserDepartment() + "";
String userDepartmentName = departmentComInfo.getDepartmentName(userDepartment);
String userHrmid = user.getUID() + "";
String userHrmName = "";
if(!"".equals(userHrmid)){
	sql = "select a.id, a.lastname name from HrmResource a where a.id ="+userHrmid+"";
	rs.executeSql(sql);
	if(rs.next()){
		userHrmName = rs.getString("name");
	}
}


//subId="";depId="";hrmId="";
if(qryFunctionType == 0){
	if("".equals(subId)){
		subId =  userSubcompany;
	}
	if("".equals(deptId)){
		deptId = userDepartment;
	}
	if("".equals(hrmId)){
		hrmId = userHrmid;
	}
}

if(!"".equals(subId)){
	String _subId = "";
	
	sql = "select a.id, a.subcompanyname name from HrmSubCompany a where a.id in ("+subId+") ORDER BY a.showorder, a.subcompanycode, a.subcompanyname";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameSub.length() > 0){
			shownameSub.append(",");
			_subId+=",";
		}
		shownameSub.append(Util.null2String(rs.getString("name")).trim());
		_subId+=Util.null2String(rs.getString("id")).trim();
	}
	subId = _subId;
}

if(!"".equals(deptId)){
	String _deptId = "";
	
	sql = "select a.id, a.departmentname name from HrmDepartment a where a.id in ("+deptId+") ORDER BY a.showorder, a.departmentcode, a.departmentname";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameDep.length() > 0){
			shownameDep.append(",");
			_deptId+=",";
		}
		shownameDep.append(Util.null2String(rs.getString("name")).trim());
		_deptId+=Util.null2String(rs.getString("id")).trim();
	}
	deptId = _deptId;
}

if(!"".equals(hrmId)){
	String _hrmId = "";
	
	sql = "select a.id, a.lastname name from HrmResource a where a.id in ("+hrmId+") ORDER BY a.dsporder, a.workcode, a.lastname";
	rs.executeSql(sql);
	while(rs.next()){
		if(shownameHrm.length() > 0){
			shownameHrm.append(",");
			_hrmId+=",";
		}
		shownameHrm.append(Util.null2String(rs.getString("name")).trim());
		_hrmId+=Util.null2String(rs.getString("id")).trim();
	}
	hrmId = _hrmId;
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
<html>
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
	if(canview){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82508,user.getLanguage())+",javascript:doSaveResult(),_self}";
		RCMenuHeight += RCMenuHeightStep ;
	}
}
if(isTemp==0 || isTemp==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:doExpExcel(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post"  action="/fna/report/LoanRepaymentAnalysis/LoanRepaymentAnalysisInner.jsp">
<input id="qryFunctionType" name="qryFunctionType" value="0" type="hidden" />
<input id="_guid1" name="_guid1" value="<%=_guid1 %>" type="hidden" />


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(isTemp==1){
				if(canview){
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82508,user.getLanguage()) %>" class="e8_btn_top" onclick="doSaveResult()"/><!-- 保存查询结果 -->
			<%	}
			} %>
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
	    <wea:group context="<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>"><!-- 常用条件 -->
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31131,user.getLanguage()) %></wea:item><!-- 日期 -->
		    <wea:item>
					<select id="datetype" name="datetype"> 
						<option value="1" <%if(datetype == 1){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %></option>
						<option value="2" <%if(datetype == 2){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %></option>
						<option value="3" <%if(datetype == 3){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %></option>
						<option value="4" <%if(datetype == 4){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(17028,user.getLanguage()) %></option>
						<option value="5" <%if(datetype == 5){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %></option>
						<option value="6" <%if(datetype == 6){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(127287,user.getLanguage()) %></option>
						<option value="7" <%if(datetype == 7){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %></option>
						<option value="8" <%if(datetype == 8){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(17029,user.getLanguage()) %></option>
						<option value="9" <%if(datetype == 9){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage()) %></option>
					</select>
				<span id="spanDate" style="display: none;" >
					<span id="createdate" style="<%=createdateselect.equals("6")?"":"display:none;" %>">
						<input class=wuiDate  type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>" _minDate="" _maxDate="" />
						&nbsp;&nbsp;-&nbsp;&nbsp; 
						<input class=wuiDate  type="hidden" id="todate" name="todate" value="<%=todate%>" _minDate="" _maxDate="" />
					</span>
		    	</span>
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></wea:item><!-- 分部 -->
		    <wea:item>
		    	<%
		    	String _browserUrl = new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#";
		    	%>
				 <brow:browser viewType="0" name="subId" browserValue="<%=subId %>" 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle="<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"
	                browserSpanValue="<%=shownameSub.toString() %>" width="60%" 
				                
                >
		        </brow:browser>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %></wea:item><!-- 部门 -->
		    <wea:item>
		    	<%
		    	String _browserUrl = new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#";
		    	%>
		    	 <brow:browser viewType="0" name="deptId" browserValue="<%=deptId %>" 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle="<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"
	                browserSpanValue="<%=shownameDep.toString() %>" width="60%" 
                >
		        </brow:browser>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></wea:item>
		    <wea:item>
		    	<%
		    	String _browserUrl = new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26resourceids=#id#";
		    	%>
		    	<brow:browser viewType="0" name="hrmId" browserValue="<%=hrmId %>" 
		                browserUrl="<%=_browserUrl %>"
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle="<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>"
		                browserSpanValue="<%=shownameHrm.toString() %>" width="60%" 
                >
		        </brow:browser>
		    </wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="loanResetCondtion();"
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
       "<table instanceid=\"FNA_RPT_LoanRepaymentAnalysis\" pageId=\""+PageIdConst.FNA_RPT_LoanRepaymentAnalysis+"\" "+
			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_RPT_LoanRepaymentAnalysis,user.getUID(),PageIdConst.FNA)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" "+
       " />"+
       "<head>"+
			"<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" "+//部门
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getDepNameLink\"  "+
					" />"+
			"<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\" "+//姓名
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.getHrmNameLink\" "+
					" />"+
			"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(127288,user.getLanguage())+"\" column=\"borrowAmt\" orderkey=\"borrowAmt\" align=\"right\" "+//借款金额总和
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(127289,user.getLanguage())+"\" column=\"repayAmt\" orderkey=\"repayAmt\" align=\"right\" "+//已还金额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(127290,user.getLanguage())+"\" column=\"pendingRepayAmt\" orderkey=\"pendingRepayAmt\" align=\"right\" "+//审批中待还金额
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountQuartile\" "+
					" />"+
			"<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(83288,user.getLanguage())+"\" column=\"remainAmt\" orderkey=\"remainAmt\" align=\"right\" "+//未还金额
					" otherpara=\"openDetails+column:requestid+column:hrmid\" "+ //拼链接
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.fmtAmountWithLink\" "+
					" />"+
       "</head>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.FNA_RPT_LoanRepaymentAnalysis %>" />
				
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>

<script language="javascript">
var _guid1 = "<%=_guid1 %>";

jQuery(document).ready(function(){
	if(jQuery("#datetype").val() == '9'){
		jQuery("#spanDate").show();
	}
	
	jQuery("#datetype").change(function(){
		if(jQuery(this).val() === '9'){
			jQuery("#spanDate").show();
		}else{
			jQuery("#spanDate").hide();
			/* jQuery("#fromdate").val("");
			jQuery("#todate").val(""); */
		}
	});
	
	
<%if(!isTempConfirm){
	if(canview){	
%>
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82525,user.getLanguage()) %>", 
		function(){
			doSaveResult();
		},function(){}
	);
<%	}
}
%>

});


/*
点击未还金额触发此方法
requestid : 当前未还金额涉及到的所有流程 requestid, 逗号分隔
hrmid : 申请人ID
*/
function openDetails(requestid,hrmid){
	//window.open("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&_workflowid="+workflowid+"&_workflowtype=&isovertime=0");
	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/report/LoanRepaymentAnalysis/LoanRepaymentAnalysisInnerDetaile.jsp?hrmid="+hrmid+
			"&jklc="+requestid, 
			"", 
			_w, _h);
	
}

function loanResetCondtion(){
	__browserNamespace__._writeBackData('subId',1,{id:'<%=userSubcompany%>',name:'<%=userSubcompanyName%>'},null);
	__browserNamespace__._writeBackData('deptId',1,{id:'<%=userDepartment%>',name:'<%=userDepartmentName%>'},null);
	__browserNamespace__._writeBackData('hrmId',1,{id:'<%=userHrmid%>',name:'<%=userHrmName%>'},null);
	
	jQuery("#datetype").selectbox("change","2");
	//jQuery("#datetype ").find("option[value='2']").attr("selected",true);
	//jQuery("#datetype ").find("option[value='2']").attr("selected",true);
}

function hiddenSaveBtn(){
	jQuery("#qryFunctionType").val("1");
	jQuery("#_guid1").val(_guid1);
	form2.submit();
}

//保存查询结果
function doSaveResult(){
	_fnaOpenDialog("/fna/report/common/FnaRptSave.jsp?_guid1="+_guid1+"&rptTypeName=LoanRepaymentAnalysis", 
			"<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>", 
			200, 230);
}

//导出Excel
function doExpExcel(){
	document.getElementById("dwnfrm").src = "/fna/report/LoanRepaymentAnalysis/LoanRepaymentAnalysisExcel.jsp?_guid1="+_guid1;
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
			
			
			var datetype = jQuery("#datetype").val();
			var fromdate = jQuery("#fromdate").val();
			var todate = jQuery("#todate").val();
			var subId = jQuery("#subId").val();
			var deptId = jQuery("#deptId").val();
			var hrmId = jQuery("#hrmId").val();
			
			
			var _data = "_guid1="+_guid1+
				"&datetype="+datetype+"&fromdate="+fromdate+"&todate="+todate+
				"&subId="+subId+"&deptId="+deptId+"&hrmId="+hrmId
				"&r="+$System.Math.IntUtil.genGUIDV4();
			jQuery.ajax({
				url : "/fna/report/LoanRepaymentAnalysis/LoanRepaymentAnalysisOp.jsp",
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