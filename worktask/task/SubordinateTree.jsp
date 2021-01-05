
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
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
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
String id=Util.null2String(request.getParameter("id"));


%>

<BODY style="overflow-y: hidden;" scroll=no>
	<FORM NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">

<table height="100%" width=100% cellspacing="0" cellpadding="0" class="flowsTable" valign="top">
	<TR>
	<td height="100%" style="width:23%;" >
	    <div id="pageLeftContent" style="width:100%; width:224px;border-right:1px solid #cad1d7">
	         <div style="height: 60px;line-height: 60px;padding-left: 10px;background: #f4fafc;border-bottom: 1px solid #E9E9E2;">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
					<span style="font-size:14px;font-weight:bold"><%=SystemEnv.getHtmlLabelNames("442,320",user.getLanguage())%></span>
			</div>
			<div style="display:none">
						<span id="searchblockspan"><span  >
						    <input type="text"  style="vertical-align: top;width: 223px;height: 27px;line-height: 27px;"><span class="middle searchImg" style="position: absolute; right: 0px;top: 37px;">
						    <img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png"></span>
						</span></span>
			</div>
			<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                <ul id="ztreedeep" class="ztree"></ul>
            </div> 
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
		
		$("#pageLeftContent").css("height",($(window.top.document.body).height()-52)+'px');
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    resetPageRightSrc(treeNode.id);
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
		setHrm(treeNode.id);
		
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

	function setHrm(id){
		//parent.setUser(id);
	}
	
	function resetPageRightSrc(userid){
	  if(userid !="<%=user.getUID() %>"){
	      $("#pageRight", window.parent.document).attr("src","/worktask/task/tasktab.jsp?subuserid="+userid);
	  }
	}
	//-->
</SCRIPT>


</BODY>
</HTML>