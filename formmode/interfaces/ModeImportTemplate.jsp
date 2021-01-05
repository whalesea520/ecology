
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/formmode/checkright4setting.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
String modeid = Util.null2String(request.getParameter("modeid"));
String formid = Util.null2String(request.getParameter("formid"));
String isHaveTemplate = Util.null2String(request.getParameter("isHaveTemplate"));
String templateTitle = "";
if("1".equals(isHaveTemplate)){//编辑模板
	templateTitle = SystemEnv.getHtmlLabelName(93, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage());
}else{//设置模板
	templateTitle = SystemEnv.getHtmlLabelName(68, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage());
}
%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<BODY>
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
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}

		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        mouldID:"<%= MouldIDConst.getID("formmode")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=templateTitle%>"
		   	});
		}); 
	</script>
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
		            <iframe src="ModeImportTemplateIframe.jsp?modeid=<%=modeid %>&formid=<%=formid %>" onload="if(typeof(update)=='function'){update()}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		        </div>
		   </div>
	</div> 
</body>
</html>
<SCRIPT language="javascript">

jQuery(document).ready(function(){
	jQuery(window).resize();
}) 

var dialog;
var parentWin;
try{
		parentWin = window.parent.getParentWindow(window);
		dialog = window.parent.getDialog(window);
		if(!dialog){
			parentWin = parent.parentWin;
			dialog = parent.dialog;
		}
}catch(e){
		
}
function onCloseAndRefresh() {
	var returnjson = {id:"", name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
			dialog.close();
		}catch(e){}
	}
}

</script>
