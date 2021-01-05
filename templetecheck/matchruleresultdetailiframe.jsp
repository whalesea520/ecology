<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.templetecheck.ConfigUtil" %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	String filepath = Util.null2String(request.getParameter("filepath"));
	String tabtype = request.getParameter("tabtype");
	String ishtml = request.getParameter("ishtml");
	String type = request.getParameter("type");//检测类型  1表示是检测移动建模模板
	String pageid = request.getParameter("pageid");

	String url = "/templetecheck/matchruleresultdetail.jsp?filepath="+filepath+"&tabtype="+tabtype+"&ishtml="+ishtml+"&type="+type+"&pageid="+pageid;
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("checkfile")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"检测结果明细"
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
				<span id="objName"></span>
			</div>
			<div>
					 <ul class="tab_menu">
					 </ul>
				    <div id="rightBox" class=" e8_rightBox">
				    </div>
				    </div>
		</div>
	</div>		    
				    <div class="  tab_box">
				        <div>
				            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				        </div>
				    </div>
	</div>
	<style>
		.searchImg {
    		display: none!important;
		}
	</style>
</body>
</html>