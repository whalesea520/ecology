
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}
   String navName = SystemEnv.getHtmlLabelName(699, user.getLanguage());
%>
<%
String formid = Util.null2String(request.getParameter("formid"));
String message = Util.null2String(request.getParameter("message"));
String isoldform = Util.null2String(request.getParameter("isoldform"));
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
String dialog = Util.null2String(request.getParameter("dialog"));
String url="/workflow/form/editSysform.jsp?ajax=1&formid="+formid+"&dialog="+dialog;


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
			dialog =parent.getDialog(window);
		}catch(e){}
		
		$(function(){
         $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
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
	        		<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
	       		</li>
   				<li>
		        	<a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15449, user.getLanguage())%></a>
		        </li>		               		        
		    </ul>
	    <div id="rightBox" class="e8_rightBox"></div>
	   </div>
	  </div>
	</div>  
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div> 
	<%if("1".equals(dialog)){%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<%}%>
</body>
</html>
<SCRIPT language="javascript">
function viewSourceUrl(){
   prompt("",location);
}
function settab1(){
	$("#tabcontentframe").attr("src","/workflow/form/editSysform.jsp?ajax=1&formid=<%=formid%>");
}
function settab2(){
	$("#tabcontentframe").attr("src","/workflow/workflow/BillManagementDetail0.jsp?billId=<%=formid%>&isbill=1");
}

jQuery(document).ready(function(){
	jQuery(window).resize();
})
</script>
