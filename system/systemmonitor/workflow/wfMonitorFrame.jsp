
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	String navName = SystemEnv.getHtmlLabelName(16758, user.getLanguage());
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	if(offical.equals("1")){
		if(officalType==1){
			navName = SystemEnv.getHtmlLabelName(33785, user.getLanguage());
		}else if(officalType==2){
			navName = SystemEnv.getHtmlLabelName(33792, user.getLanguage());
		}
	}
 	String  typeName="";
	String workFlowName="";
	String typeid=Util.null2String(request.getParameter("wftype"));
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	//查询流程名
	if(typeid!=null && typeid!=""){
	StringBuffer typeSql= new StringBuffer();
	typeSql.append("select typename from workflow_type where");
	typeSql.append(" id= ").append(typeid);
	
	RecordSet.execute(typeSql.toString());

	if(RecordSet.next()){
	  typeName=Util.null2String(RecordSet.getString("typename"));
	
	}
	}
	//查询工作流类型
	if(workflowid!=null && workflowid!="" ){
	StringBuffer workflowSql= new StringBuffer();
	workflowSql.append("select workflowname from workflow_base where");
	workflowSql.append(" id= ").append(workflowid);
	
	RecordSet.execute(workflowSql.toString());
	
	if(RecordSet.next()){
	 workFlowName=Util.null2String(RecordSet.getString("workflowname"));
	}
	}
	if(workFlowName!="" ){
		navName=workFlowName;
	}else if(typeName!=""){
		navName=typeName;
	}
%>
<%int fromLeftMenu = Util.getIntValue(request.getParameter("fromleftmenu"),0);
String frmurl = "";	
if(fromLeftMenu == 1)
	frmurl = "/system/systemmonitor/workflow/WorkflowMonitorPageFrame.jsp?offical="+offical+"&officalType="+officalType;
else
	frmurl = "/system/systemmonitor/workflow/WorkflowMonitorList.jsp?offical="+offical+"&officalType="+officalType+"&workflowid="+workflowid+"&typeid="+typeid;
%>

<script type="text/javascript">
var fromleftmenu = "<%=fromLeftMenu%>";
window.notExecute = true;
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID(offical.equals("1")?"offical":"workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
   	//attachUrl();
   	jQuery("#e8TreeSwitch").css("display","none");
   	$("#e8_tablogo,#e8TreeSwitch").bind("click",syloadTree);
    //$("#e8_tablogo,#e8TreeSwitch").bind("click",showloading);
   	
}); 

//异步加载树调用方法

function syloadTree()
{
	window.parent.resetLeftMenuTree();
	$("#e8_tablogo,#e8TreeSwitch").unbind("click",syloadTree);
}

function resettab_menu()
{
	$(".tab_menu").css("display","block");
}

function settab0(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("0");
	jQuery("input[name=createdatefrom]",_contentDocument).val("");
	jQuery("input[name=createdateto]",_contentDocument).val("");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=0&timecondition=0&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}
function settab1(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("1");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=1&timecondition=1&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}
function settab2(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("2");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=2&timecondition=2&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}
function settab3(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("3");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=3&timecondition=3&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}
function settab4(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("4");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=4&timecondition=4&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}
function settab5(){
	var _contentDocument = getIframeDocument2();
	jQuery("#createdateselect",_contentDocument).val("5");
	jQuery("#offical",_contentDocument).val("<%=offical%>");
	jQuery("#officalType",_contentDocument).val("<%=officalType%>");
	jQuery("#weaver",_contentDocument).submit();
	//$("#tabcontentframe").attr("src","/system/systemmonitor/workflow/WorkflowMonitorList.jsp?createdateselect=5&timecondition=5&offical=<%=offical%>&officalType=<%=officalType%>&<%=request.getQueryString()%>");
}

function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
		var url = "<%=frmurl%>&"+requestParameters;
		if($(this).attr("timecondition"))
			url += "&timecondition="+$(this).attr("timecondition");
		$(this).attr("href",url);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
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
	    
		<ul class="tab_menu" style="display:none">
			<li class="e8_tree">
				<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
			</li>
			<li class="current">
				<a onclick="settab0()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></a>
			</li>
			<li >
				<a onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></a>
			</li>
			<li >
				<a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></a>
			</li>
			<li >
				<a onclick="settab3()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></a>
			</li>
			<li >
				<a onclick="settab4()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></a>
			</li>
			<li >
				<a onclick="settab5()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></a>
			</li>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe src="<%=frmurl %>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="requestParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					//System.out.println(paramenterName + ":" + value);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
				
			%>
		</form>
	</div></div>
</body>
</html>

