<%--
  Created by IntelliJ IDEA.
  User: sean.yang
  Date: 2006-3-3
  Time: 13:21:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String cptdata1_maintenance=Util.null2String(request.getParameter("cptdata1_maintenance"));//来自资产资料维护页面
    String cpt_mycapital=Util.null2String(request.getParameter("cpt_mycapital"));//来自我的资产页面
    String cpt_search=Util.null2String(request.getParameter("cpt_search"));//来自查询资产页面
    String id=Util.null2String(request.getParameter("paraid"));
    String checktype=Util.null2String(request.getParameter("checktype"));  //radio or not
    String onlyendnode=Util.null2String(request.getParameter("onlyendnode")); //如果需要check是否仅仅只是没有孩子的节点
%>
<HTML>
<HEAD>

	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">

<script type="text/javascript">
var cptdata1_maintenance="<%=cptdata1_maintenance %>";
var cpt_mycapital="<%=cpt_mycapital %>";
var cpt_search="<%=cpt_search %>";
var linkUrl=cptdata1_maintenance==1?"/cpt/capital/CptCapMain_data1tab.jsp"
		:cpt_mycapital==1?"/cpt/search/CptMyCapitaltab.jsp"
		:cpt_search==1?"/cpt/search/CptSearchtab.jsp"
				:"/cpt/maintenance/CptAssortmentTab.jsp";

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?showcptcount=y&checktype=<%=checktype%>&onlyendnode=<%=onlyendnode%><%if(!id.equals("")){%>&id=<%=id%>&init=y<%}%>";
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
		//ztreeobj.expandAll(true);
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "com_0", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    }
	    
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	    var id=treeNode.id;
	    var array = id.split("_");
		id = array[array.length-1];
		 
	    if(id>0){
	       document.all.form1.action = linkUrl;
	       document.all.paraid.value=id;
	    }else if(id==0){
	       document.all.form1.action = linkUrl;
	       document.all.paraid.value=0;
	    }
	    document.all.form1.submit();
	};

	
</SCRIPT>
</HEAD>
</HTML>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>

<script>
rightMenu.style.visibility='hidden'
</script>
<form action="" name="form1" id ="form1" method="get" target="optFrame">
				     <input type="hidden"  name="paraid" id ="paraid" value="<%=id %>">
				     <input type="hidden"  name="_fromURL" id ="_fromURL" value="">

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch" >
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span>资产组</span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
		</td>
	</tr>
	<tr>
		<td style="width:220px;" class="flowMenusTd">
		
			<div class="flowMenuDiv"  >
				<table height="100%" width="100%" cellspacing="0" cellpadding="0">
				    
				    <tr>
				        <td height="100%">
				          <div id="ztreeDiv" style="height:100%;width:100%;">
				             	<ul id="ztreeObj" class="ztree"></ul>
				             </div>
				        <td>
				    </tr>
				</table>
			</div>
		</td>
	</tr>
</table>

</form>

</BODY>
</HTML>
