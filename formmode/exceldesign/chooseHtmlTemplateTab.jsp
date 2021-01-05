<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String modeid = Util.null2String(request.getParameter("modeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String choosetype = Util.null2String(request.getParameter("choosetype"));
	String curlayoutid = Util.null2String(request.getParameter("curlayoutid"));
	String fromwhere = Util.null2String(request.getParameter("fromwhere"));
	String objName = SystemEnv.getHtmlLabelName(64,user.getLanguage());
%>
<html>
<head>
	<!--以下是显示定制组件所需的js -->
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery('.e8_box').Tabs({
			getLine : 1,
			iframe : "templateIframe",
			mouldID:"<%= MouldIDConst.getID("formmode")%>",
			staticOnLoad:true,
			objName:"<%=objName %>"
		});
		changeTemplate("<%=choosetype %>");
		<%if("0".equals(choosetype)){ %>
			jQuery("#objName").parent().css("line-height", "60px");
		<%} %>
	});
	
	function changeTemplate(layouttype){
		var url = "/formmode/exceldesign/chooseHtmlTemplate.jsp?layouttype="+layouttype+"&modeid=<%=modeid %>&search_modeid=<%=modeid %>&formid=<%=formid %>&curlayoutid=<%=curlayoutid %>&fromwhere=<%=fromwhere %>";
		jQuery("#templateIframe").attr("src", url);
	}
	
	//显示遮罩及loading效果
	function __setloaddingeffect() {
		try {
			var pTop= document.body.offsetHeight/2 - (50/2);
			var pLeft= document.body.offsetWidth/2 - (217/2);
			jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
			jQuery("#submitloaddingdiv").show();
			jQuery("#submitloaddingdiv_out").show();
		} catch (e) {}
	}
	</script>
</head>
<body>
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
					<%if("0".equals(choosetype)){ %>
					<li>
						<a onclick="changeTemplate(0);" target="templateIframe"><%=SystemEnv.getHtmlLabelName(82134,user.getLanguage()) %></a>
					</li>
					<%}else if("1".equals(choosetype)){ %>
						<li class="current">
							<a onclick="changeTemplate(1);" target="templateIframe"><%=SystemEnv.getHtmlLabelName(82135,user.getLanguage()) %></a>
						</li>
					<%}else if("2".equals(choosetype)){ %>
						<li class="current">
							<a onclick="changeTemplate(2);" target="templateIframe"><%=SystemEnv.getHtmlLabelName(82136,user.getLanguage()) %></a>
						</li>
					<%}else if("3".equals(choosetype)){ %>
						<li class="current">
							<a onclick="changeTemplate(3);" target="templateIframe"><%=SystemEnv.getHtmlLabelName(82137,user.getLanguage()) %></a>
						</li>
					<%}else if("4".equals(choosetype)){ %>
						<li class="current">
							<a onclick="changeTemplate(4);" target="templateIframe"><%=SystemEnv.getHtmlLabelName(82138,user.getLanguage()) %></a>
						</li>
					<%} %>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box"><div>
	<iframe src="" onload="update();" id="templateIframe" name="templateIframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	<div id="submitloaddingdiv_out" style="display:none;position:absolute;width:100%;height:100%;top:0px;left:0px;background:#000;z-index:999999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;"></div>
	<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
		<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;">正在处理，请稍候...</span>
		<div style="display:none;"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div>
	</span>
</div>
</body>
</html>