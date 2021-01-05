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

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//费控流程 //33075
String needfav ="1";
String needhelp ="";


int mainId = Util.getIntValue(request.getParameter("id"));

int workflowid = 0;
boolean enable = false;
boolean isAllNodesControl = false;
int fnaWfTypeReverse = 0;

String sql = "select * from fnaFeeWfInfo where id = "+mainId;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
	isAllNodesControl = 1==rs.getInt("isAllNodesControl");
	fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
}

String nodeIds1Str = "";
String nodeNames1Str = "";
String nodeIds2Str = "";
String nodeNames2Str = "";
sql = "select b.id nodeid, b.nodename, a.checkway from fnaFeeWfInfoNodeCtrl a join workflow_nodebase b on a.nodeid = b.id where a.mainid = " + mainId;
rs.executeSql(sql);
while(rs.next()){
	int checkway = Util.getIntValue(rs.getString("checkway"), 0);
	
	
	if(checkway == 1){
		//预算校验控制节点
		if(!"".equals(nodeIds1Str)){
			nodeIds1Str += ",";
			nodeNames1Str += ",";
		}
		
		nodeIds1Str += Util.getIntValue(rs.getString("nodeid"), 0);
		nodeNames1Str += Util.null2String(rs.getString("nodename"));
	}else if(checkway == 2){
		//冲销校验控制节点
		if(!"".equals(nodeIds2Str)){
			nodeIds2Str += ",";
			nodeNames2Str += ",";
		}
		
		nodeIds2Str += Util.getIntValue(rs.getString("nodeid"), 0);
		nodeNames2Str += Util.null2String(rs.getString("nodename"));
	}
}


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
<%
String frozeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
String frozeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(127951,user.getLanguage())%>'><!-- 节点控制 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(125922,user.getLanguage())%></wea:item><!-- 校验规则 -->
		<wea:item>
			<input type=checkbox id="isAllNodesControl" name="isAllNodesControl" onclick="fnaSpanTrigger();" tzCheckbox="true" value="1" <% if(isAllNodesControl) {%> checked <%}%> >
		</wea:item>
		
			<wea:item><%=SystemEnv.getHtmlLabelName(83363,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125921,user.getLanguage())%></wea:item><!-- 预算校验控制节点 -->
			<wea:item>
				<span id="spanRegion1" <%if(isAllNodesControl){ %> style="display: none;"<%} %>>
					<brow:browser name="nodectrl1" viewType="0" hasBrowser="true" hasAdd="false" 
						browserUrl='<%=frozeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=frozeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=nodeIds1Str %>' browserSpanValue='<%=FnaCommon.escapeHtml(nodeNames1Str) %>' />
				</span>
			</wea:item>
			<%if(fnaWfTypeReverse > 0){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(83364,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125921,user.getLanguage())%></wea:item><!-- 冲销校验控制节点 -->
				<wea:item>
					<span id="spanRegion2" <%if(isAllNodesControl){ %> style="display: none;"<%} %>>
						<brow:browser name="nodectrl2" viewType="0" hasBrowser="true" hasAdd="false" 
							browserUrl='<%=frozeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
							completeUrl='<%=frozeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=nodeIds2Str %>' browserSpanValue='<%=FnaCommon.escapeHtml(nodeNames2Str) %>' />
					</span>
				</wea:item>
			<%} %>
		
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
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
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

	var isAllNodesControl = jQuery("#isAllNodesControl").attr("checked")?"1":"";
	var nodectrl1 = null2String(jQuery("#nodectrl1").val());
	var nodectrl2 = null2String(jQuery("#nodectrl2").val());
	
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				var _data = "operation=FnaWfSetEditPageCtrlSave&mainId="+mainId+"&isAllNodesControl="+isAllNodesControl+
					"&nodectrl1="+nodectrl1+"&nodectrl2="+nodectrl2;
		
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



function onShowFnaNodes(inputName,spanName,workflowId){
	printNodes=inputName.value;
    tempUrl=escape("/workflow/workflow/WorkflowNodeBrowserMulti.jsp?printNodes="+printNodes+"&workflowId="+workflowId);
    var result =window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

    if (result != null){
		if (result.id!=""){
		    inputName.value=result.id;
		    spanName.innerHTML=result.name;
		}else{
		    inputName.value="0";
		    spanName.innerHTML="";
		}
    }
}

function fnaSpanTrigger(){
	var isAllNodesControl = jQuery("#isAllNodesControl").attr("checked")?"1":"";
	
	if(isAllNodesControl == "1"){
		jQuery("#spanRegion1").hide();
		jQuery("#spanRegion2").hide();
	}else{
		jQuery("#spanRegion1").show();
		jQuery("#spanRegion2").show();
	}
}

function onCancel(){
	var dialog = parent.parent.getDialog(parent.window);	
	dialog.closeByHand();
}

</script>

</body>
</html>
