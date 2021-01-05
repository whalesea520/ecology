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
int fnaWfTypeColl = 0;
int fnaWfTypeReverse = 0;
int fnaWfTypeReverseAdvance = 0;

String sql = "select * from fnaFeeWfInfo where id = "+mainId;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
	fnaWfTypeColl = rs.getInt("fnaWfTypeColl");
	fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
	fnaWfTypeReverseAdvance = rs.getInt("fnaWfTypeReverseAdvance");
}

boolean isEdit = true;
int trIdx = 0;


List mainFieldIdListDouble = new ArrayList();
HashMap mainFieldInfoDoubleHrm = new HashMap();

FnaWfSet.getFieldListForFieldType(mainFieldIdListDouble, mainFieldInfoDoubleHrm, 
		new ArrayList(), new HashMap(), 
		"1", "3", 
		workflowid, 0);

List mainFieldIdListHrm = new ArrayList();//申请人--单人力浏览框
HashMap mainFieldInfoHmHrm = new HashMap();
List mainFieldIdListReqs = new ArrayList();//费用申请流程--单请求、多请求
HashMap mainFieldInfoHmReqs = new HashMap();
List mainFieldIdListOpt = new ArrayList();//是否报销完成--选择框（0：否；1：是；）
HashMap mainFieldInfoHmOpt = new HashMap();
List mainFieldIdListAll = new ArrayList();//所有主表字段
HashMap mainFieldInfoHmAll = new HashMap();

FnaWfSet.getWfFieldList(mainFieldIdListReqs, mainFieldInfoHmReqs, "3", 16, workflowid, 0);

int formid = FnaWfSet.getFieldListForFieldTypeMain(mainFieldIdListHrm, mainFieldInfoHmHrm, 
		mainFieldIdListReqs, mainFieldInfoHmReqs, 
		mainFieldIdListOpt, mainFieldInfoHmOpt, 
		mainFieldIdListAll, mainFieldInfoHmAll, 
		workflowid);

String main_fieldIdSqr = "";
String main_fieldIdFysqlc = "";//费用申请流程
String main_fieldIdSfbxwc = "";//是否报销完成
int main_fieldIdFysqlc_isWfFieldLinkage = 0;//费用申请流程是否通过标准产品流程字段联动带出明细数据
int controlflowSubmission = 0;//控制流程提交  0:不控制；1：控制(默认选中)
String main_fieldIdYfkZfHj = "";

boolean main_showAllTypeSqr = false;
boolean main_showAllTypeFysqlc = false;//费用申请流程
boolean main_showAllTypeSfbxwc = false;//是否报销完成
boolean main_showAllTypeYfkZfHj = false;

boolean main_fieldIdSqr_controlBorrowingWf = false;//还款流程中通过申请人字段控制可选择的借款流程

sql = "select * from fnaFeeWfInfoField where dtlNumber = 0 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	int isWfFieldLinkage = Util.getIntValue(rs.getString("isWfFieldLinkage"), 0);
	if(Util.getIntValue(fieldType)==1){
		main_fieldIdSqr = fieldId;
		main_showAllTypeSqr = showAllType;
		main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(rs.getString("controlBorrowingWf"), 0)==1;
	}else if(Util.getIntValue(fieldType)==2){
		main_fieldIdFysqlc = fieldId;
		main_showAllTypeFysqlc = showAllType;
		main_fieldIdFysqlc_isWfFieldLinkage = isWfFieldLinkage;
		controlflowSubmission = Util.getIntValue(rs.getString("controlflowSubmission"), 1);
	}else if(Util.getIntValue(fieldType)==3){
		main_fieldIdSfbxwc = fieldId;
		main_showAllTypeSfbxwc = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		main_fieldIdYfkZfHj = fieldId;
		main_showAllTypeYfkZfHj = showAllType;
	}
}


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

List dtlFieldIdListReqId = new ArrayList(); 
HashMap dtlFieldInfoHmReqId = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListReqId, dtlFieldInfoHmReqId, "3", 16, workflowid, 1);

List dtlFieldIdListReqDtId = new ArrayList(); 
HashMap dtlFieldInfoHmReqDtId = new HashMap();
FnaWfSet.getWfFieldList(dtlFieldIdListReqDtId, dtlFieldInfoHmReqDtId, "-99999", -99999, workflowid, 1);

formid = FnaWfSet.getFieldListForFieldType(new ArrayList(), new HashMap(), 
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
String fieldIdReqId = ""; 
String fieldIdReqDtId = ""; 

boolean showAllTypeSubject = false;
boolean showAllTypeOrgType = false;
boolean showAllTypeOrgId = false;
boolean showAllTypeOccurdate = false;
boolean showAllTypeAmount = false;
boolean showAllTypeHrmInfo = false;
boolean showAllTypeDepInfo = false;
boolean showAllTypeSubInfo = false;
boolean showAllTypeFccInfo = false;
//boolean showAllTypeReqId = false; 
//boolean showAllTypeReqDtId = false; 

boolean automaticTakeOrgId = false;

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
	}else if(Util.getIntValue(fieldType)==1000){
		fieldIdReqId = fieldId;
		//showAllTypeReqId = showAllType;
	}else if(Util.getIntValue(fieldType)==1010){
		fieldIdReqDtId = fieldId;
		//showAllTypeReqDtId = showAllType;
	}
}


//冲账明细2
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


//收款明细3
List dtl3_FieldIdListOpt = new ArrayList();//收款方式--选择框(现金、银行转账)
HashMap dtl3_FieldInfoHmOpt = new HashMap();

List dtl3_FieldIdListDouble = new ArrayList();//收款金额--单行文本框(浮点数)
HashMap dtl3_FieldInfoHmDouble = new HashMap();

List dtl3_FieldIdListText = new ArrayList();//开户银行--单行文本框；户名--单行文本框；收款账号--单行文本框
HashMap dtl3_FieldInfoHmText = new HashMap();

List dtl3_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl3_FieldInfoHmAll = new HashMap();

FnaWfSet.getFieldListForFieldTypeDtl(dtl3_FieldIdListOpt, dtl3_FieldInfoHmOpt, 
		dtl3_FieldIdListDouble, dtl3_FieldInfoHmDouble, 
		dtl3_FieldIdListText, dtl3_FieldInfoHmText, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, 
		workflowid, 3);

String dt3_fieldIdSkfs = "";
String dt3_fieldIdSkje = "";
String dt3_fieldIdKhyh = "";
String dt3_fieldIdHuming = "";
String dt3_fieldIdSkzh = "";

boolean dt3_showAllTypeSkfs = false;
boolean dt3_showAllTypeSkje = false;
boolean dt3_showAllTypeKhyh = false;
boolean dt3_showAllTypeHuming = false;
boolean dt3_showAllTypeSkzh = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 3 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt3_fieldIdSkfs = fieldId;
		dt3_showAllTypeSkfs = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt3_fieldIdSkje = fieldId;
		dt3_showAllTypeSkje = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt3_fieldIdKhyh = fieldId;
		dt3_showAllTypeKhyh = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		dt3_fieldIdHuming = fieldId;
		dt3_showAllTypeHuming = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		dt3_fieldIdSkzh = fieldId;
		dt3_showAllTypeSkzh = showAllType;
	}
}


//预付款冲销明细4
List dtl4_FieldIdListDouble = new ArrayList();//借款金额、已还金额、审批中待还金额、未还金额、本次冲销金额--单行文本框(浮点数)；
HashMap dtl4_FieldInfoHmDouble = new HashMap();

List dtl4_FieldIdListText = new ArrayList();//借款单号--单行文本框；
HashMap dtl4_FieldInfoHmText = new HashMap();

List dtl4_FieldIdListReq = new ArrayList();//借款流程--请求浏览按钮
HashMap dtl4_FieldInfoHmReq = new HashMap();

List dtl4_FieldIdListInt = new ArrayList();//单内序号--整数(自动变成明细行浏览按钮)
HashMap dtl4_FieldInfoHmInt = new HashMap();

List dtl4_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl4_FieldInfoHmAll = new HashMap();

FnaWfSet.getFieldListForFieldTypeDtl(new ArrayList(), new HashMap(), 
		dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, 
		dtl4_FieldIdListText, dtl4_FieldInfoHmText, 
		dtl4_FieldIdListReq, dtl4_FieldInfoHmReq, 
		dtl4_FieldIdListInt, dtl4_FieldInfoHmInt, 
		dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, 
		workflowid, 4);

String dt4_fieldIdYfklc = "";
String dt4_fieldIdYfkdh = "";
String dt4_fieldIdDnxh = "";
String dt4_fieldIdYfkje = "";
String dt4_fieldIdYhje = "";
String dt4_fieldIdSpzje = "";
String dt4_fieldIdWhje = "";
String dt4_fieldIdCxje = "";

boolean dt4_showAllTypeYfklc = false;
boolean dt4_showAllTypeYfkdh = false;
boolean dt4_showAllTypeDnxh = false;
boolean dt4_showAllTypeYfkje = false;
boolean dt4_showAllTypeYhje = false;
boolean dt4_showAllTypeSpzje = false;
boolean dt4_showAllTypeWhje = false;
boolean dt4_showAllTypeCxje = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 4 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt4_fieldIdYfklc = fieldId;
		dt4_showAllTypeYfklc = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt4_fieldIdYfkdh = fieldId;
		dt4_showAllTypeYfkdh = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt4_fieldIdDnxh = fieldId;
		dt4_showAllTypeDnxh = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		dt4_fieldIdYfkje = fieldId;
		dt4_showAllTypeYfkje = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		dt4_fieldIdYhje = fieldId;
		dt4_showAllTypeYhje = showAllType;
	}else if(Util.getIntValue(fieldType)==6){
		dt4_fieldIdSpzje = fieldId;
		dt4_showAllTypeSpzje = showAllType;
	}else if(Util.getIntValue(fieldType)==7){
		dt4_fieldIdWhje = fieldId;
		dt4_showAllTypeWhje = showAllType;
	}else if(Util.getIntValue(fieldType)==8){
		dt4_fieldIdCxje = fieldId;
		dt4_showAllTypeCxje = showAllType;
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
	<%if(fnaWfTypeReverse > 0){ %>
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
	<%} %>

	<%if(fnaWfTypeReverseAdvance==1){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(128568,user.getLanguage()) %></wea:item><!-- 预付款支付合计 -->
		<wea:item>
			<span id="main_fieldIdYfkZfHjSpan" style="<%=main_showAllTypeYfkZfHj?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(mainFieldIdListDouble, mainFieldInfoDoubleHrm, main_fieldIdYfkZfHj, user, formid, "main_fieldIdYfkZfHj", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="main_showAllTypeYfkZfHjSpan" style="<%=main_showAllTypeYfkZfHj?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(mainFieldIdListAll, mainFieldInfoHmAll, main_fieldIdYfkZfHj, user, formid, "main_showAllTypeYfkZfHj", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(697,user.getLanguage())+")" %>" /><!-- 单行文本框(浮点数) -->
			<input id="main_showYfkZfHj" name="main_showYfkZfHj" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'main_fieldIdYfkZfHjSpan', 'main_showAllTypeYfkZfHjSpan');" 
				<%=main_showAllTypeYfkZfHj?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	<%} %>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(84631,user.getLanguage()) %></wea:item><!-- 费用申请流程 -->
		<wea:item>
			<span id="main_fieldIdFysqlcSpan" style="<%=main_showAllTypeFysqlc?displayNoneStr:"" %>" onchange="showInfo();">
				<%=FnaWfSet.getSelect(mainFieldIdListReqs, mainFieldInfoHmReqs, main_fieldIdFysqlc, user, formid, "main_fieldIdFysqlc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="main_showAllTypeFysqlcSpan" style="<%=main_showAllTypeFysqlc?"":displayNoneStr %>" >
				<%=FnaWfSet.getSelect(mainFieldIdListAll, mainFieldInfoHmAll, main_fieldIdFysqlc, user, formid, "main_showAllTypeFysqlc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(20156,user.getLanguage()) %>" /><!-- 多请求 -->
			<input id="main_showFysqlc" name="main_showFysqlc" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'main_fieldIdFysqlcSpan', 'main_showAllTypeFysqlcSpan');" 
				<%=main_showAllTypeFysqlc?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
				
			<br/>
			<span id="span_controlflowSubmission">
				<input id="main_fieldIdFysqlc_isWfFieldLinkage" name="main_fieldIdFysqlc_isWfFieldLinkage" value="1" type="checkbox" 
					<%=main_fieldIdFysqlc_isWfFieldLinkage==1?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(129916,user.getLanguage()) %><!-- 报销明细不自动带出 -->
					
				<input id="controlflowSubmission" name="controlflowSubmission" value="1" type="checkbox" 
					<%=controlflowSubmission==1?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(129918,user.getLanguage()) %><!-- 控制流程提交 -->
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(84632,user.getLanguage()) %></wea:item><!-- 是否报销完成 -->
		<wea:item>
			<span id="main_fieldIdSfbxwcSpan" style="<%=main_showAllTypeSfbxwc?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(mainFieldIdListOpt, mainFieldInfoHmOpt, main_fieldIdSfbxwc, user, formid, "main_fieldIdSfbxwc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="main_showAllTypeSfbxwcSpan" style="<%=main_showAllTypeSfbxwc?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(mainFieldIdListAll, mainFieldInfoHmAll, main_fieldIdSfbxwc, user, formid, "main_showAllTypeSfbxwc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(84633,user.getLanguage()) %>" /><!-- 选择框（0：否；1：是；） -->
			<input id="main_showSfbxwc" name="main_showSfbxwc" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'main_fieldIdSfbxwcSpan', 'main_showAllTypeSfbxwcSpan');" 
				<%=main_showAllTypeSfbxwc?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382389,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"、formtable_main_"+Math.abs(formid)+"_dt1）"%>'><!-- 报销信息字段（主表/明细表1） -->
		<wea:item><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %></wea:item><!-- 预算科目 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(83370,user.getLanguage()) %></wea:item><!-- 承担主体类型 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(83371,user.getLanguage()) %></wea:item><!-- 承担主体 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(27767,user.getLanguage()) %></wea:item><!-- 费用日期 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(18671,user.getLanguage()) %></wea:item><!-- 报销金额 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(15402,user.getLanguage()) %></wea:item><!-- 个人预算 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(15401,user.getLanguage()) %></wea:item><!-- 部门预算 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(18654,user.getLanguage()) %></wea:item><!-- 分部预算 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelNames("515,386",user.getLanguage()) %></wea:item><!-- 成本中心预算 -->
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
		<wea:item attributes="{'customAttrs':'id=ListReqIdValidate'}"><%=SystemEnv.getHtmlLabelName(131109,user.getLanguage()) %></wea:item><!-- 费用申请流程ID requestId -->
		<wea:item attributes="{'customAttrs':'id=ListReqIdValidate'}">
			<%=FnaWfSet.getSelect(dtlFieldIdListReqId, dtlFieldInfoHmReqId, fieldIdReqId, user, formid, "fieldIdReqId", isEdit, trIdx, true, "width:380px;") %>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83291,user.getLanguage()) %>" /><!-- 流程浏览框 -->
		</wea:item>
		<wea:item attributes="{'customAttrs':'id=ReqDtIdValidate'}"><%=SystemEnv.getHtmlLabelName(131110,user.getLanguage()) %></wea:item><!-- 明细表ID id -->
		<wea:item attributes="{'customAttrs':'id=ReqDtIdValidate'}">
			<%=FnaWfSet.getSelect(dtlFieldIdListReqDtId, dtlFieldInfoHmReqDtId, fieldIdReqDtId, user, formid, "fieldIdReqDtId", isEdit, trIdx, true, "width:380px;") %>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83327,user.getLanguage()) %>" /><!-- 自定义浏览框 -->
		</wea:item>
	</wea:group>
	
<%if(fnaWfTypeReverse > 0){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382385,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt2）"%>'><!-- 冲账明细字段（明细表2） -->
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
<%} %>

<%if(fnaWfTypeColl > 0){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382383,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt3）"%>'><!-- 收款明细字段（明细表3） -->
		<wea:item><%=SystemEnv.getHtmlLabelName(83192,user.getLanguage()) %></wea:item><!-- 收款方式--选择框(现金、银行转账) -->
		<wea:item>
			<span id="dt3_fieldIdSkfsSpan" style="<%=dt3_showAllTypeSkfs?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListOpt, dtl3_FieldInfoHmOpt, dt3_fieldIdSkfs, user, formid, "dt3_fieldIdSkfs", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt3_showAllTypeSkfsSpan" style="<%=dt3_showAllTypeSkfs?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, dt3_fieldIdSkfs, user, formid, "dt3_showAllTypeSkfs", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(1249,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(83804,user.getLanguage())+")" %>" /><!-- 选择框(现金、银行转账) -->
			<input id="dt3_showSkfs" name="dt3_showSkfs" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt3_fieldIdSkfsSpan', 'dt3_showAllTypeSkfsSpan');" 
				<%=dt3_showAllTypeSkfs?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17176,user.getLanguage()) %></wea:item><!-- 收款金额--单行文本框(浮点数) -->
		<wea:item>
			<span id="dt3_fieldIdSkjeSpan" style="<%=dt3_showAllTypeSkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListDouble, dtl3_FieldInfoHmDouble, dt3_fieldIdSkje, user, formid, "dt3_fieldIdSkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt3_showAllTypeSkjeSpan" style="<%=dt3_showAllTypeSkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, dt3_fieldIdSkje, user, formid, "dt3_showAllTypeSkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt3_showSkje" name="dt3_showSkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt3_fieldIdSkjeSpan', 'dt3_showAllTypeSkjeSpan');" 
				<%=dt3_showAllTypeSkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage()) %></wea:item><!-- 开户银行--单行文本框 -->
		<wea:item>
			<span id="dt3_fieldIdKhyhSpan" style="<%=dt3_showAllTypeKhyh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListText, dtl3_FieldInfoHmText, dt3_fieldIdKhyh, user, formid, "dt3_fieldIdKhyh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt3_showAllTypeKhyhSpan" style="<%=dt3_showAllTypeKhyh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, dt3_fieldIdKhyh, user, formid, "dt3_showAllTypeKhyh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt3_showKhyh" name="dt3_showKhyh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt3_fieldIdKhyhSpan', 'dt3_showAllTypeKhyhSpan');" 
				<%=dt3_showAllTypeKhyh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage()) %></wea:item><!-- 帐户名称--单行文本框 -->
		<wea:item>
			<span id="dt3_fieldIdHumingSpan" style="<%=dt3_showAllTypeHuming?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListText, dtl3_FieldInfoHmText, dt3_fieldIdHuming, user, formid, "dt3_fieldIdHuming", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt3_showAllTypeHumingSpan" style="<%=dt3_showAllTypeHuming?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, dt3_fieldIdHuming, user, formid, "dt3_showAllTypeHuming", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt3_showHuming" name="dt3_showHuming" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt3_fieldIdHumingSpan', 'dt3_showAllTypeHumingSpan');" 
				<%=dt3_showAllTypeHuming?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83191,user.getLanguage()) %></wea:item><!-- 收款账号--单行文本框 -->
		<wea:item>
			<span id="dt3_fieldIdSkzhSpan" style="<%=dt3_showAllTypeSkzh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListText, dtl3_FieldInfoHmText, dt3_fieldIdSkzh, user, formid, "dt3_fieldIdSkzh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt3_showAllTypeSkzhSpan" style="<%=dt3_showAllTypeSkzh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl3_FieldIdListAll, dtl3_FieldInfoHmAll, dt3_fieldIdSkzh, user, formid, "dt3_showAllTypeSkzh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt3_showSkzh" name="dt3_showSkzh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt3_fieldIdSkzhSpan', 'dt3_showAllTypeSkzhSpan');" 
				<%=dt3_showAllTypeSkzh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
<%} %>

<%if(fnaWfTypeReverseAdvance==1){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382387,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt4）" %>'><!-- 预付款冲销字段（明细表4） -->
		<wea:item><%=SystemEnv.getHtmlLabelName(128564,user.getLanguage()) %></wea:item><!-- 预付款流程 -->
		<wea:item>
			<span id="dt4_fieldIdYfklcSpan" style="<%=dt4_showAllTypeYfklc?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListReq, dtl4_FieldInfoHmReq, dt4_fieldIdYfklc, user, formid, "dt4_fieldIdYfklc", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeYfklcSpan" style="<%=dt4_showAllTypeYfklc?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdYfklc, user, formid, "dt4_showAllTypeYfklc", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(83291,user.getLanguage()) %>" /><!-- 流程浏览框 -->
			<input id="dt4_showYfklc" name="dt4_showYfklc" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdYfklcSpan', 'dt4_showAllTypeYfklcSpan');" 
				<%=dt4_showAllTypeYfklc?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(128565,user.getLanguage()) %></wea:item><!-- 预付款单号 -->
		<wea:item>
			<span id="dt4_fieldIdYfkdhSpan" style="<%=dt4_showAllTypeYfkdh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListText, dtl4_FieldInfoHmText, dt4_fieldIdYfkdh, user, formid, "dt4_fieldIdYfkdh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeYfkdhSpan" style="<%=dt4_showAllTypeYfkdh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdYfkdh, user, formid, "dt4_showAllTypeYfkdh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage()) %>" /><!-- 单行文本框 -->
			<input id="dt4_showYfkdh" name="dt4_showYfkdh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdYfkdhSpan', 'dt4_showAllTypeYfkdhSpan');" 
				<%=dt4_showAllTypeYfkdh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83285,user.getLanguage()) %></wea:item><!-- 单内序号 -->
		<wea:item>
			<span id="dt4_fieldIdDnxhSpan" style="<%=dt4_showAllTypeDnxh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListInt, dtl4_FieldInfoHmInt, dt4_fieldIdDnxh, user, formid, "dt4_fieldIdDnxh", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeDnxhSpan" style="<%=dt4_showAllTypeDnxh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdDnxh, user, formid, "dt4_showAllTypeDnxh", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelNames("688,696",user.getLanguage()) %>" /><!-- 单行文本框整数 -->
			<input id="dt4_showDnxh" name="dt4_showDnxh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdDnxhSpan', 'dt4_showAllTypeDnxhSpan');" 
				<%=dt4_showAllTypeDnxh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(128566,user.getLanguage()) %></wea:item><!-- 预付款金额 -->
		<wea:item>
			<span id="dt4_fieldIdYfkjeSpan" style="<%=dt4_showAllTypeYfkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, dt4_fieldIdYfkje, user, formid, "dt4_fieldIdYfkje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeYfkjeSpan" style="<%=dt4_showAllTypeYfkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdYfkje, user, formid, "dt4_showAllTypeYfkje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt4_showYfkje" name="dt4_showYfkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdYfkjeSpan', 'dt4_showAllTypeYfkjeSpan');" 
				<%=dt4_showAllTypeYfkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83286,user.getLanguage()) %></wea:item><!-- 已还金额 -->
		<wea:item>
			<span id="dt4_fieldIdYhjeSpan" style="<%=dt4_showAllTypeYhje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, dt4_fieldIdYhje, user, formid, "dt4_fieldIdYhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeYhjeSpan" style="<%=dt4_showAllTypeYhje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdYhje, user, formid, "dt4_showAllTypeYhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt4_showYhje" name="dt4_showYhje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdYhjeSpan', 'dt4_showAllTypeYhjeSpan');" 
				<%=dt4_showAllTypeYhje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83287,user.getLanguage()) %></wea:item><!-- 审批中待还金额 -->
		<wea:item>
			<span id="dt4_fieldIdSpzjeSpan" style="<%=dt4_showAllTypeSpzje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, dt4_fieldIdSpzje, user, formid, "dt4_fieldIdSpzje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeSpzjeSpan" style="<%=dt4_showAllTypeSpzje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdSpzje, user, formid, "dt4_showAllTypeSpzje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt4_showSpzje" name="dt4_showSpzje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdSpzjeSpan', 'dt4_showAllTypeSpzjeSpan');" 
				<%=dt4_showAllTypeSpzje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83288,user.getLanguage()) %></wea:item><!-- 未还金额 -->
		<wea:item>
			<span id="dt4_fieldIdWhjeSpan" style="<%=dt4_showAllTypeWhje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, dt4_fieldIdWhje, user, formid, "dt4_fieldIdWhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeWhjeSpan" style="<%=dt4_showAllTypeWhje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdWhje, user, formid, "dt4_showAllTypeWhje", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt4_showWhje" name="dt4_showWhje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdWhjeSpan', 'dt4_showAllTypeWhjeSpan');" 
				<%=dt4_showAllTypeWhje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(128567,user.getLanguage()) %></wea:item><!-- 本次冲销预付款金额 -->
		<wea:item>
			<span id="dt4_fieldIdCxjeSpan" style="<%=dt4_showAllTypeCxje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListDouble, dtl4_FieldInfoHmDouble, dt4_fieldIdCxje, user, formid, "dt4_fieldIdCxje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt4_showAllTypeCxjeSpan" style="<%=dt4_showAllTypeCxje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl4_FieldIdListAll, dtl4_FieldInfoHmAll, dt4_fieldIdCxje, user, formid, "dt4_showAllTypeCxje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt4_showCxje" name="dt4_showCxje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt4_fieldIdCxjeSpan', 'dt4_showAllTypeCxjeSpan');" 
				<%=dt4_showAllTypeCxje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
<%} %>
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
	try{onShowAllTypeClick(jQuery("#main_showFysqlc")[0], 'main_fieldIdFysqlcSpan', 'main_showAllTypeFysqlcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#main_showSfbxwc")[0], 'main_fieldIdSfbxwcSpan', 'main_showAllTypeSfbxwcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#main_fieldIdYfkZfHj")[0], 'main_fieldIdYfkZfHjSpan', 'main_showAllTypeYfkZfHjSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeSubject")[0], 'fieldIdSubjectSpan', 'fieldIdSubjectAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgType")[0], 'fieldIdOrgTypeSpan', 'fieldIdOrgTypeAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOrgId")[0], 'fieldIdOrgIdSpan', 'fieldIdOrgIdAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeOccurdate")[0], 'fieldIdOccurdateSpan', 'fieldIdOccurdateAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeAmount")[0], 'fieldIdAmountSpan', 'fieldIdAmountAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeHrmInfo")[0], 'fieldIdHrmInfoSpan', 'fieldIdHrmInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeDepInfo")[0], 'fieldIdDepInfoSpan', 'fieldIdDepInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeSubInfo")[0], 'fieldIdSubInfoSpan', 'fieldIdSubInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#showAllTypeFccInfo")[0], 'fieldIdFccInfoSpan', 'fieldIdFccInfoAllSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJklc")[0], 'dt2_fieldIdJklcSpan', 'dt2_showAllTypeJklcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJkdh")[0], 'dt2_fieldIdJkdhSpan', 'dt2_showAllTypeJkdhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showDnxh")[0], 'dt2_fieldIdDnxhSpan', 'dt2_showAllTypeDnxhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showJkje")[0], 'dt2_fieldIdJkjeSpan', 'dt2_showAllTypeJkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showYhje")[0], 'dt2_fieldIdYhjeSpan', 'dt2_showAllTypeYhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showSpzje")[0], 'dt2_fieldIdSpzjeSpan', 'dt2_showAllTypeSpzjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showWhje")[0], 'dt2_fieldIdWhjeSpan', 'dt2_showAllTypeWhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showCxje")[0], 'dt2_fieldIdCxjeSpan', 'dt2_showAllTypeCxjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt3_showSkfs")[0], 'dt3_fieldIdSkfsSpan', 'dt3_showAllTypeSkfsSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt3_showSkje")[0], 'dt3_fieldIdSkjeSpan', 'dt3_showAllTypeSkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt3_showKhyh")[0], 'dt3_fieldIdKhyhSpan', 'dt3_showAllTypeKhyhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt3_showHuming")[0], 'dt3_fieldIdHumingSpan', 'dt3_showAllTypeHumingSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt3_showSkzh")[0], 'dt3_fieldIdSkzhSpan', 'dt3_showAllTypeSkzhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showYfklc")[0], 'dt4_fieldIdYfklcSpan', 'dt4_showAllTypeYfklcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showYfkdh")[0], 'dt4_fieldIdYfkdhSpan', 'dt4_showAllTypeYfkdhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showDnxh")[0], 'dt4_fieldIdDnxhSpan', 'dt4_showAllTypeDnxhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showYfkje")[0], 'dt4_fieldIdYfkjeSpan', 'dt4_showAllTypeYfkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showYhje")[0], 'dt4_fieldIdYhjeSpan', 'dt4_showAllTypeYhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showSpzje")[0], 'dt4_fieldIdSpzjeSpan', 'dt4_showAllTypeSpzjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showWhje")[0], 'dt4_fieldIdWhjeSpan', 'dt4_showAllTypeWhjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt4_showCxje")[0], 'dt4_fieldIdCxjeSpan', 'dt4_showAllTypeCxjeSpan');}catch(ex1){}
	resizeDialog(document);
	/*
	checkinput("fieldIdSubject_0","fieldIdSubjectReqSpan");
	jQuery("#fieldIdSubject_0").bind('change', function(){
		checkinput("fieldIdSubject_0","fieldIdSubjectReqSpan");
	});
	*/
	
	showInfo();
});


function showInfo(){
	var fieldIdFysqlcSpan = jQuery("#main_fieldIdFysqlcSpan .sbSelector").text();
	var idArray = ["ListReqIdValidate","ReqDtIdValidate"];
	if(jQuery.trim(fieldIdFysqlcSpan).length == 0){
		jQuery("#span_controlflowSubmission").hide();
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().hide();
			jQuery("#"+idArray[i]).parent().next().hide();
		}
	}else{
		jQuery("#span_controlflowSubmission").show();
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().show();
			jQuery("#"+idArray[i]).parent().next().show();
		}
	}
	
}

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
	var main_fieldIdFysqlc = null2String(jQuery("#main_fieldIdFysqlc_0").val());
	var main_fieldIdSfbxwc = null2String(jQuery("#main_fieldIdSfbxwc_0").val());
	var main_fieldIdYfkZfHj = null2String(jQuery("#main_fieldIdYfkZfHj_0").val());

	var main_showAllTypeSqr = null2String(jQuery("#main_showAllTypeSqr_0").val());
	var main_showAllTypeFysqlc = null2String(jQuery("#main_showAllTypeFysqlc_0").val());
	var main_showAllTypeSfbxwc = null2String(jQuery("#main_showAllTypeSfbxwc_0").val());
	var main_showAllTypeYfkZfHj = null2String(jQuery("#main_showAllTypeYfkZfHj_0").val());

	var main_showSqr = jQuery("#main_showSqr").attr("checked")?"1":"";
	var main_showFysqlc = jQuery("#main_showFysqlc").attr("checked")?"1":"";
	var main_showSfbxwc = jQuery("#main_showSfbxwc").attr("checked")?"1":"";
	var main_showYfkZfHj = jQuery("#main_showYfkZfHj").attr("checked")?"1":"";

	var main_fieldIdSqr_controlBorrowingWf = jQuery("#main_fieldIdSqr_controlBorrowingWf").attr("checked")?"1":"";

	var main_fieldIdFysqlc_isWfFieldLinkage = jQuery("#main_fieldIdFysqlc_isWfFieldLinkage").attr("checked")?"1":"";
	var controlflowSubmission = jQuery("#controlflowSubmission").attr("checked")?"1":"";
	
	if(main_showSqr==1){
		main_fieldIdSqr = main_showAllTypeSqr;
	}
	if(main_showFysqlc==1){
		main_fieldIdFysqlc = main_showAllTypeFysqlc;
	}
	if(main_showSfbxwc==1){
		main_fieldIdSfbxwc = main_showAllTypeSfbxwc;
	}
	if(main_showYfkZfHj==1){
		main_fieldIdYfkZfHj = main_showAllTypeYfkZfHj;
	}

<%if(fnaWfTypeReverse > 0){ %>
	if(main_fieldIdSqr==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("368,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
<%} %>
	
	if(main_fieldIdFysqlc=="" && main_fieldIdSfbxwc!=""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84635,user.getLanguage())%>!");//选择费用申请流程后才能选择是否报销完成！
		return;
	}
	
	
	
	var fieldIdSubject = null2String(jQuery("#fieldIdSubject_0").val());
	var fieldIdOrgType = null2String(jQuery("#fieldIdOrgType_0").val());
	var fieldIdOrgId = null2String(jQuery("#fieldIdOrgId_0").val());
	var fieldIdOccurdate = null2String(jQuery("#fieldIdOccurdate_0").val());
	var fieldIdAmount = null2String(jQuery("#fieldIdAmount_0").val());
	var fieldIdHrmInfo = null2String(jQuery("#fieldIdHrmInfo_0").val());
	var fieldIdDepInfo = null2String(jQuery("#fieldIdDepInfo_0").val());
	var fieldIdSubInfo = null2String(jQuery("#fieldIdSubInfo_0").val());
	var fieldIdFccInfo = null2String(jQuery("#fieldIdFccInfo_0").val());
	var fieldIdReqId = null2String(jQuery("#fieldIdReqId_0").val()); 
	var fieldIdReqDtId = null2String(jQuery("#fieldIdReqDtId_0").val()); 
	
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
	
	if(fieldIdSubject==""
			|| fieldIdOrgType==""
			|| fieldIdOrgId==""
			|| fieldIdOccurdate==""
			|| fieldIdAmount==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("1462,125163,83370,125163,83371,125163,27767,125163,18671,18019",user.getLanguage())%>!");//xxxx必填
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

<%if(fnaWfTypeReverse > 0){ %>
	if(dt2_fieldIdJklc==""
			|| dt2_fieldIdDnxh==""
			|| dt2_fieldIdCxje==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83182",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83285",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83289,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
<%} %>
	
	
	

	var dt3_fieldIdSkfs = null2String(jQuery("#dt3_fieldIdSkfs_0").val());
	var dt3_fieldIdSkje = null2String(jQuery("#dt3_fieldIdSkje_0").val());
	var dt3_fieldIdKhyh = null2String(jQuery("#dt3_fieldIdKhyh_0").val());
	var dt3_fieldIdHuming = null2String(jQuery("#dt3_fieldIdHuming_0").val());
	var dt3_fieldIdSkzh = null2String(jQuery("#dt3_fieldIdSkzh_0").val());
	
	var dt3_showAllTypeSkfs = null2String(jQuery("#dt3_showAllTypeSkfs_0").val());
	var dt3_showAllTypeSkje = null2String(jQuery("#dt3_showAllTypeSkje_0").val());
	var dt3_showAllTypeKhyh = null2String(jQuery("#dt3_showAllTypeKhyh_0").val());
	var dt3_showAllTypeHuming = null2String(jQuery("#dt3_showAllTypeHuming_0").val());
	var dt3_showAllTypeSkzh = null2String(jQuery("#dt3_showAllTypeSkzh_0").val());

	var dt3_showSkfs = jQuery("#dt3_showSkfs").attr("checked")?"1":"";
	var dt3_showSkje = jQuery("#dt3_showSkje").attr("checked")?"1":"";
	var dt3_showKhyh = jQuery("#dt3_showKhyh").attr("checked")?"1":"";
	var dt3_showHuming = jQuery("#dt3_showHuming").attr("checked")?"1":"";
	var dt3_showSkzh = jQuery("#dt3_showSkzh").attr("checked")?"1":"";
	
	if(dt3_showSkfs==1){
		dt3_fieldIdSkfs = dt3_showAllTypeSkfs;
	}
	if(dt3_showSkje==1){
		dt3_fieldIdSkje = dt3_showAllTypeSkje;
	}
	if(dt3_showKhyh==1){
		dt3_fieldIdKhyh = dt3_showAllTypeKhyh;
	}
	if(dt3_showHuming==1){
		dt3_fieldIdHuming = dt3_showAllTypeHuming;
	}
	if(dt3_showSkzh==1){
		dt3_fieldIdSkzh = dt3_showAllTypeSkzh;
	}

<%if(fnaWfTypeColl > 0){ %>
	if(dt3_fieldIdSkfs==""
			|| dt3_fieldIdSkje==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83192",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("17176,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
<%} %>
	
	
	var dt4_fieldIdYfklc = null2String(jQuery("#dt4_fieldIdYfklc_0").val());
	var dt4_showAllTypeYfklc = null2String(jQuery("#dt4_showAllTypeYfklc_0").val());
	var dt4_showYfklc = jQuery("#dt4_showYfklc").attr("checked")?"1":"";
	if(dt4_showYfklc==1){
		dt4_fieldIdYfklc = dt4_showAllTypeYfklc;
	}
	
	var dt4_fieldIdYfkdh = null2String(jQuery("#dt4_fieldIdYfkdh_0").val());
	var dt4_showAllTypeYfkdh = null2String(jQuery("#dt4_showAllTypeYfkdh_0").val());
	var dt4_showYfkdh = jQuery("#dt4_showYfkdh").attr("checked")?"1":"";
	if(dt4_showYfkdh==1){
		dt4_fieldIdYfkdh = dt4_showAllTypeYfkdh;
	}
	
	var dt4_fieldIdDnxh = null2String(jQuery("#dt4_fieldIdDnxh_0").val());
	var dt4_showAllTypeSkje = null2String(jQuery("#dt4_showAllTypeDnxh_0").val());
	var dt4_showDnxh = jQuery("#dt4_showDnxh").attr("checked")?"1":"";
	if(dt4_showDnxh==1){
		dt4_fieldIdDnxh = dt4_showAllTypeSkje;
	}
	
	var dt4_fieldIdYfkje = null2String(jQuery("#dt4_fieldIdYfkje_0").val());
	var dt4_showAllTypeYfkje = null2String(jQuery("#dt4_showAllTypeYfkje_0").val());
	var dt4_showYfkje = jQuery("#dt4_showYfkje").attr("checked")?"1":"";
	if(dt4_showYfkje==1){
		dt4_fieldIdYfkje = dt4_showAllTypeYfkje;
	}
	
	var dt4_fieldIdYhje = null2String(jQuery("#dt4_fieldIdYhje_0").val());
	var dt4_showAllTypeYhje = null2String(jQuery("#dt4_showAllTypeYhje_0").val());
	var dt4_showYhje = jQuery("#dt4_showYhje").attr("checked")?"1":"";
	if(dt4_showYhje==1){
		dt4_fieldIdYhje = dt4_showAllTypeYhje;
	}
	
	var dt4_fieldIdSpzje = null2String(jQuery("#dt4_fieldIdSpzje_0").val());
	var dt4_showAllTypeSpzje = null2String(jQuery("#dt4_showAllTypeSpzje_0").val());
	var dt4_showSpzje = jQuery("#dt4_showSpzje").attr("checked")?"1":"";
	if(dt4_showSpzje==1){
		dt4_fieldIdSpzje = dt4_showAllTypeSpzje;
	}
	
	var dt4_fieldIdWhje = null2String(jQuery("#dt4_fieldIdWhje_0").val());
	var dt4_showAllTypeWhje = null2String(jQuery("#dt4_showAllTypeWhje_0").val());
	var dt4_showWhje = jQuery("#dt4_showWhje").attr("checked")?"1":"";
	if(dt4_showWhje==1){
		dt4_fieldIdWhje = dt4_showAllTypeWhje;
	}
	
	var dt4_fieldIdCxje = null2String(jQuery("#dt4_fieldIdCxje_0").val());
	var dt4_showAllTypeCxje = null2String(jQuery("#dt4_showAllTypeCxje_0").val());
	var dt4_showCxje = jQuery("#dt4_showCxje").attr("checked")?"1":"";
	if(dt4_showCxje==1){
		dt4_fieldIdCxje = dt4_showAllTypeCxje;
	}
	
	<%if(fnaWfTypeReverseAdvance == 1){ %>
	if(dt4_fieldIdYfklc==""
			|| dt4_fieldIdDnxh==""
			|| dt4_fieldIdCxje==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83182",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83285",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("83289,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	<%} %>
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
					
					"&main_fieldIdSqr="+main_fieldIdSqr+"&main_showSqr="+main_showSqr+"&main_fieldIdSqr_controlBorrowingWf="+main_fieldIdSqr_controlBorrowingWf+
					"&main_fieldIdFysqlc="+main_fieldIdFysqlc+"&main_showFysqlc="+main_showFysqlc+"&main_fieldIdFysqlc_isWfFieldLinkage="+main_fieldIdFysqlc_isWfFieldLinkage+
					"&controlflowSubmission="+controlflowSubmission+
					"&main_fieldIdSfbxwc="+main_fieldIdSfbxwc+"&main_showSfbxwc="+main_showSfbxwc+
					"&main_fieldIdYfkZfHj="+main_fieldIdYfkZfHj+"&main_showAllTypeYfkZfHj="+main_showAllTypeYfkZfHj+
				
					"&fieldIdSubject="+fieldIdSubject+"&fieldIdOrgType="+fieldIdOrgType+"&fieldIdOrgId="+fieldIdOrgId+
					"&fieldIdOccurdate="+fieldIdOccurdate+"&fieldIdAmount="+fieldIdAmount+"&fieldIdHrmInfo="+fieldIdHrmInfo+
					"&fieldIdDepInfo="+fieldIdDepInfo+"&fieldIdSubInfo="+fieldIdSubInfo+"&fieldIdFccInfo="+fieldIdFccInfo+
					"&fieldIdReqId="+fieldIdReqId+"&fieldIdReqDtId="+fieldIdReqDtId+ 
					"&showAllTypeSubject="+showAllTypeSubject+"&showAllTypeOrgType="+showAllTypeOrgType+"&showAllTypeOrgId="+showAllTypeOrgId+
					"&showAllTypeOccurdate="+showAllTypeOccurdate+"&showAllTypeAmount="+showAllTypeAmount+"&showAllTypeHrmInfo="+showAllTypeHrmInfo+
					"&showAllTypeDepInfo="+showAllTypeDepInfo+"&showAllTypeSubInfo="+showAllTypeSubInfo+"&showAllTypeFccInfo="+showAllTypeFccInfo+
					"&automaticTakeOrgId="+automaticTakeOrgId+
					
					"&dt2_fieldIdJklc="+dt2_fieldIdJklc+"&dt2_showJklc="+dt2_showJklc+
					"&dt2_fieldIdJkdh="+dt2_fieldIdJkdh+"&dt2_showJkdh="+dt2_showJkdh+
					"&dt2_fieldIdDnxh="+dt2_fieldIdDnxh+"&dt2_showDnxh="+dt2_showDnxh+
					"&dt2_fieldIdJkje="+dt2_fieldIdJkje+"&dt2_showJkje="+dt2_showJkje+
					"&dt2_fieldIdYhje="+dt2_fieldIdYhje+"&dt2_showYhje="+dt2_showYhje+
					"&dt2_fieldIdSpzje="+dt2_fieldIdSpzje+"&dt2_showSpzje="+dt2_showSpzje+
					"&dt2_fieldIdWhje="+dt2_fieldIdWhje+"&dt2_showWhje="+dt2_showWhje+
					"&dt2_fieldIdCxje="+dt2_fieldIdCxje+"&dt2_showCxje="+dt2_showCxje+
					
					"&dt3_fieldIdSkfs="+dt3_fieldIdSkfs+"&dt3_fieldIdSkje="+dt3_fieldIdSkje+"&dt3_fieldIdKhyh="+dt3_fieldIdKhyh+
					"&dt3_fieldIdHuming="+dt3_fieldIdHuming+"&dt3_fieldIdSkzh="+dt3_fieldIdSkzh+
					"&dt3_showSkfs="+dt3_showSkfs+"&dt3_showSkje="+dt3_showSkje+"&dt3_showKhyh="+dt3_showKhyh+
					"&dt3_showHuming="+dt3_showHuming+"&dt3_showSkzh="+dt3_showSkzh+
					
					"&dt4_fieldIdYfklc="+dt4_fieldIdYfklc+"&dt4_showYfklc="+dt4_showYfklc+
					"&dt4_fieldIdYfkdh="+dt4_fieldIdYfkdh+"&dt4_showYfkdh="+dt4_showYfkdh+
					"&dt4_fieldIdDnxh="+dt4_fieldIdDnxh+"&dt4_showDnxh="+dt4_showDnxh+
					"&dt4_fieldIdYfkje="+dt4_fieldIdYfkje+"&dt4_showYfkje="+dt4_showYfkje+
					"&dt4_fieldIdYhje="+dt4_fieldIdYhje+"&dt4_showYhje="+dt4_showYhje+
					"&dt4_fieldIdSpzje="+dt4_fieldIdSpzje+"&dt4_showSpzje="+dt4_showSpzje+
					"&dt4_fieldIdWhje="+dt4_fieldIdWhje+"&dt4_showWhje="+dt4_showWhje+
					"&dt4_fieldIdCxje="+dt4_fieldIdCxje+"&dt4_showCxje="+dt4_showCxje;
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/FnaWfSetEditOp.jsp",
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
								parent.location.href = "/fna/budget/FnaWfSetEditPage.jsp?id="+mainId+"&tabId=2";
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
