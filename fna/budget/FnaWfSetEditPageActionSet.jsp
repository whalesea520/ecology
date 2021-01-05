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

//冻结-节点前附加操作
StringBuffer nodeIdsOrder = new StringBuffer("");
String frozeNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeNode1Ids");
String frozeNode1Names = FnaWfSet.getNodesName(frozeNode1Ids, nodeIdsOrder);
frozeNode1Ids = nodeIdsOrder.toString();
//冻结-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String frozeNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeNode2Ids");
String frozeNode2Names = FnaWfSet.getNodesName(frozeNode2Ids, nodeIdsOrder);
frozeNode2Ids = nodeIdsOrder.toString();
//冻结-出口附加操作
nodeIdsOrder = new StringBuffer("");
String frozeNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "frozeNode3Ids");
String frozeNode3Names = FnaWfSet.getNodePortalsName(frozeNode3Ids, nodeIdsOrder);
frozeNode3Ids = nodeIdsOrder.toString();

//扣除-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String deductNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductNode1Ids");
String deductNode1Names = FnaWfSet.getNodesName(deductNode1Ids, nodeIdsOrder);
deductNode1Ids = nodeIdsOrder.toString();
//扣除-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String deductNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductNode2Ids");
String deductNode2Names = FnaWfSet.getNodesName(deductNode2Ids, nodeIdsOrder);
deductNode2Ids = nodeIdsOrder.toString();
//扣除-出口附加操作
nodeIdsOrder = new StringBuffer("");
String deductNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "deductNode3Ids");
String deductNode3Names = FnaWfSet.getNodePortalsName(deductNode3Ids, nodeIdsOrder);
deductNode3Ids = nodeIdsOrder.toString();

//释放-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseNode1Ids");
String releaseNode1Names = FnaWfSet.getNodesName(releaseNode1Ids, nodeIdsOrder);
releaseNode1Ids = nodeIdsOrder.toString();
//释放-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseNode2Ids");
String releaseNode2Names = FnaWfSet.getNodesName(releaseNode2Ids, nodeIdsOrder);
releaseNode2Ids = nodeIdsOrder.toString();
//释放-出口附加操作
nodeIdsOrder = new StringBuffer("");
String releaseNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseNode3Ids");
String releaseNode3Names = FnaWfSet.getNodePortalsName(releaseNode3Ids, nodeIdsOrder);
releaseNode3Ids = nodeIdsOrder.toString();



//冻结借款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
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



//冻结预付款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String freezeAdvanceNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeAdvanceNode1Ids");
String freezeAdvanceNode1Names = FnaWfSet.getNodesName(freezeAdvanceNode1Ids, nodeIdsOrder);
freezeAdvanceNode1Ids = nodeIdsOrder.toString();
//冻结预付款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String freezeAdvanceNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeAdvanceNode2Ids");
String freezeAdvanceNode2Names = FnaWfSet.getNodesName(freezeAdvanceNode2Ids, nodeIdsOrder);
freezeAdvanceNode2Ids = nodeIdsOrder.toString();
//冻结预付款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String freezeAdvanceNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "freezeAdvanceNode3Ids");
String freezeAdvanceNode3Names = FnaWfSet.getNodePortalsName(freezeAdvanceNode3Ids, nodeIdsOrder);
freezeAdvanceNode3Ids = nodeIdsOrder.toString();


//冲销预付款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentAdvanceNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentAdvanceNode1Ids");
String repaymentAdvanceNode1Names = FnaWfSet.getNodesName(repaymentAdvanceNode1Ids, nodeIdsOrder);
repaymentAdvanceNode1Ids = nodeIdsOrder.toString();
//冲销预付款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentAdvanceNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentAdvanceNode2Ids");
String repaymentAdvanceNode2Names = FnaWfSet.getNodesName(repaymentAdvanceNode2Ids, nodeIdsOrder);
repaymentAdvanceNode2Ids = nodeIdsOrder.toString();
//冲销预付款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String repaymentAdvanceNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "repaymentAdvanceNode3Ids");
String repaymentAdvanceNode3Names = FnaWfSet.getNodePortalsName(repaymentAdvanceNode3Ids, nodeIdsOrder);
repaymentAdvanceNode3Ids = nodeIdsOrder.toString();


//释放冻结预付款-节点前附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeAdvanceNode1Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeAdvanceNode1Ids");
String releaseFreezeAdvanceNode1Names = FnaWfSet.getNodesName(releaseFreezeAdvanceNode1Ids, nodeIdsOrder);
releaseFreezeAdvanceNode1Ids = nodeIdsOrder.toString();
//释放冻结预付款-节点后附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeAdvanceNode2Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeAdvanceNode2Ids");
String releaseFreezeAdvanceNode2Names = FnaWfSet.getNodesName(releaseFreezeAdvanceNode2Ids, nodeIdsOrder);
releaseFreezeAdvanceNode2Ids = nodeIdsOrder.toString();
//释放冻结预付款-出口附加操作
nodeIdsOrder = new StringBuffer("");
String releaseFreezeAdvanceNode3Ids = FnaWfSet.getActionSet4Wf(workflowid, "releaseFreezeAdvanceNode3Ids");
String releaseFreezeAdvanceNode3Names = FnaWfSet.getNodePortalsName(releaseFreezeAdvanceNode3Ids, nodeIdsOrder);
releaseFreezeAdvanceNode3Ids = nodeIdsOrder.toString();

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
				<%=SystemEnv.getHtmlLabelName(33097,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冻结预算 -->
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
				<%=SystemEnv.getHtmlLabelName(33098,user.getLanguage()) %>
			</span>
		</wea:item><!-- 扣除预算 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String deductNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="deductNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode1Ids_completeUrl %>'  width="95%" browserValue='<%=deductNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String deductNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="deductNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode2Ids_completeUrl %>'  width="95%" browserValue='<%=deductNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String deductNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String deductNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="deductNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=deductNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=deductNode3Ids_completeUrl %>'  width="95%" browserValue='<%=deductNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(deductNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(33099,user.getLanguage()) %>
			</span>
		</wea:item><!-- 释放预算 -->
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
		
	<%if(fnaWfTypeReverse > 0){ %>
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
	<%} %>
		
	<%if(fnaWfTypeReverseAdvance == 1){ %>
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(128581,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冻结预付款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String freezeNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="freezeAdvanceNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode1Ids_completeUrl %>'  width="95%" browserValue='<%=freezeAdvanceNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeAdvanceNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String freezeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="freezeAdvanceNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=freezeAdvanceNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeAdvanceNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String freezeNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String freezeNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="freezeAdvanceNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=freezeNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=freezeNode3Ids_completeUrl %>'  width="95%" browserValue='<%=freezeAdvanceNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(freezeAdvanceNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(128582,user.getLanguage()) %>
			</span>
		</wea:item><!-- 冲销预付款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String repaymentNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentAdvanceNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode1Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentAdvanceNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentAdvanceNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String repaymentNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentAdvanceNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode2Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentAdvanceNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentAdvanceNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String repaymentNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String repaymentNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="repaymentAdvanceNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=repaymentNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=repaymentNode3Ids_completeUrl %>'  width="95%" browserValue='<%=repaymentAdvanceNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(repaymentAdvanceNode3Names) %>' />
		</wea:item>
		
		<wea:item>
			<span style="margin-left: 5px;">
				<%=SystemEnv.getHtmlLabelName(128583,user.getLanguage()) %>
			</span>
		</wea:item><!-- 释放冻结（冲销）预付款 -->
		<wea:item><!-- 执行节点(节点前附加操作) -->
			<%
			String releaseFreezeNode1Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode1Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeAdvanceNode1Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode1Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode1Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeAdvanceNode1Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeAdvanceNode1Names) %>' />
		</wea:item>
		<wea:item><!-- 执行节点(节点后附加操作) -->
			<%
			String releaseFreezeNode2Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode2Ids_completeUrl = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeAdvanceNode2Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode2Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode2Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeAdvanceNode2Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeAdvanceNode2Names) %>' />
		</wea:item>
		<wea:item><!-- 执行出口 -->
			<%
			String releaseFreezeNode3Ids_browserUrl ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodePortalBrowserMulti.jsp%3FprintNodes%3D#id#%26workflowId%3D"+workflowid;
			String releaseFreezeNode3Ids_completeUrl = "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+workflowid;
			%>
	        <brow:browser name="releaseFreezeAdvanceNode3Ids" viewType="0" hasBrowser="true" hasAdd="false" 
		        browserUrl='<%=releaseFreezeNode3Ids_browserUrl %>' isMustInput="1" isSingle="false" hasInput="true"
		        completeUrl='<%=releaseFreezeNode3Ids_completeUrl %>'  width="95%" browserValue='<%=releaseFreezeAdvanceNode3Ids %>' browserSpanValue='<%=FnaCommon.escapeHtml(releaseFreezeAdvanceNode3Names) %>' />
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

	//扣除-节点前附加操作
	var deductNode1Ids = null2String(jQuery("#deductNode1Ids").val());
	//扣除-节点后附加操作
	var deductNode2Ids = null2String(jQuery("#deductNode2Ids").val());
	//扣除-出口附加操作
	var deductNode3Ids = null2String(jQuery("#deductNode3Ids").val());

	//释放-节点前附加操作
	var releaseNode1Ids = null2String(jQuery("#releaseNode1Ids").val());
	//释放-节点后附加操作
	var releaseNode2Ids = null2String(jQuery("#releaseNode2Ids").val());
	//释放-出口附加操作
	var releaseNode3Ids = null2String(jQuery("#releaseNode3Ids").val());
	
	var freezeBorrowNode1Ids = null2String(jQuery("#freezeBorrowNode1Ids").val());
	var freezeBorrowNode2Ids = null2String(jQuery("#freezeBorrowNode2Ids").val());
	var freezeBorrowNode3Ids = null2String(jQuery("#freezeBorrowNode3Ids").val());

	var repaymentBorrowNode1Ids = null2String(jQuery("#repaymentBorrowNode1Ids").val());
	var repaymentBorrowNode2Ids = null2String(jQuery("#repaymentBorrowNode2Ids").val());
	var repaymentBorrowNode3Ids = null2String(jQuery("#repaymentBorrowNode3Ids").val());

	var releaseFreezeBorrowNode1Ids = null2String(jQuery("#releaseFreezeBorrowNode1Ids").val());
	var releaseFreezeBorrowNode2Ids = null2String(jQuery("#releaseFreezeBorrowNode2Ids").val());
	var releaseFreezeBorrowNode3Ids = null2String(jQuery("#releaseFreezeBorrowNode3Ids").val());
	
	var freezeAdvanceNode1Ids = null2String(jQuery("#freezeAdvanceNode1Ids").val());
	var freezeAdvanceNode2Ids = null2String(jQuery("#freezeAdvanceNode2Ids").val());
	var freezeAdvanceNode3Ids = null2String(jQuery("#freezeAdvanceNode3Ids").val());

	var repaymentAdvanceNode1Ids = null2String(jQuery("#repaymentAdvanceNode1Ids").val());
	var repaymentAdvanceNode2Ids = null2String(jQuery("#repaymentAdvanceNode2Ids").val());
	var repaymentAdvanceNode3Ids = null2String(jQuery("#repaymentAdvanceNode3Ids").val());

	var releaseFreezeAdvanceNode1Ids = null2String(jQuery("#releaseFreezeAdvanceNode1Ids").val());
	var releaseFreezeAdvanceNode2Ids = null2String(jQuery("#releaseFreezeAdvanceNode2Ids").val());
	var releaseFreezeAdvanceNode3Ids = null2String(jQuery("#releaseFreezeAdvanceNode3Ids").val());

	
	try{
		//确定要保存么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
			function(){
				hideRightMenuIframe();
				var _data = "operation=editActionSet&mainId="+mainId+"&workflowid="+workflowid+
					"&frozeNode1Ids="+frozeNode1Ids+"&frozeNode2Ids="+frozeNode2Ids+"&frozeNode3Ids="+frozeNode3Ids+
					"&deductNode1Ids="+deductNode1Ids+"&deductNode2Ids="+deductNode2Ids+"&deductNode3Ids="+deductNode3Ids+
					"&releaseNode1Ids="+releaseNode1Ids+"&releaseNode2Ids="+releaseNode2Ids+"&releaseNode3Ids="+releaseNode3Ids+
					
					"&freezeBorrowNode1Ids="+freezeBorrowNode1Ids+"&freezeBorrowNode2Ids="+freezeBorrowNode2Ids+"&freezeBorrowNode3Ids="+freezeBorrowNode3Ids+
					"&repaymentBorrowNode1Ids="+repaymentBorrowNode1Ids+"&repaymentBorrowNode2Ids="+repaymentBorrowNode2Ids+"&repaymentBorrowNode3Ids="+repaymentBorrowNode3Ids+
					"&releaseFreezeBorrowNode1Ids="+releaseFreezeBorrowNode1Ids+"&releaseFreezeBorrowNode2Ids="+releaseFreezeBorrowNode2Ids+"&releaseFreezeBorrowNode3Ids="+releaseFreezeBorrowNode3Ids+
					
					"&freezeAdvanceNode1Ids="+freezeAdvanceNode1Ids+"&freezeAdvanceNode2Ids="+freezeAdvanceNode2Ids+"&freezeAdvanceNode3Ids="+freezeAdvanceNode3Ids+
					"&repaymentAdvanceNode1Ids="+repaymentAdvanceNode1Ids+"&repaymentAdvanceNode2Ids="+repaymentAdvanceNode2Ids+"&repaymentAdvanceNode3Ids="+repaymentAdvanceNode3Ids+
					"&releaseFreezeAdvanceNode1Ids="+releaseFreezeAdvanceNode1Ids+"&releaseFreezeAdvanceNode2Ids="+releaseFreezeAdvanceNode2Ids+"&releaseFreezeAdvanceNode3Ids="+releaseFreezeAdvanceNode3Ids;
		
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
