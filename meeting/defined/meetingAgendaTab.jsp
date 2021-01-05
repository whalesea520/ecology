<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
//没有分组的自定义字段编辑
if(!HrmUserVarify.checkUserRight("Meeting:fieldDefined", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
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
         mouldID:"<%= MouldIDConst.getID("meeting")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(81894,user.getLanguage())%>"
    });
    
});


</script>

<%
	String url = "/meeting/defined/NoGroupEditFieldBatch.jsp?scopeId=2";
	
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
							<a href="/meeting/defined/NoGroupEditFieldBatch.jsp?scopeId=2" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(15449,user.getLanguage()) %>
							</a>
						</li>
						<li>
							<a href="/meeting/defined/FieldLabel.jsp?grouptype=2"  target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %>
							</a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox">
					</div>
				</div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>
	
</body>
</html>

<script type="text/javascript">

function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}

function closeDialog(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

</script>