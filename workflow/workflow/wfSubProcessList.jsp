<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
<% 
String navName = SystemEnv.getHtmlLabelName(19350,user.getLanguage());
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String triwfid = Util.null2String(request.getParameter("subwfscope"));
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:0,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
});

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(window);
	dialog =parent.getDialog(window);
}catch(e){}

function onClose(){
	dialog.close();
}
</script>
<%
	String url = "/workflow/workflow/wfSubProcessListTab.jsp?wfid="+wfid+"&nodeid="+nodeid+"&subwfscope="+triwfid;
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
		        	 <li class="current">

			        </li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	    <wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</body>
</html>