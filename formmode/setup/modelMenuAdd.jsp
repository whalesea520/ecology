
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
String parmes = Util.null2String(request.getParameter("parmes"));

RCMenu += "{"+SystemEnv.getHtmlLabelName(16631,user.getLanguage())+",javascript:addmenu(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>
<head>	
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
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
String navName = SystemEnv.getHtmlLabelName(23033,user.getLanguage());
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
		        mouldID:"<%= MouldIDConst.getID("portal")%>",
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
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
		</div>
	</div> 
	 <div class="tab_box">
	        <div>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<tr><td valign="top">
		<TABLE class=Shadow>
			<tr><td valign="top"><font color=red></font>
			<wea:layout type="twoCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item> 
			    <table class="LayoutTable" style="width: 100%; table-layout: fixed;">
					<tbody><tr>
						<td class="e8_tblForm_field">
							<div style="background-color:#FFF;padding-left:17%">
								<div style="height:30px"></div>
								<input type=radio name=menutype id=menutype value="1" checked/>
								<%=SystemEnv.getHtmlLabelName(33675,user.getLanguage())%><br/>
								<div style="height:30px"></div>
								<input type=radio name=menutype id=menutype value="2" />
								<%=SystemEnv.getHtmlLabelName(33676,user.getLanguage())%><br/>
								<div style="height:50px"></div>
							</div>
						</td>
	            		</tr>
	            	</tbody>
				</table> 
			</wea:item>
			</wea:group>
			</wea:layout>
			</td></tr>
		</TABLE>	
	</td></tr>
</table>			
			</div>
	    </div>
	</div> 
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0!important;">
		<div style="padding: 5px 0;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="javascript:addmenu()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
		</div>
	</div>
	
	<style type="text/css">
	.tab_box {
		bottom:30px;
	}
	</style>
</body>
</html>
<SCRIPT language="javascript">
function showHelp()
{
    var pathKey = "workflow/form/editform.jsp";
    
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";

    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");

}
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
function addmenu(){
	var parmes = escape("<%=parmes%>");
	var menutype = $("input[name='menutype']:checked").val();
	var url = "/formmode/menu/CreateMenuNew.jsp?menutype="+menutype+"&menuaddress="+parmes;
	window.open(url);
	dialog.closeByHand();
}
</script>
