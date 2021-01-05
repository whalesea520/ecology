
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ktm" class="weaver.general.KnowledgeTransMethod" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%

	String navName = SystemEnv.getHtmlLabelName(1207, user.getLanguage()); 
	String  typeName="";
	String workFlowName="";
	String typeid=Util.null2String(request.getParameter("wftype"));
	String workflowid=Util.null2String(request.getParameter("workflowid"));
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	if(offical.equals("1")){
		if(officalType==1){
			navName = SystemEnv.getHtmlLabelName(33769, user.getLanguage());
		}else if(officalType==2){
			navName = SystemEnv.getHtmlLabelName(33787, user.getLanguage());
		}
	}
	//查询流程名

	if(typeid!=null && typeid!=""){
	StringBuffer typeSql= new StringBuffer();
	typeSql.append("select typename from workflow_type where");
	typeSql.append(" id= ").append(typeid);
	if(requestutil.getOfsSetting().getIsuse()==1) {
		typeSql.append(" union select SysShortName as typename from  ofs_sysinfo  where sysid=").append(typeid);
	}
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
	
	if(requestutil.getOfsSetting().getIsuse()==1) {
		workflowSql.append(" union select workflowname from ofs_workflow where workflowid=").append(workflowid);		
	}
	
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
	String currtab = Util.getIntValue(Util.null2String(request.getParameter("viewcondition")),0)+"";
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
        objName:"<%=Util.toScreenForJs(navName) %>"
    });
    attachUrl();
    syloadTree();
    showloading();
    //$("#e8_tablogo,#e8TreeSwitch").bind("mouseover",syloadTree);
    //$("#e8_tablogo,#e8TreeSwitch").bind("click",showloading);
}); 

function getNumCount(){
    $.ajax({
  		type: "POST",
  		url: "/workflow/search/wfTabFrameCount.jsp",
  		data: { workflowid: "<%=workflowid%>", typeid: "<%=typeid%>",offical:"<%=offical%>",officalType:"<%=officalType%>" },
		success:function(data){
			if(!!data)
			{
				var __data = jQuery.trim(data)
				if(__data != "")
				{
					var _dataJson = JSON.parse(__data);
					$("#faNumSpn").text("("+_dataJson.flowAll+")");
					$("#fnNumSpn").text("("+_dataJson.flowNew+")");
					$("#frNumSpn").text("("+_dataJson.flowResponse+")");
					$("#foNumSpn").text("("+_dataJson.flowOut+")");
					$("#fsNumSpn").text("("+_dataJson.flowSup+")");
				}
			}
		}
	});
}

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
		var	url = "/workflow/search/WFSearchTemp.jsp?"+requestParameters;
		if($(this).attr("viewcondition")){
			url += "&viewcondition="+$(this).attr("viewcondition");
		}
		if($(this).attr("sysId")){
			url += "&sysId="+$(this).attr("sysId");
		}
		if($(this).attr("processId")){
			url += "&processId="+$(this).attr("processId");
		}
		$(this).attr("href",url);
	}).bind("click",function(){
		var params = requestParameters;
		if($(this).attr("viewcondition"))
			params += "&viewcondition="+$(this).attr("viewcondition");
		if($(this).attr("sysId")){
			params += "&sysId="+$(this).attr("sysId");
		}
		if($(this).attr("processId")){
			params += "&processId="+$(this).attr("processId");
		}
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe'][viewcondition='<%=currtab%>']").attr("href"));
	
}
//异步加载树调用方法

function syloadTree()
{
	var loadtree = $(window.parent.overFlowDiv).attr("loadtree");
	if(loadtree === "true")
		$("#e8_tablogo,#e8TreeSwitch").unbind("mouseover",syloadTree);
	else if(loadtree === "loading"){}
	else
	{
		window.parent.onloadtree();
		$(window.parent.overFlowDiv).attr("loadtree","loading");
	}
}
function showloading()
{
	var loadtree = $(window.parent.overFlowDiv).attr("loadtree");
	if(loadtree === "loading"){
		window.parent.showloading();
	}else if(loadtree === "true")
		$("#e8_tablogo,#e8TreeSwitch").unbind("click",showloading);
}


//回调刷新数量
function reloadLeftNum(){
	var workflowid = "<%=workflowid%>";
	var typeid = "<%=typeid%>";
	var optkeys = window.__optkeys;
	if(workflowid !="" || typeid !="" || (!!optkeys && optkeys != "")){
	var url = "/workflow/request/RequestViewAjaxCount.jsp?<%=request.getQueryString() %>";
	try {
		url = parent.getajaxcounturl() + "&<%=request.getQueryString() %>";
	} catch (e) {}
	
	url += "&optkeys=" + optkeys;
	
	parent.jQuery(".ulDiv").leftNumMenu(url,
			"update", 
			null, 
			{
				callback:function (menudata) {
					for(var i=0;i<menudata.length;i++){
						var menu = menudata[i];
						var attr = menu.attr;
						var __domid__ = menu.__domid__;
						if(typeid != "" && __domid__.indexOf("type") > -1 ){
							var __type_ = __domid__.split("type_")[1];
							if(typeid == __type_){
								$("#faNumSpn").text("("+attr.flowAll+")");
								$("#fnNumSpn").text("("+attr.flowNew+")");
								$("#frNumSpn").text("("+attr.flowResponse+")");
								$("#foNumSpn").text("("+attr.flowOut+")");
								$("#fsNumSpn").text("("+attr.flowSup+")");
							}
						}else if(workflowid != "" && __domid__.indexOf("wf") > -1 ){
							var __wf_ = __domid__.split("wf_")[1];
							if(workflowid == __wf_){
								$("#faNumSpn").text("("+attr.flowAll+")");
								$("#fnNumSpn").text("("+attr.flowNew+")");
								$("#frNumSpn").text("("+attr.flowResponse+")");
								$("#foNumSpn").text("("+attr.flowOut+")");
								$("#fsNumSpn").text("("+attr.flowSup+")");
							}
						}
					}
					
					if (!!optkeys && optkeys.length > 0) {
						getNumCount();
					}
				}
			}
	);
	}else{
		getNumCount();	
	}
}
</script>


</head>
<%
	
	
	
	int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
	int flowResponse=Util.getIntValue(Util.null2String(request.getParameter("flowResponse")), 0);
	int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
	int flowOut=Util.getIntValue(Util.null2String(request.getParameter("flowOut")), 0);
	int flowSup = Util.getIntValue(Util.null2String(request.getParameter("flowSup")),0);
	
%>
<body scroll="no">
	<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
	</div>
	<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:240px;position:absolute;z-index:9999;font-size:12px;">
		<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage()) %></span>
	</span>
	

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
				<a onmouseover="syloadTree();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
			</li>
			<%if(offical.equals("1")){ %>
				<li <%=(currtab.equals("0") || currtab.equals(""))?"class=current":"" %>>
					<a href="" viewcondition='0' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></a>
				</li>
				<% 
					String sql = "";
					if(officalType==1){
						sql = "select * from workflow_processdefine where status=1 and linktype in(1) order by sortorder";
					}else if(officalType==2){
						sql = "select * from workflow_processdefine where status=1 and linktype=2 order by sortorder";
					}
					RecordSet.executeSql(sql);
					int vd = 6;
					while(RecordSet.next()){
						int processId = Util.getIntValue(RecordSet.getString("id"),0);
						int sysId = Util.getIntValue(RecordSet.getString("sysid"),0);
						String label = ktm.getLabel(RecordSet.getString("shownamelabel"),""+user.getLanguage());
						if(label.equals(""))label = Util.null2String(RecordSet.getString("label"));
						vd++;
				%>
					<li>
						<a href="" viewcondition='<%=vd %>' sysId="<%=sysId %>" processId="<%=processId %>" target="tabcontentframe"><%=label %></a>
					</li>
					<%} %>
			<%}else{ %>
				<li <%=(currtab.equals("0") || currtab.equals(""))?"class=current":"" %>>
					<a href="" viewcondition='0' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %><span id="faNumSpn">(<%=flowAll%>)</span></a>
				</li>
				<li <%=currtab.equals("1")?"class=current":"" %>>
					<a href="" viewcondition='1' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(25426, user.getLanguage()) %><span id="fnNumSpn">(<%=flowNew%>)</span></a>
				</li>
				<li <%=currtab.equals("2")?"class=current":"" %>>
					<a href="" viewcondition='2' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(21950, user.getLanguage()) %><span id="frNumSpn">(<%=flowResponse%>)</span></a>
				</li>
				<li <%=currtab.equals("3")?"class=current":"" %>>
					<a href="" viewcondition='3' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(19081 , user.getLanguage()) %><span id="foNumSpn">(<%=flowOut%>)</span></a>
				</li>
				<li >
					<a href="" viewcondition='4' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33220 , user.getLanguage()) %><span id="fsNumSpn">(<%=flowSup%>)</span></a>
				</li>
			<%} %>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
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
	</div>
</body>
</html>

