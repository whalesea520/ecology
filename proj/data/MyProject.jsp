<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<%
String from=Util.null2String(request.getParameter("from"));
if(!"MyProject".equals(from) ){
	response.sendRedirect("/proj/data/PrjTypeTreeFrame.jsp?from=MyProject");
	return;
}
String paraid=Util.null2String(request.getParameter("paraid"));
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
}); 
window.notExecute = true;
</script>

<%
	String url = "/proj/data/MyProjectTab.jsp?paraid="+paraid;
	
	
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
		    	<li class="e8_tree">
		        	<a>&lt;&lt;结构</a>
		        </li>
		        <li class="current">
					<a target="tabcontentframe" href="<%=url %>"><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage()) %><span id="allNum_span"></span></a>
				</li>
<%
ProjectStatusComInfo.setTofirstRow();
while(ProjectStatusComInfo.next()){
	int statusid=Util.getIntValue( ProjectStatusComInfo.getProjectStatusid(),-1);
	if(statusid==0||statusid==3||statusid==4||statusid==6||statusid==7){
		continue;
	}
	String statusLabel=ProjectStatusComInfo.getProjectStatusname();
	String statusUrl=url+"&src=cusstatus&statusid="+statusid;
	String statusSpan="cusstatus_"+statusid+"_span";
	if(statusid==5){//立项批准
		statusUrl=url+"&src=todo&statusid="+statusid;
		statusSpan="todoNum_span";
	}else if(statusid==1){//正常
		statusUrl=url+"&src=doing&statusid="+statusid;
		statusSpan="doingNum_span";
	}else if(statusid==2){//延期
		statusUrl=url+"&src=overtime&statusid="+statusid;
		statusSpan="overtimeNum_span";
	}

%>	
		       	<li class="">
					<a target="tabcontentframe" href="<%=statusUrl %>"><%=SystemEnv.getHtmlLabelNames(statusLabel ,user.getLanguage()) %><span id="<%=statusSpan %>"></span></a>
				</li>
<%
	
}

%>				
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
<script type="text/javascript">	
$(function(){
	setTabObjName("<%=SystemEnv.getHtmlLabelName(16408,user.getLanguage()) %>");
});
</script>   
</BODY>
</HTML>
