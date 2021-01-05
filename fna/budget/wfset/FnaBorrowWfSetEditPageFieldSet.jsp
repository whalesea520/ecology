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

sql = "select * from fnaFeeWfInfoField where dtlNumber = 0 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		main_fieldIdSqr = fieldId;
		main_showAllTypeSqr = showAllType;
	}
}


List dtl1_FieldIdListOpt = new ArrayList();//借款类型--选择框(个人借款、公务借款)；收款方式--选择框(现金、银行转账)
HashMap dtl1_FieldInfoHmOpt = new HashMap();

List dtl1_FieldIdListDouble = new ArrayList();//借款金额--单行文本框(浮点数)；收款金额--单行文本框(浮点数)
HashMap dtl1_FieldInfoHmDouble = new HashMap();

List dtl1_FieldIdListText = new ArrayList();//调整明细--单行文本框；开户银行--单行文本框；户名--单行文本框；收款账号--单行文本框
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

String dt1_fieldIdJklx = "";
String dt1_fieldIdJkje = "";
String dt1_fieldIdJkmx = "";
String dt1_fieldIdJksm = "";
String dt1_fieldIdXghklc = "";

boolean dt1_showAllTypeJklx = false;
boolean dt1_showAllTypeJkje = false;
boolean dt1_showAllTypeJkmx = false;
boolean dt1_showAllTypeJksm = false;
boolean dt1_showAllTypeXghklc = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 1 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt1_fieldIdJklx = fieldId;
		dt1_showAllTypeJklx = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt1_fieldIdJkje = fieldId;
		dt1_showAllTypeJkje = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt1_fieldIdJkmx = fieldId;
		dt1_showAllTypeJkmx = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		dt1_fieldIdJksm = fieldId;
		dt1_showAllTypeJksm = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		dt1_fieldIdXghklc = fieldId;
		dt1_showAllTypeXghklc = showAllType;
	}
}


List dtl2_FieldIdListOpt = new ArrayList();//收款方式--选择框(现金、银行转账)
HashMap dtl2_FieldInfoHmOpt = new HashMap();

List dtl2_FieldIdListDouble = new ArrayList();//收款金额--单行文本框(浮点数)
HashMap dtl2_FieldInfoHmDouble = new HashMap();

List dtl2_FieldIdListText = new ArrayList();//开户银行--单行文本框；户名--单行文本框；收款账号--单行文本框
HashMap dtl2_FieldInfoHmText = new HashMap();

List dtl2_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl2_FieldInfoHmAll = new HashMap();

FnaWfSet.getFieldListForFieldTypeDtl(dtl2_FieldIdListOpt, dtl2_FieldInfoHmOpt, 
		dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, 
		dtl2_FieldIdListText, dtl2_FieldInfoHmText, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, 
		workflowid, 2);

String dt2_fieldIdSkfs = "";
String dt2_fieldIdSkje = "";
String dt2_fieldIdKhyh = "";
String dt2_fieldIdHuming = "";
String dt2_fieldIdSkzh = "";

boolean dt2_showAllTypeSkfs = false;
boolean dt2_showAllTypeSkje = false;
boolean dt2_showAllTypeKhyh = false;
boolean dt2_showAllTypeHuming = false;
boolean dt2_showAllTypeSkzh = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 2 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt2_fieldIdSkfs = fieldId;
		dt2_showAllTypeSkfs = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt2_fieldIdSkje = fieldId;
		dt2_showAllTypeSkje = showAllType;
	}else if(Util.getIntValue(fieldType)==3){
		dt2_fieldIdKhyh = fieldId;
		dt2_showAllTypeKhyh = showAllType;
	}else if(Util.getIntValue(fieldType)==4){
		dt2_fieldIdHuming = fieldId;
		dt2_showAllTypeHuming = showAllType;
	}else if(Util.getIntValue(fieldType)==5){
		dt2_fieldIdSkzh = fieldId;
		dt2_showAllTypeSkzh = showAllType;
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
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382391,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt1）"%>'><!-- 借款明细字段 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(22138,user.getLanguage()) %></wea:item><!-- 借款类型--选择框(个人借款、公务借款) -->
		<wea:item>
			<span id="dt1_fieldIdJklxSpan" style="<%=dt1_showAllTypeJklx?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListOpt, dtl1_FieldInfoHmOpt, dt1_fieldIdJklx, user, formid, "dt1_fieldIdJklx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeJklxSpan" style="<%=dt1_showAllTypeJklx?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdJklx, user, formid, "dt1_showAllTypeJklx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(83306,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(83305,user.getLanguage())+")" %>" /><!-- 选择框(个人借款、公务借款) -->
			<input id="dt1_showJklx" name="dt1_showJklx" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdJklxSpan', 'dt1_showAllTypeJklxSpan');" 
				<%=dt1_showAllTypeJklx?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1043,user.getLanguage()) %></wea:item><!-- 借款金额--单行文本框(浮点数) -->
		<wea:item>
			<span id="dt1_fieldIdJkjeSpan" style="<%=dt1_showAllTypeJkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListDouble, dtl1_FieldInfoHmDouble, dt1_fieldIdJkje, user, formid, "dt1_fieldIdJkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeJkjeSpan" style="<%=dt1_showAllTypeJkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdJkje, user, formid, "dt1_showAllTypeJkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt1_showJkje" name="dt1_showJkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdJkjeSpan', 'dt1_showAllTypeJkjeSpan');" 
				<%=dt1_showAllTypeJkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83190,user.getLanguage()) %></wea:item><!-- 调整明细--单行文本框 -->
		<wea:item>
			<span id="dt1_fieldIdJkmxSpan" style="<%=dt1_showAllTypeJkmx?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListText, dtl1_FieldInfoHmText, dt1_fieldIdJkmx, user, formid, "dt1_fieldIdJkmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeJkmxSpan" style="<%=dt1_showAllTypeJkmx?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdJkmx, user, formid, "dt1_showAllTypeJkmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt1_showJkmx" name="dt1_showJkmx" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdJkmxSpan', 'dt1_showAllTypeJkmxSpan');" 
				<%=dt1_showAllTypeJkmx?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83354,user.getLanguage()) %></wea:item><!-- 借款说明--单行文本框 -->
		<wea:item>
			<span id="dt1_fieldIdJksmSpan" style="<%=dt1_showAllTypeJksm?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListText, dtl1_FieldInfoHmText, dt1_fieldIdJksm, user, formid, "dt1_fieldIdJksm", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeJksmSpan" style="<%=dt1_showAllTypeJksm?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdJksm, user, formid, "dt1_showAllTypeJksm", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt1_showJksm" name="dt1_showJksm" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdJksmSpan', 'dt1_showAllTypeJksmSpan');" 
				<%=dt1_showAllTypeJksm?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(84626,user.getLanguage()) %></wea:item><!-- 相关还款流程--单行文本框 -->
		<wea:item>
			<span id="dt1_fieldIdXghklcSpan" style="<%=dt1_showAllTypeXghklc?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListText, dtl1_FieldInfoHmText, dt1_fieldIdXghklc, user, formid, "dt1_fieldIdXghklc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeXghklcSpan" style="<%=dt1_showAllTypeXghklc?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdXghklc, user, formid, "dt1_showAllTypeXghklc", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt1_showXghklc" name="dt1_showXghklc" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdXghklcSpan', 'dt1_showAllTypeXghklcSpan');" 
				<%=dt1_showAllTypeXghklc?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382383,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt2）"%>'><!-- 收款明细字段 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(83192,user.getLanguage()) %></wea:item><!-- 收款方式--选择框(现金、银行转账) -->
		<wea:item>
			<span id="dt2_fieldIdSkfsSpan" style="<%=dt2_showAllTypeSkfs?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListOpt, dtl2_FieldInfoHmOpt, dt2_fieldIdSkfs, user, formid, "dt2_fieldIdSkfs", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeSkfsSpan" style="<%=dt2_showAllTypeSkfs?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdSkfs, user, formid, "dt2_showAllTypeSkfs", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())+
				"("+SystemEnv.getHtmlLabelName(1249,user.getLanguage())+"、"+SystemEnv.getHtmlLabelName(83804,user.getLanguage())+")" %>" /><!-- 选择框(现金、银行转账) -->
			<input id="dt2_showSkfs" name="dt2_showSkfs" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdSkfsSpan', 'dt2_showAllTypeSkfsSpan');" 
				<%=dt2_showAllTypeSkfs?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17176,user.getLanguage()) %></wea:item><!-- 收款金额--单行文本框(浮点数) -->
		<wea:item>
			<span id="dt2_fieldIdSkjeSpan" style="<%=dt2_showAllTypeSkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListDouble, dtl2_FieldInfoHmDouble, dt2_fieldIdSkje, user, formid, "dt2_fieldIdSkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeSkjeSpan" style="<%=dt2_showAllTypeSkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdSkje, user, formid, "dt2_showAllTypeSkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt2_showSkje" name="dt2_showSkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdSkjeSpan', 'dt2_showAllTypeSkjeSpan');" 
				<%=dt2_showAllTypeSkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage()) %></wea:item><!-- 开户银行--单行文本框 -->
		<wea:item>
			<span id="dt2_fieldIdKhyhSpan" style="<%=dt2_showAllTypeKhyh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListText, dtl2_FieldInfoHmText, dt2_fieldIdKhyh, user, formid, "dt2_fieldIdKhyh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeKhyhSpan" style="<%=dt2_showAllTypeKhyh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdKhyh, user, formid, "dt2_showAllTypeKhyh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt2_showKhyh" name="dt2_showKhyh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdKhyhSpan', 'dt2_showAllTypeKhyhSpan');" 
				<%=dt2_showAllTypeKhyh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage()) %></wea:item><!-- 帐户名称--单行文本框 -->
		<wea:item>
			<span id="dt2_fieldIdHumingSpan" style="<%=dt2_showAllTypeHuming?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListText, dtl2_FieldInfoHmText, dt2_fieldIdHuming, user, formid, "dt2_fieldIdHuming", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeHumingSpan" style="<%=dt2_showAllTypeHuming?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdHuming, user, formid, "dt2_showAllTypeHuming", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt2_showHuming" name="dt2_showHuming" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdHumingSpan', 'dt2_showAllTypeHumingSpan');" 
				<%=dt2_showAllTypeHuming?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83191,user.getLanguage()) %></wea:item><!-- 收款账号--单行文本框 -->
		<wea:item>
			<span id="dt2_fieldIdSkzhSpan" style="<%=dt2_showAllTypeSkzh?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListText, dtl2_FieldInfoHmText, dt2_fieldIdSkzh, user, formid, "dt2_fieldIdSkzh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<span id="dt2_showAllTypeSkzhSpan" style="<%=dt2_showAllTypeSkzh?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl2_FieldIdListAll, dtl2_FieldInfoHmAll, dt2_fieldIdSkzh, user, formid, "dt2_showAllTypeSkzh", isEdit, trIdx, true, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt2_showSkzh" name="dt2_showSkzh" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt2_fieldIdSkzhSpan', 'dt2_showAllTypeSkzhSpan');" 
				<%=dt2_showAllTypeSkzh?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
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
	try{onShowAllTypeClick(jQuery("#dt1_showJklx")[0], 'dt1_fieldIdJklxSpan', 'dt1_showAllTypeJklxSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showJkje")[0], 'dt1_fieldIdJkjeSpan', 'dt1_showAllTypeJkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showJkmx")[0], 'dt1_fieldIdJkmxSpan', 'dt1_showAllTypeJkmxSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showJksm")[0], 'dt1_fieldIdJksmSpan', 'dt1_showAllTypeJksmSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showXghklc")[0], 'dt1_fieldIdXghklcSpan', 'dt1_showAllTypeXghklcSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showSkfs")[0], 'dt2_fieldIdSkfsSpan', 'dt2_showAllTypeSkfsSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showSkje")[0], 'dt2_fieldIdSkjeSpan', 'dt2_showAllTypeSkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showKhyh")[0], 'dt2_fieldIdKhyhSpan', 'dt2_showAllTypeKhyhSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showHuming")[0], 'dt2_fieldIdHumingSpan', 'dt2_showAllTypeHumingSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt2_showSkzh")[0], 'dt2_fieldIdSkzhSpan', 'dt2_showAllTypeSkzhSpan');}catch(ex1){}
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
	
	if(main_showSqr==1){
		main_fieldIdSqr = main_showAllTypeSqr;
	}
	
	if(main_fieldIdSqr==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("368,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	
	
	
	var dt1_fieldIdJklx = null2String(jQuery("#dt1_fieldIdJklx_0").val());
	var dt1_fieldIdJkje = null2String(jQuery("#dt1_fieldIdJkje_0").val());
	var dt1_fieldIdJkmx = null2String(jQuery("#dt1_fieldIdJkmx_0").val());
	var dt1_fieldIdJksm = null2String(jQuery("#dt1_fieldIdJksm_0").val());
	var dt1_fieldIdXghklc = null2String(jQuery("#dt1_fieldIdXghklc_0").val());
	
	var dt1_showAllTypeJklx = null2String(jQuery("#dt1_showAllTypeJklx_0").val());
	var dt1_showAllTypeJkje = null2String(jQuery("#dt1_showAllTypeJkje_0").val());
	var dt1_showAllTypeJkmx = null2String(jQuery("#dt1_showAllTypeJkmx_0").val());
	var dt1_showAllTypeJksm = null2String(jQuery("#dt1_showAllTypeJksm_0").val());
	var dt1_showAllTypeXghklc = null2String(jQuery("#dt1_showAllTypeXghklc_0").val());

	var dt1_showJklx = jQuery("#dt1_showJklx").attr("checked")?"1":"";
	var dt1_showJkje = jQuery("#dt1_showJkje").attr("checked")?"1":"";
	var dt1_showJkmx = jQuery("#dt1_showJkmx").attr("checked")?"1":"";
	var dt1_showJksm = jQuery("#dt1_showJksm").attr("checked")?"1":"";
	var dt1_showXghklc = jQuery("#dt1_showXghklc").attr("checked")?"1":"";
	
	if(dt1_showJklx==1){
		dt1_fieldIdJklx = dt1_showAllTypeJklx;
	}
	if(dt1_showJkje==1){
		dt1_fieldIdJkje = dt1_showAllTypeJkje;
	}
	if(dt1_showJkmx==1){
		dt1_fieldIdJkmx = dt1_showAllTypeJkmx;
	}
	if(dt1_showJksm==1){
		dt1_fieldIdJksm = dt1_showAllTypeJksm;
	}
	if(dt1_showXghklc==1){
		dt1_fieldIdXghklc = dt1_showAllTypeXghklc;
	}
	
	if(dt1_fieldIdJklx==""
			|| dt1_fieldIdJkje==""
			|| dt1_fieldIdJkmx==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("22138",user.getLanguage())+"、"+
			SystemEnv.getHtmlLabelNames("1043",user.getLanguage())+"、"+
			SystemEnv.getHtmlLabelNames("83190,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	


	var dt2_fieldIdSkfs = null2String(jQuery("#dt2_fieldIdSkfs_0").val());
	var dt2_fieldIdSkje = null2String(jQuery("#dt2_fieldIdSkje_0").val());
	var dt2_fieldIdKhyh = null2String(jQuery("#dt2_fieldIdKhyh_0").val());
	var dt2_fieldIdHuming = null2String(jQuery("#dt2_fieldIdHuming_0").val());
	var dt2_fieldIdSkzh = null2String(jQuery("#dt2_fieldIdSkzh_0").val());
	
	var dt2_showAllTypeSkfs = null2String(jQuery("#dt2_showAllTypeSkfs_0").val());
	var dt2_showAllTypeSkje = null2String(jQuery("#dt2_showAllTypeSkje_0").val());
	var dt2_showAllTypeKhyh = null2String(jQuery("#dt2_showAllTypeKhyh_0").val());
	var dt2_showAllTypeHuming = null2String(jQuery("#dt2_showAllTypeHuming_0").val());
	var dt2_showAllTypeSkzh = null2String(jQuery("#dt2_showAllTypeSkzh_0").val());

	var dt2_showSkfs = jQuery("#dt2_showSkfs").attr("checked")?"1":"";
	var dt2_showSkje = jQuery("#dt2_showSkje").attr("checked")?"1":"";
	var dt2_showKhyh = jQuery("#dt2_showKhyh").attr("checked")?"1":"";
	var dt2_showHuming = jQuery("#dt2_showHuming").attr("checked")?"1":"";
	var dt2_showSkzh = jQuery("#dt2_showSkzh").attr("checked")?"1":"";
	
	if(dt2_showSkfs==1){
		dt2_fieldIdSkfs = dt2_showAllTypeSkfs;
	}
	if(dt2_showSkje==1){
		dt2_fieldIdSkje = dt2_showAllTypeSkje;
	}
	if(dt2_showKhyh==1){
		dt2_fieldIdKhyh = dt2_showAllTypeKhyh;
	}
	if(dt2_showHuming==1){
		dt2_fieldIdHuming = dt2_showAllTypeHuming;
	}
	if(dt2_showSkzh==1){
		dt2_fieldIdSkzh = dt2_showAllTypeSkzh;
	}
	
	if(dt2_fieldIdSkfs==""
			|| dt2_fieldIdSkje==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83192",user.getLanguage())+"、"+
				SystemEnv.getHtmlLabelNames("17176,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	
	
	
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
					"&main_fieldIdSqr="+main_fieldIdSqr+"&main_showSqr="+main_showSqr+
					"&dt1_fieldIdJklx="+dt1_fieldIdJklx+"&dt1_fieldIdJkje="+dt1_fieldIdJkje+"&dt1_fieldIdJkmx="+dt1_fieldIdJkmx+
					"&dt1_showJklx="+dt1_showJklx+"&dt1_showJkje="+dt1_showJkje+"&dt1_showJkmx="+dt1_showJkmx+
					"&dt1_fieldIdJksm="+dt1_fieldIdJksm+"&dt1_showJksm="+dt1_showJksm+
					"&dt1_fieldIdXghklc="+dt1_fieldIdXghklc+"&dt1_showXghklc="+dt1_showXghklc+
					"&dt2_fieldIdSkfs="+dt2_fieldIdSkfs+"&dt2_fieldIdSkje="+dt2_fieldIdSkje+"&dt2_fieldIdKhyh="+dt2_fieldIdKhyh+
					"&dt2_fieldIdHuming="+dt2_fieldIdHuming+"&dt2_fieldIdSkzh="+dt2_fieldIdSkzh+
					"&dt2_showSkfs="+dt2_showSkfs+"&dt2_showSkje="+dt2_showSkje+"&dt2_showKhyh="+dt2_showKhyh+
					"&dt2_showHuming="+dt2_showHuming+"&dt2_showSkzh="+dt2_showSkzh+
					"&r=1";
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/FnaBorrowWfSetEditOp.jsp",
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
