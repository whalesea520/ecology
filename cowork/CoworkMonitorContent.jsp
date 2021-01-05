
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String mainid = Util.null2String(request.getParameter("mainid"));//主类型
String typeid = Util.null2String(request.getParameter("typeid"));//协作区类型

%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>


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
							<a href="" target="tabcontentframe" _commentStatus="0"><%=SystemEnv.getHtmlLabelName(21269,user.getLanguage())%></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _commentStatus="1"><%=SystemEnv.getHtmlLabelName(18967,user.getLanguage())%></a>
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
window.notExecute = true;  
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("collaboration")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(32577,user.getLanguage())%>"
	});
	attachUrl();
	
	jQuery("#e8_tablogo").bind("click",function(){
   		parent.refreshTree2();
   	});
});

function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var commentStatus=$(this).attr("_commentStatus");
		
		$(this).attr("href","/cowork/CoworkCommentList.jsp?mainid=<%=mainid%>&typeid=<%=typeid%>&from=content&commentStatus="+commentStatus);
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}

</script>
</html>

