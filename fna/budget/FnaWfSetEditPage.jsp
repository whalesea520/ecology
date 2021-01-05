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

RecordSet rs = new RecordSet();

int workflowid = 0;
boolean enable = false;
int fnaWfTypeColl = 0;
int fnaWfTypeReverse = 0;
int fnaWfTypeReverseAdvance = 0;

String sql = "select * from fnaFeeWfInfo where id = "+id;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
	fnaWfTypeColl = rs.getInt("fnaWfTypeColl");
	fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
	fnaWfTypeReverseAdvance = rs.getInt("fnaWfTypeReverseAdvance");
}

boolean haveApplicationBudget = false;//是否有预算申请流程
sql = "select FIELDID from fnaFeeWfInfoField where ISDTL = 0 and FIELDTYPE = 2 and DTLNUMBER = 0 and MAINID = "+id;
rs.executeSql(sql);
if(rs.next() && rs.getInt("FIELDID") > 0){
	haveApplicationBudget = true;
}


String tabId1Class = "";
String tabId2Class = "";
String tabId3Class = "";
String tabId4Class = "";
String tabId5Class = "";
String tabId6Class = "";
String tabId7Class = "";
String tabId8Class = "";

String FnaWfSetEditPageBaseInfoUrl = "/fna/budget/FnaWfSetEditPageBaseInfo.jsp?id="+id;
String FnaWfSetEditPageFieldSetUrl = "/fna/budget/FnaWfSetEditPageFieldSet.jsp?id="+id;
String FnaWfSetEditPageActionSetUrl = "/fna/budget/FnaWfSetEditPageActionSet.jsp?id="+id;
String FnaWfSetEditPageLogicSetApplicationUrl = "/fna/budget/FnaWfSetEditPageLogicSetApplication.jsp?id="+id;
String FnaWfSetEditPageLogicSetUrl = "/fna/budget/FnaWfSetEditPageLogicSet.jsp?id="+id;
String FnaWfSetEditPageLogicSetReverseUrl = "/fna/budget/FnaWfSetEditPageLogicSetReverse.jsp?id="+id;
String FnaWfSetEditPageLogicSetAdvanceReverseUrl = "/fna/budget/FnaWfSetEditPageLogicSetAdvanceReverse.jsp?id="+id;
String FnaWfSetEditPageCtrlUrl = "/fna/budget/FnaWfSetEditPageCtrl.jsp?id="+id;

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
	ysxxUrl = FnaWfSetEditPageLogicSetApplicationUrl;
	tabId4Class = "current";
}else if(tabId == 5){
	ysxxUrl = FnaWfSetEditPageLogicSetUrl;
	tabId5Class = "current";
}else if(tabId == 6){
	ysxxUrl = FnaWfSetEditPageLogicSetReverseUrl;
	tabId6Class = "current";
}else if(tabId == 7){
	ysxxUrl = FnaWfSetEditPageLogicSetAdvanceReverseUrl;
	tabId7Class = "current";
}else if(tabId == 8){
	ysxxUrl = FnaWfSetEditPageCtrlUrl;
	tabId8Class = "current";
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
				        <%if(haveApplicationBudget){ %>
			    		<li class="<%=tabId4Class %>">
				        	<a id="tabId4" href="<%=FnaWfSetEditPageLogicSetApplicationUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(84634,user.getLanguage())%><!-- 预申请预算校验 --> 
				        	</a>
				        </li>
				        <%} %>
			    		<li class="<%=tabId5Class %>">
				        	<a id="tabId5" href="<%=FnaWfSetEditPageLogicSetUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(83363,user.getLanguage())%><!-- 预算校验 --> 
				        	</a>
				        </li>
				        <%if(fnaWfTypeReverse > 0){ %>
			    		<li class="<%=tabId6Class %>">
				        	<a id="tabId6" href="<%=FnaWfSetEditPageLogicSetReverseUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(83364,user.getLanguage())%><!-- 冲销校验 --> 
				        	</a>
				        </li>
				        <%} %>
				        <%if(fnaWfTypeReverseAdvance == 1){ %>
			    		<li class="<%=tabId7Class %>">
				        	<a id="tabId7" href="<%=FnaWfSetEditPageLogicSetAdvanceReverseUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(128569,user.getLanguage())%><!-- 预付款冲销校验 --> 
				        	</a>
				        </li>
				        <%} %>
				        <li class="<%=tabId8Class %>">
				        	<a id="tabId8" href="<%=FnaWfSetEditPageCtrlUrl %>" target="tabcontentframe1">
				        		<%=SystemEnv.getHtmlLabelName(125921,user.getLanguage())%><!-- 控制节点 --> 
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
    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(83184, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>
</body>
</html>

