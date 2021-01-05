
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>



 
<%
int ownerid=Util.getIntValue(request.getParameter("ownerid"));
if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
%>

 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("2118",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->wfBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
 </HEAD>
  <BODY>
   <div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

  <div id="tree_projectcategory"></div>
    </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
 </BODY>
 </HTML>

 <SCRIPT LANGUAGE="JavaScript">
	<!--          
	  function onSubmit(obj){        
		 obj.disabled=true ;
		 frmDocSubscribeAdd.submit();
	  }

	   function onBack(){ 
		 window.history.go(-1);
	  }         
	 
	//-->
	</SCRIPT>
	<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
	<!-- Files needed for SwfUploaderPanel -->
	
   <SCRIPT LANGUAGE="JavaScript">
		 Ext.onReady(function() {	
			 

			  // Define Tree.
				var Tree_Category_Loader = new Ext.tree.TreeLoader({
					//baseParams:{requestAction: 'projectCategoryTree'},
					dataUrl   :"WfTreeData.jsp?sqlwhere=<%=sqlwhere%>"
				});
				//lable 21409:具有创建权限的目录
				var Tree_Category = new Ext.tree.TreePanel({
					title            : '<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>', 
					collapsible      : false,
					animCollapse     : false,
					border           : true,
					id               : "tree_projectcategory",
					el               : "tree_projectcategory",
					autoScroll       : true,
					animate          : true,
					enableDD         : true,
					containerScroll  : true,
					height           : 420,
					width            : 498,
					loader           : Tree_Category_Loader
				});



				  
				// SET the root node.
				//lable 1478: 目录信息
				var Tree_Category_Root = new Ext.tree.AsyncTreeNode({
					text		: '<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>',
					
					draggable	: false,
					id		: 'root_0'  //root  main  sub
				});
			 
				// Render the tree.
				Tree_Category.setRootNode(Tree_Category_Root);


				Tree_Category.on("click",function(node,event){
					var nodepara=node.id.split("_");
					var nodetype=nodepara[0];
					var nodeid=nodepara[1];

					if(nodetype=="request"){	
						btnSubmit(nodeid,node.text,node.parentNode.parentNode.text+"/"+node.parentNode.text+"/"+node.text);
						//alert(nodeid+":"+node.text+":"+node.parentNode.parentNode.text+"/"+node.parentNode.text+"/"+node.text);
					}
				});

				Tree_Category.render();
				Tree_Category_Root.expand();
		});
		
		function btnclear_onclick(){
			if(dialog){
				try{
				dialog.callback({id:"",name:""});
				}catch(e){}
				try{
				dialog.close({id:"",name:""});
				}catch(e){}
			}else{
		    	window.parent.returnValue={id:"",name:""}
		    	window.parent.close();
		    }
		}
		
		function onClose(){
			if(dialog){
				dialog.close();
			}else{
		    	window.parent.close();
		    }
		}
		
		function btnSubmit(nodeId,nodeText,nodePath){
			if(dialog){
				try{
				dialog.callback({id:nodeId,name:nodeText,nodePath:nodePath});
				}catch(e){}
				try{
				dialog.close({id:nodeId,name:nodeText,nodePath:nodePath});
				}catch(e){}
			}else{
		    	window.parent.returnValue={id:nodeId,name:nodeText,nodePath:nodePath};
		    	window.parent.close();
		    }
		}
	</script>