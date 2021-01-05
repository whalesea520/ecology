
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
	String navName = SystemEnv.getHtmlLabelName(23039,user.getLanguage());
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
%>
<html>
<head>	
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
　<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
　<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog =parent.getDialog(window);
}catch(e){}
   
function cancleclose(){
	var dialog1 =parent.parent.getDialog(parent.window);
	dialog1.close();
}
   
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%=MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName %>"
   	});
   	setTab('1');
});

function setTab(index){
	var url="";
	if(index==='1'){
		url="/workflow/workflow/WorkflowModeBrowser.jsp?formid=<%=formid %>&isbill=<%=isbill %>&isprint=1";
	}else if(index==='2'){
		url="/workflow/workflow/WorkflowHtmlBrowser.jsp?formid=<%=formid %>&isbill=<%=isbill %>&layouttype=1&dialog=1";	
	}
	$("#tabcontentframe").attr("src",url+"&isframe=y");
}
</script>
</head>
<body>
	<div class="e8_box">
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
			        		<a onclick="setTab('1')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18017, user.getLanguage())%></a>
			       		</li>
			  			<li>
				        	<a onclick="setTab('2')" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(23682, user.getLanguage())%></a>
				        </li>	        		        
					</ul>
				    <div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div> 
		<div class="tab_box">
	        <div>
	            <iframe id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
		</div>
	</div> 		
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="cancleclose()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</body>
</html>