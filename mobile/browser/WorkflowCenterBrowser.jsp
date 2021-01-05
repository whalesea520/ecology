
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String formids = request.getParameter("formids");
String flag = request.getParameter("flag");
RecordSet rs = new RecordSet() ;

User user = HrmUserVarify.checkUser (request , response) ;
if(user == null){

	int logintype = 0;
	rs.execute("select * from mobileconfig where mc_type = 7");
	if(rs.next()) {
		logintype = Util.getIntValue(rs.getString("mc_value"),0);
	}
	
	MobileService ms = new MobileServiceImpl();
	if(ms.checkUserLogin(username, password, logintype)==1) {
		user = new User() ;
		rs.execute("SELECT id,firstname,lastname,systemlanguage,seclevel FROM HrmResourceManager WHERE loginid='"+username+"'");
		if(rs.next()){
			user.setUid(rs.getInt("id"));
			user.setLoginid(username);
			user.setFirstname(rs.getString("firstname"));
			user.setLastname(rs.getString("lastname"));
			user.setLanguage(Util.getIntValue(rs.getString("systemlanguage"),0));
			user.setSeclevel(rs.getString("seclevel"));
			user.setLogintype("1");
			request.getSession(true).setAttribute("weaver_user@bean",user) ;
		}
	} else {
		out.println("Login Error !");
		return;
	}
}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />

<form name="frmFlwCenter"  id="frmFlwCenter" action="" method="post">
	<input type='hidden' name='typeids'  id='typeids'>
	<input type='hidden' name='flowids'  id='flowids'>
	<input type='hidden' name='nodeids'  id='nodeids'>
	<input type="hidden"  id="btnSave"  onclick='onGetChecked()'>
	<div id="tree"></div>
<form>

<script type="text/javascript" src="/js/homepage/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/homepage/extjs/ext-all_wev8.js"></script>
<!-- Files needed for SwfUploaderPanel -->

<%
String scope = Util.null2String(request.getParameter("scope"));
String initvalue = Util.null2String(request.getParameter("initvalue"));
%>

<SCRIPT LANGUAGE="JavaScript">
	 var Tree_Category;
	 Ext.onReady(function() {	
		 

			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
		   // Define Tree.
			var Tree_Category_Loader = new Ext.tree.TreeLoader({
				baseParams:{scope:'<%=scope%>',initvalue:'<%=initvalue%>',formids:'<%=formids%>'},
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
				if(!node.isExpanded()&&!node.isLeaf()){	
					node.expand();
					Tree_Category.fireEvent('sleep', node); 
				} else {
				node.eachChild(function(child) { 
				   child.attributes.checked = checked;  
				   child.fireEvent('checkchange', child, checked); 
				   child.ui.toggleCheck(checked);  
				});			

				 node.attributes.checked = checked; 
				 node.ui.toggleCheck(checked);
/*
				 if(checked){
					 try{
						 node.parentNode.attributes.checked = checked; 
						 node.parentNode.ui.toggleCheck(checked);

						 node.parentNode.parentNode.attributes.checked = checked; 
						 node.parentNode.parentNode.ui.toggleCheck(checked);
					 } catch(e){}
				 } else {
					  try{
						 //查看一下其兄弟节点是不是都为空
						 var isAllUncheck=true;
						 node.parentNode.eachChild(function(child) { 
							 if(child.attributes.checked) {
								 isAllUncheck=false;
							 }
						 });	

						 if(isAllUncheck){
							 node.parentNode.attributes.checked = checked; 
							 node.parentNode.ui.toggleCheck(checked);
						 }

						  //查看一下其所有的上级节点是不是都为空

						 isAllUncheck=true;
						 node.parentNode.parentNode.eachChild(function(child) { 
							 if(child.attributes.checked) {
								 isAllUncheck=false;							
							 }
						 });	

						  if(isAllUncheck){
							 node.parentNode.parentNode.attributes.checked = checked; 
							 node.parentNode.parentNode.ui.toggleCheck(checked);
						  }
					 } catch(e){}
				 }
					 */
				}
		    });
			Tree_Category.render();			
			Tree_Category_Root.expand();						
	});


	function onGetChecked(){
		var objs=Tree_Category.getChecked("id");
		var typeids="";
	    var flowids="";
        var nodeids="";
		
		for(var i=0;i<objs.length;i++){
			var obj=objs[i];
			var pos=obj.indexOf("_");			
			if(pos!=-1){
				var type=obj.substring(0,pos);
				var content=obj.substring(pos+1);
				if(type=="wftype"){
					typeids+=content+",";
				} else if(type=="wf"){
					flowids+=content+",";
				} else if(type=="node"){
					nodeids+=content+",";
				}				
			}
		}		
		if(typeids!=="") typeids=typeids.substring(0,typeids.length-1);
		if(flowids!=="") flowids=flowids.substring(0,flowids.length-1);
		if(nodeids!=="") nodeids=nodeids.substring(0,nodeids.length-1);
		
		document.getElementById("typeids").value=typeids;
		document.getElementById("flowids").value=flowids;
		document.getElementById("nodeids").value=nodeids;
	}
</script>

	

