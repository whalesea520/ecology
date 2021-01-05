<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
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
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

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

int totalAmtVerification = 1;
int intensity = 2;
int totalAmtVerification2 = 1;

String promptSC = "";

if(mainId > 0){
	//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	FnaWfSet.clearOldFnaFeeWfInfoLogicReverseData(workflowid);
	
	sql = "select * from fnaFeeWfInfoLogicReverse where mainId = "+mainId;
	rs.executeSql(sql);
	if(rs.next()){
		totalAmtVerification = rs.getInt("rule1");
		intensity = rs.getInt("rule1intensity");
		totalAmtVerification2 = rs.getInt("rule2");

		promptSC = Util.null2String(rs.getString("promptSC")).trim();
	}
}else{
	//"本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！";
	promptSC = FnaLanguage.getPromptSC_FnaWfSetEditPageLogicSetReverse(user.getLanguage());
}

%>

<%@page import="weaver.fna.general.FnaLanguage"%><html>
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
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83194,user.getLanguage())+" 1"%>'><!-- 校验规则 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(127149,user.getLanguage()) %></wea:item><!-- 启用校验 -->
		<wea:item>
			<input id="totalAmtVerification2" name="totalAmtVerification2" <%=totalAmtVerification2==1?"checked=\"checked\"":"" %> value="1" type="checkbox" />
			<%=SystemEnv.getHtmlLabelName(126679,user.getLanguage()) %><!-- 报销金额合计 = 冲销金额合计 + 收款金额合计-->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(127151,user.getLanguage()) %></wea:item><!-- 校验强度 -->
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32137, user.getLanguage()) %><!-- 强控 -->
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83194,user.getLanguage())+" 2"%>'><!-- 校验规则 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(127149,user.getLanguage()) %></wea:item><!-- 启用校验 -->
		<wea:item>
			<input id="totalAmtVerification" name="totalAmtVerification" <%=totalAmtVerification==1?"checked=\"checked\"":"" %> value="1" type="checkbox" />
			<%=SystemEnv.getHtmlLabelName(83294,user.getLanguage()) %><!-- 本次冲销金额 <= 未还金额 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(127151,user.getLanguage()) %></wea:item><!-- 校验强度 -->
		<wea:item>
			<select id="intensity" name="intensity" style="width: 60px;float: left;">
				<option value="2" <%=(intensity==2)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32137, user.getLanguage()) %></option><!-- 强控 -->
				<option value="3" <%=(intensity==3)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32138, user.getLanguage()) %></option><!-- 弱控 -->
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33141,user.getLanguage()) %></wea:item><!-- 提示语句 -->
		<wea:item>
			<wea:required id="promptSCspan" required="true">
				<input id="promptSC" name="promptSC" value="<%=FnaCommon.escapeHtml(promptSC) %>" maxlength="2000" style="width: 90%;" class="inputstyle" 
				 onblur="checkinput('promptSC','promptSCspan');" />
			</wea:required>
		</wea:item>
		<wea:item>
			<font color="red">
				<%=SystemEnv.getHtmlLabelName(33151,user.getLanguage()) %>：<br /><!-- 提示语句占位符 -->
				#amount1#：<%=SystemEnv.getHtmlLabelNames("83289,358",user.getLanguage()) %><br /><!-- 本次冲销金额合计 -->
				#amount2#：<%=SystemEnv.getHtmlLabelNames("83288,358",user.getLanguage()) %><br /><!-- 未还金额合计 -->
			</font>
		</wea:item><!-- 使用说明 -->
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
	resizeDialog(document);
	checkinput("promptSC","promptSCspan");
	orgType_onchange();
});

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//保存
function doSave(_openEditPage){
	var mainId = null2String(jQuery("#mainId").val());
	var workflowid = null2String(jQuery("#workflowid").val());

	var totalAmtVerification = jQuery("#totalAmtVerification").attr("checked")?"1":"";
	var intensity = null2String(jQuery("#intensity").val());
	var totalAmtVerification2 = jQuery("#totalAmtVerification2").attr("checked")?"1":"";
	
	var promptSC = null2String(jQuery("#promptSC").val());
	var __multilangpre_promptSC = null2String(jQuery("input[name='__multilangpre_promptSC']").val());

	if(promptSC==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33141,user.getLanguage())+
				SystemEnv.getHtmlLabelName(22054,user.getLanguage())+SystemEnv.getHtmlLabelName(18019,user.getLanguage()) %>");//提示语句中文简体必填
		return;
	}
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				var _data = "operation=FnaWfSetEditPageLogicSetReverse&mainId="+mainId+"&workflowid="+workflowid+
					"&intensity="+intensity+"&totalAmtVerification="+totalAmtVerification+"&totalAmtVerification2="+totalAmtVerification2+
					"&promptSC="+encodeURI(promptSC)+"&__multilangpre_promptSC="+encodeURI(__multilangpre_promptSC);
		
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
	}
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
