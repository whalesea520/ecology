
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <!--    <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>-->
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<style>
	.root_docu {
		background-color: transparent;
	}
	button {
		background-color: transparent;
	}
</style>
</HEAD>


<%
int uid=user.getUID();
String id=Util.null2String(request.getParameter("id"));


%>

<BODY style="overflow-y: hidden;" scroll=no>
	<FORM NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">

<table height="100%" width=100% cellspacing="0" cellpadding="0" class="flowsTable" valign="top">
	<TR>
	<td height="100%" style="width:23%;" >
			<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                <ul id="ztreedeep" class="ztree"></ul>
            </div> 
	
	</td>
	</tr>
	</table>
	</FORM>


<script type="text/javascript">
	
	//<!--
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "GetSubordinateXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "GetSubordinateXML.jsp?id=<%=id%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	   }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		check: {
			enable: false       //启用checkbox或者radio

		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
		//$("#overFlowDiv").perfectScrollbar();
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
		setHrm(treeNode.id)
	};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.transformToArray(treeObj.getNodes());
		if(nodes.length == 1){
			treeObj.expandNode(nodes[0]);
		}
		$("#deeptree").css("margin-top","10px");
		//treeObj.expandAll(true); 
		//$("#overFlowDiv").perfectScrollbar("update");
	}

	function setHrm(id){
		parent.setUser(id);
	}
	//-->
</SCRIPT>


</BODY>
</HTML>