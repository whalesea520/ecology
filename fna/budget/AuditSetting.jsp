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
boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

RecordSet rs = new RecordSet();

boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
}

String ysxxUrl = "";
String url1 = "/fna/budget/AuditSettingLeft.jsp?fnaType=1";
String url2 = "/fna/budget/AuditSettingLeft.jsp?fnaType=2";
if(fnaBudgetOAOrg && fnaBudgetCostCenter){
	ysxxUrl = url1;
}else if(fnaBudgetOAOrg){
	ysxxUrl = url1;
}else if(fnaBudgetCostCenter){
	ysxxUrl = url2;
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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(18436, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
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
				<%if(fnaBudgetOAOrg && fnaBudgetCostCenter){ %>
		    		<li class="current">
			        	<a id="divMainInfo1" href="<%=url1 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("33062",user.getLanguage()) %><!-- 组织机构 --> 
			        	</a>
			        </li>
		    		<li>
			        	<a id="divMainInfo2" href="<%=url2 %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(515,user.getLanguage()) %><!-- 成本中心 --> 
			        	</a>
			        </li>
				<%}else{ %>
					<li class="defaultTab">
						<a href="#">
							<%=TimeUtil.getCurrentTimeString() %>
						</a>
					</li>
				<%} %>
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

