<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	String condition = request.getParameter("condition")==null?"":request.getParameter("condition");
 %>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0" action="HrmCity.jsp" method=post target="contentframe">
	<table height="100%" width=100% class="LayoutTable e8_Noborder" valign="top">
		<TR>
			<td height="100%">
			<div id="ztreeDiv" style="height:100%;width:100%;">
					<ul id="ztreeObj" class="ztree"></ul>
				 </div>
			</td>
		</tr>
	</table>
	<input class=inputstyle type="hidden" name="jobgroup" id="jobgroup">
	<input class=inputstyle type="hidden" name="jobactivite" id="jobactivite">
	<input class=inputstyle type="hidden" name="jobtitles" id="jobtitles">
</FORM>
    
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
		var pid = null;
		if(!!treeNode && !!treeNode.id){
			pid = treeNode.id.replace(/\D/g,"");
		}
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/jobtitlestemplet/indexTreeLeftXML.jsp?pid="+pid+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime()+"&condition="+'<%=condition%>';
	    } else {
	    	//初始化时
	    	return "/hrm/jobtitlestemplet/indexTreeLeftXMLSearch.jsp?condition="+'<%=condition%>';
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
	    var node = treeObj.getNodeByParam("id", "0", null);
	    
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
			onClickJobGroup(treeNode.id)
	}

function onClickJobGroup(nodeid) {
	document.getElementById("jobgroup").value = "";
	document.getElementById("jobactivite").value = "";
	document.getElementById("jobtitles").value = "";
	var cmd = nodeid.split("_")[0];
	var id = nodeid.split("_")[1];
	if(cmd=="jobgroup"){
		document.getElementById("jobgroup").value = id;
		document.SearchForm.action = "/hrm/HrmTab.jsp?_fromURL=jobgrouptemplet";
		document.SearchForm.submit();
	} else if(cmd=="jobactivities") {
		document.getElementById("jobactivite").value = id;
		document.SearchForm.action = "/hrm/HrmTab.jsp?_fromURL=jobactivitiestemplet";
		document.SearchForm.submit();
	}else if(cmd=="jobtitlestemplet") {
		document.getElementById("jobtitles").value = id;
		document.SearchForm.action = "/hrm/HrmTab.jsp?_fromURL=jobtitlestempletdsp";
		document.SearchForm.submit();
	}
}
</script>
