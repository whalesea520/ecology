
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	String navName = "";
	String agented = Util.null2String(request.getParameter("agented"));
	  navName = SystemEnv.getHtmlLabelName(125031,user.getLanguage()) ;
	   
	String menutype = Util.null2String(request.getParameter("menutype"));
	String menuid = Util.null2String(request.getParameter("menuid"));
	String agentFlag = Util.null2String(request.getParameter("agentFlag"));
	String overlapagentstrid= Util.null2String(request.getParameter("overlapagentstrid"));
	int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
	int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
	
%>

<script type="text/javascript">
$(function(){
	window.notExecute = true;
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%=MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
	});
	attachUrl();
});

function attachUrl(){

	$("a[target='tabcontentframe']").bind("click",function(){
		var url = "/workflow/request/wfAgentConditList.jsp";
		var params = "?agented=<%=agented %>&beagenterId2=<%=beagenterId%>&agenterId2=<%=agenterId%>";
		if($(this).attr("agtcd"))
			params += "&agentFlag="+$(this).attr("agtcd");
		$("[name='tabcontentframe']").attr("src",url+params);
	});
	
	
}

function changeMenu(ag)
{
	var leftframe = $("#leftframe",parent.document);
	leftframe[0].contentWindow.refreshTree(ag);
}
</script>

</head>
<body scroll="no">
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
		<div class="tab_box"><div>
		<iframe onload="update()"  id="tabcontentframe" name="tabcontentframe"  src='/workflow/request/wfAgentConditList.jsp?agentFlag=<%=Util.null2String(request.getParameter("agentFlag"))%>&menutype=<%=menutype%>&menuid=<%=menuid%>&agented=<%=agented %>&beagenterId2=<%=beagenterId%>&agenterId2=<%=agenterId%>' class="flowFrame" frameborder="0" width="100%;"></iframe>
	 
	</div>
	</div>
	</div>
</body>
</html>

