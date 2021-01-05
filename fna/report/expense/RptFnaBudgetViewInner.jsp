<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
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

String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本
String guid1 = Util.null2String(request.getParameter("guid1"));
String goBackUrl = Util.null2String(request.getParameter("goBackUrl"));

RecordSet rs = new RecordSet();

if(budgetperiods <= 0){
	String fnayear = Util.getIntValue(TimeUtil.getCurrentDateString().split("-")[0])+"";
	rs.executeSql("select id from FnaYearsPeriods a where a.fnayear = '"+Util.getIntValue(fnayear)+"'");
	if(rs.next()){
		budgetperiods = rs.getInt("id");
	}
}

rs.executeSql("select id, status, revision from FnaBudgetInfo a \n" +
		" where a.status = 1 \n" +
		" and a.organizationtype = "+Util.getIntValue(organizationtype)+" \n" +
		" and a.budgetorganizationid = "+Util.getIntValue(organizationid)+" \n" +
		" and a.budgetperiods = "+budgetperiods+" ");
if(rs.next()){
	budgetinfoid = rs.getInt("id");
	status = rs.getInt("status");
	revision = rs.getInt("revision");
}

String _ysxxUrl = "/fna/report/expense/RptFnaBudgetViewInner1.jsp?organizationtype="+organizationtype+"&organizationid="+organizationid+
	"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+"&status="+status+"&revision="+revision+"&goBackUrl="+goBackUrl;
String ysxxUrl = _ysxxUrl;

String objName = SystemEnv.getHtmlLabelName(15403, user.getLanguage());//部门收支
if("3".equals(organizationtype)){
	objName = SystemEnv.getHtmlLabelName(15404, user.getLanguage());
	//ResourceComInfo rci = new ResourceComInfo();
	//objName = rci.getLastname(organizationid)+"（"+SystemEnv.getHtmlLabelName(15404, user.getLanguage())+"）";//个人收支
}else{
	//DepartmentComInfo dci = new DepartmentComInfo();
	//objName = dci.getDepartmentname(organizationid)+"（"+objName+"）";
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
        objName:<%=JSONObject.quote(objName) %>,
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
					<li class="defaultTab">
						<a href="#">
							<%=TimeUtil.getCurrentTimeString() %>
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

