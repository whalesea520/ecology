
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.cowork.CoworkLabelVO"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"),"2");
String width="100%";
if(layout.equals("1")) width="478px";
String tabtype=Util.null2String(request.getParameter("tabtype"),"add");
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="<%=tabtype.equals("add")?"current":""%>" >
							<a href="" target="tabcontentframe" _datetype="add"><%=SystemEnv.getHtmlLabelName(2086,user.getLanguage())+SystemEnv.getHtmlLabelName(82,user.getLanguage()) %></a>
						</li>
						<li class="<%=tabtype.equals("import")?"current":""%>">
							<a href="" target="tabcontentframe" _datetype="import"><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage()) %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
		<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<div>
		</div>
		</div>
	</div>	
	
</body>
<script>

$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("customer")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(15006,user.getLanguage())%>"
	});
	attachUrl();
});

//隐藏导航栏
function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
	
		if("add" == datetype){
			$(this).attr("href","/CRM/data/AddCustomerExist.jsp?"+new Date().getTime());
		}
		
		if("import" == datetype){
			$(this).attr("href","/CRM/CrmExcelToDB.jsp?"+new Date().getTime());
		}
		
	});
	if("<%=tabtype%>"=="add")
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	else
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(1)").attr("href"));	
}
</script>
</html>

