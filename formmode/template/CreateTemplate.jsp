
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String customid = Util.null2String(request.getParameter("customid"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String templateid = Util.null2String(request.getParameter("templateid"));
String sourcetype = Util.null2String(request.getParameter("sourcetype"));//1--高级搜索；2--普通查询
String tempquerystring = Util.null2String(request.getQueryString()); 
if (tempquerystring.indexOf("&flag") > -1) {
	tempquerystring = tempquerystring.substring(0,tempquerystring.indexOf("&flag"));
}

String url = "/formmode/template/CreateTemplateIframe.jsp?"+tempquerystring+"&flag=true&customid="+customid+"&sourcetype="+sourcetype+"&isdialog="+isDialog;
%>
<!DOCTYPE html><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(16388 ,user.getLanguage()) %>"  //新建模板
    });
}); 
</script>
</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName" title="<%=SystemEnv.getHtmlLabelName(16388 ,user.getLanguage()) %>"></span>
				</div>
				<div>	
			    <ul class="tab_menu">
				    <li class="current">
						<a href="<%=url %>" target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(16388 ,user.getLanguage()) %>
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
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script type="text/javascript">
function closeWinAFrsh(templateid){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh(templateid);
}
</script>
