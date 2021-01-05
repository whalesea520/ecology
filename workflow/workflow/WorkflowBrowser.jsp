<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<%
int ownerid=Util.getIntValue(request.getParameter("ownerid"));
if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String showvalid=Util.null2String(request.getParameter("showvalid"));
%>

 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16579",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
 </HEAD>
  <BODY>
  <div class="zDialog_div_content">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

  <div id="tree_projectcategory"></div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=T  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
				<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
	//<!--          
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
	
   <script LANGUAGE="JavaScript">
		 Ext.onReady(function() {	
			 Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';

			  // Define Tree.
				var Tree_Category_Loader = new Ext.tree.TreeLoader({
					//baseParams:{requestAction: 'projectCategoryTree'},
					dataUrl   :"TreeData.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&showvalid=<%=showvalid%>"
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
					height           : '100%',
					width            : '100%',
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
	</script>
	
<script type="text/javascript">

function btnclear_onclick(){
	var returnjson ={id:"",name:"",path:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
		dialog.close(returnjson);
		}catch(e){}
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function btnSubmit(nodeId,nodeText,nodePath){
	var returnjson ={id:""+nodeId,name:nodeText,path:nodePath};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
		dialog.close(returnjson);
		}catch(e){}
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}
</script>
