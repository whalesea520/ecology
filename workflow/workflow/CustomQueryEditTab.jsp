
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.execute("select a.*,b.typename from workflow_custom a left join workflow_customQuerytype b on a.Querytypeid=b.id where a.id="+id);
	RecordSet.next();
	String formID = Util.null2String(RecordSet.getString("formID"));	
	String isBill = Util.null2String(RecordSet.getString("isBill"));
	int dbordercount = 0;
	String otype = Util.null2String(request.getParameter("otype"));
	
	int operatelevel = 0;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	if(detachable == 1){
		String subcompanyid= Util.null2String(RecordSet.getString("subcompanyid"));
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
	}else{
	    operatelevel = 2;
	}
	
	String initUrl = "/workflow/workflow/CustomEdit.jsp?otype="+otype+"&id=" + id+"&operatelevel="+operatelevel;
	
	
%>
<html>
	<head>	
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
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
		        objName:"<%=SystemEnv.getHtmlLabelName(20785, user.getLanguage())%>"
		   	 });
		}); 

		function viewSourceUrl(){
	   	    prompt("",location);
		}

		function openTab(tabId){
			if(tabId == 1)
				$("#tabcontentframe").attr("src","/workflow/workflow/CustomEdit.jsp?otype=<%=otype%>&id=<%=id%>&operatelevel=<%=operatelevel%>");
			else if(tabId == 2)
				$("#tabcontentframe").attr("src","/workflow/workflow/CustomFieldAdd.jsp?otype=<%=otype%>&id=<%=id%>&isBill=<%= isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>&operatelevel=<%=operatelevel%>");
		}
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
		        			<a onclick="openTab(1)" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></a>
		       			</li>
		   				<li>
				        	<a onclick="openTab(2)" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(20773, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331, user.getLanguage())%></a>
				        </li>
				    </ul>
			    	<div id="rightBox" class="e8_rightBox"></div>
	     		</div>
			</div>
		</div> 
		<div class="tab_box">
	        <div>
	            <iframe src="<%=initUrl %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;height:40px;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
</body>
</html>
