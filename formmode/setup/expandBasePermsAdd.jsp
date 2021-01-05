<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String modeid = StringHelper.null2String(request.getParameter("modeid"));
	String expandid = StringHelper.null2String(request.getParameter("expandid"));
	String url = "/formmode/setup/expandBasePermsAddIframe.jsp?modeid="+modeid+"&expandid="+expandid;
%>
<script type="text/javascript">
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("formmode")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(16526,user.getLanguage())%>"
	});//条件编辑
	attachUrl("linkcond");
});


function attachUrl(param){
	$("[name='tabcontentframe']").attr("src","<%=url%>");
}
function doClose(){
    var dialog = parent.parent.getDialog(parent);
    if(dialog){
    	dialog.close();
    }else{
		window.close();
		window.parent.close();
	}
}
function doReload(){
    var dialog = parent.parent.getDialog(parent);
    if(dialog){
    	 var currentWindow = dialog.currentWindow;
		 currentWindow.location.reload(); 
	     dialog.close();
		// currentWindow.location.href = currentWindow.location.href;				
    }
     
}
</script>
</HEAD>
<BODY>
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" style="margin-left: 6px; background-image: url('/js/tabs/images/nav/mnav0.png');"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
				<ul class="tab_menu">
					
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
