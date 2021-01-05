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
	
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String ishtml = Util.null2String((String)request.getParameter("ishtml"));
	String tabtype = Util.null2String((String)request.getParameter("tabtype"));
	String navName = Util.null2String((String)request.getParameter("navName"));
	
	String tmphref = "";
	if("3".equals(ishtml)) {//0--流程模板 1--KB包xml配置文件 2--web.xml 3.其他 4.检测移动引擎HTML模板  5.检测表单建模HTML模板 6.流程自定义页面查询
		tmphref = "matchrule.jsp";
	} else  if("0".equals(ishtml)) {
		tmphref = "matchruleHtml.jsp";
	}  else if("1".equals(ishtml)||"2".equals(ishtml)){
		tmphref = "matchruleConfig.jsp";
	} else if("4".equals(ishtml)) {//检测移动引擎HTML模板
		tmphref = "matchruleHtml.jsp";
	} else if("5".equals(ishtml)) {//检测表单建模HTML模板
		tmphref = "matchruleHtml.jsp";
	} else if("6".equals(ishtml)) {
		tmphref = "SearchCustomPage.jsp";
	}
	
	tmphref= tmphref+"?tabtype="+tabtype+"&ishtml="+ishtml+"&navName="+navName;
	String url = tmphref;
	
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("checkfile")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"文件检测"
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
		span .searchImg{
		display:none !important;
	}
	</style>
</body>

</html>