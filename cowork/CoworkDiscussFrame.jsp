
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%



int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"),"2");
String typeid=Util.null2String(request.getParameter("typeid"));
String mainid=Util.null2String(request.getParameter("mainid"));
String width="100%";
if(layout.equals("1")) width="478px";
%>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<style>
.frmCenterImgOpen {background:#B1D4D9 url('/wui/theme/ecology7/skins/default/general/toggler_wev8.png') no-repeat center center;height: 60px;cursor: pointer;}
.frmCenterImgClose {background:#B1D4D9 url('/wui/theme/ecology7/skins/default/general/toggler-open_wev8.png') no-repeat center center;height: 60px;cursor: pointer;}
#frmCenter{background:#B1D4D9;;cursor:e-resize;height:100%}
.layout_right2{position: absolute;left: 275px;top:0px;right:0px;width: 835px;}
.layout_left1{position: absolute;left: 0px;top:42px;width:275px;height:570px;overflow: hidden;}
.layout_left2{position: absolute;left: 0px;top:0px;width:275px;bottom:0px;overflow: hidden;}
</style>

</head>
<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
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
							<a><%=SystemEnv.getHtmlLabelName(83222,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="1"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="2"><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="3"><%=SystemEnv.getHtmlLabelName(83223,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="4"><%=SystemEnv.getHtmlLabelName(83224,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="5"><%=SystemEnv.getHtmlLabelName(83225,user.getLanguage())%></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</div>
	</div>	
</body>
<script>

var menuUrl="/cowork/CoworkApprovalList.jsp?1=1";
window.notExecute = true;  
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("collaboration")%>",
   		staticOnLoad:true,
   		objName:"<%=SystemEnv.getHtmlLabelName(32575,user.getLanguage())%>"
	});
	attachUrl();
	
	jQuery("#e8_tablogo").bind("click",function(){
   		parent.refreshTree2();
   	});
});

//隐藏导航栏
function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		$(this).attr("href","/cowork/CoworkApprovalList.jsp?from=approve&mainid=<%=mainid%>&typeid=<%=typeid%>&datetype="+datetype);
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}

  
</script>
</html>

