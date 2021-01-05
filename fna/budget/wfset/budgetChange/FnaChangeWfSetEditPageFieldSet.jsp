<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//费控流程 //33075
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();


int mainId = Util.getIntValue(request.getParameter("id"));

int workflowid = 0;
boolean enable = false;

String sql = "select * from fnaFeeWfInfo where id = "+mainId;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
}

boolean isEdit = true;
int trIdx = 0;



//报销明细1
List fieldIdList = new ArrayList();
HashMap fieldInfoHm = new HashMap();

List dtlFieldIdListKm = new ArrayList();//科目
HashMap dtlFieldInfoHmKm = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListKm, dtlFieldInfoHmKm, "3", 22, workflowid, 0);

List dtlFieldIdListBxlx = new ArrayList();//报销类型
HashMap dtlFieldInfoHmBxlx = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListBxlx, dtlFieldInfoHmBxlx, "5", 0, workflowid, 0);

List dtlFieldIdListBxdw = new ArrayList();//报销单位
HashMap dtlFieldInfoHmBxdw = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListBxdw, dtlFieldInfoHmBxdw, "3", 4, workflowid, 0);

List dtlFieldIdListBxrq = new ArrayList();//报销日期
HashMap dtlFieldInfoHmBxrq = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListBxrq, dtlFieldInfoHmBxrq, "3", 2, workflowid, 0);

List dtlFieldIdListSqje = new ArrayList();//申请金额
HashMap dtlFieldInfoHmSqje = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListSqje, dtlFieldInfoHmSqje, "1", 3, workflowid, 0);

List dtlFieldIdListYs = new ArrayList();//个人预算 部门预算 分部预算
HashMap dtlFieldInfoHmYs = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListYs, dtlFieldInfoHmYs, "1", 1, workflowid, 0);

List dtlFieldIdListAll = new ArrayList();//所有明细字段
HashMap dtlFieldInfoHmAll = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListAll, dtlFieldInfoHmAll, "", 0, workflowid, 0);

int formid = FnaWfSet.getFieldListForFieldType(new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtlFieldIdListBxlx, dtlFieldInfoHmBxlx, 
		dtlFieldIdListSqje, dtlFieldInfoHmSqje, 
		dtlFieldIdListYs, dtlFieldInfoHmYs, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtlFieldIdListBxrq, dtlFieldInfoHmBxrq, 
		dtlFieldIdListKm, dtlFieldInfoHmKm, 
		dtlFieldIdListBxdw, dtlFieldInfoHmBxdw,
		dtlFieldIdListAll, dtlFieldInfoHmAll, 
		workflowid, 1);

String fieldIdSubject = "";
String fieldIdOrgType = "";
String fieldIdOrgId = "";
String fieldIdOccurdate = "";
String fieldIdAmount = "";
String fieldIdHrmInfo = "";
String fieldIdDepInfo = "";
String fieldIdSubInfo = "";
String fieldIdFccInfo = "";

String fieldIdSubject2 = "";
String fieldIdOrgType2 = "";
String fieldIdOrgId2 = "";
String fieldIdOccurdate2 = "";
String fieldIdHrmInfo2 = "";
String fieldIdDepInfo2 = "";
String fieldIdSubInfo2 = "";
String fieldIdFccInfo2 = "";

boolean showAllTypeSubject = false;
boolean showAllTypeOrgType = false;
boolean showAllTypeOrgId = false;
boolean showAllTypeOccurdate = false;
boolean showAllTypeAmount = false;
boolean showAllTypeHrmInfo = false;
boolean showAllTypeDepInfo = false;
boolean showAllTypeSubInfo = false;
boolean showAllTypeFccInfo = false;

boolean showAllTypeSubject2 = false;
boolean showAllTypeOrgType2 = false;
boolean showAllTypeOrgId2 = false;
boolean showAllTypeOccurdate2 = false;
boolean showAllTypeHrmInfo2 = false;
boolean showAllTypeDepInfo2 = false;
boolean showAllTypeSubInfo2 = false;
boolean showAllTypeFccInfo2 = false;

boolean automaticTakeOrgId = false;

boolean automaticTakeOrgId2 = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 1 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	
	if(Util.getIntValue(fieldType)==1){
		fieldIdSubject = fieldId;
		showAllTypeSubject = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		fieldIdOrgType = fieldId;
		showAllTypeOrgType = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		fieldIdOrgId = fieldId;
		showAllTypeOrgId = showAllType;
		automaticTakeOrgId = Util.getIntValue(rs.getString("automaticTake"), 0)==1;
	}else if(Util.getIntValue(fieldType)==4){
		fieldIdOccurdate = fieldId;
		showAllTypeOccurdate = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		fieldIdAmount = fieldId;
		showAllTypeAmount = showAllType;
	}else if(Util.getIntValue(fieldType)==6){
		fieldIdHrmInfo = fieldId;
		showAllTypeHrmInfo = showAllType;
	}else if(Util.getIntValue(fieldType)==7){
		fieldIdDepInfo = fieldId;
		showAllTypeDepInfo = showAllType;
	}else if(Util.getIntValue(fieldType)==8){
		fieldIdSubInfo = fieldId;
		showAllTypeSubInfo = showAllType;
	}else if(Util.getIntValue(fieldType)==9){
		fieldIdFccInfo = fieldId;
		showAllTypeFccInfo = showAllType;
	}

	else if(Util.getIntValue(fieldType)==10){
		fieldIdSubject2 = fieldId;
		showAllTypeSubject2 = showAllType;
	}else if(Util.getIntValue(fieldType)==11){
		fieldIdOrgType2 = fieldId;
		showAllTypeOrgType2 = showAllType;
	}else if(Util.getIntValue(fieldType)==12){
		fieldIdOrgId2 = fieldId;
		showAllTypeOrgId2 = showAllType;
		automaticTakeOrgId2 = Util.getIntValue(rs.getString("automaticTake"), 0)==1;
	}else if(Util.getIntValue(fieldType)==13){
		fieldIdOccurdate2 = fieldId;
		showAllTypeOccurdate2 = showAllType;
	}else if(Util.getIntValue(fieldType)==14){
		fieldIdHrmInfo2 = fieldId;
		showAllTypeHrmInfo2 = showAllType;
	}else if(Util.getIntValue(fieldType)==15){
		fieldIdDepInfo2 = fieldId;
		showAllTypeDepInfo2 = showAllType;
	}else if(Util.getIntValue(fieldType)==16){
		fieldIdSubInfo2 = fieldId;
		showAllTypeSubInfo2 = showAllType;
	}else if(Util.getIntValue(fieldType)==17){
		fieldIdFccInfo2 = fieldId;
		showAllTypeFccInfo2 = showAllType;
	}
}

String displayNoneStr = "display: none;";
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(false),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave(false);" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form action="">
<input id="mainId" name="mainId" value="<%=mainId %>" type="hidden" />
<input id="workflowid" name="workflowid" value="<%=workflowid %>" type="hidden" />
<input id="formid" name="formid" value="<%=formid %>" type="hidden" />
<wea:layout type="2col">
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382390,user.getLanguage())+"<br />（formtable_main_"+Math.abs(formid)+"、formtable_main_"+Math.abs(formid)+"_dt1）"%>'><!-- 预算变更明细（明细表1） -->
		<wea:item><%=SystemEnv.getHtmlLabelName(124871,user.getLanguage()) %></wea:item><!-- 变更科目 -->
		<wea:item>
			<span id="fieldIdSubjectSpan" style="<%=showAllTypeSubject?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListKm, dtlFieldInfoHmKm, fieldIdSubject, user, formid, "fieldIdSubject", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdSubjectAllSpan" style="<%=showAllTypeSubject?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdSubject, user, formid, "fieldIdSubjectAll", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(854,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 报销费用类型浏览按钮 -->
			<input id="showAllTypeSubject" name="showAllTypeSubject" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdSubjectSpan', 'fieldIdSubjectAllSpan');" 
				<%=showAllTypeSubject?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124869,user.getLanguage()) %></wea:item><!-- 变更主体类型 -->
		<wea:item>
			<span id="fieldIdOrgTypeSpan" style="<%=showAllTypeOrgType?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxlx, dtlFieldInfoHmBxlx, fieldIdOrgType, user, formid, "fieldIdOrgType", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdOrgTypeAllSpan" style="<%=showAllTypeOrgType?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOrgType, user, formid, "fieldIdOrgTypeAll", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelName(141,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(515,user.getLanguage())+")" %>" /><!-- 选择框(个人、部门、分部、成本中心) -->
			<input id="showAllTypeOrgType" name="showAllTypeOrgType" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOrgTypeSpan', 'fieldIdOrgTypeAllSpan');" 
				<%=showAllTypeOrgType?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124870,user.getLanguage()) %></wea:item><!-- 变更主体 -->
		<wea:item>
			<span id="fieldIdOrgIdSpan" style="<%=showAllTypeOrgId?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxdw, dtlFieldInfoHmBxdw, fieldIdOrgId, user, formid, "fieldIdOrgId", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdOrgIdAllSpan" style="<%=showAllTypeOrgId?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOrgId, user, formid, "fieldIdOrgIdAll", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 部门浏览按钮 -->
			<input id="showAllTypeOrgId" name="showAllTypeOrgId" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOrgIdSpan', 'fieldIdOrgIdAllSpan');" 
				<%=showAllTypeOrgId?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
			<br />
			<input id="automaticTakeOrgId" name="automaticTakeOrgId" value="1" type="checkbox" 
				<%=automaticTakeOrgId?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(131113,user.getLanguage()) %><!-- 自动带出承担主体 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124872,user.getLanguage()) %></wea:item><!-- 变更期间 -->
		<wea:item>
			<span id="fieldIdOccurdateSpan" style="<%=showAllTypeOccurdate?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxrq, dtlFieldInfoHmBxrq, fieldIdOccurdate, user, formid, "fieldIdOccurdate", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdOccurdateAllSpan" style="<%=showAllTypeOccurdate?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOccurdate, user, formid, "fieldIdOccurdateAll", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(97,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 部门浏览按钮 -->
			<input id="showAllTypeOccurdate" name="showAllTypeOccurdate" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOccurdateSpan', 'fieldIdOccurdateAllSpan');" 
				<%=showAllTypeOccurdate?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124873,user.getLanguage()) %></wea:item><!-- 变更金额 -->
		<wea:item>
			<span id="fieldIdAmountSpan" style="<%=showAllTypeAmount?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListSqje, dtlFieldInfoHmSqje, fieldIdAmount, user, formid, "fieldIdAmount", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdAmountAllSpan" style="<%=showAllTypeAmount?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdAmount, user, formid, "fieldIdAmountAll", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(697,user.getLanguage())+")" %>" /><!-- 单行文本框(浮点数) -->
			<input id="showAllTypeAmount" name="showAllTypeAmount" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdAmountSpan', 'fieldIdAmountAllSpan');" 
				<%=showAllTypeAmount?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124870,15402",user.getLanguage()) %></wea:item><!-- 变更主体个人预算 -->
		<wea:item>
			<span id="fieldIdHrmInfoSpan" style="<%=showAllTypeHrmInfo?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdHrmInfo, user, formid, "fieldIdHrmInfo", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdHrmInfoAllSpan" style="<%=showAllTypeHrmInfo?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdHrmInfo, user, formid, "fieldIdHrmInfoAll", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeHrmInfo" name="showAllTypeHrmInfo" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdHrmInfoSpan', 'fieldIdHrmInfoAllSpan');" 
				<%=showAllTypeHrmInfo?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124870,15401",user.getLanguage()) %></wea:item><!-- 变更主体部门预算 -->
		<wea:item>
			<span id="fieldIdDepInfoSpan" style="<%=showAllTypeDepInfo?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdDepInfo, user, formid, "fieldIdDepInfo", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdDepInfoAllSpan" style="<%=showAllTypeDepInfo?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdDepInfo, user, formid, "fieldIdDepInfoAll", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeDepInfo" name="showAllTypeDepInfo" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdDepInfoSpan', 'fieldIdDepInfoAllSpan');" 
				<%=showAllTypeDepInfo?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124870,18654",user.getLanguage()) %></wea:item><!-- 变更主体分部预算 -->
		<wea:item>
			<span id="fieldIdSubInfoSpan" style="<%=showAllTypeSubInfo?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdSubInfo, user, formid, "fieldIdSubInfo", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdSubInfoAllSpan" style="<%=showAllTypeSubInfo?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdSubInfo, user, formid, "fieldIdSubInfoAll", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeSubInfo" name="showAllTypeSubInfo" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdSubInfoSpan', 'fieldIdSubInfoAllSpan');" 
				<%=showAllTypeSubInfo?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124870,515,386",user.getLanguage()) %></wea:item><!-- 变更主体成本中心预算 -->
		<wea:item>
			<span id="fieldIdFccInfoSpan" style="<%=showAllTypeFccInfo?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdFccInfo, user, formid, "fieldIdFccInfo", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdFccInfoAllSpan" style="<%=showAllTypeFccInfo?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdFccInfo, user, formid, "fieldIdFccInfoAll", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeFccInfo" name="showAllTypeFccInfo" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdFccInfoSpan', 'fieldIdFccInfoAllSpan');" 
				<%=showAllTypeFccInfo?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(124867,user.getLanguage()) %></wea:item><!-- 转出科目 -->
		<wea:item>
			<span id="fieldIdSubjectSpan2" style="<%=showAllTypeSubject2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListKm, dtlFieldInfoHmKm, fieldIdSubject2, user, formid, "fieldIdSubject2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdSubjectAllSpan2" style="<%=showAllTypeSubject2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdSubject2, user, formid, "fieldIdSubjectAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(854,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 报销费用类型浏览按钮 -->
			<input id="showAllTypeSubject2" name="showAllTypeSubject2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdSubjectSpan2', 'fieldIdSubjectAllSpan2');" 
				<%=showAllTypeSubject2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124865,user.getLanguage()) %></wea:item><!-- 转出主体类型 -->
		<wea:item>
			<span id="fieldIdOrgTypeSpan2" style="<%=showAllTypeOrgType2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxlx, dtlFieldInfoHmBxlx, fieldIdOrgType2, user, formid, "fieldIdOrgType2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdOrgTypeAllSpan2" style="<%=showAllTypeOrgType2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOrgType2, user, formid, "fieldIdOrgTypeAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelName(141,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(515,user.getLanguage())+")" %>" /><!-- 选择框(个人、部门、分部、成本中心) -->
			<input id="showAllTypeOrgType2" name="showAllTypeOrgType2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOrgTypeSpan2', 'fieldIdOrgTypeAllSpan2');" 
				<%=showAllTypeOrgType2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124866,user.getLanguage()) %></wea:item><!-- 转出主体 -->
		<wea:item>
			<span id="fieldIdOrgIdSpan2" style="<%=showAllTypeOrgId2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxdw, dtlFieldInfoHmBxdw, fieldIdOrgId2, user, formid, "fieldIdOrgId2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdOrgIdAllSpan2" style="<%=showAllTypeOrgId2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOrgId2, user, formid, "fieldIdOrgIdAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 部门浏览按钮 -->
			<input id="showAllTypeOrgId2" name="showAllTypeOrgId2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOrgIdSpan2', 'fieldIdOrgIdAllSpan2');" 
				<%=showAllTypeOrgId2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
			<br />
			<input id="automaticTakeOrgId2" name="automaticTakeOrgId2" value="1" type="checkbox" 
				<%=automaticTakeOrgId2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(131113,user.getLanguage()) %><!-- 自动带出承担主体 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124868,user.getLanguage()) %></wea:item><!-- 转出期间 -->
		<wea:item>
			<span id="fieldIdOccurdateSpan2" style="<%=showAllTypeOccurdate2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListBxrq, dtlFieldInfoHmBxrq, fieldIdOccurdate2, user, formid, "fieldIdOccurdate2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdOccurdateAllSpan2" style="<%=showAllTypeOccurdate2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdOccurdate2, user, formid, "fieldIdOccurdateAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(97,user.getLanguage())+SystemEnv.getHtmlLabelName(695,user.getLanguage()) %>" /><!-- 部门浏览按钮 -->
			<input id="showAllTypeOccurdate2" name="showAllTypeOccurdate2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOccurdateSpan2', 'fieldIdOccurdateAllSpan2');" 
				<%=showAllTypeOccurdate2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124866,15402",user.getLanguage()) %></wea:item><!-- 转出主体个人预算 -->
		<wea:item>
			<span id="fieldIdHrmInfoSpan2" style="<%=showAllTypeHrmInfo2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdHrmInfo2, user, formid, "fieldIdHrmInfo2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdHrmInfoAllSpan2" style="<%=showAllTypeHrmInfo2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdHrmInfo2, user, formid, "fieldIdHrmInfoAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeHrmInfo2" name="showAllTypeHrmInfo2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdHrmInfoSpan2', 'fieldIdHrmInfoAllSpan2');" 
				<%=showAllTypeHrmInfo2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124866,15401",user.getLanguage()) %></wea:item><!-- 转出主体部门预算 -->
		<wea:item>
			<span id="fieldIdDepInfoSpan2" style="<%=showAllTypeDepInfo2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdDepInfo2, user, formid, "fieldIdDepInfo2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdDepInfoAllSpan2" style="<%=showAllTypeDepInfo2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdDepInfo2, user, formid, "fieldIdDepInfoAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeDepInfo2" name="showAllTypeDepInfo2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdDepInfoSpan2', 'fieldIdDepInfoAllSpan2');" 
				<%=showAllTypeDepInfo2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124866,18654",user.getLanguage()) %></wea:item><!-- 转出主体分部预算 -->
		<wea:item>
			<span id="fieldIdSubInfoSpan2" style="<%=showAllTypeSubInfo2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdSubInfo2, user, formid, "fieldIdSubInfo2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdSubInfoAllSpan2" style="<%=showAllTypeSubInfo2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdSubInfo2, user, formid, "fieldIdSubInfoAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeSubInfo2" name="showAllTypeSubInfo2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdSubInfoSpan2', 'fieldIdSubInfoAllSpan2');" 
				<%=showAllTypeSubInfo2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("124866,515,386",user.getLanguage()) %></wea:item><!-- 转出主体成本中心预算 -->
		<wea:item>
			<span id="fieldIdFccInfoSpan2" style="<%=showAllTypeFccInfo2?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListYs, dtlFieldInfoHmYs, fieldIdFccInfo2, user, formid, "fieldIdFccInfo2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="fieldIdFccInfoAllSpan2" style="<%=showAllTypeFccInfo2?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtlFieldIdListAll, dtlFieldInfoHmAll, fieldIdFccInfo2, user, formid, "fieldIdFccInfoAll2", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="showAllTypeFccInfo2" name="showAllTypeFccInfo2" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdFccInfoSpan2', 'fieldIdFccInfoAllSpan2');" 
				<%=showAllTypeFccInfo2?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>

<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...


jQuery(document).ready(function(){
	try{onShowAllTypeClick(jQuery("#showAllTypeSubject")[0], 'fieldIdSubjectSpan', 'fieldIdSubjectAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgType")[0], 'fieldIdOrgTypeSpan', 'fieldIdOrgTypeAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgId")[0], 'fieldIdOrgIdSpan', 'fieldIdOrgIdAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOccurdate")[0], 'fieldIdOccurdateSpan', 'fieldIdOccurdateAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeAmount")[0], 'fieldIdAmountSpan', 'fieldIdAmountAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeHrmInfo")[0], 'fieldIdHrmInfoSpan', 'fieldIdHrmInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeDepInfo")[0], 'fieldIdDepInfoSpan', 'fieldIdDepInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeSubInfo")[0], 'fieldIdSubInfoSpan', 'fieldIdSubInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeFccInfo")[0], 'fieldIdFccInfoSpan', 'fieldIdFccInfoAllSpan');}catch(ex1){}

	try{onShowAllTypeClick(jQuery("#showAllTypeSubject2")[0], 'fieldIdSubjectSpan2', 'fieldIdSubjectAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgType2")[0], 'fieldIdOrgTypeSpan2', 'fieldIdOrgTypeAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgId2")[0], 'fieldIdOrgIdSpan2', 'fieldIdOrgIdAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOccurdate2")[0], 'fieldIdOccurdateSpan2', 'fieldIdOccurdateAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeAmount2")[0], 'fieldIdAmountSpan2', 'fieldIdAmountAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeHrmInfo2")[0], 'fieldIdHrmInfoSpan2', 'fieldIdHrmInfoAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeDepInfo2")[0], 'fieldIdDepInfoSpan2', 'fieldIdDepInfoAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeSubInfo2")[0], 'fieldIdSubInfoSpan2', 'fieldIdSubInfoAllSpan2');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeFccInfo2")[0], 'fieldIdFccInfoSpan2', 'fieldIdFccInfoAllSpan2');}catch(ex1){}
	
	resizeDialog(document);
});

function onShowAllTypeClick(_obj, _sel1Id, _sel2Id){
	var _obj1 = jQuery(_obj);
	var _checked = _obj1.attr("checked")?"1":"";
	jQuery("#"+_sel1Id).hide();
	jQuery("#"+_sel2Id).hide();
	if(_checked=="1"){
		jQuery("#"+_sel2Id).show();
	}else{
		jQuery("#"+_sel1Id).show();
	}
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

//保存
function doSave(_openEditPage){
	var mainId = null2String(jQuery("#mainId").val());
	var workflowid = null2String(jQuery("#workflowid").val());
	var formid = null2String(jQuery("#formid").val());

	
	
	
	var fieldIdSubject = null2String(jQuery("#fieldIdSubject_0").val());
	var fieldIdOrgType = null2String(jQuery("#fieldIdOrgType_0").val());
	var fieldIdOrgId = null2String(jQuery("#fieldIdOrgId_0").val());
	var fieldIdOccurdate = null2String(jQuery("#fieldIdOccurdate_0").val());
	var fieldIdAmount = null2String(jQuery("#fieldIdAmount_0").val());
	var fieldIdHrmInfo = null2String(jQuery("#fieldIdHrmInfo_0").val());
	var fieldIdDepInfo = null2String(jQuery("#fieldIdDepInfo_0").val());
	var fieldIdSubInfo = null2String(jQuery("#fieldIdSubInfo_0").val());
	var fieldIdFccInfo = null2String(jQuery("#fieldIdFccInfo_0").val());
	
	var fieldIdSubjectAll = null2String(jQuery("#fieldIdSubjectAll_0").val());
	var fieldIdOrgTypeAll = null2String(jQuery("#fieldIdOrgTypeAll_0").val());
	var fieldIdOrgIdAll = null2String(jQuery("#fieldIdOrgIdAll_0").val());
	var fieldIdOccurdateAll = null2String(jQuery("#fieldIdOccurdateAll_0").val());
	var fieldIdAmountAll = null2String(jQuery("#fieldIdAmountAll_0").val());
	var fieldIdHrmInfoAll = null2String(jQuery("#fieldIdHrmInfoAll_0").val());
	var fieldIdDepInfoAll = null2String(jQuery("#fieldIdDepInfoAll_0").val());
	var fieldIdSubInfoAll = null2String(jQuery("#fieldIdSubInfoAll_0").val());
	var fieldIdFccInfoAll = null2String(jQuery("#fieldIdFccInfoAll_0").val());

	var showAllTypeSubject = jQuery("#showAllTypeSubject").attr("checked")?"1":"";
	var showAllTypeOrgType = jQuery("#showAllTypeOrgType").attr("checked")?"1":"";
	var showAllTypeOrgId = jQuery("#showAllTypeOrgId").attr("checked")?"1":"";
	var showAllTypeOccurdate = jQuery("#showAllTypeOccurdate").attr("checked")?"1":"";
	var showAllTypeAmount = jQuery("#showAllTypeAmount").attr("checked")?"1":"";
	var showAllTypeHrmInfo = jQuery("#showAllTypeHrmInfo").attr("checked")?"1":"";
	var showAllTypeDepInfo = jQuery("#showAllTypeDepInfo").attr("checked")?"1":"";
	var showAllTypeSubInfo = jQuery("#showAllTypeSubInfo").attr("checked")?"1":"";
	var showAllTypeFccInfo = jQuery("#showAllTypeFccInfo").attr("checked")?"1":"";

	var automaticTakeOrgId = jQuery("#automaticTakeOrgId").attr("checked")?"1":"";
	
	if(showAllTypeSubject==1){
		fieldIdSubject = fieldIdSubjectAll;
	}
	if(showAllTypeOrgType==1){
		fieldIdOrgType = fieldIdOrgTypeAll;
	}
	if(showAllTypeOrgId==1){
		fieldIdOrgId = fieldIdOrgIdAll;
	}
	if(showAllTypeOccurdate==1){
		fieldIdOccurdate = fieldIdOccurdateAll;
	}
	if(showAllTypeAmount==1){
		fieldIdAmount = fieldIdAmountAll;
	}
	if(showAllTypeHrmInfo==1){
		fieldIdHrmInfo = fieldIdHrmInfoAll;
	}
	if(showAllTypeDepInfo==1){
		fieldIdDepInfo = fieldIdDepInfoAll;
	}
	if(showAllTypeSubInfo==1){
		fieldIdSubInfo = fieldIdSubInfoAll;
	}
	if(showAllTypeFccInfo==1){
		fieldIdFccInfo = fieldIdFccInfoAll;
	}

	
	
	
	var fieldIdSubject2 = null2String(jQuery("#fieldIdSubject2_0").val());
	var fieldIdOrgType2 = null2String(jQuery("#fieldIdOrgType2_0").val());
	var fieldIdOrgId2 = null2String(jQuery("#fieldIdOrgId2_0").val());
	var fieldIdOccurdate2 = null2String(jQuery("#fieldIdOccurdate2_0").val());
	var fieldIdHrmInfo2 = null2String(jQuery("#fieldIdHrmInfo2_0").val());
	var fieldIdDepInfo2 = null2String(jQuery("#fieldIdDepInfo2_0").val());
	var fieldIdSubInfo2 = null2String(jQuery("#fieldIdSubInfo2_0").val());
	var fieldIdFccInfo2 = null2String(jQuery("#fieldIdFccInfo2_0").val());
	
	var fieldIdSubjectAll2 = null2String(jQuery("#fieldIdSubjectAll2_0").val());
	var fieldIdOrgTypeAll2 = null2String(jQuery("#fieldIdOrgTypeAll2_0").val());
	var fieldIdOrgIdAll2 = null2String(jQuery("#fieldIdOrgIdAll2_0").val());
	var fieldIdOccurdateAll2 = null2String(jQuery("#fieldIdOccurdateAll2_0").val());
	var fieldIdHrmInfoAll2 = null2String(jQuery("#fieldIdHrmInfoAll2_0").val());
	var fieldIdDepInfoAll2 = null2String(jQuery("#fieldIdDepInfoAll2_0").val());
	var fieldIdSubInfoAll2 = null2String(jQuery("#fieldIdSubInfoAll2_0").val());
	var fieldIdFccInfoAll2 = null2String(jQuery("#fieldIdFccInfoAll2_0").val());

	var showAllTypeSubject2 = jQuery("#showAllTypeSubject2").attr("checked")?"1":"";
	var showAllTypeOrgType2 = jQuery("#showAllTypeOrgType2").attr("checked")?"1":"";
	var showAllTypeOrgId2 = jQuery("#showAllTypeOrgId2").attr("checked")?"1":"";
	var showAllTypeOccurdate2 = jQuery("#showAllTypeOccurdate2").attr("checked")?"1":"";
	var showAllTypeHrmInfo2 = jQuery("#showAllTypeHrmInfo2").attr("checked")?"1":"";
	var showAllTypeDepInfo2 = jQuery("#showAllTypeDepInfo2").attr("checked")?"1":"";
	var showAllTypeSubInfo2 = jQuery("#showAllTypeSubInfo2").attr("checked")?"1":"";
	var showAllTypeFccInfo2 = jQuery("#showAllTypeFccInfo2").attr("checked")?"1":"";

	var automaticTakeOrgId2 = jQuery("#automaticTakeOrgId2").attr("checked")?"1":"";
	
	if(showAllTypeSubject2==1){
		fieldIdSubject2 = fieldIdSubjectAll2;
	}
	if(showAllTypeOrgType2==1){
		fieldIdOrgType2 = fieldIdOrgTypeAll2;
	}
	if(showAllTypeOrgId2==1){
		fieldIdOrgId2 = fieldIdOrgIdAll2;
	}
	if(showAllTypeOccurdate2==1){
		fieldIdOccurdate2 = fieldIdOccurdateAll2;
	}
	if(showAllTypeHrmInfo2==1){
		fieldIdHrmInfo2 = fieldIdHrmInfoAll2;
	}
	if(showAllTypeDepInfo2==1){
		fieldIdDepInfo2 = fieldIdDepInfoAll2;
	}
	if(showAllTypeSubInfo2==1){
		fieldIdSubInfo2 = fieldIdSubInfoAll2;
	}
	if(showAllTypeFccInfo2==1){
		fieldIdFccInfo2 = fieldIdFccInfoAll2;
	}
	
	if(fieldIdSubject==""
			|| fieldIdOrgType==""
			|| fieldIdOrgId==""
			|| fieldIdOccurdate==""
			|| fieldIdAmount==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("124871,125163,124869,125163,124870,125163,124872,125163,124873,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
					
					"&fieldIdSubject="+fieldIdSubject+"&fieldIdOrgType="+fieldIdOrgType+"&fieldIdOrgId="+fieldIdOrgId+
					"&fieldIdOccurdate="+fieldIdOccurdate+"&fieldIdAmount="+fieldIdAmount+"&fieldIdHrmInfo="+fieldIdHrmInfo+
					"&fieldIdDepInfo="+fieldIdDepInfo+"&fieldIdSubInfo="+fieldIdSubInfo+"&fieldIdFccInfo="+fieldIdFccInfo+
					"&showAllTypeSubject="+showAllTypeSubject+"&showAllTypeOrgType="+showAllTypeOrgType+"&showAllTypeOrgId="+showAllTypeOrgId+
					"&showAllTypeOccurdate="+showAllTypeOccurdate+"&showAllTypeAmount="+showAllTypeAmount+"&showAllTypeHrmInfo="+showAllTypeHrmInfo+
					"&showAllTypeDepInfo="+showAllTypeDepInfo+"&showAllTypeSubInfo="+showAllTypeSubInfo+"&showAllTypeFccInfo="+showAllTypeFccInfo+
					"&automaticTakeOrgId="+automaticTakeOrgId+
					
					"&fieldIdSubject2="+fieldIdSubject2+"&fieldIdOrgType2="+fieldIdOrgType2+"&fieldIdOrgId2="+fieldIdOrgId2+
					"&fieldIdOccurdate2="+fieldIdOccurdate2+"&fieldIdHrmInfo2="+fieldIdHrmInfo2+
					"&fieldIdDepInfo2="+fieldIdDepInfo2+"&fieldIdSubInfo2="+fieldIdSubInfo2+"&fieldIdFccInfo2="+fieldIdFccInfo2+
					"&showAllTypeSubject2="+showAllTypeSubject2+"&showAllTypeOrgType2="+showAllTypeOrgType2+"&showAllTypeOrgId2="+showAllTypeOrgId2+
					"&showAllTypeOccurdate2="+showAllTypeOccurdate2+"&showAllTypeHrmInfo2="+showAllTypeHrmInfo2+
					"&showAllTypeDepInfo2="+showAllTypeDepInfo2+"&showAllTypeSubInfo2="+showAllTypeSubInfo2+"&showAllTypeFccInfo2="+showAllTypeFccInfo2+
					"&automaticTakeOrgId2="+automaticTakeOrgId2+
					
					"&r=1";
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditOp.jsp",
					type : "post",
					cache : false,
					processData : false,
					data : _data,
					dataType : "json",
					success: function do4Success(_json){
					    try{
							try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
							if(_json.flag){
								//var parentWin = parent.parent.getParentWindow(parent.window);
								//onCancel2();
								top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>");//保存成功
							}else{
								top.Dialog.alert(_json.msg);
							}
		
					    	showRightMenuIframe();
					    }catch(e1){
					    	showRightMenuIframe();
					    }
					}
				});	
			},
			function(){}
		);
	}catch(e1){
		showRightMenuIframe();
	}
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}

function onCancel2(){
	parent.onCancel();	
}

</script>

</body>
</html>
