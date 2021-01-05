
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%
	String mouldID = Util.null2String(request.getParameter("modeId"));
	String entryID = Util.null2String(request.getParameter("entryID"));
	String ajax = Util.null2String(request.getParameter("ajax"));
	String url = "/formmode/setup/fieldTriggerEntry.jsp?modeId="+mouldID+"&entryID="+entryID+"&ajax="+ajax;
	String navName = SystemEnv.getHtmlLabelNames("21848,33508",user.getLanguage());//字段联动,设置
%>
<html>
  <head>
  	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<script type="text/javascript">
		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        iframe:"tabcontentframe",
		        mouldID:"<%= MouldIDConst.getID("formmode")%>",
		        staticOnLoad:true,
		        objName:"<%=navName%>"
		    });
		}); 
	</script>
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
	    	<div id="rightBox" class="e8_rightBox"></div>
	  	  </div>
		</div>
	  </div>
	  <div class="tab_box">
        <div>
            <iframe src="<%=url%>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
	  </div>
	</div>  
  </body>
</html>
