
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<%
	//hpu.handleHpinfoOrdernumForE7();
	String titlename = SystemEnv.getHtmlLabelName(24668, user.getLanguage());
%>
<HTML>
	<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	
	
<style>
.ztree li span {
padding-top: 6px;
}

</style>
	
	</HEAD>
	<BODY style="overflow: hidden;">
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="portal"/>
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24668, user.getLanguage())%>"/> 
		</jsp:include>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmAdd" method="post" action="HomepageLocationOperation.jsp">
		    
		    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="75px">					
					</td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top"  onclick="onSave();"/>
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		    
			<div id="menu_content" style="margin-bottom: 50px;">
				<ul id="menutree" class="ztree" style="overflow: hidden;"></ul>
			</div>
			
			<div id="show_Dialog"></div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<table width="100%">
				    <tr><td style="text-align:center;" colspan="3">
				     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
				    </td></tr>
				</table>
			</div>
		</form>
		
	</BODY>
</HTML>
<LINK REL=stylesheet type=text/css	HREF=/wui/theme/ecology8/skins/default/wui_wev8.css>
<!-- for zTree -->
<link rel="stylesheet"	href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/CustomResourcezTreeStyle_wev8.css"	type="text/css">
<script type="text/javascript"	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
<script type="text/javascript"	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript"	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<!-- for scrollbar -->
<link rel="stylesheet" type="text/css"	href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript"	src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript"	src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<!--For zDialog-->
<link rel="stylesheet"	href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language="javascript"	src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript"	src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	})
	
	function OnAsyncSuccess(event, treeId, treeNode, msg) {
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		var nodes; 
		if(treeNode){
			nodes = treeNode.children;
		}else{
			nodes = zTree.getNodes();
		}
	}
	
	//zTree配置信息
	var setting = {
			async: {
				enable: true,       //启用异步加载
				dataType: "text",   //ajax数据类型
				url: "/homepage/maint/HomepageLocationJSON.jsp"    //ajax的url
			},
			edit: {
					enable: true,
					showRemoveBtn: false,
					showRenameBtn: false,
					drag: {
						prev: true,//menu移到上方,
						next: true,//menu移到上方,
						inner: true//menu成为子节点
					}
			},
			data: {
				keep: {
					parent: false,
					leaf: false
				},
				simpleData: {    
                    enable: true
                }
			},
			callback: {
				onAsyncSuccess: OnAsyncSuccess,
				onClick: zTreeOnClick
			},
			view: {
				dblClickExpand: false,
				showLine: false,
				showIcon: false,
				selectedMulti: true,
			}
	};

	var zNodes =[];
	$(document).ready(function(){
		$.fn.zTree.init($("#menutree"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("menutree");
			zTree.expandNode(treeNode);
	}

	function onSave(){
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		var nodeJson = treeObj.getNodes();
		var nodesArr = treeObj.transformToArray(nodeJson);
		var data = getnodeChild(nodesArr);
		jQuery.post("/homepage/maint/HomepageLocationOperation.jsp?data="+data);
		$.ajax({
            data: null,
            type: "POST",
            url: "/homepage/maint/HomepageLocationOperation.jsp?data="+data,
            timeout: 20000,
            dataType: 'json',
            success: function(rs){
                //存储成功
               if(rs.success==='1'){
                    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83718,user.getLanguage())%>");
                //存储失败
               }else{
                   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83719,user.getLanguage())%>");
               }
            },fail:function(){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83719,user.getLanguage())%>");
            }
        });
	}
	var treeStr = "";
	function getnodeChild(obj){
		var ordernum = 1;

		for(var i=0;i<obj.length;i++){
		     treeStr+=obj[i].id;
		     if(null != obj[i].pId ){
					treeStr+=","+obj[i].pId;
				}else{
					treeStr+=",0";
				}
		    treeStr+=","+ordernum++;
			treeStr+=";";
		}
		
		treeStr=treeStr.substring(0,treeStr.length-1);
  		//console.log(treeStr);
  		return treeStr;
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}
	
	//window.onunload=function(){
		//onSave();
	//}
</script>