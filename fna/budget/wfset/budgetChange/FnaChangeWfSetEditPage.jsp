<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<!-- 自定义设置tab页 -->
<%
int id = Util.getIntValue(request.getParameter("id"));
int tabId = Util.getIntValue(request.getParameter("tabId"), 1);

String tabId1Class = "";
String tabId2Class = "";
String tabId3Class = "";
String tabId4Class = "";

String FnaWfSetEditPageBaseInfoUrl = "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditPageBaseInfo.jsp?id="+id;
String FnaWfSetEditPageFieldSetUrl = "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditPageFieldSet.jsp?id="+id;
String FnaWfSetEditPageActionSetUrl = "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditPageActionSet.jsp?id="+id;
String FnaWfSetEditPageLogicSetUrl = "/fna/budget/wfset/budgetChange/FnaChangeWfSetEditPageLogicSet.jsp?id="+id;

String ysxxUrl = "";
if(tabId == 1){
	ysxxUrl = FnaWfSetEditPageBaseInfoUrl;
	tabId1Class = "current";
}else if(tabId == 2){
	ysxxUrl = FnaWfSetEditPageFieldSetUrl;
	tabId2Class = "current";
}else if(tabId == 3){
	ysxxUrl = FnaWfSetEditPageActionSetUrl;
	tabId3Class = "current";
}else if(tabId == 4){
	ysxxUrl = FnaWfSetEditPageLogicSetUrl;
	tabId4Class = "current";
}
%>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
				    <ul class="tab_menu">
			    		<li class="<%=tabId1Class %>">
				        	<a id="tabId1" href="<%=FnaWfSetEditPageBaseInfoUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(83283,user.getLanguage())%><!-- 概览 --> 
				        	</a>
				        </li>
			    		<li class="<%=tabId2Class %>">
				        	<a id="tabId2" href="<%=FnaWfSetEditPageFieldSetUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(33084,user.getLanguage())%><!-- 字段对应 --> 
				        	</a>
				        </li>
			    		<li class="<%=tabId3Class %>">
				        	<a id="tabId3" href="<%=FnaWfSetEditPageActionSetUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(33085,user.getLanguage())%><!-- 动作设置 --> 
				        	</a>
				        </li>
			    		<li class="<%=tabId4Class %>">
				        	<a id="tabId4" href="<%=FnaWfSetEditPageLogicSetUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(83194,user.getLanguage())%><!-- 校验规则 --> 
				        	</a>
				        </li>
				    </ul>
				    <div id="rightBox" class="e8_rightBox">
				    </div>
				</div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe1" name="tabcontentframe1" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
<script type="text/javascript">

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"tabcontentframe1",
    mouldID:"<%=MouldIDConst.getID("fna") %>",
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(124864, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>
</body>
</html>

