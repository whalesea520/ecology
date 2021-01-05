
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.workflow.request.WFAgentTreeUtil" %>
<%
String  agentback=request.getParameter("agentback");
if(!"".equals(agentback) && "1".equals(agentback))
{
WFAgentTreeUtil  manager=new WFAgentTreeUtil();
manager.removeUserAgent(request,RecordSet);
}
String  agentInfo=Util.null2String(request.getParameter("agentInfo"));

if(agentInfo.equals(""))
{
    agentInfo="0";
}

%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/wfAgentManager_wev8.js"></script>
</head>
<body scroll="no">
	<div class="e8_box">
		<ul class="tab_menu">

			<li  <%if(agentInfo.equals("0")){%> class="current"<%}%>>
				<a name='0'  ><%=SystemEnv.getHtmlLabelName(32608, user.getLanguage())%></a>
			</li>
			<li  <%if(agentInfo.equals("1")){%> class="current"<%}%>>
				<a name='1'  ><%=SystemEnv.getHtmlLabelName(32609, user.getLanguage())%></a>
			</li>
		</ul>
		<div id="rightBox" class="e8_rightBox"></div>
		<div class="tab_box"><div>
		<iframe onload="update()" src="/workflow/request/wfAgentDetail.jsp?agentInfo=<%=agentInfo%>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="requestParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
			%>
		</form>
	</div>
</body>
</html>

