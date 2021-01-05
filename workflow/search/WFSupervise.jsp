
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<% 
String  navName = Util.null2String(request.getParameter("workflowname"));
if(navName.equals("")){
	navName = SystemEnv.getHtmlLabelName(21218,user.getLanguage());
}
%>
<script type="text/javascript">
//隐藏左侧菜单树，要在TD上加上display:none;
window.notExecute=true;
var reload = "<%=Util.null2String(request.getParameter("reload"))%>";
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
    $("a[target='tabcontentframe']").bind("click",function(){
		var isdo = jQuery(this).attr("name");
		var requestParameters=$(".requestParameterForm").serialize();
		$("[name='tabcontentframe']").attr("src","/workflow/search/WFSuperviseList.jsp?isdo="+isdo+"&"+requestParameters);
	});
	$("#e8_tablogo").bind("click",syloadTree);
	attachUrl();
	if(reload != "false"){
		syloadTree();
	}
}); 

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	$("[name='tabcontentframe']").attr("src","/workflow/search/WFSuperviseList.jsp?"+requestParameters);
}

//异步加载树调用方法
function syloadTree()
{
	$("#e8_tablogo").unbind("click",syloadTree);
	window.parent.$("#leftframe")[0].contentWindow.onloadtree();
}

</script>


</head>
<body scroll="no">
	<div class="e8_box">
	 <div class="e8_boxhead">
	    <div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
		<div>
		<ul class="tab_menu">
			<li class="e8_tree">
				<a><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
			</li>
			<li class="current">
				<a name='0' target="tabcontentframe" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a>
			</li>
			<li >
				<a name='1' target="tabcontentframe" ><%=SystemEnv.getHtmlLabelName(33226,user.getLanguage()) %></a>
			</li>
			<li >
				<a name='2' target="tabcontentframe" ><%=SystemEnv.getHtmlLabelName(33227,user.getLanguage()) %></a>
			</li>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box"><div>
		<iframe onload="update()" src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="requestParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
			%>
		</form>
	</div>
	</div>
	
</body>
</html>

