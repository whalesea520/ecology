<%@page import="org.json.JSONObject"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
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
if(!HrmUserVarify.checkUserRight("fnaControlScheme:set", user)){
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

String FnaWfSetEditPageBaseInfoUrl = "/fna/budget/FnaControlSchemeSetEditInner.jsp?id="+id;
String FnaWfSetEditPageLogicSetUrl = "/fna/budget/FnaControlSchemeSetLogic.jsp?id="+id;

String ysxxUrl = "";
if(tabId == 1){
	ysxxUrl = FnaWfSetEditPageBaseInfoUrl;
	tabId1Class = "current";
}else if(tabId == 2){
	ysxxUrl = FnaWfSetEditPageLogicSetUrl;
	tabId2Class = "current";
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
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%><!-- 基本信息 --> 
			        	</a>
			        </li>
		    		<li class="<%=tabId2Class %>">
			        	<a id="tabId2" href="<%=FnaWfSetEditPageLogicSetUrl %>" target="tabcontentframe1">
			        		<%=SystemEnv.getHtmlLabelName(32132,user.getLanguage())%><!-- 费控设置 --> 
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
	//dialog.close();
	dialog.closeByHand();
}
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"tabcontentframe1",
    mouldID:"<%=MouldIDConst.getID("fna") %>",
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33071,user.getLanguage())) %>,
	staticOnLoad:true
});
</script>
</body>
</html>

