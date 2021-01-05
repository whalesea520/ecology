
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>
	<head>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		<script type="text/javascript">
		// var fromleftmenu = "<%=fromLeftMenu%>";
			$(function(){
			    $('.e8_box').Tabs({
			        getLine:1,
			        mouldID:"<%= MouldIDConst.getID("workflow")%>",
			        iframe:"tabcontentframe",
			        staticOnLoad:true,
			        objName:"<%=navName%>"
			    });
			    // refreshTabNew(window.parent.document,false);
			   	// $("#e8_tablogo").click(function(){
			   	// 	if(fromleftmenu === "1")
			   	// 		refreshTabNew(window.parent.document,false);
			   	// });
			}); 
		</script>
	</head>
<%

	// String navName = "批量打印"; 
	// String  typeName="";
	// String workFlowName="";
	//获取左侧树的参数值
	// String typeid=Util.null2String(request.getParameter("typeid"));//流程类型id
 //    String workflowid=Util.null2String(request.getParameter("workflowid"));//类型流程id
	//查询流程类型
	// if(typeid!=null && typeid!=""){
	// StringBuffer typeSql= new StringBuffer();
	// typeSql.append("select typename from workflow_type where");
	// typeSql.append(" id= ").append(typeid);
	
	// RecordSet.execute(typeSql.toString());

	// if(RecordSet.next()){
	//   typeName=Util.null2String(RecordSet.getString("typename"));
	
	// }
	// }
	//查询类型流程
	// if(workflowid!=null && workflowid!="" ){
	// StringBuffer workflowSql= new StringBuffer();
	// workflowSql.append("select workflowname from workflow_base where");
	// workflowSql.append(" id= ").append(workflowid);
	
	// RecordSet.execute(workflowSql.toString());
	
	// if(RecordSet.next()){
	//  workFlowName=Util.null2String(RecordSet.getString("workflowname"));
	// }
	// }
	// if(workFlowName!="" ){
	// 	navName=workFlowName;
	// }else if(typeName!=""){
	// 	navName=typeName;
	// }
	
%>
<%
// int fromLeftMenu = Util.getIntValue(request.getParameter("fromleftmenu"),0);
// String frmurl = "";	
// if(fromLeftMenu == 1)
// 	frmurl = "/workflow/request/WorkflowMultiPrintPageFrame.jsp";
// else
// 	frmurl = "/workflow/request/WorkflowMultiPrintListTab.jsp?typeid="+typeid+"&workflowid="+workflowid+"&fromself=1";
%>

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
		    	<li class="e8_tree">
				<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
				</li>
		        	 <li class="current">
			        	<a href="/workflow/request/WorkflowMultiPrintListTab.jsp?typeid=<%=typeid %>&workflowid=<%=workflowid %>&fromself=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(26382,user.getLanguage())%>
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
	            <iframe src="/workflow/request/WorkflowMultiPrintPageFrame.jsp" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>