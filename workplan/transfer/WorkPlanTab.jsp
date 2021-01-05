
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("schedule")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage()) %>"
    });

});

</script>

<%
	String isHidden = Util.null2String(request.getParameter("isHidden"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String idStr=Util.null2String(request.getParameter("idStr"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));


	String url = "/workplan/transfer/WorkPlan.jsp?isdialog=1";
	url += "&fromid="+fromid+"&toid="+toid+"&type="+_type+"&idStr="+idStr+"&isAll="+isAll+"&jsonSql="+Tools.getURLEncode(Tools.getURLEncode(jsonSql))+"&isHidden="+isHidden;
	 
%>

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
<SCRIPT LANGUAGE="JavaScript">


</SCRIPT>