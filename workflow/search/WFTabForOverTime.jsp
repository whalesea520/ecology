
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ktm" class="weaver.general.KnowledgeTransMethod" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	String navName = SystemEnv.getHtmlLabelName(18910, user.getLanguage()); 
	String typeName="";
	String workFlowName="";
	String overtimetype=Util.null2String(request.getParameter("overtimetype"));
	String typeid=Util.null2String(request.getParameter("wftype"));
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	//System.out.println("overtimetype = "+overtimetype);
	//查询工作流类型
	String url="";
	if("1".equals(overtimetype)){
		url="WFSearchResult.jsp?isovertime=1&isFromMessage=1&needHeader=false&overtimetype=1&flag=overtime";
	}else{
		url="WFSearchResult.jsp?isovertime=1&isFromMessage=1&needHeader=false&overtimetype=0&flag=overtime";
	}
%>

<script type="text/javascript">
window.notExecute = true;
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        staticOnLoad:true,
        iframe:"tabcontentframe",
        objName:"<%=navName%>"
    });
	
    $.ajax({
  		type: "POST",
  		url: "/workflow/search/WFTabForOTCount.jsp",
  		data: { },
		success:function(data){
			if(!!data)
			{
				var __data = jQuery.trim(data)
				if(__data != "")
				{
					var _dataJson = JSON.parse(__data);
					$("#willovertime").text("("+_dataJson.willovertime+")");
					$("#timedout").text("("+_dataJson.timedout+")");
				}
			}
		}
	});
}); 

function settab0(){
	$("#tabcontentframe").attr("src","WFSearchResult.jsp?isovertime=1&isFromMessage=1&needHeader=false&overtimetype=0&flag=overtime");
}
function settab1(){
	$("#tabcontentframe").attr("src","WFSearchResult.jsp?isovertime=1&isFromMessage=1&needHeader=false&overtimetype=1&flag=overtime");
}

</script>

</head>
<%
	int willovertime=Util.getIntValue(Util.null2String(request.getParameter("willovertime")), 0);
	int timedout=Util.getIntValue(Util.null2String(request.getParameter("timedout")), 0);
%>
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
	    
		<ul class="tab_menu">
				<li class="current">
					<a onclick="settab0()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18911, user.getLanguage()) %><span id="willovertime">(<%=willovertime%>)</span></a>
				</li>
				<li>
					<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(129411, user.getLanguage())%><span id="timedout">(<%=timedout%>)</span></a>
				</li>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>
	</div>
	</div>
</body>
</html>

