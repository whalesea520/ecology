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

//冻结-节点前附加操作
StringBuffer nodeIdsOrder = new StringBuffer("");
String frozeNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeShareNode1Ids");
String frozeNode1Names = FnaWfSet.getNodesName(frozeNode1Ids, nodeIdsOrder);
frozeNode1Ids = nodeIdsOrder.toString();
//冻结-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String frozeNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeShareNode2Ids");
String frozeNode2Names = FnaWfSet.getNodesName(frozeNode2Ids, nodeIdsOrder);
frozeNode2Ids = nodeIdsOrder.toString();
//冻结-出口附加操作
nodeIdsOrder = new StringBuffer("");
String frozeNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeShareNode3Ids");
String frozeNode3Names = FnaWfSet.getNodePortalsName(frozeNode3Ids, nodeIdsOrder);
frozeNode3Ids = nodeIdsOrder.toString();

//生效-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String effectNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "effectShareNode1Ids");
String effectNode1Names = FnaWfSet.getNodesName(effectNode1Ids, nodeIdsOrder);
effectNode1Ids = nodeIdsOrder.toString();
//生效-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String effectNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "effectShareNode2Ids");
String effectNode2Names = FnaWfSet.getNodesName(effectNode2Ids, nodeIdsOrder);
effectNode2Ids = nodeIdsOrder.toString();
//生效-出口附加操作
nodeIdsOrder = new StringBuffer("");
String effectNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "effectShareNode3Ids");
String effectNode3Names = FnaWfSet.getNodePortalsName(effectNode3Ids, nodeIdsOrder);
effectNode3Ids = nodeIdsOrder.toString();

//释放-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseShareNode1Ids");
String releaseNode1Names = FnaWfSet.getNodesName(releaseNode1Ids, nodeIdsOrder);
releaseNode1Ids = nodeIdsOrder.toString();
//释放-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseShareNode2Ids");
String releaseNode2Names = FnaWfSet.getNodesName(releaseNode2Ids, nodeIdsOrder);
releaseNode2Ids = nodeIdsOrder.toString();
//释放-出口附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseShareNode3Ids");
String releaseNode3Names = FnaWfSet.getNodePortalsName(releaseNode3Ids, nodeIdsOrder);
releaseNode3Ids = nodeIdsOrder.toString();

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
				<%=SystemEnv.getHtmlLabelName(124977,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冻结分摊费用 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String frozeNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String frozeNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="frozeNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=frozeNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=frozeNode1Ids_completeUrl %>'  width="95%" browserValue='<%=frozeNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(frozeNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String frozeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String frozeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="frozeNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=frozeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=frozeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=frozeNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(frozeNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String frozeNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String frozeNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="frozeNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=frozeNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=frozeNode3Ids_completeUrl %>'  width="95%" browserValue='<%=frozeNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(frozeNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(124978,user.getLanguage()) %>
			</span>
		</wea:item><!-- 生效分摊费用 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String effectNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String effectNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="effectNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=effectNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=effectNode1Ids_completeUrl %>'  width="95%" browserValue='<%=effectNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(effectNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String effectNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String effectNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="effectNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=effectNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=effectNode2Ids_completeUrl %>'  width="95%" browserValue='<%=effectNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(effectNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String effectNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String effectNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="effectNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=effectNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=effectNode3Ids_completeUrl %>'  width="95%" browserValue='<%=effectNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(effectNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(124979,user.getLanguage()) %>
			</span>
		</wea:item><!-- 釋放凍結的分攤費用 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String releaseNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode1Ids_completeUrl %>'  width="95%" browserValue='<%=releaseNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String releaseNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode2Ids_completeUrl %>'  width="95%" browserValue='<%=releaseNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String releaseNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="releaseNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseNode3Ids_completeUrl %>'  width="95%" browserValue='<%=releaseNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseNode3Names) %>' />
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
	
	//冻结-节点前附加操作
	var frozeNode1Ids = null2String(jQuery("#frozeNode1Ids").val());
	//冻结-节点后附加操作
	var frozeNode2Ids = null2String(jQuery("#frozeNode2Ids").val());
	//冻结-出口附加操作
	var frozeNode3Ids = null2String(jQuery("#frozeNode3Ids").val());

	//生效-节点前附加操作
	var effectNode1Ids = null2String(jQuery("#effectNode1Ids").val());
	//生效-节点后附加操作
	var effectNode2Ids = null2String(jQuery("#effectNode2Ids").val());
	//生效-出口附加操作
	var effectNode3Ids = null2String(jQuery("#effectNode3Ids").val());

	//释放-节点前附加操作
	var releaseNode1Ids = null2String(jQuery("#releaseNode1Ids").val());
	//释放-节点后附加操作
	var releaseNode2Ids = null2String(jQuery("#releaseNode2Ids").val());
	//释放-出口附加操作
	var releaseNode3Ids = null2String(jQuery("#releaseNode3Ids").val());
	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editActionSet&mainId="+mainId+"&workflowid="+workflowid+
					"&frozeNode1Ids="+frozeNode1Ids+"&frozeNode2Ids="+frozeNode2Ids+"&frozeNode3Ids="+frozeNode3Ids+
					"&effectNode1Ids="+effectNode1Ids+"&effectNode2Ids="+effectNode2Ids+"&effectNode3Ids="+effectNode3Ids+
					"&releaseNode1Ids="+releaseNode1Ids+"&releaseNode2Ids="+releaseNode2Ids+"&releaseNode3Ids="+releaseNode3Ids;
		
				openNewDiv_FnaBudgetViewInner1(_Label33574);
				jQuery.ajax({
					url : "/fna/budget/wfset/budgetShare/FnaShareWfSetEditOp.jsp",
					type : "post",
					cache : false,
					processData : false,
					data : _data,
					dataType : "json",
					success: function do4Success(_json){
					    try{
							try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
							if(_json.flag){
								var parentWin = parent.parent.getParentWindow(parent.window);
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
