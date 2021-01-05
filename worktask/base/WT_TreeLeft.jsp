
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>

<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0" action="" method=post target="contentframe">
 <input type="hidden" name="wtid" value="">
	<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">
		<TR>
			<td height="100%">
			<div id="ztreeDiv" style="height:100%;width:100%;">
					<ul id="ztreeObj" class="ztree"></ul>
				 </div>
			</td>
		</tr>
	</table>
</FORM>

<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var cid = null;
		if(!!treeNode && !!treeNode.id){
			cid = treeNode.id.replace(/\D/g,"");
		}
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/worktask/base/WT_TreeLeftXml.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/worktask/base/WT_TreeLeftXml.jsp";
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		data: {
			simpleData: {
				enable: true,   //返回的json数据为简单数据类型，非复杂json数据类型
				idKey:"id",     //tree的标识属性
				pIdKey:"pId",   //父节点标识属性
				rootPId: 0      //顶级节点的父id
			}
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    //treeObj.expandAll(true);keyword_0
	    var node = treeObj.getNodeByParam("id", "country_0", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setCategory(treeNode.id);
	};


	function setCategory(nodeId) {
	    var id=nodeId.substring(nodeId.lastIndexOf("_")+1);
		$("#SearchForm").attr("action", "worktaskAdd.jsp");
		document.all("wtid").value = id;
		$("#SearchForm")[0].submit();
	}
	
	function onClickSys(){
		document.all("wtid").value = "-1";
		$("#SearchForm").attr("action", "worktaskSysSet.jsp");
		$("#SearchForm")[0].submit();
    }

</SCRIPT>