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
boolean canview = HrmUserVarify.checkUserRight("costSummary:qry",user) ;

if(!canview) {
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
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(82617, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%	
String type = Util.null2String(request.getParameter("type")).trim();
if("".equals(type)){
	type = "qry";
}

String _classQry = "current";
String _classHistory = "";
String _ysxxUrlQry = "/fna/report/costSummary/costSummaryInner.jsp";
String _ysxxUrlHistory = "/fna/report/common/fanRptHistory.jsp?rptTypeName=costSummary";
String ysxxUrl = _ysxxUrlQry;
if("history".equals(type)){
	ysxxUrl = _ysxxUrlHistory;
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
					<li id="tabTop1" class="<%=_classQry %>">
						<a id="divMainInfo_qry" 
							href="<%=_ysxxUrlQry %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(24616, user.getLanguage()) %><!-- 查询报表 -->
			        	</a>
					</li>
					<li id="tabTop2" class="<%=_classHistory %>">
						<a id="divMainInfo_history" 
							href="<%=_ysxxUrlHistory %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(82503, user.getLanguage()) %><!-- 历史查询结果 -->
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
	            <iframe src="<%=ysxxUrl %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

