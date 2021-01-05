<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</head>
<body>
<div class="zDialog_div_content">
		<wea:layout attributes="{'formTableId':'BrowseTable'}">
   		<wea:group context="" attributes="{'groupDisplay':'none'}">
   			<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="selObj">
				<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                	<ul id="ztreedeep" class="ztree"></ul>
            	</div>
   			</wea:item>
		</wea:group>
	</wea:layout>
</DIV>
<script type="text/javascript">
jQuery(document).ready(function(){
	
});
var selectallflag=true;
var cxtree_ids ; 
var setting = {
		async: {
			enable: true,
			url: getUrl
		},
		data: {
			simpleData: {
				enable: true
			},
			keep: {
				parent: true
			}
		},
		view: {
			expandSpeed: ""
		},
		  callback: {
		   onClick: zTreeOnClick   //节点点击事件
		 }
	};

 
	function getUrl(treeId, treeNode) {
		var param =""; 
	    if(treeNode){
	       param="id="+treeNode.id;
	    }
		return "/demo/demo_treedata.jsp?" + param;
	}
	$(document).ready(function(){
		$.fn.zTree.init($("#ztreedeep"),setting);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);//打开子节点
		}else{
			parent.jQuery("#contentframe").attr("src","/demo/body.jsp?nodeid="+treeNode.id);
			//打开右侧页面传递节点id
		}
		
	};

</script>
</body>
</HTML>

































