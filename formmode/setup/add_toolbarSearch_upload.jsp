
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
String formRightStr = "FormManage:All";
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
if(isFromMode==1){
	formRightStr = "FORMMODEFORM:ALL";
}

if(!HrmUserVarify.checkUserRight(formRightStr, user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
%>
<%
String formid = Util.null2String(request.getParameter("formid"));
String message = Util.null2String(request.getParameter("message"));
String isoldform = Util.null2String(request.getParameter("isoldform"));
String dialog = Util.null2String(request.getParameter("dialog"),"1");
String appid = Util.null2String(request.getParameter("appid"));
String isnew = Util.null2String(request.getParameter("isnew"));
String url = "/formmode/setup/toolbar_search_upload.jsp?src=editform&ajax=1&isFromMode="+isFromMode+"&formid="+formid+"&dialog="+dialog+"&isoldform="+isoldform;
String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
%>
<html>
<head>	
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />  
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
    <style type="text/css">
    	.tablenameCheckLoading{
    		background: url('/images/messageimages/loading_wev8.gif') no-repeat;
    		padding-left: 18px;
    	}
		.tablenameCheckSuccess{
			background: url('/images/BacoCheck_wev8.gif') no-repeat;
			padding-left: 18px;
			background-position: left 2px;
		}
		.tablenameCheckError{
			background: url('/images/BacoCross_wev8.gif') no-repeat;
			padding-left: 18px;
			color: red;
			background-position: left 2px;
		}
	</style> 
<% 
String navName = SystemEnv.getHtmlLabelName(124841, user.getLanguage()) ;
%>	
    <script type="text/javascript">

  	  	var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.getParentWindow(window);
			dialog = parent.getDialog(window);
		}catch(e){}

		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        mouldID:"<%= MouldIDConst.getID("formmode")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=navName%>"
		   	});
		}); 
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
	   			<li class="current">
	        		<a onclick="settab0()"  target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(124841, user.getLanguage())%></a>
	       		</li>	        
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
		</div>
	</div> 
	 <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="if(typeof(update)=='function'){update()}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div> 
</body>
</html>
<SCRIPT language="javascript">
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
</script>
