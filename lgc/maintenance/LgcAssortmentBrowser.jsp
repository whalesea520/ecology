<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"type="text/css"/>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</HEAD>
<BODY>
<%
	String newtype = Util.null2String(request.getParameter("newtype"));
	
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
 <jsp:include page="/systeminfo/commonTabHead.jsp">
    <jsp:param name="mouldID" value="customer"/>
    <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15108,user.getLanguage()) %>"/>
 </jsp:include>
 
<div id="menu_content" style="overflow-x:hidden;overflow-y:auto;height:500px;">
	<ul id="menutree" class="ztree"  style="overflow: hidden;"></ul>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave();">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
	    </td></tr>
	</table>
</div>
</BODY></HTML>
<script language=javascript>
	var appendimg = 'Home';
	var appendname = 'selObj';
	var allselect = "all";
	var cxtree_id = "";
	
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/lgc/maintenance/LgcAssortmentBrowserOperation.jsp?parentid="+treeNode.id+"&method=getTreeJson&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/lgc/maintenance/LgcAssortmentBrowserOperation.jsp?parentid=0&method=getTreeJson&" + new Date().getTime() + "=" + new Date().getTime();
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
			enable: true,       //启用checkbox或者radio
			chkStyle: "radio",  //check类型为radio
			radioType: "all",   //radio选择范围
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
		$.fn.zTree.init($("#menutree"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
	};


	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var heighttemp = document.body.clientHeight;
			heighttemp = parseInt(heighttemp)-45;
	    jQuery("#menu_content").height(heighttemp+"px");
	    jQuery("#overFlowDivTree").height("auto");
	}
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    var returnValue = {id:"",name:""};
	    if(trunStr != null && trunStr != ""){
				returnVBArray = trunStr.split("$");
				returnValue = {id:returnVBArray[0], name:returnVBArray[1]};
		}
		if(dialog){
			dialog.callback(returnValue);
		}else{
	       window.parent.returnValue  = returnValue;
	       window.parent.close();
		}
    }
    function onSaveJavaScript(){
    	var newtype = "<%=newtype%>";
	    var nameStr="";
	    var idStr = "";
	    var isparent = "";
	    var canassort = "";
	    var treeObj = $.fn.zTree.getZTreeObj("menutree");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		for (var i=0; i<nodes.length; i++) {
			nameStr = nodes[i].id;
			idStr = nodes[i].name;
			isparent = nodes[i].isParent;
			canassort = nodes[i].canassort;
		}
	    var resultStr = nameStr;
    	resultStr = resultStr + "$" + idStr;
    	if(isparent && newtype=="product"){window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32704,user.getLanguage())%>");return;}
    	if(newtype=="assort" && canassort){window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32705,user.getLanguage())%>");return;};
	    return resultStr;
		
	}
	
	
    function ajaxinit(){
	    var ajax=false;
	    try {
	        ajax = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
	        try {
	            ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	            ajax = false;
	        }
	    }
	    if (!ajax && typeof XMLHttpRequest!='undefined') {
	    ajax = new XMLHttpRequest();
	    }
	    return ajax;
	}
    function onClear() {
	    var returnValue = {id:"",name:""};
		if(dialog){
			dialog.callback(returnValue);
		}else{
	       window.parent.returnValue  = returnValue;
	       window.parent.close();
		}
	}
</script>