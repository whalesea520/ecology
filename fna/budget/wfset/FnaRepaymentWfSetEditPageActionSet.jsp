<%@page import="weaver.fna.general.FnaCommon"%>
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


//冻结借款-节点前附加操作
StringBuffer nodeIdsOrder = new StringBuffer("");
String freezeBorrowNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeBorrowNode1Ids");
String freezeBorrowNode1Names = FnaWfSet.getNodesName(freezeBorrowNode1Ids, nodeIdsOrder);
freezeBorrowNode1Ids = nodeIdsOrder.toString();
//冻结借款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String freezeBorrowNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeBorrowNode2Ids");
String freezeBorrowNode2Names = FnaWfSet.getNodesName(freezeBorrowNode2Ids, nodeIdsOrder);
freezeBorrowNode2Ids = nodeIdsOrder.toString();
//冻结借款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String freezeBorrowNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeBorrowNode3Ids");
String freezeBorrowNode3Names = FnaWfSet.getNodePortalsName(freezeBorrowNode3Ids, nodeIdsOrder);
freezeBorrowNode3Ids = nodeIdsOrder.toString();


//冲销借款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentBorrowNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentBorrowNode1Ids");
String repaymentBorrowNode1Names = FnaWfSet.getNodesName(repaymentBorrowNode1Ids, nodeIdsOrder);
repaymentBorrowNode1Ids = nodeIdsOrder.toString();
//冲销借款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentBorrowNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentBorrowNode2Ids");
String repaymentBorrowNode2Names = FnaWfSet.getNodesName(repaymentBorrowNode2Ids, nodeIdsOrder);
repaymentBorrowNode2Ids = nodeIdsOrder.toString();
//冲销借款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentBorrowNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentBorrowNode3Ids");
String repaymentBorrowNode3Names = FnaWfSet.getNodePortalsName(repaymentBorrowNode3Ids, nodeIdsOrder);
repaymentBorrowNode3Ids = nodeIdsOrder.toString();


//释放冻结借款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeBorrowNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeBorrowNode1Ids");
String releaseFreezeBorrowNode1Names = FnaWfSet.getNodesName(releaseFreezeBorrowNode1Ids, nodeIdsOrder);
releaseFreezeBorrowNode1Ids = nodeIdsOrder.toString();
//释放冻结借款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeBorrowNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeBorrowNode2Ids");
String releaseFreezeBorrowNode2Names = FnaWfSet.getNodesName(releaseFreezeBorrowNode2Ids, nodeIdsOrder);
releaseFreezeBorrowNode2Ids = nodeIdsOrder.toString();
//释放冻结借款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeBorrowNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeBorrowNode3Ids");
String releaseFreezeBorrowNode3Names = FnaWfSet.getNodePortalsName(releaseFreezeBorrowNode3Ids, nodeIdsOrder);
releaseFreezeBorrowNode3Ids = nodeIdsOrder.toString();

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
<wea:layout type="table" attributes="{'cols':'4','groupDisplay':'none'}">
	<wea:group context="">
		<wea:item type="thead">
			<%=SystemEnv.getHtmlLabelName(19831,user.getLanguage()) %>
		</wea:item><!-- 执行动作 -->
		<wea:item type="thead">
			<%=SystemEnv.getHtmlLabelName(33100,user.getLanguage())+"<br />("+SystemEnv.getHtmlLabelName(18009,user.getLanguage())+")" %>
		</wea:item><!-- 执行节点(节点前附加操作) -->
		<wea:item type="thead">
			<%=SystemEnv.getHtmlLabelName(33100,user.getLanguage())+"<br />("+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+")" %>
		</wea:item><!-- 执行节点(节点后附加操作) -->
		<wea:item type="thead">
			<%=SystemEnv.getHtmlLabelName(33101,user.getLanguage()) %>
		</wea:item><!-- 执行出口 -->
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(83292,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冻结借款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String freezeNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="freezeBorrowNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode1Ids_completeUrl %>'  width="95%" browserValue='<%=freezeBorrowNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeBorrowNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String freezeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="freezeBorrowNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=freezeBorrowNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeBorrowNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String freezeNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="freezeBorrowNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode3Ids_completeUrl %>'  width="95%" browserValue='<%=freezeBorrowNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeBorrowNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(83296,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冲销借款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String repaymentNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentBorrowNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode1Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentBorrowNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentBorrowNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String repaymentNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentBorrowNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode2Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentBorrowNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentBorrowNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String repaymentNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentBorrowNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode3Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentBorrowNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentBorrowNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(83295,user.getLanguage()) %>
			</span>
		</wea:item><!-- 释放冻结（冲销）借款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String releaseFreezeNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeBorrowNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode1Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeBorrowNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeBorrowNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String releaseFreezeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeBorrowNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeBorrowNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeBorrowNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String releaseFreezeNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeBorrowNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode3Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeBorrowNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeBorrowNode3Names) %>' />
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
	resizeDialog(document);
});

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

//保存
function doSave(_openEditPage){
	var mainId = null2String(jQuery("#mainId").val());
	var workflowid = null2String(jQuery("#workflowid").val());
	
	var freezeBorrowNode1Ids = null2String(jQuery("#freezeBorrowNode1Ids").val());
	var freezeBorrowNode2Ids = null2String(jQuery("#freezeBorrowNode2Ids").val());
	var freezeBorrowNode3Ids = null2String(jQuery("#freezeBorrowNode3Ids").val());

	var repaymentBorrowNode1Ids = null2String(jQuery("#repaymentBorrowNode1Ids").val());
	var repaymentBorrowNode2Ids = null2String(jQuery("#repaymentBorrowNode2Ids").val());
	var repaymentBorrowNode3Ids = null2String(jQuery("#repaymentBorrowNode3Ids").val());

	var releaseFreezeBorrowNode1Ids = null2String(jQuery("#releaseFreezeBorrowNode1Ids").val());
	var releaseFreezeBorrowNode2Ids = null2String(jQuery("#releaseFreezeBorrowNode2Ids").val());
	var releaseFreezeBorrowNode3Ids = null2String(jQuery("#releaseFreezeBorrowNode3Ids").val());

	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editActionSet&mainId="+mainId+"&workflowid="+workflowid+
					"&freezeBorrowNode1Ids="+freezeBorrowNode1Ids+"&freezeBorrowNode2Ids="+freezeBorrowNode2Ids+"&freezeBorrowNode3Ids="+freezeBorrowNode3Ids+
					"&repaymentBorrowNode1Ids="+repaymentBorrowNode1Ids+"&repaymentBorrowNode2Ids="+repaymentBorrowNode2Ids+"&repaymentBorrowNode3Ids="+repaymentBorrowNode3Ids+
					"&releaseFreezeBorrowNode1Ids="+releaseFreezeBorrowNode1Ids+"&releaseFreezeBorrowNode2Ids="+releaseFreezeBorrowNode2Ids+"&releaseFreezeBorrowNode3Ids="+releaseFreezeBorrowNode3Ids;
		
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
