
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<HTML>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(26630,user.getLanguage()) %></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</HEAD>
<body scroll=no>
<%
	String tabItem=Util.null2String(request.getParameter("tabItem"),"base");
%>
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
					<li class="<%=tabItem.equals("base")?"current":""%>" onmouseover="javascript:showSecMenu();">
						<a href="" target="tabcontentframe" _datetype="base"><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage()) %></a>
					</li>
					<li class="<%=tabItem.equals("share")?"current":""%>">
						<a href="" target="tabcontentframe" _datetype="share"><%=SystemEnv.getHtmlLabelName(26945,user.getLanguage()) %></a>
					</li>
					<li class="<%=tabItem.equals("group")?"current":""%>">
						<a href="" target="tabcontentframe" _datetype="group"><%=SystemEnv.getHtmlLabelName(34105,user.getLanguage())%></a>
					</li>
					<li class="<%=tabItem.equals("group")?"current":""%>">
						<a href="" target="tabcontentframe" _datetype="template"><%=SystemEnv.getHtmlLabelName(16367,user.getLanguage()) %></a>
					</li>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
		
	<div class="tab_box">
		<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	<div>
</div>


</body>
<script>
window.notExecute = true;


$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("blog")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(26630,user.getLanguage())%>"
		});
		attachUrl();
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("base" == datetype){
			$(this).attr("href","/blog/baseSetting.jsp");
		}
		
		if("share" == datetype){
			$(this).attr("href","/blog/shareSetting.jsp");
		}
		
		if("group" == datetype){
			$(this).attr("href","/blog/group/BlogGroupSetting.jsp");
		}
		
		if("template" == datetype){
			$(this).attr("href","/blog/BlogTemplatePersonSetting.jsp");
		}
	});
	if("<%=tabItem%>"=="base")
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	else if("<%=tabItem%>"=="share")	
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(1)").attr("href"));
	else if("<%=tabItem%>"=="group")	
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(2)").attr("href"));
	else if("<%=tabItem%>"=="template")	
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(3)").attr("href"));
		
}


function controlOperation(groupid){
	if(groupid == "all" || groupid == "nogroup"){
			jQuery("span[name='all']").hide();
			jQuery("span[name='union']").show();
	}else{
		jQuery("span[name='all']").show();
		jQuery("span[name='union']").show();
	}
}



</script>
