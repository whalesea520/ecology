
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	String navName = "";
	String viewType=Util.null2String(request.getParameter("viewType"));
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	if(viewType.equals("2")){
		navName=SystemEnv.getHtmlLabelName(17991,user.getLanguage());
		if(officalType==1){
			navName = SystemEnv.getHtmlLabelName(33530, user.getLanguage());
		}else if(officalType==2){
			navName = SystemEnv.getHtmlLabelName(33789, user.getLanguage());
		}
	}else if(viewType.equals("4")){
		navName=SystemEnv.getHtmlLabelName(1210,user.getLanguage());
		if(offical.equals("1")){
			if(officalType==1){
				navName = SystemEnv.getHtmlLabelName(33529, user.getLanguage());
			}else if(officalType==2){
				navName = SystemEnv.getHtmlLabelName(33790, user.getLanguage());
			}
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
	
	String curTab = Util.getIntValue(Util.null2String(request.getParameter("viewcondition")),0)+"";
	
%>

<script type="text/javascript">
//window.notExecute = true;
$(function(){
var loadtree = $(window.parent.overFlowDiv).attr("loadtree");
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID(offical.equals("1")?"offical":"workflow")%>",
        staticOnLoad:true,
        iframe:"tabcontentframe",
        objName:"<%=navName%>"
    });
    attachUrl();
    syloadTree();
    //$("#e8_tablogo").bind("click",syloadTree);
}); 

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	
	$("a[target='tabcontentframe']").each(function(){
		var	url = "/workflow/search/WFSearchTemp.jsp?"+requestParameters;
		if($(this).attr("viewcondition")){
			url += "&viewcondition="+$(this).attr("viewcondition");
		}
		$(this).attr("href",url);
	}).bind("click",function(){
		var params = requestParameters;
		if($(this).attr("viewcondition"))
			params += "&viewcondition="+$(this).attr("viewcondition");
	});
	var curtab = "<%=curTab%>";
	if(curtab === "4" || curtab === "5")
	{
		var url = "/workflow/search/WFSearchTemp.jsp?"+requestParameters;
		$("[name='tabcontentframe']").attr("src",url+"&viewcondition="+curtab);
	}else 
	{
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe'][viewcondition='"+curtab+"']").attr("href"));
	}
}

//异步加载树调用方法
function syloadTree()
{
	var loadtree = $(window.parent.overFlowDiv).attr("loadtree");
	if(loadtree === "true")
		$("#e8_tablogo").unbind("click",syloadTree);
	else
		window.parent.onloadtree();
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
		<ul class="tab_menu">
			<li class="e8_tree">
				<a><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
			</li>
			<li <%=!curTab.equals("3")?"class=current":"" %>>
				<a href="" viewcondition='0' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="" viewcondition='1' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage()) %></a>
			</li>
			<li >
				<a href="" viewcondition='2' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage()) %></a>
			</li>
			<li <%=curTab.equals("3")?"class=current":"" %>>
				<a href="" viewcondition='3' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21950, user.getLanguage()) %></a>
			</li>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box"><div>
		<iframe src="" id="tabcontentframe" onload="update()" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="requestParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					if(!paramenterName.equals("viewcondition")){
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% }
				}
				
			%>
		</form>
	</div>
	</div>
</body>
</html>

