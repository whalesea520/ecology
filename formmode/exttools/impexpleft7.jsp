<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<%@ include file="/systeminfo/init.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

String treeFieldId=Util.null2String(request.getParameter("treeFieldId"));
String err=Util.null2String(request.getParameter("err"));
%>

<HTML><HEAD>
	
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function (){
		jQuery("#ztreeDiv").height(jQuery(document.body).height());
	});
}
</script>
</HEAD>

<BODY>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0"
	action="DocTreeDocFieldDsp.jsp" method=post target="contentframe">

<table height="100%" width=100% class="ViewForm" valign="top">

	<!--######## Search Table Start########-->
	<TR>
		<td height="100%">	
			 <div id="ztreeDiv" style="height:100%;width:100%;">
             	 <ul id="ztreeObj" class="ztree"></ul>
             </div>
		<td>
	</tr>
</table>

<input class=inputstyle type="hidden" name="id" id="hdnid">
<input class=inputstyle type="hidden" name="typeId" id="typeId">
</FORM>

</BODY>
</HTML>
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/formmode/setup/ModeTreeLeftXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/formmode/setup/ModeTreeLeftXML.jsp";
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
	    //treeObj.expandAll(false);
		var node = treeObj.getNodeByParam("id", "field_<%=treeFieldId%>", null);
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
		setTreeField(treeNode.id);
	};

	function setTreeField(nodeId) {
	    var treeFieldId = "";
	    var treetype = nodeId.split("_");
		if(treetype.length == 3){
			treeFieldId = treetype[2];
		    parent.settingRight(treeFieldId, 1, 0);
		}else{
			treeFieldId = nodeId.substring(nodeId.lastIndexOf("_")+1);
		    parent.settingRight(treeFieldId, 0, 1);
		}
	}
	
</SCRIPT>