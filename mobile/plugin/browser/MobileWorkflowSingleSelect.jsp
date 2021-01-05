
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="MobileInit.jsp"%>
<%
String scope = Util.null2String(fu.getParameter("scope"));
String selectids = Util.null2String(fu.getParameter("selectids"));
String formids ="7,13,46,49,74,79,158,181,182,200,10,11,156,28,180,14,159,38,85,18,19,201,224,17,21,163,157,45";
String moduleid = Util.null2String(fu.getParameter("moduleid"));
String include = Util.null2String(fu.getParameter("include"));
String componentid = Util.null2String(fu.getParameter("componentid"));
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/mobile/plugin/browser/js/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.core-3.1_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/browser/js/zTree/js/jquery.ztree.excheck-3.1.min_wev8.js"></script>
	
	<SCRIPT type="text/javascript">
		<!--
		var selectNodeID = "<%=selectids%>";
		var setting = {
			view: {
				dblClickExpand: dblClickExpand
			},
			check: {
				enable: false
			},
			async: {
				enable: true,
				type:"post",
				contentType:"application/json",
				url:"/mobile/plugin/browser/BrowserOperation.jsp?operation=getWorkflowTtree&pluginCode=1&formids=<%=formids%>",
				autoParam:["level", "nodeValue"],
				otherParam:{"scope":"<%=scope%>","selectids":"<%=selectids%>"}
			},
			callback: {
				//onCheck:zTreeOnCheck,
				onClick:onClickTree,
				onAsyncSuccess:zTreeOnAsyncSuccess
			}
		};
		function onClickTree(event, treeId, treeNode){
			if(treeNode['level'] == 2){
				selectNodeID = treeNode['nodeValue'];
			}else{
				var treeObj = $.fn.zTree.getZTreeObj("tree");
				treeObj.refresh();
				if(selectNodeID !==""){
					var node = treeObj.getNodeByParam("nodeValue", selectNodeID); 
					treeObj.selectNode(node,true);
				}
			}
		}
		function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
			if(treeNode&&treeNode.level==1&&treeNode.checked!=treeNode.checkedOld) {
    			var treeObj = $.fn.zTree.getZTreeObj("tree");
    			for(var i=0; i<treeNode.children.length; i++) {
    				treeNode.children[i].checked=treeNode.checked;
    				treeObj.updateNode(treeNode.children[i]);
    			}
    		}
    		
    		if(!treeNode){
	    		var treeObj = $.fn.zTree.getZTreeObj("tree");
				var nodes = treeObj.getCheckedNodes();
				for(var i=0;i<nodes.length;i++){ 
					var obj=nodes[i];
					if(obj.isParent&&!obj.isInitAttr){
					   treeObj.reAsyncChildNodes(obj,"refresh",false);
					   obj.isInitAttr = true;
					   treeObj.updateNode(obj);
					   //treeObj.selectNode(obj,true);
					}   
				}
				//console.log(selectNodeID);
				setTimeout(function(){
					var treeObj = $.fn.zTree.getZTreeObj("tree");
					var node = treeObj.getNodeByParam("nodeValue", selectNodeID); 
					treeObj.selectNode(node,true);
				},500);
    		}
		};

		function zTreeOnCheck(event, treeId, treeNode) {
			var treeObj = $.fn.zTree.getZTreeObj("tree");
			if(!treeNode.zAsync){
				treeObj.reAsyncChildNodes(treeNode, "refresh");
			}else{
				treeObj.expandNode(treeNode, true, true, true);
			}
			
		};
		
		function dblClickExpand(treeId, treeNode) {
			return treeNode.level > 0;
		}
 
		$(document).ready(function(){
			$.fn.zTree.init($("#tree"), setting);
		});
		
		function onGetChecked(){

			var para = {"selectids":selectNodeID,"include":0}

			if(typeof window.parent.closeModalDialog == "function") {
				window.parent.closeModalDialog(para);
			} else {
				window.returnValue = para;
				window.close();
			}
		}
		
		function onCancel() {
			if(typeof window.parent.closeModalDialog == "function") {
				window.parent.closeModalDialog();
			} else {
				window.close();
			}
		}
		function onClear(){
			var treeObj = $.fn.zTree.getZTreeObj("tree");
			treeObj.refresh();
			selectNodeID = "";
		}
		//-->
	</SCRIPT>
	<style type="text/css">
		.ztree li button.switch.level0 {visibility:hidden; width:1px;}
		.ztree li ul.level0 {padding:0; background:none;}
	</style>
  </head>
  
  <body style="overflow-y: hidden;overflow-x: hidden;">
  <form name="frmFlwCenter"  id="frmFlwCenter" action="" method="post">
	<input type='hidden' name='chgflowids'  id='chgflowids'>
	<input type="hidden"  id="btnSave"  onclick='onGetChecked()'/>
	<table style="height: 100%;width: 100%">
	   
				<%
					if(componentid.equals("1")){
				%>
					<tr>
						<td colspan="3">
							<input type="checkbox" id="include" 
							<%
								if(include.equals("1")){
							%>
								checked="true"
							<%
								}
							%>
							></input>
							<font  size="2"><%=SystemEnv.getHtmlLabelName(82805,user.getLanguage())%></font>
						</td>
					</tr>
				<%
					}
					if(componentid.equals("8")){
				%>
					<tr>
						<td colspan="3">
							<input type="checkbox" id="include"
							<%
								if(include.equals("1")){
							%>
								checked="true"
							<%
								}
							%>
							></input>
							<font  size="2"><%=SystemEnv.getHtmlLabelName(82806,user.getLanguage())%></font>
						</td>
					</tr>
				<%
					}
				%>	
				
			
	   <tr>
	      <td width="10px;"></td>
	      <td width="*">
	          <div style="overflow: auto;height: 445px;">
	             <ul id="tree" class="ztree" style="margin: 0px;padding: 0px;"></ul>
	          </div>
	          <div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
			     <BUTTON type="button" class=btn accessKey=O id="searchBtn" onclick="onGetChecked()"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
				 <BUTTON type="button" class=btn accessKey=2  id="btnclear" onclick="onClear()"><u>2</u>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			     <BUTTON type="button" class=btnReset accessKey=T id="cancelBtn" onclick="onCancel()"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
              </div>
	      </td>
	      <td width="10px;"></td>
	   </tr>
	</table>
	
  </form>
  
  </body>
</html>
