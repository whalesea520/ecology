
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="MobileInit.jsp"%>
<%
String formids ="7,13,46,49,74,79,158,181,182,200,10,11,156,28,180,14,159,38,85,18,19,201,224,17,21,163,157";
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
					}   
				}
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
			var selectids = window.opener.$("#wfids").val();
			
			var setting = {
				view: {
					dblClickExpand: dblClickExpand
				},
				check: {
					enable: true
				},
				async: {
					enable: true,
					type:"post",
					contentType:"application/json",
					url:"/mobile/plugin/browser/BrowserOperation.jsp?operation=getWorkflowTtree&pluginCode=1&formids=<%=formids%>",
					autoParam:["level", "nodeValue"],
					otherParam:{"selectids": selectids}
				},
				callback: {
					onCheck:zTreeOnCheck,
					onAsyncSuccess:zTreeOnAsyncSuccess
				}
			};
			
			$.fn.zTree.init($("#tree"), setting);
		});
		
		function onGetChecked(){
			var treeObj = $.fn.zTree.getZTreeObj("tree");
			var nodes = treeObj.getCheckedNodes();
			var selectids="";
			var selectnames="";
			for(var i=0;i<nodes.length;i++){
				var obj=nodes[i];
				if(!obj.isParent) {
				   selectids+=","+obj.nodeValue;
				   selectnames+=","+obj.name;
				}
			}
			if(selectids!=="") selectids=selectids.substring(1);
			window.opener.$("#wfids").val(selectids);
			if(selectnames!=="") selectnames=selectnames.substring(1);
			window.opener.$("#wfname").text(selectnames);
			window.close();
		}
		//-->
	</SCRIPT>
	<style type="text/css">
		.ztree li button.switch.level0 {visibility:hidden; width:1px;}
		.ztree li ul.level0 {padding:0; background:none;}
	</style>
  </head>
  
  <body style="overflow-y: hidden;">
  <form name="frmFlwCenter"  id="frmFlwCenter" action="" method="post">
	<table style="height: 100%;width: 100%">
	   <tr>
	      <td width="10px;"></td>
	      <td width="*">
	          <div style="overflow: auto;height: 445px;width:510px;">
	             <ul id="tree" class="ztree" style="margin: 0px;padding: 0px;"></ul>
	          </div>
	          <div align="center" style="background:rgb(246, 246, 246);vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
			     <BUTTON type="button" class=btn accessKey=O id="searchBtn" onclick="onGetChecked()"><u>O</u>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>&nbsp;&nbsp;
			     <BUTTON type="button" class=btnReset accessKey=T id="cancelBtn" onclick="window.close()"><u>T</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
              </div>
	      </td>
	      <td width="10px;"></td>
	   </tr>
	</table>
  </form>
  </body>
</html>
