
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.system.*"%>
<jsp:useBean id="FunctionUpgradeUtil" class="com.weaver.upgrade.FunctionUpgradeUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<%
	String ruleid = Util.null2String(request.getParameter("ruleid"));
	//System.out.println(ruleid);
	
	int cid = Util.getIntValue(new License().getCId());
    int id = FunctionUpgradeUtil.getMenuId(cid,10168);
	int stats = FunctionUpgradeUtil.getMenuStatus(cid,1,10168);
	boolean showMenu=false;
	rs.executeSql("select menuid from menucontrollist where menuid="+id+" and isopen ="+stats+" and type = 'top'");
	if(rs.next()){
		showMenu=true;
	}
%>
<BODY>
<script type="text/javascript">
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("workflow")%>",
		staticOnLoad:true,
		objName:""
	});
	attachUrl();
});


function attachUrl(obj)
{
	var rulesrc= "";
	if(obj)
		rulesrc=$(obj).attr("condit");
	$("[name='tabcontentframe']").attr("src","/workflow/ruleDesign/viewRuleMapping.jsp?date=" + new Date().getTime() + "&ruleid=<%=ruleid%>&rulesrc="+rulesrc);
}
</script>
</HEAD>
<BODY>
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
					<li class="current" ><a condit="" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a></li>
					<li class="" ><a condit="1" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(33413,user.getLanguage()) %></a></li>
					<li class="" ><a condit="2" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage()) %></a></li>
					<li class="" ><a condit="4" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage()) %></a></li>
					<li class="" ><a condit="6" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(26241,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage()) %></a></li>
					<%if(showMenu){ %>
					<li class="" ><a condit="5" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(124849,user.getLanguage()) %></a></li>
					<%} %>
					<li class="" ><a condit="7,8" target="tabcontentframe" onclick="attachUrl(this)"><%=SystemEnv.getHtmlLabelName(126298,user.getLanguage()) %></a></li>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box"><div>
	<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
</div> 
</BODY>
</HTML>


