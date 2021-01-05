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
boolean canview = HrmUserVarify.checkUserRight("FnaTransaction:All", user);

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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(15404, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%	
String _ysxxUrl = "/fna/report/expense/FnaExpenseResourceInner.jsp";
String ysxxUrl = _ysxxUrl;
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
					<%
					String currentYear = TimeUtil.getCurrentDateString().split("-")[0];
					RecordSet rs = new RecordSet();
					rs.executeSql("select id, fnayear from FnaYearsPeriods where status <> -1 order by fnayear desc");
					while(rs.next()){
						String fnayear = Util.null2String(rs.getString("fnayear")).trim();
						String _class = "";
						if(Util.getIntValue(currentYear) == Util.getIntValue(fnayear)){
							_class = "current";
							ysxxUrl += "?fnayear="+fnayear;
						}
					%>
					<li class="<%=_class %>">
						<a id="divMainInfo_<%=fnayear %>" 
							href="<%=_ysxxUrl+"?fnayear="+fnayear %>" target="tabcontentframe">
			        		<%=fnayear %><!-- 当前预算年度 -->
			        	</a>
					</li>
					<%
					}
					%>
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

