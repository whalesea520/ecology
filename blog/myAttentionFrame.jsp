
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<html>
<head>
<%
int type = Util.getIntValue(request.getParameter("type"),0);
String blogid = Util.null2String(request.getParameter("blogid"));

%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />


</head>

<body scroll="no">
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
						<li class="e8_tree">
							<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(455,user.getLanguage()) %></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="list"></a>
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

<script type="text/javascript">
	
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("blog")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%>"
		});
		
		attachUrl();
	});
  
  	function attachUrl(){
  		var url = "";
  		if("<%=type%>" == 0){
  			url = "/blog/myAttention.jsp";
  			$("[name='tabcontentframe']").attr("src",url);
  		}else if("<%=type%>"=="1"){
	    	url="/blog/viewBlog.jsp?blogid=<%=blogid%>";
	    	window.location.href=url;
    	}else if("<%=type%>"=="2"||"<%=type%>"=="3"){
			url="/blog/orgReport.jsp?orgid=<%=blogid%>&type=<%=type%>";
			$("[name='tabcontentframe']").attr("src",url);
		}
		
		
  	}
  	

</script>
</html>

