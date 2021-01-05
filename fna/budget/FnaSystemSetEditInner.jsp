<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%@ page import="weaver.systeminfo.label.LabelComInfo"%>

<%
if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

boolean show_subjectCodeUniqueCtrl = Util.getIntValue(new BaseBean().getPropValue("subjectCodeUniqueCtrl", "show"))==1;

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();

boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());
//是否启用从下至上编辑财务费用设置
boolean ifbottomtotop = 1==Util.getIntValue(fnaSystemSetComInfo.get_ifbottomtotop());
boolean enableGlobalFnaCtrl = 1==Util.getIntValue(fnaSystemSetComInfo.get_enableGlobalFnaCtrl());
boolean fnaBackgroundValidator = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBackgroundValidator());
String alertvalue = Util.null2String(fnaSystemSetComInfo.get_alertvalue());
String agreegap = Util.null2String(fnaSystemSetComInfo.get_agreegap());
String showHiddenSubject = Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject(), 0)+"";
String cancelFnaEditCheck = Util.getIntValue(fnaSystemSetComInfo.get_cancelFnaEditCheck(), 0)+"";//取消预算编制页面的验证功能。
boolean enableRuleSet = 1==Util.getIntValue(fnaSystemSetComInfo.get_enableRuleSet());//是否启用预算编制权限
int wfForceOverLogic = Util.getIntValue(fnaSystemSetComInfo.get_wfForceOverLogic(), 0);//强制归档流程费用业务逻辑
boolean recursiveSubOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_recursiveSubOrg());//费用流程中 显示时递归统计下级费用单位的已发生、审批中费用
boolean fnaWfSysWf = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaWfSysWf());//流程允许批量提交      报销申请单;付款申请单
boolean fnaWfCustom = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaWfCustom());//流程允许批量提交      自定义表单费控流程
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter());//科目过滤
boolean enableDispalyAll = 1==Util.getIntValue(fnaSystemSetComInfo.get_enableDispalyAll());//选择科目浏览按钮显示所有层级
String separator=Util.null2String(fnaSystemSetComInfo.get_separator());//层级间分隔符
int budgetControlType = Util.getIntValue(fnaSystemSetComInfo.get_budgetControlType(), 0);//1:下级独立预算;
int budgetControlType1 = Util.getIntValue(fnaSystemSetComInfo.get_budgetControlType1(), 1);//1:不允许费用超标;2:允许费用超标;
int subjectBrowseDefExpanded = Util.getIntValue(fnaSystemSetComInfo.get_subjectBrowseDefExpanded(), 0);//单科目浏览框默认展开
int enableRptCtrl = Util.getIntValue(fnaSystemSetComInfo.get_enableRptCtrl(), 0);//启用报表权限控制
int cancelBudgetPeriodCheck = Util.getIntValue(fnaSystemSetComInfo.get_cancelBudgetPeriodCheck(), 0);//预算期间关闭时不可使用预算
int cancelCostLimitedCheck = Util.getIntValue(fnaSystemSetComInfo.get_cancelCostLimitedCheck(), 0);//同时控制在途费用
int budgetControlType2 = Util.getIntValue(fnaSystemSetComInfo.get_budgetControlType2(), 0);//1:开启上下级独立预算;
int subjectCodeUniqueCtrl = Util.getIntValue(fnaSystemSetComInfo.get_subjectCodeUniqueCtrl(), 0);//1:开启上下级独立预算;（预算科目编码）
int subjectCodeUniqueCtrl2 = Util.getIntValue(fnaSystemSetComInfo.get_subjectCodeUniqueCtrl2(), 0);//1:开启上下级独立预算;（会计科目编码）

String div_budgetCtrlType_0 = "display: none;";
String div_budgetCtrlType_1 = "display: none;";
String div_budgetCtrlType_2 = "display: none;";
String div_budgetCtrlType_3 = "display: none;";
String div_budgetCtrlType_a = "display: none;";
String div_budgetCtrlType_b = "display: none;";
int budgetCtrlType = 1;//0：无效果；1：上下级独立编制；2：下级独立编制；3：自下而上编辑预算；
if(fnaSystemSetComInfo.getRsCount() > 0){
	if(budgetControlType2==1){//1：上下级独立编制；
		budgetCtrlType = 1;
		div_budgetCtrlType_1 = "";
		div_budgetCtrlType_a = "";
	}else if(budgetControlType==1){//2：下级独立编制；
		budgetCtrlType = 2;
		div_budgetCtrlType_2 = "";
		div_budgetCtrlType_b = "";
	}else if(ifbottomtotop){//3：自下而上编辑预算；
		budgetCtrlType = 3;
		div_budgetCtrlType_3 = "";
		div_budgetCtrlType_b = "";
	}else{//0：无效果；
		budgetCtrlType = 0;
		div_budgetCtrlType_0 = "";
		div_budgetCtrlType_b = "";
	}
}



//fnaWfSysWf = false;//强制系统表单不允许批量提交

//FnaBudgetInfoDetail表有脏数据
boolean haveDirtyData_FnaBudgetInfoDetail = false;
String sql = "select count(*) cnt \n" +
" from FnaBudgetInfoDetail a \n" +
" where not EXISTS (select 1 from FnaBudgetInfo b where a.budgetinfoid = b.id)";
rs.executeSql(sql);
if(rs.next() && rs.getInt("cnt")>0){
	haveDirtyData_FnaBudgetInfoDetail = true;
}

//FnaSynchronized表有锁定数据
boolean haveRecordData_FnaSynchronized = false;
sql = "select count(*) cnt from FnaSynchronized a";
rs.executeSql(sql);
if(rs.next() && rs.getInt("cnt")>0){
	haveRecordData_FnaSynchronized = true;
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self}";
RCMenuHeight += RCMenuHeightStep ;
if(haveDirtyData_FnaBudgetInfoDetail){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(126505,user.getLanguage())+",javascript:clearDirtyData(),_self}";//清除无效的预算数据
	RCMenuHeight += RCMenuHeightStep ;
}
if(haveRecordData_FnaSynchronized){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(131406,user.getLanguage())+",javascript:open_SynData(),_self}";//查询锁定信息
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="/fna/budget/FnaSystemSetOperation.jsp">
<input id="operation" name="operation" value="FnaSystemSetEditInner" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" 
				class="e8_btn_top" onclick="doSave();"/><!-- 保存 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

	<wea:layout type="2col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(83363,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 预算校验设置 -->
			<wea:item><%=SystemEnv.getHtmlLabelNames("33633",user.getLanguage())%></wea:item><!-- 取消预算编制页面的验证功能 -->
			<wea:item>
    			<input id="cancelFnaEditCheck" name="cancelFnaEditCheck" value="1" type="checkbox" tzCheckbox="true" <%=("1".equals(cancelFnaEditCheck))?"checked":"" %> />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(126677,user.getLanguage()) %></wea:item><!-- 启用费控流程提交校验 -->
			<wea:item>
    			<input id="enableGlobalFnaCtrl" name="enableGlobalFnaCtrl" value="1" type="checkbox" tzCheckbox="true" <%=(enableGlobalFnaCtrl)?"checked":"" %> 
    				onclick="enableGlobalFnaCtrl_onClick();" />
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'id=tD1WfValidate'}"><%=SystemEnv.getHtmlLabelName(126678,user.getLanguage())%></wea:item><!-- 启用费控流程提交后端校验 -->
			<wea:item attributes="{'customAttrs':'id=tD2WfValidate'}">
    			<input id="fnaBackgroundValidator" name="fnaBackgroundValidator" value="1" type="checkbox" tzCheckbox="true" <%=(fnaBackgroundValidator)?"checked":"" %> />
			</wea:item>
			
			<!-- 预算期间关闭时不可使用预算  0：默认不影响；1：开启影响 -->
			<wea:item attributes="{'customAttrs':'id=budgetPeriodCheck'}"><%=SystemEnv.getHtmlLabelNames("129919",user.getLanguage())%></wea:item>
			<wea:item attributes="{'customAttrs':'id=budgetPeriodCheck'}">
    			<input id="cancelBudgetPeriodCheck" name="cancelBudgetPeriodCheck" value="1" type="checkbox" tzCheckbox="true" <%=(cancelBudgetPeriodCheck==1)?"checked":"" %> onclick="showLimitedCheck();"/>
    			
    			<span id="span_cancelCostLimitedCheck">
    				<input id="cancelCostLimitedCheck" name="cancelCostLimitedCheck" value="1" type="checkbox" 
				<%=cancelCostLimitedCheck==1?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(129920,user.getLanguage()) %><!-- 同时控制在途费用 0:默认受限；1：不受限 -->
    			</span>
    			
			</wea:item>
			
	    </wea:group>
	    
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33177,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 预算编制 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(81544,user.getLanguage())%></wea:item><!-- 预算编制维度 -->
			<wea:item>
    			<input id="fnaBudgetOAOrg" name="fnaBudgetOAOrg" value="1" type="checkbox" <%=(fnaBudgetOAOrg)?"checked":"" %> />
    			<%=SystemEnv.getHtmlLabelName(33062,user.getLanguage())%>
    			<input id="fnaBudgetCostCenter" name="fnaBudgetCostCenter" value="1" type="checkbox" <%=(fnaBudgetCostCenter)?"checked":"" %> onclick="fnaBudgetCostCenter_onclick();"/>
    			<%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%>
				<input id="btnFccDimensionSet" type="button" value="<%=SystemEnv.getHtmlLabelName(129723,user.getLanguage())%>" class="e8_btn_top" 
					style="margin-left: 10px;<%=(fnaBudgetCostCenter)?"":"display: none;" %>" 
					onclick="btnFccDimensionSet_onclick();" /><!-- 成本中心维度设置 -->
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(130392,user.getLanguage())%></wea:item><!-- 编制预算方式  -->
			<wea:item>
				<select id="budgetCtrlType" name="budgetCtrlType" onchange="budgetCtrlType_onchange();">
    				<option value="1" <%=(budgetCtrlType==1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(130393,user.getLanguage())%></option><!-- 上下级独立编制 -->
    				<option value="2" <%=(budgetCtrlType==2)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(130394,user.getLanguage())%></option><!-- 下级独立编制 -->
    				<option value="3" <%=(budgetCtrlType==3)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(33079,user.getLanguage())%></option><!-- 自下而上编辑预算 -->
    				<option value="0" <%=(budgetCtrlType==0)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(130461,user.getLanguage())%></option><!-- 自上而下编制预算 -->
				</select>
    			<input id="budgetControlType1" name="budgetControlType1" value="1" type="hidden" /><!-- 下级独立编制预算校验方式 --><!-- 1：不允许费用超标；2：允许费用超标；  -->
    			<div id="div_budgetCtrlType_0" style="<%=div_budgetCtrlType_0 %>color:red;">
    				<%=SystemEnv.getHtmlLabelName(130410,user.getLanguage())%><br><!-- 1、上级预算额度，一定包含了下级预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130411,user.getLanguage())%><br><!-- 1)总部预算包含了直接下级分部的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130412,user.getLanguage())%><br><!-- 2)分部预算包含了该分部的直接下级分部、直接下级部门的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130413,user.getLanguage())%><br><br><!-- 3)部门预算包含了该部门的直接下级部门、所有该部门的人员的预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130414,user.getLanguage())%><!-- 2、当编制了下级预算时，上级的预算额度不会自动发生变化。 -->
    			</div>
    			<div id="div_budgetCtrlType_1" style="<%=div_budgetCtrlType_1 %>color:red;">
    				<%=SystemEnv.getHtmlLabelName(130415,user.getLanguage())%><!-- 1、上下级预算之间没有关系，分部、部门、个人、成本中心：预算只包含自身的额度。 -->
    			</div>
    			<div id="div_budgetCtrlType_2" style="<%=div_budgetCtrlType_2 %>color:red;">
    				<%=SystemEnv.getHtmlLabelName(130410,user.getLanguage())%><br><!-- 1、上级预算额度，一定包含了下级预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130411,user.getLanguage())%><br><!-- 1)总部预算包含了直接下级分部的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130412,user.getLanguage())%><br><!-- 2)分部预算包含了该分部的直接下级分部、直接下级部门的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130413,user.getLanguage())%><br><br><!-- 3)部门预算包含了该部门的直接下级部门、所有该部门的人员的预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130416,user.getLanguage())%><br><!-- 2、当编制了下级预算时，会依次同步增减所有直线上级的预算额度。 -->
    				<%=SystemEnv.getHtmlLabelName(130417,user.getLanguage())%><br><!-- 例如：组织机构：总部A->分部A->部门A->人员A -->
    				<%=SystemEnv.getHtmlLabelName(130459,user.getLanguage())%><br><!-- 当增加了人员A的预算额度100时，依次增加：部门A、分部A、总部A预算额度100； -->
    				<%=SystemEnv.getHtmlLabelName(130460,user.getLanguage())%><!-- 当减少了人员A的预算额度60时，依次增加：部门A、分部A、总部A预算额度-60； -->
    			</div>
    			<div id="div_budgetCtrlType_3" style="<%=div_budgetCtrlType_3 %>color:red;">
    				<%=SystemEnv.getHtmlLabelName(130410,user.getLanguage())%><br><!-- 1、上级预算额度，一定包含了下级预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130411,user.getLanguage())%><br><!-- 1)总部预算包含了直接下级分部的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130412,user.getLanguage())%><br><!-- 2)分部预算包含了该分部的直接下级分部、直接下级部门的预算额度； -->
    				<%=SystemEnv.getHtmlLabelName(130413,user.getLanguage())%><br><br><!-- 3)部门预算包含了该部门的直接下级部门、所有该部门的人员的预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130420,user.getLanguage())%><br><!-- 2、当编制了下级预算时，会依据以下口径，有条件的增减直线上级的预算额度。 -->
    				<%=SystemEnv.getHtmlLabelName(130417,user.getLanguage())%><br><!-- 例如：组织机构：总部A->分部A->部门A->人员A -->
    				<%=SystemEnv.getHtmlLabelName(130421,user.getLanguage())%><br><!-- 当修改了人员A的预算额度+100时，会先检查部门A当前可用预算额度 -->
    				<%=SystemEnv.getHtmlLabelName(130422,user.getLanguage())%><br><!-- 1)如果大于等于100则不会追加部门A的额度，且停止继续追加其余上级额度； -->
    				<%=SystemEnv.getHtmlLabelNames("130423,130424",user.getLanguage())%><br><br>
    				<!-- 2)如果小于100则会追加不足的额度（加入部门A的可用额度是30，则会追加70），且会按照相同的口径继续追加其余上级额度（继续检查分部A当前可用预算额度是否大于等于70或小于70）； -->
    				<%=SystemEnv.getHtmlLabelName(130425,user.getLanguage())%><!-- 如果人员A本次预算变更额度是减少，则上级额度不会发生变化，此时上级可用额度会相应增加。 -->
    			</div>
    			<br>
    			<div id="div_budgetCtrlType_a" style="<%=div_budgetCtrlType_a %>color: blue;">
	    			<%=SystemEnv.getHtmlLabelName(130426,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130466,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130463,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130429,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130430,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130464,user.getLanguage())%>
    			</div>
    			<div id="div_budgetCtrlType_b" style="<%=div_budgetCtrlType_b %>color: blue;">
	    			<%=SystemEnv.getHtmlLabelName(130426,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130427,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130428,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130429,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130430,user.getLanguage())%><br>
	    			<%=SystemEnv.getHtmlLabelName(130431,user.getLanguage())%>
    			</div>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("89,22151,585",user.getLanguage())%></wea:item><!-- 显示封存科目 -->
			<wea:item>
    			<input id="showHiddenSubject" name="showHiddenSubject" value="1" type="checkbox" tzCheckbox="true" <%=("1".equals(showHiddenSubject))?"checked":"" %> />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("18095,33177,385",user.getLanguage())%></wea:item><!-- 启用预算编制权限 -->
			<wea:item>
    			<input id="enableRuleSet" name="enableRuleSet" value="1" type="checkbox" tzCheckbox="true" <%=(enableRuleSet)?"checked":"" %> 
					onclick="enableRuleSet_onclick();"/>
				<input id="btnRuleCtrl" type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>" class="e8_btn_top" 
					style="margin-left: 20px;<%=(enableRuleSet)?"":"display: none;" %>" 
					onclick="btnRuleCtrl_onclick();" />
			</wea:item>
	    </wea:group>
	    
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33303,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 通用费控设置 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(81858,user.getLanguage())%></wea:item><!-- 流程强制归档逻辑 -->
			<wea:item>
				<select id="wfForceOverLogic" name="wfForceOverLogic">
					<option value="0" <%=wfForceOverLogic==0?"selected=\"selected\"":""%>><%=SystemEnv.getHtmlLabelName(81859,user.getLanguage())%></option><!-- 释放冻结预算 -->
					<option value="1" <%=wfForceOverLogic==1?"selected=\"selected\"":""%>><%=SystemEnv.getHtmlLabelName(81860,user.getLanguage())%></option><!-- 生效冻结预算 -->
				</select>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(82485,user.getLanguage())%></wea:item><!-- 显示时递归统计下级费用 -->
			<wea:item>
    			<input id="recursiveSubOrg" name="recursiveSubOrg" value="1" type="checkbox" tzCheckbox="true" <%=(recursiveSubOrg)?"checked":"" %> />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())+
				SystemEnv.getHtmlLabelName(115,user.getLanguage())+
				SystemEnv.getHtmlLabelName(17598,user.getLanguage())%></wea:item><!-- 流程允许批量提交 -->
			<wea:item>
    			<input id="fnaWfSysWf" name="fnaWfSysWf" value="1" type="checkbox" <%=(fnaWfSysWf)?"checked":"" %> />
    			<%=SystemEnv.getHtmlLabelName(18670,user.getLanguage())%>；<%=SystemEnv.getHtmlLabelName(18591,user.getLanguage())%><!-- 报销申请单;付款申请单 -->
    			<input id="fnaWfCustom" name="fnaWfCustom" value="1" type="checkbox" <%=(fnaWfCustom)?"checked":"" %> />
    			<%=SystemEnv.getHtmlLabelName(82979,user.getLanguage())%><!-- 自定义表单费控流程 -->
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128633,user.getLanguage())%></wea:item><!-- 启用报表权限控制 -->
			<wea:item>
				<input id="enableRptCtrl" name="enableRptCtrl" value="1" type="checkbox" tzCheckbox="true" <%=(enableRptCtrl==1)?"checked":"" %> 
					onclick="enableRptCtrl_onclick();"/>
				<input id="btnRptCtrl" type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>" class="e8_btn_top" 
					style="margin-left: 20px;<%=(enableRptCtrl==1)?"":"display: none;" %>" 
					onclick="btnRptCtrl_onclick();" />
			</wea:item>
	    </wea:group>
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("132113",user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 科目设置  -->
			<wea:item><%=SystemEnv.getHtmlLabelNames("132118",user.getLanguage())%></wea:item><!-- 科目应用范围 -->
			<wea:item>
    			<input id="subjectFilter" name="subjectFilter" value="1" type="checkbox" tzCheckbox="true" <%=(subjectFilter)?"checked":"" %> />
			</wea:item>
			
			<wea:item attributes="{'samePair':'tD_subjectCodeUniqueCtrl'}"><%=SystemEnv.getHtmlLabelNames("132114",user.getLanguage())%></wea:item><!-- 科目编码校验规则 -->
			<wea:item attributes="{'samePair':'tD_subjectCodeUniqueCtrl'}">
				<select id="subjectCodeUniqueCtrl" name="subjectCodeUniqueCtrl" onchange="subjectCodeUniqueCtrl_onchange();">
					<option value="0" <%=(subjectCodeUniqueCtrl==0)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(132115,user.getLanguage())%></option><!-- 全局唯一  -->
				<%if(subjectFilter){ %>
					<option value="2" <%=(subjectCodeUniqueCtrl==2)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("132116,132133",user.getLanguage())%></option><!-- 按科目应用范围唯一（分部级）  -->
					<option value="3" <%=(subjectCodeUniqueCtrl==3)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("132116,132134",user.getLanguage())%></option><!-- 按科目应用范围唯一（部门级）  -->
				<%} %>
					<option value="1" <%=(subjectCodeUniqueCtrl==1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(132117,user.getLanguage())%></option><!-- 无唯一性控制  -->
				</select>
				<br />
				<%
				String span_subjectCodeUniqueCtrl0_display = subjectCodeUniqueCtrl==0?"":"display: none;";
				String span_subjectCodeUniqueCtrl2_display = subjectCodeUniqueCtrl==2?"":"display: none;";
				String span_subjectCodeUniqueCtrl3_display = subjectCodeUniqueCtrl==3?"":"display: none;";
				String span_subjectCodeUniqueCtrl1_display = subjectCodeUniqueCtrl==1?"":"display: none;";
				%>
				<span class="span_subjectCodeUniqueCtrl span_subjectCodeUniqueCtrl0" style="color: red;<%=span_subjectCodeUniqueCtrl0_display%>">
					<%=SystemEnv.getHtmlLabelName(132173,user.getLanguage())%><!-- OA系统中所有科目的编码：不允许重复 -->
				</span>
				<span class="span_subjectCodeUniqueCtrl span_subjectCodeUniqueCtrl2" style="color: red;<%=span_subjectCodeUniqueCtrl2_display%>">
					<%=SystemEnv.getHtmlLabelName(132126,user.getLanguage())%><!-- OA系统中所有科目的编码： -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132406,user.getLanguage())%><!-- 1、组织架构：分部级别的应用范围内部不允许重复；总部、部门的应用范围内允许重复  -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132128,user.getLanguage())%><!-- 2、成本中心的应用范围内部不允许重复 -->
				</span>
				<span class="span_subjectCodeUniqueCtrl span_subjectCodeUniqueCtrl3" style="color: red;<%=span_subjectCodeUniqueCtrl3_display%>">
					<%=SystemEnv.getHtmlLabelName(132126,user.getLanguage())%><!-- OA系统中所有科目的编码： -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132407,user.getLanguage())%><!-- 1、部门级别的应用范围内部不允许重复；总部、分部的应用范围内允许重复  -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132128,user.getLanguage())%><!-- 2、成本中心的应用范围内部不允许重复 -->
				</span>
				<span class="span_subjectCodeUniqueCtrl span_subjectCodeUniqueCtrl1" style="color: red;<%=span_subjectCodeUniqueCtrl1_display%>">
					<%=SystemEnv.getHtmlLabelName(132130,user.getLanguage())%><!-- OA系统中所有科目的编码：允许重复 -->
				</span>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelNames("132166",user.getLanguage())%></wea:item><!-- 会计科目编码校验规则 -->
			<wea:item>
				<select id="subjectCodeUniqueCtrl2" name="subjectCodeUniqueCtrl2" onchange="subjectCodeUnique2Ctrl_onchange();">
					<option value="0" <%=(subjectCodeUniqueCtrl2==0)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(132115,user.getLanguage())%></option><!-- 全局唯一  -->
				<%if(subjectFilter){ %>
					<option value="2" <%=(subjectCodeUniqueCtrl2==2)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("132116,132133",user.getLanguage())%></option><!-- 按科目应用范围唯一（分部级）  -->
					<option value="3" <%=(subjectCodeUniqueCtrl2==3)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("132116,132134",user.getLanguage())%></option><!-- 按科目应用范围唯一（部门级）  -->
				<%} %>
					<option value="1" <%=(subjectCodeUniqueCtrl2==1)?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(132117,user.getLanguage())%></option><!-- 无唯一性控制  -->
				</select>
				<br />
				<%
				String span_subjectCodeUnique2Ctrl0_display = subjectCodeUniqueCtrl2==0?"":"display: none;";
				String span_subjectCodeUnique2Ctrl2_display = subjectCodeUniqueCtrl2==2?"":"display: none;";
				String span_subjectCodeUnique2Ctrl3_display = subjectCodeUniqueCtrl2==3?"":"display: none;";
				String span_subjectCodeUnique2Ctrl1_display = subjectCodeUniqueCtrl2==1?"":"display: none;";
				%>
				<span class="span_subjectCodeUnique2Ctrl span_subjectCodeUnique2Ctrl0" style="color: red;<%=span_subjectCodeUnique2Ctrl0_display%>">
					<%=SystemEnv.getHtmlLabelName(132174,user.getLanguage())%><!-- OA系统中所有会计科目的编码：不允许重复 -->
				</span>
				<span class="span_subjectCodeUnique2Ctrl span_subjectCodeUnique2Ctrl2" style="color: red;<%=span_subjectCodeUnique2Ctrl2_display%>">
					<%=SystemEnv.getHtmlLabelName(132175,user.getLanguage())%><!-- OA系统中所有会计科目的编码： -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132406,user.getLanguage())%><!-- 1、组织架构：分部级别的应用范围内部不允许重复；总部、部门的应用范围内允许重复  -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132128,user.getLanguage())%><!-- 2、成本中心的应用范围内部不允许重复 -->
				</span>
				<span class="span_subjectCodeUnique2Ctrl span_subjectCodeUnique2Ctrl3" style="color: red;<%=span_subjectCodeUnique2Ctrl3_display%>">
					<%=SystemEnv.getHtmlLabelName(132175,user.getLanguage())%><!-- OA系统中所有会计科目的编码： -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132407,user.getLanguage())%><!-- 1、部门级别的应用范围内部不允许重复；总部、分部的应用范围内允许重复  -->
					<br />
					<%=SystemEnv.getHtmlLabelName(132128,user.getLanguage())%><!-- 2、成本中心的应用范围内部不允许重复 -->
				</span>
				<span class="span_subjectCodeUnique2Ctrl span_subjectCodeUnique2Ctrl1" style="color: red;<%=span_subjectCodeUnique2Ctrl1_display%>">
					<%=SystemEnv.getHtmlLabelName(132176,user.getLanguage())%><!-- OA系统中所有会计科目的编码：允许重复 -->
				</span>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(18429,user.getLanguage())%></wea:item><!-- 科目预警值 -->
			<wea:item>
				<input class="inputstyle" id="alertvalue" name="alertvalue" maxlength=3 style="width:30px;text-align: right;"
				 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' value="<%=alertvalue%>">%
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15389,user.getLanguage())%></wea:item><!-- 允许偏差 -->
			<wea:item>
				<input class="inputstyle" id="agreegap" name="agreegap" maxlength=3 style="width:30px;text-align: right;"
				 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' value="<%=agreegap%>">%
			</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("128632,128839",user.getLanguage())%></wea:item><!-- 科目浏览框默认展开首个一级科目 -->
			<wea:item>
				<input id="subjectBrowseDefExpanded" name="subjectBrowseDefExpanded" value="1" type="checkbox" tzCheckbox="true" <%=(subjectBrowseDefExpanded==1)?"checked":"" %> />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(128840,user.getLanguage())%></wea:item><!-- 浏览框选出值显示所有层级 -->
			<wea:item>
				<input id="enableDispalyAll" name="enableDispalyAll" value="1" type="checkbox" tzCheckbox="true" <%=(enableDispalyAll)?"checked":"" %> 
					onclick="enableDispalyAll_onclick();"/>
			</wea:item>
			<wea:item attributes="{'customAttrs':'id=separator1Validate'}">
				<%=SystemEnv.getHtmlLabelName(127402,user.getLanguage())%></wea:item><!-- 层级间分隔符 -->
			<wea:item attributes="{'customAttrs':'id=separator2Validate'}">
				<input class="inputstyle" id="separator" name="separator" maxlength=5 style="width:30px;text-align: right;" value="<%=separator%>"/>
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

function onBtnSearchClick(){}

<%if(!show_subjectCodeUniqueCtrl){%>
	hideEle("tD_subjectCodeUniqueCtrl");
<%}%>


showLimitedCheck();

function subjectCodeUnique2Ctrl_onchange(){
	var subjectCodeUniqueCtrl_val = jQuery("#subjectCodeUniqueCtrl2").val();
	jQuery(".span_subjectCodeUnique2Ctrl").hide();
	jQuery(".span_subjectCodeUnique2Ctrl"+subjectCodeUniqueCtrl_val).show();
}

function subjectCodeUniqueCtrl_onchange(){
	var subjectCodeUniqueCtrl_val = jQuery("#subjectCodeUniqueCtrl").val();
	jQuery(".span_subjectCodeUniqueCtrl").hide();
	jQuery(".span_subjectCodeUniqueCtrl"+subjectCodeUniqueCtrl_val).show();
}

function budgetCtrlType_onchange(){
	var div_budgetCtrlType_0 = jQuery("#div_budgetCtrlType_0");
	var div_budgetCtrlType_1 = jQuery("#div_budgetCtrlType_1");
	var div_budgetCtrlType_2 = jQuery("#div_budgetCtrlType_2");
	var div_budgetCtrlType_3 = jQuery("#div_budgetCtrlType_3");
	var div_budgetCtrlType_a = jQuery("#div_budgetCtrlType_a");
	var div_budgetCtrlType_b = jQuery("#div_budgetCtrlType_b");
	div_budgetCtrlType_0.hide();
	div_budgetCtrlType_1.hide();
	div_budgetCtrlType_2.hide();
	div_budgetCtrlType_3.hide();
	div_budgetCtrlType_a.hide();
	div_budgetCtrlType_b.hide();
	var budgetCtrlType = jQuery("#budgetCtrlType").val();
	if(budgetCtrlType=="1"){//1：上下级独立编制；
		div_budgetCtrlType_1.show();
		div_budgetCtrlType_a.show();
	}else if(budgetCtrlType=="2"){//2：下级独立编制；
		div_budgetCtrlType_2.show();
		div_budgetCtrlType_b.show();
	}else if(budgetCtrlType=="3"){//3：自下而上编辑预算；
		div_budgetCtrlType_3.show();
		div_budgetCtrlType_b.show();
	}else{//0：无效果；
		div_budgetCtrlType_0.show();
		div_budgetCtrlType_b.show();
	}
	alert("<%=SystemEnv.getHtmlLabelName(130465,user.getLanguage()) %>");
}

function showLimitedCheck(){
	var ischecked = jQuery("#cancelBudgetPeriodCheck").attr("checked")?true:false;
	if(ischecked){
		jQuery("#span_cancelCostLimitedCheck").show();
	}else{
		jQuery("#span_cancelCostLimitedCheck").hide();
	}
}

function btnFccDimensionSet_onclick(){
	_fnaOpenDialog("/fna/costCenter/fccDimensionSet/fccDimensionSet.jsp",  
			"<%=SystemEnv.getHtmlLabelName(129723,user.getLanguage()) %>", 800, 600);
}

function btnRuleCtrl_onclick(){
	_fnaOpenDialog("/fna/budget/FnaLeftRuleSet/ruleSet.jsp?isDialog=1",  
			"<%=SystemEnv.getHtmlLabelName(33193,user.getLanguage()) %>", 800, 600);
}

function btnRptCtrl_onclick(){
	_fnaOpenDialog("/fna/report/FnaRptCtrl/ruleSet.jsp",  
			"<%=SystemEnv.getHtmlLabelName(128636,user.getLanguage()) %>", 800, 600);
}

function fnaBudgetCostCenter_onclick(){
	var fnaBudgetCostCenter = jQuery("#fnaBudgetCostCenter").attr("checked")?true:false;
	if(fnaBudgetCostCenter){
		jQuery("#btnFccDimensionSet").show();
	}else{
		jQuery("#btnFccDimensionSet").hide();
	}
}

function enableRuleSet_onclick(){
	var enableRuleSet = jQuery("#enableRuleSet").attr("checked")?true:false;
	if(enableRuleSet){
		jQuery("#btnRuleCtrl").show();
	}else{
		jQuery("#btnRuleCtrl").hide();
	}
}

function enableRptCtrl_onclick(){
	var enableRptCtrl = jQuery("#enableRptCtrl").attr("checked")?true:false;
	if(enableRptCtrl){
		jQuery("#btnRptCtrl").show();
	}else{
		jQuery("#btnRptCtrl").hide();
	}
}

function budgetControlType_onclick(){
	var budgetControlType = jQuery("#budgetControlType").attr("checked")?true:false;
	if(budgetControlType){
		jQuery("#ifbottomtotop").attr("checked", false);
		fna_____changeCheckboxStatus4tzCheckBox($G("ifbottomtotop"),false);
		showEle("budgetControlType_samePair");
	}else{
		hideEle("budgetControlType_samePair");
	}
}

function ifbottomtotop_onclick(){
	var ifbottomtotop = jQuery("#ifbottomtotop").attr("checked")?true:false;
	if(ifbottomtotop){
		jQuery("#budgetControlType").attr("checked", false);
		hideEle("budgetControlType_samePair");
		fna_____changeCheckboxStatus4tzCheckBox($G("budgetControlType"),false);
	}
}

function enableGlobalFnaCtrl_onClick(){
	var ifbudgetmove = jQuery("#enableGlobalFnaCtrl").attr("checked")?true:false;
	var idArray = ["tD1WfValidate","budgetPeriodCheck"];
	if(ifbudgetmove){
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().show();
			jQuery("#"+idArray[i]).parent().next().show();
		}
	}else{
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().hide();
			jQuery("#"+idArray[i]).parent().next().hide();
		}
	}
}

function enableDispalyAll_onclick(){
	var enableDispalyAll = jQuery("#enableDispalyAll").attr("checked")?true:false;
	var idArray = ["separator1Validate"];
	if(enableDispalyAll){
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().show();
			jQuery("#"+idArray[i]).parent().next().show();
		}
	}else{
		for(var i=0;i<idArray.length;i++){
			jQuery("#"+idArray[i]).parent().hide();
			jQuery("#"+idArray[i]).parent().next().hide();
		}
	}
}

function open_SynData(){
	_fnaOpenDialog("/fna/budget/fnaSynData.jsp",  
			"<%=SystemEnv.getHtmlLabelName(131406,user.getLanguage()) %>", 800, 600);
}

function clearDirtyData(){
	hideRightMenuIframe();
	try{
		var _data = "operation=clearDirtyData";

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/budget/FnaSystemSetEditInnerAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					alert(_json.msg);
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
	}catch(e1){
		showRightMenuIframe();
	}
}

//切换美化checkbox是否选中
function fna_____changeCheckboxStatus4tzCheckBox(obj, checked) {
	//jQuery(obj).attr("checked", checked);
	if (checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
		jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
	}
}

function doSave(){
	var enableDispalyAll = jQuery("#enableDispalyAll").attr("checked")?true:false;
	if(enableDispalyAll){
		var separator = $GetEle("separator").value.trim();
		if(separator==""){
			alert("<%=SystemEnv.getHtmlLabelName(127411,user.getLanguage())%>");
			return;
		}
	}

	var fnaBudgetOAOrg = jQuery("#fnaBudgetOAOrg").attr("checked")?1:0;
	var fnaBudgetCostCenter = jQuery("#fnaBudgetCostCenter").attr("checked")?1:0;
	var subjectFilter = jQuery("#subjectFilter").attr("checked")?1:0;
	var subjectCodeUniqueCtrl = jQuery("#subjectCodeUniqueCtrl").val();
	var subjectCodeUniqueCtrl2 = jQuery("#subjectCodeUniqueCtrl2").val();
	var _data = "fnaBudgetOAOrg="+fnaBudgetOAOrg+"&fnaBudgetCostCenter="+fnaBudgetCostCenter+"&subjectFilter="+subjectFilter+
		"&subjectCodeUniqueCtrl="+subjectCodeUniqueCtrl+"&subjectCodeUniqueCtrl2="+subjectCodeUniqueCtrl2;
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/budget/FnaSystemSetOperationAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
			try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			if(_json.flag){
				form2.submit();
			}else{
				alert(_json.msg);
			}
		}
	});	
}
enableGlobalFnaCtrl_onClick();
enableDispalyAll_onclick();
</script>
</body>
</html>
