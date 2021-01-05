
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
 <jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
 
<script type="text/javascript">		
			jQuery(function(){
			    jQuery('.e8_box').Tabs({
			        getLine:1,
			        iframe:"tabcontentframe"
			
			    });
			    
			});
			function refreshTab() {
				jQuery('.flowMenusTd', parent.document).toggle();
				jQuery('.leftTypeSearch', parent.document).toggle();
			}
	
		</script>
<html>
<%
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int printtypes = Util.getIntValue(request.getParameter("printtypes"),0);
int typeid2 = Util.getIntValue(request.getParameter("typeid2"),0);
int workflowid2 = Util.getIntValue(request.getParameter("workflowid2"),0);
int multitype=Util.getIntValue(request.getParameter("multitype"),0);
String where=Util.null2String(request.getParameter("wheresql"));
String start=Util.null2String(request.getParameter("start"));
%>
<body scroll="no">
	<div class="e8_box demo2">
		<ul class="tab_menu">
			<li class="current">
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=0&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='0' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=1&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='1' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=2&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='2' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=3&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='3' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=4&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='4' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&searchtype=5&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>" timecondition='5' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></a>
			</li>
		</ul>
		<div id="rightBox" class="e8_rightBox"></div>
		<div class="tab_box"><div>
		
	 
	    <iframe src="/workflow/request/WorkflowLogNewShow.jsp?requestid=<%=requestid %>&printtypes=<%=printtypes %>&typeid2=<%=typeid2 %>&workflowid2=<%=workflowid2 %>&multitype=<%=multitype%>"
						onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	 
		<form class="requestParameterForm">
	     
		</form>
	</div>
</body>
</html>

