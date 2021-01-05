
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
 <jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
int ownerid=Util.getIntValue(request.getParameter("ownerid"));
if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
int wfid=Util.getIntValue(request.getParameter("wfid"));
 
%>

 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
 </HEAD>
  <BODY>
   
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

  <div id="tree_projectcategory"></div>
  <br>
  <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
 </BODY>
 </HTML>

	<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
	<!-- Files needed for SwfUploaderPanel -->
	
	<SCRIPT type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function btnclear_onclick(){
	     selectData('', '');
	}
	
	function btnSubmit(nodeId,nodeText,nodePath){
	     selectData(nodeId, nodeText);
	}

	function selectData(id, name) {
		var returnjson = {id: id,name: name};
		if(dialog){
			dialog.callback(returnjson);
		}else{
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
		}
	}
	
	Ext.onReady(function() {	
	Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s_wev8.gif';
	
	 // Define Tree.
	var Tree_Category_Loader = new Ext.tree.TreeLoader({
	 
		dataUrl   :"TreeData2.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>&wfid=<%=wfid%>"
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
		height           : 560,
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
	</SCRIPT>
