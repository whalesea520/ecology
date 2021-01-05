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


List dtl1_FieldIdListDouble = new ArrayList();//单行文本框(浮点数)
HashMap dtl1_FieldInfoHmDouble = new HashMap();

List dtl1_FieldIdListText = new ArrayList();//单行文本框
HashMap dtl1_FieldInfoHmText = new HashMap();

List dtl1_FieldIdListAll = new ArrayList();//所有明细字段
HashMap dtl1_FieldInfoHmAll = new HashMap();

int formid = FnaWfSet.getFieldListForFieldTypeDtl(new ArrayList(), new HashMap(), 
		dtl1_FieldIdListDouble, dtl1_FieldInfoHmDouble, 
		dtl1_FieldIdListText, dtl1_FieldInfoHmText, 
		new ArrayList(), new HashMap(), 
		new ArrayList(), new HashMap(), 
		dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, 
		workflowid, 1);

String dt1_fieldIdYfkje = "";
String dt1_fieldIdYfkmx = "";

boolean dt1_showAllTypeYfkje = false;
boolean dt1_showAllTypeYfkmx = false;

sql = "select * from fnaFeeWfInfoField where dtlNumber = 1 and mainId = "+mainId;
rs.executeSql(sql);
while(rs.next()){
	String fieldType = Util.null2String(rs.getString("fieldType"));
	String fieldId = Util.null2String(rs.getString("fieldId"));
	boolean showAllType = Util.getIntValue(rs.getString("showAllType"), 0)==1;
	if(Util.getIntValue(fieldType)==1){
		dt1_fieldIdYfkje = fieldId;
		dt1_showAllTypeYfkje = showAllType;
	}else if(Util.getIntValue(fieldType)==2){
		dt1_fieldIdYfkmx = fieldId;
		dt1_showAllTypeYfkmx = showAllType;
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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(382386,user.getLanguage())+"（formtable_main_"+Math.abs(formid)+"_dt1）"%>'><!-- 预付款明细字段  -->
		<wea:item><%=SystemEnv.getHtmlLabelName(128578,user.getLanguage()) %></wea:item><!-- 预付款金额--单行文本框(浮点数) -->
		<wea:item>
			<span id="dt1_fieldIdYfkjeSpan" style="<%=dt1_showAllTypeYfkje?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListDouble, dtl1_FieldInfoHmDouble, dt1_fieldIdYfkje, user, formid, "dt1_fieldIdYfkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeYfkjeSpan" style="<%=dt1_showAllTypeYfkje?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdYfkje, user, formid, "dt1_showAllTypeYfkje", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(688,user.getLanguage())+SystemEnv.getHtmlLabelName(697,user.getLanguage()) %>" /><!-- 单行文本框浮点数 -->
			<input id="dt1_showYfkje" name="dt1_showYfkje" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdYfkjeSpan', 'dt1_showAllTypeYfkjeSpan');" 
				<%=dt1_showAllTypeYfkje?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83190,user.getLanguage()) %></wea:item><!-- 调整明细--单行文本框 -->
		<wea:item>
			<span id="dt1_fieldIdYfkmxSpan" style="<%=dt1_showAllTypeYfkmx?displayNoneStr:"" %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListText, dtl1_FieldInfoHmText, dt1_fieldIdYfkmx, user, formid, "dt1_fieldIdYfkmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<span id="dt1_showAllTypeYfkmxSpan" style="<%=dt1_showAllTypeYfkmx?"":displayNoneStr %>">
				<%=FnaWfSet.getSelect(dtl1_FieldIdListAll, dtl1_FieldInfoHmAll, dt1_fieldIdYfkmx, user, formid, "dt1_showAllTypeYfkmx", isEdit, trIdx, false, "width:380px;") %>
			</span>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(23193,user.getLanguage()) %>" /><!-- 单行文本框（文本） -->
			<input id="dt1_showYfkmx" name="dt1_showYfkmx" value="1" type="checkbox" onclick="onShowAllTypeClick(this, 'dt1_fieldIdYfkmxSpan', 'dt1_showAllTypeYfkmxSpan');" 
				<%=dt1_showAllTypeYfkmx?"checked=\"checked\"":"" %> /><%=SystemEnv.getHtmlLabelName(82481,user.getLanguage()) %><!-- 显示所有类型 -->
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
	try{onShowAllTypeClick(jQuery("#dt1_showYfkje")[0], 'dt1_fieldIdYfkjeSpan', 'dt1_showAllTypeYfkjeSpan');}catch(ex1){}
	try{onShowAllTypeClick(jQuery("#dt1_showYfkmx")[0], 'dt1_fieldIdYfkmxSpan', 'dt1_showAllTypeYfkmxSpan');}catch(ex1){}
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

	
	
	var dt1_fieldIdYfkje = null2String(jQuery("#dt1_fieldIdYfkje_0").val());
	var dt1_fieldIdYfkmx = null2String(jQuery("#dt1_fieldIdYfkmx_0").val());
	
	var dt1_showAllTypeYfkje = null2String(jQuery("#dt1_showAllTypeYfkje_0").val());
	var dt1_showAllTypeYfkmx = null2String(jQuery("#dt1_showAllTypeYfkmx_0").val());

	var dt1_showYfkje = jQuery("#dt1_showYfkje").attr("checked")?"1":"";
	var dt1_showYfkmx = jQuery("#dt1_showYfkmx").attr("checked")?"1":"";
	
	if(dt1_showYfkje==1){
		dt1_fieldIdYfkje = dt1_showAllTypeYfkje;
	}
	if(dt1_showYfkmx==1){
		dt1_fieldIdYfkmx = dt1_showAllTypeYfkmx;
	}
	
	if(dt1_fieldIdYfkje==""
			|| dt1_fieldIdYfkmx==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("128578",user.getLanguage())+" "+
			SystemEnv.getHtmlLabelNames("83190,18019",user.getLanguage())%>!");//xxxx必填
		return;
	}
	
	
	

	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+
					"&dt1_fieldIdYfkje="+dt1_fieldIdYfkje+"&dt1_fieldIdYfkmx="+dt1_fieldIdYfkmx+
					"&dt1_showYfkje="+dt1_showYfkje+"&dt1_showYfkmx="+dt1_showYfkmx+
					"&r=1";
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/budgetAdvance/FnaAdvanceWfSetEditOp.jsp",
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
