<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="workType" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	String navName = SystemEnv.getHtmlLabelName(81829,user.getLanguage());
	String isFromMode = Util.null2String(request.getParameter("isFromMode"),"0");
	String noneedtree = Util.null2String(request.getParameter("noneedtree"),"0");
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%=MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 


jQuery(document).ready(function(){ setTabObjName("<%=navName%>"); });

	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function winclose(){
		dialog.close();
	}
</script>
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
				    	<a href="/workflow/field/browsermanagetype.jsp?isFromMode=<%=isFromMode %>&noneedtree=<%=noneedtree %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16490,user.getLanguage())%></a>
				    </li>
					<li>
					    <a href="/workflow/field/browsertypeedit.jsp" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(81830,user.getLanguage())%></a>
					</li>    
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="/workflow/field/browsermanagetype.jsp?isFromMode=<%=isFromMode %>&noneedtree=<%=noneedtree %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
    function searchTable(){
	  window.frames["tabcontentframe"].searchTable();
	}
</script>
</html>
