<%--
  Created by IntelliJ IDEA.
  User: sean
  Date: 2006-3-29
  Time: 9:12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%
    String id=Util.null2String(request.getParameter("capitalgroupid"));
    //1数据源管理，2注册服务管理
    String showtype=Util.null2String(request.getParameter("showtype"));
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">

</HEAD>
</HTML>
<BODY oncontextmenu=self.event.returnValue=false style="overflow:hidden;">
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td style="width:23%;" class="flowMenusTd" style="overflow:hidden;">
			<div id="ztreeDiv" style="overflow:hidden;height:100%;width:100%;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
		</td>
	</tr>
</table>
<script type="text/javascript">

	 $(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	 });

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/integration/serviceReg/serviceRegTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/integration/serviceReg/serviceRegTreeXML.jsp<%if(!id.equals("")){%>?id=<%=id%>&init=y<%}%>";
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
	

	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		//alert(msg)
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "com_0", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	//zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		
	    onClick(treeNode.id);
	};
	
	//单击树形菜单中的每一项选中时 onClick() 方法应该和 zTreeOnClick()方法写在一个Script里面 这样在谷歌中才能把选中的节点的值传入到onClick()中
	//2012-13-13 ypc 修改
	function onClick(id){
		if(id){
			var array = id.split("_");
			if(array[2]){
			
				 //1数据源管理，2注册服务管理
	    		if("<%=showtype%>"=="1"){
					window.parent.document.getElementById("contentframe").src="/integration/serviceReg/serviceRegTabs.jsp?_fromURL=1&showtype="+array[2]+"&hpid="+array[1];
	    						/*if(array[2]=="1"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataDMLlist.jsp?hpid="+array[1];
	    						}else if(array[2]=="2"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataWebservicelist.jsp?hpid="+array[1];
	    						}else if(array[2]=="3"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataSAPlist.jsp?hpid="+array[1];
	    						}*/
	    						//loadurl="/integration/dateSource/dataSAPlist.jsp";
								///integration/dateSource/dataDMLlist.jsp
								///integration/dateSource/dataWebservicelist.jsp
							
	    		}else if("<%=showtype%>"=="2"){
					window.parent.document.getElementById("contentframe").src="/integration/serviceReg/serviceRegTabs.jsp?_fromURL=2&showtype="+array[2]+"&hpid="+array[1];
	    				//window.parent.document.getElementById("contentframe").src="/integration/serviceReg/serviceReg_"+array[2]+"list.jsp?hpid="+array[1];
	    		}
		  	}
	   }
	}
	
</SCRIPT>
</BODY>
</HTML>

<script language="javascript">

//to use xtree,you must implement top() and showcom(node) functions

function top(){

}

function showcom(node){

}

function check(id,name){

}
</script>
