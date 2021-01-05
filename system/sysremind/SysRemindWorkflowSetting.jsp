
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/workflow/request/CommonUtils.jsp" %>
<HTML>

<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
<script type="text/javascript"  src="/js/weaver_wev8.js"></script>

<style>
	.x-tree-lines .x-tree-elbow-end-plus{
		background:url(/images/ecology8/workflow/pointto_wev8.png) 50% 50% no-repeat!important;
	}
	
	.x-tree-lines .x-tree-elbow-end-minus{
		background:url(/images/ecology8/workflow/pointto1_wev8.png) 50% 50% no-repeat!important;
	}
	
	.x-tree-lines .x-tree-elbow-plus{
		background:url(/images/ecology8/workflow/pointto_wev8.png) 50% 50% no-repeat!important;
	}
	
	.x-tree-lines .x-tree-elbow-minus{
		background:url(/images/ecology8/workflow/pointto1_wev8.png) 50% 50% no-repeat!important;
	}
	
	.x-tree-lines .x-tree-elbow-line{
		background : none;
		width : 0px;
	}
	
	.x-tree-node-expanded .x-tree-node-icon{
		background : none;
		width : 0px;
	}
	
	.x-tree-node-collapsed .x-tree-node-icon{
		background : none;
		width : 0px;
	}
	
	.x-tree-node-leaf .x-tree-node-icon{
		background : none;
	}
	
	.x-tree-lines .x-tree-elbow{
		background : none;
	}
	
	.x-tree-lines .x-tree-elbow-end{
		background : none;
	}

</style>
<!-- Files needed for SwfUploaderPanel -->
<%
	String typeids = Util.null2String(request.getParameter("typeids"));
	String flowids = Util.null2String(request.getParameter("flowids"));
	String flowmodule = Util.null2String(request.getParameter("flowmodule"));
	String issubmit = Util.null2String(request.getParameter("issubmit"));
	if(issubmit.equals("true")){
		String strSql="select id from SysPoppupRemindInfoConfig where resourceid ="+user.getUID();
		rs.executeSql(strSql);
		while(rs.next()){
			int setid =  rs.getInt(1);
			String delsql = "delete from SysPoppupRemindInfoConfig where id = "+setid;
			rs.executeSql(delsql);
		}
		String insertSql1 = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'typeids','-1',"+flowmodule+")";
		rs.executeSql(insertSql1);
		ArrayList typeidList= Util.TokenizerString(typeids,",");
		ArrayList flowidList= Util.TokenizerString(flowids,",");
		for(int i=0;i<typeidList.size();i++){ 
			String  typeid = (String)typeidList.get(i);
			String insertSql = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'typeids','"+typeid+"',"+flowmodule+")";
			rs.executeSql(insertSql);
		}
		for(int i=0;i<flowidList.size();i++){
			String  flowid = (String)flowidList.get(i);
			String insertSql = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'flowids','"+flowid+"',"+flowmodule+")";
			rs.executeSql(insertSql);
		}
	}

	String loginid = Util.null2String(request.getParameter("loginid"));
	int module=0;
	String sqlStr = "select idsmodule from SysPoppupRemindInfoConfig  where id_type = 'flowids' and resourceid="+user.getUID();
	rs.execute(sqlStr);
	if(rs.next()){
		module = rs.getInt("idsmodule");
	}

   	int userId = user.getUID();
	String titlename = $label(28582,user.getLanguage())+":"+$label(320,user.getLanguage());
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+$label(826,user.getLanguage())+",javascript:doOk(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+$label(311,user.getLanguage())+",javascript:doCleanAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+$label(309,user.getLanguage())+",javascript:doClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script language="javascript">
	 var Tree_Category;
	 Ext.onReady(function() {	

			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
		   // Define Tree.
			var Tree_Category_Loader = new Ext.tree.TreeLoader({
				baseParams:{"loginid":'<%=loginid%>'},
				dataUrl   :"WorkflowCenterTreeData.jsp"
			});

			//lable 21409:具有创建权限的目录
			Tree_Category = new Ext.tree.TreePanel({
				//title            : '<%=SystemEnv.getHtmlLabelName(21674,user.getLanguage())%>', 				
				collapsible      : false,
				animCollapse     : false,
				border           : true,
				//id               : "tree_projectcategory",
				el               :'tree',				
				autoScroll       : true,
				animate          : false,					
				containerScroll  : true,
				height           : 400,				
				rootVisible:true,
				loader           : Tree_Category_Loader	
			});

			// SET the root node.
			//lable 1478: 目录信息
			var Tree_Category_Root = new Ext.tree.AsyncTreeNode({
				text		: '<%=SystemEnv.getHtmlLabelName(21674,user.getLanguage())%>',
				
				draggable	: false,
				id		: 'root_0'  //root  main  sub
			});			
			Tree_Category.setRootNode(Tree_Category_Root);
			Tree_Category.on('sleep', function(node) {
				if(!node.isExpanded()){
					setTimeout( function() {Tree_Category.fireEvent('sleep', node); }, 1000); 
				} else {
					Tree_Category.fireEvent('checkchange', node, node.attributes.checked); 
				}
				
			});
			Tree_Category.on('checkchange', function(node, checked) {	
				
				if(!node.isExpanded()){	
					node.expand();
					Tree_Category.fireEvent('sleep', node); 
				} else {
					Tree_Category.suspendEvents();
					node.eachChild(function(child) { 
					   child.attributes.checked = checked;  
					   //child.fireEvent('checkchange', child, checked); 
					   child.ui.toggleCheck(checked);  
					});			
						
					if(checked){
						node.parentNode.attributes.checked = checked; 
						node.parentNode.ui.toggleCheck(checked);
					}
					
					var isAllUncheck=true;
					 node.parentNode.eachChild(function(child) { 
						 if(child.attributes.checked) {
							 isAllUncheck=false;
						 }
					 });	
		
					 if(isAllUncheck){
						 node.parentNode.attributes.checked = false; 
						 node.parentNode.ui.toggleCheck(false);
					 }
					
					Tree_Category.resumeEvents();
				}
		    });
			Tree_Category.render();			
			Tree_Category_Root.expand();						
	});

	function doCleanAll(){
		var boxes = jQuery('input[type=checkbox]');
		jQuery.each(boxes, function(k, v){
			jQuery(v).removeAttr('checked');
		});
	}
	
	function doOk(btn){
		var nodes = jQuery("div[unselectable]");
		var typeArray = [];
	    var flowArray = [];
		for(var i = 0; i < nodes.length; i++){
			var id = jQuery(nodes[i]).attr('ext:tree-node-id');
			var checked = jQuery(nodes[i]).find('input[type=checkbox]').attr('checked');
			if(checked){
				var vs = id.split('_');
				if(vs[0] == "wftype"){
					typeArray.push(vs[1]);
				} else if(vs[0] == "wf"){
					flowArray.push(vs[1]);
				}
			}
		}
		jQuery.post(
			'SysRemindWorkflowSetting.jsp',
			{
				'typeids' : typeArray.join(','),
				'flowids' : flowArray.join(','),
				'flowmodule' : jQuery('#module').val(),
				'issubmit' : 'true'
			},
			function(data){
				parent.getDialog(window).close();
			}
		);
	}
	
	function doClose(){
		parent.getDialog(window).close();
	}
</script>
<head>
<body>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	  <jsp:param name="mouldID" value="workflow"/>
	  <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("23042,33234",user.getLanguage()) %>'/>
	</jsp:include>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<span title="<%=$label(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>  

	<select id="module" style="width:642px;border:0px;" >
		<option value="0" 
		<%if(module==0){ %>
		selected
		<%} %>
		><%=$label(31524,user.getLanguage())%></option>
		<option value="1"
		<%if(module==1){ %>
		selected
		<%} %>
		><%=$label(31525,user.getLanguage())%></option>
	</select>
	<div id="tree"></div>

	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="overflow:hidden;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=$label(826,user.getLanguage()) %>" id="btnOk"  class="zd_btn_cancle" onclick="doOk(this)"/>
					<input type="button" value="<%=$label(311,user.getLanguage()) %>" id="btnClean"  class="zd_btn_cancle" onclick="doCleanAll()"/>	
			    	<input type="button" value="<%=$label(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</body>
</html>
