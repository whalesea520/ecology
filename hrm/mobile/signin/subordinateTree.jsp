<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/hrm/header.jsp" %>
<!-- Added by wcd 2015-03-25 [移动签到-人员树] -->
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<%
	String id = strUtil.vString(request.getParameter("id"));
	String slg = strUtil.vString(request.getParameter("slg"), "i");
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
		<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<style>
			.root_docu {
				background-color: transparent;
			}
			button {
				background-color: transparent;
			}
			
			.btnNBg {
				background:url(/appres/hrm/image/mobile/signin/img021.png) 0 0 no-repeat;
			}
			
			.btnYBg {
				background:url(/appres/hrm/image/mobile/signin/img022.png) 0 0 no-repeat;
			}
			
			.btnCYBg {
				background:url(/appres/hrm/image/mobile/signin/img023.png) 0 0 no-repeat;
			}
		</style>
		<script type="text/javascript">
			var zNodes =[];
			var slg = "<%=slg%>";
			//<!--
			/**
			 * 获取url（alax方式获得子节点时使用）
			 */
			function getAsyncUrl(treeId, treeNode) {
				//获取子节点时
				if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
					return "subordinateXML.jsp?slg="+slg+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
				} else {
					//初始化时
					return "subordinateXML.jsp?id=<%=id%>&slg="+slg+"&" + new Date().getTime() + "=" + new Date().getTime();
			   }
			};
			//zTree配置信息
			var setting = {
				async: {
					enable: true,       //启用异步加载
					dataType: "text",   //ajax数据类型
					url: getAsyncUrl    //ajax的url
				},
				view: {
					expandSpeed: "",     //效果
					addFirstNodeAttr: slg === "c" ? "<button id='conSubBtn' class='conSubBtn "+parent.getBtnBg()+"' type='button' style='text-align:right;margin-left:70px;' onclick='fistNodeAttrClick();'></button>" : ""
				},
				callback: {
					onClick: zTreeOnClick,   //节点点击事件
					onCheck: zTreeOnCheck,
					onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
				},
				check:{
					autoCheckTrigger : true,
					enable: true,       //启用checkbox或者radio
					chkStyle: "checkbox",  //check类型为checkbox
					radioType: "all",   //radio选择范围
					chkboxType: { "Y" : "", "N" : "" }
				}
			};
			
			var canExc = true;
			function fistNodeAttrClick(){
				var obj = $("#conSubBtn");
				if(obj.hasClass("btnNBg")) {
					change(obj, "btnNBg", "btnYBg");
					parent.setBtnBg("btnYBg");
				}else if(obj.hasClass("btnYBg")) {
					change(obj, "btnYBg", "btnNBg");
					parent.setBtnBg("btnNBg");
				}
				canExc = false;
				window.setTimeout(function(){canExc = true;return;},100);
			}
			
			function change(obj, bg1, bg2){
				obj.removeClass(bg1);
				obj.addClass(bg2);
			}
			
			var cg = false;
			var sIndex = 0;
			function zTreeOnCheck(event, treeId, treeNode){
				cg = true;
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				if (treeNode.isParent) {
					treeObj.expandNode(treeNode);
				}
				var nodes = treeObj.transformToArray(treeObj.getNodes());
				if($("#conSubBtn").hasClass("btnYBg") && nodes.length){
					for(var i=0; i<nodes.length; i++){
						if(nodes[i].parentTId !== treeNode.tId) continue;
						treeObj.checkNode(nodes[i], treeNode.checked, false);
					}
					
					window.setTimeout(function(){
						if(cg === true){
							cg = false;
							sIndex = 0;
							parent.hasException = false;
						}
						setUid(treeObj, treeNode);
					}, 200);
				} else {
					parent.hasException = false;
					setUid(treeObj, treeNode);
				}
			}
			
			function zTreeOnClick(event, treeId, treeNode) {
				if(canExc === false) return;
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				if (treeNode.isParent) {
					treeObj.expandNode(treeNode);
				}
				treeObj.checkNode(treeNode, true, false);
				parent.hasException = false;
				setUid(treeObj, treeNode);
			};
			
			function setUid(treeObj, treeNode){
				var id = "";
				if(slg === "c") {
					var nodes = treeObj.getCheckedNodes(true);
					for(var i=0;i<nodes.length;i++){
						var nodeId = nodes[i].id.split("_");
						id += (id==""?"":",")+nodeId[1];
					}
				} else {
					id = treeNode.id;
				}
				parent.setUid(id);
			}

			function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
				sIndex = 1;
				var treeObj = $.fn.zTree.getZTreeObj(treeId);
				var nodes = treeObj.transformToArray(treeObj.getNodes());
				if(nodes.length == 1) treeObj.expandNode(nodes[0]);
				if(slg == "c") try{jQuery("button.root_close").click();}catch(e){}
				if($("#conSubBtn").hasClass("btnYBg") && nodes.length){
					for(var i=0; i<nodes.length; i++){
						if(nodes[i].parentTId === treeNode.tId){
							treeObj.checkNode(nodes[i], treeNode.checked, false);
						}
					}
				}
			}
			
			function check(node){}
			
			$(document).ready(function(){
				if(slg === "c"){
					setting = jQuery.extend({
						check:{
							enable: true,       //启用checkbox或者radio
							chkStyle: "checkbox",  //check类型为checkbox
							radioType: "all",   //radio选择范围
							chkboxType: { "Y" : "", "N" : "" }
						}
					}, setting);
				}
				$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
			});
			//-->
		</script>
	</head>
	<body style="overflow-y: hidden;">
		<form NAME=SearchForm STYLE="margin-bottom:0"  method=post target="contentframe">
			<table height="100%" width=100% cellspacing="0" cellpadding="0" class="flowsTable" valign="top">
				<TR>
					<td height="100%" style="width:23%;" >
						<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
							<ul id="ztreedeep" class="ztree"></ul>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>