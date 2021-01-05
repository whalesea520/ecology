
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.common.StringUtil"%>
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
String slg = StringUtil.vString(request.getParameter("slg"), "i");

%>

<BODY style="height: 100%;"  scroll=no>
	<FORM NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">

<table height="100%" width=100% cellspacing="0" cellpadding="0" class="flowsTable" valign="top">
	<TR>
	<td height="100%" style="width:23%;height: 100%;" >
			<div id="ztreeDiv" style="height:100%;width:100%;">
					<ul id="ztreeObj" class="ztree"></ul>
            </div> 
	
	</td>
	</tr>
	</table>
	</FORM>


<script type="text/javascript">
	var slg = "<%=slg%>";
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
			return "/hrm/mobile/signin/subordinateXML.jsp?slg="+slg+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
		} else {
			//初始化时
			return "/hrm/mobile/signin/subordinateXML.jsp?id=<%=id%>&slg="+slg+"&" + new Date().getTime() + "=" + new Date().getTime();
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
		jQuery(".ztree").height(jQuery("#ztreeDiv").height()-100);
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
		//$("#overFlowDiv").perfectScrollbar();
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
		parent.setUid(treeNode.id);
	};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.transformToArray(treeObj.getNodes());
		if(nodes.length == 1){
			treeObj.expandNode(nodes[0]);
		}
		//treeObj.expandAll(true); 
		//$("#overFlowDiv").perfectScrollbar("update");
	}

</SCRIPT>


</BODY>
</HTML>
