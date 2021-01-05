
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");response.setDateHeader("Expires",0);%>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.*"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    int dummyId=Util.getIntValue(request.getParameter("dummyId"),1);
%>
    <base target="mainFrame"/>
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/docdummy/DocDummyLeftXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/docdummy/DocDummyLeftXML.jsp";
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
			onClick: zTreeOnClick   //节点点击事件
		}
	};

	var zNodes =[];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
		window.setTimeout(function(){
			var zTree = $.fn.zTree.getZTreeObj("ztreeObj");//获取ztree对象  
	        var node = zTree.getNodeByParam('id', 1);//获取id为1的点  
	       // zTree.selectNode(node);//选择点  
	        zTree.setting.callback.onClick(null, "ztreeObj", node);//调用事件 
	   },500); 
	});
	
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		//alert(treeObj);
		//treeObj.checkNode(treeNode, true, false);
	};
</SCRIPT>
	

                <div id="ztreeDiv" style="height:100%;width:100%;">
                	<ul id="ztreeObj" class="ztree"></ul>
                </div>
	<FORM NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">
    <input type="hidden" name="dummyId">

    </FORM>

<script type="text/javascript">
function onClickTreeDocField(id) {
    $("form[name='SearchForm']").attr("action", "/docs/search/DocSearchTab.jsp?_fromURL=6&dummyId="+id);
	$("input[name='dummyId']").val(id);
	$("form[name='SearchForm']").submit();
}
jQuery(document).ready(function(){
	onClickTreeDocField(<%=dummyId%>);
});
</script>