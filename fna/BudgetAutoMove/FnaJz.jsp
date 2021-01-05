<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<%
//new LabelComInfo().removeLabelCache();
if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

//是否结转设置
boolean ifbudgetmove = false;

rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	ifbudgetmove = 1==rs.getInt("ifbudgetmove");
}
%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%><HTML><HEAD>
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
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelNames("126693",user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%	
String urlFnaJzSetInner = "/fna/BudgetAutoMove/FnaJzSetInner.jsp";
String urlFnaJzInner = "/fna/BudgetAutoMove/FnaJzInner.jsp";
String urlDef = urlFnaJzSetInner;
%>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
		    		<li class="current">
			        	<a id="divMainInfo1" href="<%=urlFnaJzSetInner %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("126694",user.getLanguage()) %><!-- 结转设置 --> 
			        	</a>
			        </li>
					<%if(ifbudgetmove){ %>
		    		<li>
			        	<a id="divMainInfo2" href="<%=urlFnaJzInner %>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(126663,user.getLanguage()) %><!-- 手动结转 --> 
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
	            <iframe src="<%=urlDef %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

