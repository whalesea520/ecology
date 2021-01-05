
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
   <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<%

		String navName = ""+SystemEnv.getHtmlLabelName(16393,user.getLanguage()); 
		String offical = Util.null2String(request.getParameter("offical"));
		int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
		String fromleftmenu = Util.null2String(request.getParameter("fromleftmenu"));
		String fromhp = Util.null2String(request.getParameter("fromhp"));
		String isall = Util.null2String(request.getParameter("isall"));
		if("1".equals(fromhp)){
			session.setAttribute("fromhp",fromhp);
		}
		if("1".equals(isall)){
			session.setAttribute("isall",isall);
		}
		if(offical.equals("1")){
			if(officalType==1){
				navName = SystemEnv.getHtmlLabelName(33531, user.getLanguage());
			}else if(officalType==2){
				navName = SystemEnv.getHtmlLabelName(33791, user.getLanguage());
			}
		}
		String  typeName="";
		String workFlowName="";
		String typeid=Util.null2String(request.getParameter("typeid"));//流程类型id
		String workflowid=Util.null2String(request.getParameter("workflowid"));//类型流程id
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
	
		<script type="text/javascript">
			window.notExecute = true;
			jQuery(document).ready(function(){
				$('.e8_box').Tabs({
			        getLine:1,
			        mouldID:"<%= MouldIDConst.getID(offical.equals("1")?"offical":"workflow")%>",
			        iframe:"tabcontentframe",
			        staticOnLoad:true,
			        objName:"<%=Util.toScreenForJs(navName)%>"
			    });
			    
			    //隐藏
				jQuery('#e8TreeSwitch').hide();
				jQuery("#mainDiv div.e8_tablogo").attr("title","");
				jQuery("#mainDiv div.e8_tablogo").css("cursor","").unbind("click");
				
			});

			function showTree() {
				jQuery("#mainDiv div.e8_tablogo").attr("title","<%=SystemEnv.getHtmlLabelName(84031,user.getLanguage())%>");
				jQuery("#mainDiv div.e8_tablogo").css("cursor","pointer").unbind("click").bind("click",function(e){
					refreshTabNew();
					toggleleft();
					toggleleft(parent.parent.document);
					var e8_head = jQuery('#mainDiv').find("div.e8_boxhead");
					if(e8_head.length==0){
						e8_head = jQuery('#mainDiv').find("div#rightBox");
					}
					bindCornerMenuEvent(e8_head,jQuery('#tabcontentframe').get(0).contentWindow,e,{position:true});
				});
				$("#e8_tablogo,#e8TreeSwitch").bind("mouseover",syloadTree);
				$("#e8_tablogo,#e8TreeSwitch").bind("click",showloading);
				jQuery('#e8TreeSwitch').show();
			}
			//异步加载树调用方法
			function syloadTree()
			{
				var loadtree = $(window.parent.overFlowDiv).attr("loadtree");
				if(loadtree === "true")
					$("#e8_tablogo").unbind("mouseover",syloadTree);
				else if(loadtree === "loading"){}
				else{
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
		</script>
  </head>
  <%	
		//获取左侧树的参数值
		
		String child=Util.null2String(request.getParameter("child"));//1：父节点 2：子节点
		String numberType=Util.null2String(request.getParameter("numberType"));//数据类型
		String where="typeid="+typeid+"&child="+child+"&workflowid="+workflowid+"&numberType="+numberType;
		int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
		int flowResponse=Util.getIntValue(Util.null2String(request.getParameter("flowResponse")), 0);
		int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
		int flowOut=Util.getIntValue(Util.null2String(request.getParameter("flowOut")), 0);
		if(child.equals("") && false){
			//开始进入时
			String logintype = ""+user.getLogintype();
			int usertype = 0;

			String resourceid= ""+user.getUID();
			if(resourceid.equals("")) {
				resourceid = ""+user.getUID();
				if(logintype.equals("2")) usertype= 1;
					session.removeAttribute("RequestViewResource") ;
				}
			else {
				session.setAttribute("RequestViewResource",resourceid) ;
			}
			//System.out.println(resourceid);
			String sql="select isremark,viewtype from workflow_currentoperator where userid="+resourceid+" and usertype="+ usertype+"  and exists (select 1 from workflow_requestbase c where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ";
			if(RecordSet.getDBType().equals("oracle")){
				sql+="and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+"))";
			}else{
				sql+="and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+"))";
			}
			if(offical.equals("1")){
				if(officalType==1){
					sql+=(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
				}else if(officalType==2){
					sql+=(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
				}
			}
			sql+=") ";
			//System.out.println(sql);
			RecordSet.executeSql(sql);
			String isremark="";
			String viewtype="";
			while(RecordSet.next()){
				isremark=RecordSet.getString("isremark");
				viewtype=RecordSet.getString("viewtype");
				if(isremark.equals("5")){
					flowOut++;
				}
				if(viewtype.equals("0")){
					flowNew++;
				}else if(viewtype.equals("-1")){
					flowResponse++;
				}
				flowAll++;
			}

		}

		String frmurl = "/workflow/search/WFSearchsPageFrame.jsp?offical="+offical+"&officalType="+officalType+"&fromleftmenu="+fromleftmenu+"&typeid="+typeid+"&workflowid="+workflowid;
  %>
	<body scroll="no">
	    <div id="mainDiv" class="e8_box demo2">
		    <div class="e8_boxhead">
			    <div class="div_e8_xtree" id="div_e8_xtree"></div>
		        <div class="e8_tablogo" id="e8_tablogo"></div>
				<div class="e8_ultab">
					<div class="e8_navtab" id="e8_navtab">
						<span id="objName"></span>
					</div>
					<div>
						<ul class="tab_menu" style="visibility:hidden">
							<li class="e8_tree">
								<a onclick="syloadTree();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
							</li>
							
						</ul>
						<div id="rightBox" class="e8_rightBox"></div>
			    	</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="<%=frmurl %>"
						onload="update();" id="tabcontentframe" name="tabcontentframe"
						class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>
