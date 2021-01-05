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


List mainFieldIdListHrm = new ArrayList();//申请人--单人力浏览框
HashMap mainFieldInfoHmHrm = new HashMap();
List mainFieldIdListAll = new ArrayList();//所有主表字段
HashMap mainFieldInfoHmAll = new HashMap();

int formid = FnaWfSet.getFieldListForFieldTypeMain(mainFieldIdListHrm, mainFieldInfoHmHrm, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		mainFieldIdListAll, mainFieldInfoHmAll, 
		workflowid);

String main_fieldIdSqr = "";

boolean main_showAllTypeSqr = false;
boolean main_fieldIdSqr_controlBorrowingWf = false;//还款流程中通过申请人字段控制可选择的借款流程

sql = "select * from fnaFeeWfInfoField where dtlNumber = 0 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		main_fieldIdSqr = fieldId;
		main_showAllTypeSqr = showAllType;
		main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(rs.getString("controlBorrowingWf"), 0)==1;
	}
}


List dtl1_FieldIdListOpt = new ArrayList();//还款方式--选择框(现金、银行转账)
HashMap dtl1_FieldInfoHmOpt = new HashMap();

List dtl1_FieldIdListDouble = new ArrayList();//还款金额--单行文本框(浮点数)
HashMap dtl1_FieldInfoHmDouble = new HashMap();

List dtl1_FieldIdListText = new ArrayList();//调整明细--单行文本框
HashMap dtl1_FieldInfoHmText = new HashMap();

List dtl1_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl1_FieldInfoHmAll = new HashMap();

FnaWfSet.getFieldListForFieldTypeDtl(dtl1_FieldIdListOpt, dtl1_FieldInfoHmOpt, 
		dtl1_FieldIdListDouble, dtl1_FieldInfoHmDouble, 
		dtl1_FieldIdListText, dtl1_FieldInfoHmText, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, 
		workflowid, 1);

String dt1_fieldIdHklx = "";
String dt1_fieldIdHkje = "";
String dt1_fieldIdTzmx = "";

boolean dt1_showAllTypeHklx = false;
boolean dt1_showAllTypeHkje = false;
boolean dt1_showAllTypeHkmx = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 1 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt1_fieldIdHklx = fieldId;
		dt1_showAllTypeHklx = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt1_fieldIdHkje = fieldId;
		dt1_showAllTypeHkje = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt1_fieldIdTzmx = fieldId;
		dt1_showAllTypeHkmx = showAllType;
	}
}


List dtl2_FieldIdListDouble = new ArrayList();//借款金额、已还金额、审批中待还金额、未还金额、本次冲销金额--单行文本框(浮点数)；
HashMap dtl2_FieldInfoHmDouble = new HashMap();

List dtl2_FieldIdListText = new ArrayList();//借款单号--单行文本框；
HashMap dtl2_FieldInfoHmText = new HashMap();

List dtl2_FieldIdListReq = new ArrayList();//借款流程--请求浏览按钮
HashMap dtl2_FieldInfoHmReq = new HashMap();

List dtl2_FieldIdListInt = new ArrayList();//单内序号--整数(自动变成明细行浏览按钮)
HashMap dtl2_FieldInfoHmInt = new HashMap();

List dtl2_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl2_FieldInfoHmAll = new HashMap();

FnaWfSet.getFieldListForFieldTypeDtl(new ArrayList(), new HashMap(), 
		dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, 
		dtl2_FieldIdListText, dtl2_FieldInfoHmText, 
		dtl2_FieldIdListReq, dtl2_FieldInfoHmReq, 
		dtl2_FieldIdListInt, dtl2_FieldInfoHmInt, 
		dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, 
		workflowid, 2);

String dt2_fieldIdJklc = "";
String dt2_fieldIdJkdh = "";
String dt2_fieldIdDnxh = "";
String dt2_fieldIdJkje = "";
String dt2_fieldIdYhje = "";
String dt2_fieldIdSpzje = "";
String dt2_fieldIdWhje = "";
String dt2_fieldIdCxje = "";

boolean dt2_showAllTypeJklc = false;
boolean dt2_showAllTypeJkdh = false;
boolean dt2_showAllTypeDnxh = false;
boolean dt2_showAllTypeJkje = false;
boolean dt2_showAllTypeYhje = false;
boolean dt2_showAllTypeSpzje = false;
boolean dt2_showAllTypeWhje = false;
boolean dt2_showAllTypeCxje = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 2 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt2_fieldIdJklc = fieldId;
		dt2_showAllTypeJklc = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt2_fieldIdJkdh = fieldId;
		dt2_showAllTypeJkdh = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt2_fieldIdDnxh = fieldId;
		dt2_showAllTypeDnxh = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		dt2_fieldIdJkje = fieldId;
		dt2_showAllTypeJkje = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		dt2_fieldIdYhje = fieldId;
		dt2_showAllTypeYhje = showAllType;
	}else if(Util.getIntValue(fieldType)==6){
		dt2_fieldIdSpzje = fieldId;
		dt2_showAllTypeSpzje = showAllType;
	}else if(Util.getIntValue(fieldType)==7){
		dt2_fieldIdWhje = fieldId;
		dt2_showAllTypeWhje = showAllType;
	}else if(Util.getIntValue(fieldType)==8){
		dt2_fieldIdCxje = fieldId;
		dt2_showAllTypeCxje = showAllType;
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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18020,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"）"%>'><!-- 主表字段 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(368,user.getLanguage()) %></wea:item><!-- 申请人 -->
		<wea:item>
			<span id="main_fieldIdSqrSpan" style="<%=main_showAllTypeSqr?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(mainFieldIdListHrm, mainFieldInfoHmHrm, main_fieldIdSqr, user, formid, "main_fieldIdSqr", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="main_showAllTypeSqrSpan" style="<%=main_showAllTypeSqr?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(mainFieldIdListAll, mainFieldInfoHmAll, main_fieldIdSqr, user, formid, "main_showAllTypeSqr", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(82226,user.getLanguage()) %>" /><!-- 单人力资源字段 -->
			<input id="main_showSqr" name="main_showSqr" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'main_fieldIdSqrSpan', 'main_showAllTypeSqrSpan');" 
				<%=main_showAllTypeSqr?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
			<br />
			<input id="main_fieldIdSqr_controlBorrowingWf" name="main_fieldIdSqr_controlBorrowingWf" 
				value="1" type="checkbox" 
				<%=main_fieldIdSqr_controlBorrowingWf?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(131283,user.getLanguage()) %><!-- 还款流程中通过申请人字段控制可选择的借款流程 -->
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382384,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt1）"%>'><!-- 还款明细字段 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(22097,user.getLanguage()) %></wea:item><!-- 还款方式(现金、银行转账) -->
		<wea:item>
			<span id="dt1_fieldIdHklxSpan" style="<%=dt1_showAllTypeHklx?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListOpt, dtl1_FieldInfoHmOpt, dt1_fieldIdHklx, user, formid, "dt1_fieldIdHklx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeHklxSpan" style="<%=dt1_showAllTypeHklx?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdHklx, user, formid, "dt1_showAllTypeHklx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(1249,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(83804,user.getLanguage())+")" %>" /><!-- 选择框(现金、银行转账) -->
			<input id="dt1_showHklx" name="dt1_showHklx" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdHklxSpan', 'dt1_showAllTypeHklxSpan');" 
				<%=dt1_showAllTypeHklx?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22098,user.getLanguage()) %></wea:item><!-- 还款金额 -->
		<wea:item>
			<span id="dt1_fieldIdHkjeSpan" style="<%=dt1_showAllTypeHkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListDouble, dtl1_FieldInfoHmDouble, dt1_fieldIdHkje, user, formid, "dt1_fieldIdHkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeHkjeSpan" style="<%=dt1_showAllTypeHkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdHkje, user, formid, "dt1_showAllTypeHkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt1_showHkje" name="dt1_showHkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdHkjeSpan', 'dt1_showAllTypeHkjeSpan');" 
				<%=dt1_showAllTypeHkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83190,user.getLanguage()) %></wea:item><!-- 调整明细 -->
		<wea:item>
			<span id="fieldIdOrgIdSpan" style="<%=dt1_showAllTypeHkmx?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListText, dtl1_FieldInfoHmText, dt1_fieldIdTzmx, user, formid, "dt1_fieldIdTzmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="fieldIdOrgIdAllSpan" style="<%=dt1_showAllTypeHkmx?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdTzmx, user, formid, "dt1_showAllTypeHkmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt1_showTzmx" name="dt1_showTzmx" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'fieldIdOrgIdSpan', 'fieldIdOrgIdAllSpan');" 
				<%=dt1_showAllTypeHkmx?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382385,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt2）"%>'><!-- 冲账明细字段 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(83182,user.getLanguage()) %></wea:item><!-- 借款流程 -->
		<wea:item>
			<span id="dt2_fieldIdJklcSpan" style="<%=dt2_showAllTypeJklc?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListReq, dtl2_FieldInfoHmReq, dt2_fieldIdJklc, user, formid, "dt2_fieldIdJklc", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeJklcSpan" style="<%=dt2_showAllTypeJklc?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdJklc, user, formid, "dt2_showAllTypeJklc", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(83291,user.getLanguage()) %>" /><!-- 流程浏览框 -->
			<input id="dt2_showJklc" name="dt2_showJklc" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdJklcSpan', 'dt2_showAllTypeJklcSpan');" 
				<%=dt2_showAllTypeJklc?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23884,user.getLanguage()) %></wea:item><!-- 借款单号 -->
		<wea:item>
			<span id="dt2_fieldIdJkdhSpan" style="<%=dt2_showAllTypeJkdh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListText, dtl2_FieldInfoHmText, dt2_fieldIdJkdh, user, formid, "dt2_fieldIdJkdh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeJkdhSpan" style="<%=dt2_showAllTypeJkdh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdJkdh, user, formid, "dt2_showAllTypeJkdh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage()) %>" /><!-- 单行文本框 -->
			<input id="dt2_showJkdh" name="dt2_showJkdh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdJkdhSpan', 'dt2_showAllTypeJkdhSpan');" 
				<%=dt2_showAllTypeJkdh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83285,user.getLanguage()) %></wea:item><!-- 单内序号 -->
		<wea:item>
			<span id="dt2_fieldIdDnxhSpan" style="<%=dt2_showAllTypeDnxh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListInt, dtl2_FieldInfoHmInt, dt2_fieldIdDnxh, user, formid, "dt2_fieldIdDnxh", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeDnxhSpan" style="<%=dt2_showAllTypeDnxh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdDnxh, user, formid, "dt2_showAllTypeDnxh", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelNames("688,696",user.getLanguage()) %>" /><!-- 单行文本框整数 -->
			<input id="dt2_showDnxh" name="dt2_showDnxh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdDnxhSpan', 'dt2_showAllTypeDnxhSpan');" 
				<%=dt2_showAllTypeDnxh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1043,user.getLanguage()) %></wea:item><!-- 借款金额 -->
		<wea:item>
			<span id="dt2_fieldIdJkjeSpan" style="<%=dt2_showAllTypeJkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdJkje, user, formid, "dt2_fieldIdJkje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeJkjeSpan" style="<%=dt2_showAllTypeJkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdJkje, user, formid, "dt2_showAllTypeJkje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showJkje" name="dt2_showJkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdJkjeSpan', 'dt2_showAllTypeJkjeSpan');" 
				<%=dt2_showAllTypeJkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83286,user.getLanguage()) %></wea:item><!-- 已还金额 -->
		<wea:item>
			<span id="dt2_fieldIdYhjeSpan" style="<%=dt2_showAllTypeYhje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdYhje, user, formid, "dt2_fieldIdYhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeYhjeSpan" style="<%=dt2_showAllTypeYhje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdYhje, user, formid, "dt2_showAllTypeYhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showYhje" name="dt2_showYhje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdYhjeSpan', 'dt2_showAllTypeYhjeSpan');" 
				<%=dt2_showAllTypeYhje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83287,user.getLanguage()) %></wea:item><!-- 审批中待还金额 -->
		<wea:item>
			<span id="dt2_fieldIdSpzjeSpan" style="<%=dt2_showAllTypeSpzje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdSpzje, user, formid, "dt2_fieldIdSpzje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeSpzjeSpan" style="<%=dt2_showAllTypeSpzje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdSpzje, user, formid, "dt2_showAllTypeSpzje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showSpzje" name="dt2_showSpzje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdSpzjeSpan', 'dt2_showAllTypeSpzjeSpan');" 
				<%=dt2_showAllTypeSpzje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83288,user.getLanguage()) %></wea:item><!-- 未还金额 -->
		<wea:item>
			<span id="dt2_fieldIdWhjeSpan" style="<%=dt2_showAllTypeWhje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdWhje, user, formid, "dt2_fieldIdWhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeWhjeSpan" style="<%=dt2_showAllTypeWhje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdWhje, user, formid, "dt2_showAllTypeWhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showWhje" name="dt2_showWhje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdWhjeSpan', 'dt2_showAllTypeWhjeSpan');" 
				<%=dt2_showAllTypeWhje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83289,user.getLanguage()) %></wea:item><!-- 本次冲销金额 -->
		<wea:item>
			<span id="dt2_fieldIdCxjeSpan" style="<%=dt2_showAllTypeCxje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdCxje, user, formid, "dt2_fieldIdCxje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeCxjeSpan" style="<%=dt2_showAllTypeCxje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdCxje, user, formid, "dt2_showAllTypeCxje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showCxje" name="dt2_showCxje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdCxjeSpan', 'dt2_showAllTypeCxjeSpan');" 
				<%=dt2_showAllTypeCxje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
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
	try{onShowAllTypeClick(jQuery("#main_showSqr")[0], 'main_fieldIdSqrSpan', 'main_showAllTypeSqrSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showHklx")[0], 'dt1_fieldIdHklxSpan', 'dt1_showAllTypeHklxSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showHkje")[0], 'dt1_fieldIdHkjeSpan', 'dt1_showAllTypeHkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showTzmx")[0], 'fieldIdOrgIdSpan', 'fieldIdOrgIdAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJklc")[0], 'dt2_fieldIdJklcSpan', 'dt2_showAllTypeJklcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJkdh")[0], 'dt2_fieldIdJkdhSpan', 'dt2_showAllTypeJkdhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showDnxh")[0], 'dt2_fieldIdDnxhSpan', 'dt2_showAllTypeDnxhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJkje")[0], 'dt2_fieldIdJkjeSpan', 'dt2_showAllTypeJkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showYhje")[0], 'dt2_fieldIdYhjeSpan', 'dt2_showAllTypeYhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showSpzje")[0], 'dt2_fieldIdSpzjeSpan', 'dt2_showAllTypeSpzjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showWhje")[0], 'dt2_fieldIdWhjeSpan', 'dt2_showAllTypeWhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showCxje")[0], 'dt2_fieldIdCxjeSpan', 'dt2_showAllTypeCxjeSpan');}catch(ex1){}
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
	
	var main_fieldIdSqr = null2String(jQuery("#main_fieldIdSqr_0").val());
	var main_showAllTypeSqr = null2String(jQuery("#main_showAllTypeSqr_0").val());
	var main_showSqr = jQuery("#main_showSqr").attr("checked")?"1":"";
	var main_fieldIdSqr_controlBorrowingWf = jQuery("#main_fieldIdSqr_controlBorrowingWf").attr("checked")?"1":"";
	
	if(main_showSqr==1){
		main_fieldIdSqr = main_showAllTypeSqr;
	}
	
	if(main_fieldIdSqr==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("368,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	
	
	
	var dt1_fieldIdHklx = null2String(jQuery("#dt1_fieldIdHklx_0").val());
	var dt1_fieldIdHkje = null2String(jQuery("#dt1_fieldIdHkje_0").val());
	var dt1_fieldIdTzmx = null2String(jQuery("#dt1_fieldIdTzmx_0").val());
	
	var dt1_showAllTypeHklx = null2String(jQuery("#dt1_showAllTypeHklx_0").val());
	var dt1_showAllTypeHkje = null2String(jQuery("#dt1_showAllTypeHkje_0").val());
	var dt1_showAllTypeHkmx = null2String(jQuery("#dt1_showAllTypeHkmx_0").val());

	var dt1_showHklx = jQuery("#dt1_showHklx").attr("checked")?"1":"";
	var dt1_showHkje = jQuery("#dt1_showHkje").attr("checked")?"1":"";
	var dt1_showTzmx = jQuery("#dt1_showTzmx").attr("checked")?"1":"";
	
	if(dt1_showHklx==1){
		dt1_fieldIdHklx = dt1_showAllTypeHklx;
	}
	if(dt1_showHkje==1){
		dt1_fieldIdHkje = dt1_showAllTypeHkje;
	}
	if(dt1_showTzmx==1){
		dt1_fieldIdTzmx = dt1_showAllTypeHkmx;
	}
	
	if(dt1_fieldIdHklx==""
			|| dt1_fieldIdHkje==""
			|| dt1_fieldIdTzmx==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("22097",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("22098",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83190,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	
	
	
	var dt2_fieldIdJklc = null2String(jQuery("#dt2_fieldIdJklc_0").val());
	var dt2_showAllTypeJklc = null2String(jQuery("#dt2_showAllTypeJklc_0").val());
	var dt2_showJklc = jQuery("#dt2_showJklc").attr("checked")?"1":"";
	if(dt2_showJklc==1){
		dt2_fieldIdJklc = dt2_showAllTypeJklc;
	}
	
	var dt2_fieldIdJkdh = null2String(jQuery("#dt2_fieldIdJkdh_0").val());
	var dt2_showAllTypeJkdh = null2String(jQuery("#dt2_showAllTypeJkdh_0").val());
	var dt2_showJkdh = jQuery("#dt2_showJkdh").attr("checked")?"1":"";
	if(dt2_showJkdh==1){
		dt2_fieldIdJkdh = dt2_showAllTypeJkdh;
	}
	
	var dt2_fieldIdDnxh = null2String(jQuery("#dt2_fieldIdDnxh_0").val());
	var dt2_showAllTypeSkje = null2String(jQuery("#dt2_showAllTypeDnxh_0").val());
	var dt2_showDnxh = jQuery("#dt2_showDnxh").attr("checked")?"1":"";
	if(dt2_showDnxh==1){
		dt2_fieldIdDnxh = dt2_showAllTypeSkje;
	}
	
	var dt2_fieldIdJkje = null2String(jQuery("#dt2_fieldIdJkje_0").val());
	var dt2_showAllTypeJkje = null2String(jQuery("#dt2_showAllTypeJkje_0").val());
	var dt2_showJkje = jQuery("#dt2_showJkje").attr("checked")?"1":"";
	if(dt2_showJkje==1){
		dt2_fieldIdJkje = dt2_showAllTypeJkje;
	}
	
	var dt2_fieldIdYhje = null2String(jQuery("#dt2_fieldIdYhje_0").val());
	var dt2_showAllTypeYhje = null2String(jQuery("#dt2_showAllTypeYhje_0").val());
	var dt2_showYhje = jQuery("#dt2_showYhje").attr("checked")?"1":"";
	if(dt2_showYhje==1){
		dt2_fieldIdYhje = dt2_showAllTypeYhje;
	}
	
	var dt2_fieldIdSpzje = null2String(jQuery("#dt2_fieldIdSpzje_0").val());
	var dt2_showAllTypeSpzje = null2String(jQuery("#dt2_showAllTypeSpzje_0").val());
	var dt2_showSpzje = jQuery("#dt2_showSpzje").attr("checked")?"1":"";
	if(dt2_showSpzje==1){
		dt2_fieldIdSpzje = dt2_showAllTypeSpzje;
	}
	
	var dt2_fieldIdWhje = null2String(jQuery("#dt2_fieldIdWhje_0").val());
	var dt2_showAllTypeWhje = null2String(jQuery("#dt2_showAllTypeWhje_0").val());
	var dt2_showWhje = jQuery("#dt2_showWhje").attr("checked")?"1":"";
	if(dt2_showWhje==1){
		dt2_fieldIdWhje = dt2_showAllTypeWhje;
	}
	
	var dt2_fieldIdCxje = null2String(jQuery("#dt2_fieldIdCxje_0").val());
	var dt2_showAllTypeCxje = null2String(jQuery("#dt2_showAllTypeCxje_0").val());
	var dt2_showCxje = jQuery("#dt2_showCxje").attr("checked")?"1":"";
	if(dt2_showCxje==1){
		dt2_fieldIdCxje = dt2_showAllTypeCxje;
	}
	
	if(dt2_fieldIdJklc==""
			|| dt2_fieldIdDnxh==""
			|| dt2_fieldIdCxje==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83182",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83285",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83289,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	
	
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
					"&main_fieldIdSqr="+main_fieldIdSqr+"&main_showSqr="+main_showSqr+"&main_fieldIdSqr_controlBorrowingWf="+main_fieldIdSqr_controlBorrowingWf+
					
					"&dt1_fieldIdHklx="+dt1_fieldIdHklx+"&dt1_fieldIdHkje="+dt1_fieldIdHkje+"&dt1_fieldIdTzmx="+dt1_fieldIdTzmx+
					"&dt1_showHklx="+dt1_showHklx+"&dt1_showHkje="+dt1_showHkje+"&dt1_showTzmx="+dt1_showTzmx+
					
					"&dt2_fieldIdJklc="+dt2_fieldIdJklc+"&dt2_showJklc="+dt2_showJklc+
					"&dt2_fieldIdJkdh="+dt2_fieldIdJkdh+"&dt2_showJkdh="+dt2_showJkdh+
					"&dt2_fieldIdDnxh="+dt2_fieldIdDnxh+"&dt2_showDnxh="+dt2_showDnxh+
					"&dt2_fieldIdJkje="+dt2_fieldIdJkje+"&dt2_showJkje="+dt2_showJkje+
					"&dt2_fieldIdYhje="+dt2_fieldIdYhje+"&dt2_showYhje="+dt2_showYhje+
					"&dt2_fieldIdSpzje="+dt2_fieldIdSpzje+"&dt2_showSpzje="+dt2_showSpzje+
					"&dt2_fieldIdWhje="+dt2_fieldIdWhje+"&dt2_showWhje="+dt2_showWhje+
					"&dt2_fieldIdCxje="+dt2_fieldIdCxje+"&dt2_showCxje="+dt2_showCxje+
					
					"&r=1";
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/FnaRepaymentWfSetEditOp.jsp",
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
