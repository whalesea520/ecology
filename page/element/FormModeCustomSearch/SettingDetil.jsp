
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
String id = Util.null2String(request.getParameter("id"));//查询id
String eid = Util.null2String(request.getParameter("eid"));
String url = "";

String navName = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage());

url= "/page/element/FormModeCustomSearch/SettingDetilIframe.jsp?id="+id+"&eid="+eid;
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
		        mouldID:"",
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
				         <ul class="tab_menu"></ul>
	    		         <div id="rightBox" class="e8_rightBox"></div>
	                  </div>
	              </div>
	       </div> 
		   <div class="tab_box">
		        <div>
		            <iframe src="<%=url %>" onload="if(typeof(update)=='function'){update()}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		        </div>
		   </div>
	</div> 
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0!important;">
		<div style="padding: 5px 0;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
		</div>
	</div>
</body>
</html>
<SCRIPT language="javascript">
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
</script>
