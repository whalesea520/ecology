<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	int nodesmark = 0;
	int wfid=0;
	String rightTitle= "";
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String action=Util.null2String(request.getParameter("action"));
	int design = Util.getIntValue(request.getParameter("design"),0);
	int currentnodeid=0;
	currentnodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	String total="";
	total=Util.null2String(request.getParameter("total"));
	if(action.equals("dialog")){
		rightTitle = SystemEnv.getHtmlLabelName(81579,user.getLanguage());
	}else{
		rightTitle = SystemEnv.getHtmlLabelName(33485,user.getLanguage());
	}
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<HEAD>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:0,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=rightTitle%>"
    });
});

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	dialog =parent.parent.getDialog(parent.window);
}catch(e){}

function onClose(){
	jQuery(document).contents().find("#tabcontentframe")[0].contentWindow.onClose();
}
function onSure(){
	jQuery(document).contents().find("#tabcontentframe")[0].contentWindow.onSure();
}
function onClear(){
	jQuery(document).contents().find("#tabcontentframe")[0].contentWindow.onClear();
}

</script>
<%
	String url = "/workflow/workflow/wfNodeBrownserTab.jsp?wfid="+wfid+"&nodeid="+currentnodeid+"&design="+design+"&action="+action;
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
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
			<%if(action.equals("dialog")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onSure();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			<%}else{%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
	    	<%}%>
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
</body>
</html>
