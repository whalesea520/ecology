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


//扣除-节点前附加操作
StringBuffer nodeIdsOrder = new StringBuffer("");
String deductBorrowNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductBorrowNode1Ids");
String deductBorrowNode1Names = FnaWfSet.getNodesName(deductBorrowNode1Ids, nodeIdsOrder);
deductBorrowNode1Ids = nodeIdsOrder.toString();
//扣除-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String deductBorrowNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductBorrowNode2Ids");
String deductBorrowNode2Names = FnaWfSet.getNodesName(deductBorrowNode2Ids, nodeIdsOrder);
deductBorrowNode2Ids = nodeIdsOrder.toString();
//扣除-出口附加操作
nodeIdsOrder = new StringBuffer("");
String deductBorrowNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductBorrowNode3Ids");
String deductBorrowNode3Names = FnaWfSet.getNodePortalsName(deductBorrowNode3Ids, nodeIdsOrder);
deductBorrowNode3Ids = nodeIdsOrder.toString();


//释放-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String releaseBorrowNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseBorrowNode1Ids");
String releaseBorrowNode1Names = FnaWfSet.getNodesName(releaseBorrowNode1Ids, nodeIdsOrder);
releaseBorrowNode1Ids = nodeIdsOrder.toString();
//释放-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String releaseBorrowNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseBorrowNode2Ids");
String releaseBorrowNode2Names = FnaWfSet.getNodesName(releaseBorrowNode2Ids, nodeIdsOrder);
releaseBorrowNode2Ids = nodeIdsOrder.toString();
//释放-出口附加操作
nodeIdsOrder = new StringBuffer("");
String releaseBorrowNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseBorrowNode3Ids");
String releaseBorrowNode3Names = FnaWfSet.getNodePortalsName(releaseBorrowNode3Ids, nodeIdsOrder);
releaseBorrowNode3Ids = nodeIdsOrder.toString();

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
				<%=SystemEnv.getHtmlLabelName(83193,user.getLanguage()) %>
			</span>
		</wea:item><!-- 记录借款金额 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String deductNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="deductBorrowNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode1Ids_completeUrl %>'  width="95%" browserValue='<%=deductBorrowNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductBorrowNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String deductNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="deductBorrowNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode2Ids_completeUrl %>'  width="95%" browserValue='<%=deductBorrowNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductBorrowNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String deductNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="deductBorrowNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode3Ids_completeUrl %>'  width="95%" browserValue='<%=deductBorrowNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductBorrowNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(83202,user.getLanguage()) %>
			</span>
		</wea:item><!-- 释放借款金额 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String releaseNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseBorrowNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode1Ids_completeUrl %>'  width="95%" browserValue='<%=releaseBorrowNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseBorrowNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String releaseNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseBorrowNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode2Ids_completeUrl %>'  width="95%" browserValue='<%=releaseBorrowNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseBorrowNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String releaseNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="releaseBorrowNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode3Ids_completeUrl %>'  width="95%" browserValue='<%=releaseBorrowNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseBorrowNode3Names) %>' />
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
	
	var deductBorrowNode1Ids = null2String(jQuery("#deductBorrowNode1Ids").val());
	var deductBorrowNode2Ids = null2String(jQuery("#deductBorrowNode2Ids").val());
	var deductBorrowNode3Ids = null2String(jQuery("#deductBorrowNode3Ids").val());

	var releaseBorrowNode1Ids = null2String(jQuery("#releaseBorrowNode1Ids").val());
	var releaseBorrowNode2Ids = null2String(jQuery("#releaseBorrowNode2Ids").val());
	var releaseBorrowNode3Ids = null2String(jQuery("#releaseBorrowNode3Ids").val());

	
	hideRightMenuIframe();
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				var _data = "operation=editActionSet&mainId="+mainId+"&workflowid="+workflowid+
					"&deductBorrowNode1Ids="+deductBorrowNode1Ids+"&deductBorrowNode2Ids="+deductBorrowNode2Ids+"&deductBorrowNode3Ids="+deductBorrowNode3Ids+
					"&releaseBorrowNode1Ids="+releaseBorrowNode1Ids+"&releaseBorrowNode2Ids="+releaseBorrowNode2Ids+"&releaseBorrowNode3Ids="+releaseBorrowNode3Ids;
		
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
