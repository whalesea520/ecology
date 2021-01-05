
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
%>
	
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<base target="mainFrame"/>

	<style>
	<!--
	.ztree li span.button {
		line-height: 0;
		margin: 0;
		width: 16px;
		height: 16px;
		display: inline-block;
		vertical-align: middle;
		border: 0 none;
		cursor: pointer;
		outline: none;
		background: url(/images/folder.fav_wev8.png) 0 50% no-repeat;
	}
	
	.ztree li span.button.roots_docu {
		background-position: 0 50%;
		margin-left:10px;
		margin-right:5px;
	}
	.ztree li span.button.center_docu {
		background-position: 0 50%;
		margin-left:10px;
		margin-right:5px;
	}
	.ztree li span.button.bottom_docu {
		background-position: 0 50%;
		margin-left:10px;
		margin-right:5px;
	}
	.ztree li div button.root_docu, .ztree li button.center_open, .ztree li button.roots_open, .ztree li button.root_open, .ztree li button.roots_docu, .ztree li button.bottom_open {
		background: url(/images/folder.fav_wev8.png) 0 50% no-repeat;
	}
	.ztree li div.curSelectedNode button.center_docu, .ztree li div.curSelectedNode button.bottom_docu, .ztree li button.bottom_docu, .ztree li button.center_docu {
		background: url(/images/folder.fav_wev8.png) 0 50% no-repeat;
	}
	.ztree li div.curSelectedNode button.center_open, .ztree li div.curSelectedNode button.roots_open, .ztree li div.curSelectedNode button.root_open, .ztree li div.curSelectedNode button.roots_docu, .ztree li div.curSelectedNode button.bottom_open, .ztree li div.curSelectedNode button.root_docu {
		background: url(/images/folder.fav_wev8.png) 0 50% no-repeat;
	}
	.ztree LI A.curSelectedNode
	{
		background-color:#D7F2FD!important;
		color:#000 !important;
	}
	.ztree LI DIV.curSelectedNode
	{
		background-color:#D7F2FD!important;
		color:#000 !important;
	}
	.ztree li span.button.edit {
		margin-left: 5px;
		margin-right: 2px;
		margin-bottom: 4px;
		background: url(/favourite/images/edit_wev8.png) no-repeat;
		vertical-align: middle;
	}
	.ztree li span.button.remove {
		margin-left: 5px;
		margin-right: 2px;
		margin-bottom: 4px;
		background: url(/favourite/images/del_wev8.png) no-repeat;
		vertical-align: middle;
	}
	.ztree li button {
		width: 16px;
		height: 16px;
		vertical-align: middle;
		margin-right: 8px;
		margin-left: 10px;
	}
	.leftTypeSearch span.searchInputSpan {
		border: 1px solid rgb(252,252,252);
		width: 95%;
		margin-left: 5px;
	}
	.ztree li a button {
		display: none;
	}
	ul.ztree {
		height: 100%;
		overflow-y: auto;
		overflow-x: hidden;
	}
	-->
	</style>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0" action="" method=post target="contentframe">
	
	<script>
		rightMenu.style.visibility = 'hidden'
	</script>

<table height="100%" width=100% class="LayoutTable">

	<!--######## Search Table Start########-->
	<TR>
		<td height="100%">	
			 <div id="ztreeDiv" style="height:100%;width:100%;">
             	 <ul id="ztreeObj" class="ztree"></ul>
             </div>
		</td>
	</tr>
</table>

<input class=inputstyle type="hidden" name="id" id="hdnid"> <!--########//Search Table End########-->
</FORM>
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	var deletedatatitle = favourite.maingrid.deletedata;
	var edittitle = favourite.maingrid.edit;
	//alert(deletedatatitle);
	function getAsyncUrl(treeId, treeNode) {
		//初始化时
	    return "FavouriteTreeLeftXML.jsp";
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
			expandSpeed: "",     //效果
			showIcon:false
		},
		edit: {
            enable: true,
			editNameSelectAll: true,
			showRemoveBtn: true,
			showRenameBtn: true,
			removeTitle: deletedatatitle,
			renameTitle: edittitle
        },
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			beforeRemove:beforeRemove,//点击删除时触发，用来提示用户是否确定删除  
            beforeEditName: beforeEditName,//点击编辑时触发，用来判断该节点是否能编辑  
            beforeRename:beforeRename,//编辑结束时触发，用来验证输入的数据是否符合要求  
            onRemove:onRemove,//删除节点后触发，用户后台操作  
            onRename:onRename,//编辑后触发，用于操作后台  
            onRightClick : onRightClick      //右键点击事件
		}
	};

	var zNodes =[]; 
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
		$(".flowsTable").height($("body").height());
		$("#overFlowDiv").height($("body").height()-60);
		$("#contentframe").height("100%");
		$("#ztreeObj").height($("body").height()-60);
	});
	function reloadTree()
	{
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
		$(".flowsTable").height($("body").height());
		$("#overFlowDiv").height($("body").height()-60);
		$("#contentframe").height($("body").height());
		$("#ztreeObj").height($("body").height()-60);
	}
	$(window).resize(function(){
		//alert($(".flowMenusTd").height());
		$(".flowsTable").height($("body").height());
		$("#overFlowDiv").height($("body").height()-60);
		$("#contentframe").height($("body").height());
		$("#ztreeObj").height($("body").height()-60);
	}); 
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setTreeDocField(treeNode.id);
	};
	function beforeRemove(treeId, treeNode)
	{
		var favouriteid = treeNode.id;
	    if(favouriteid.indexOf("_")>-1)
	    {
	    	favouriteid = favouriteid.substring(favouriteid.lastIndexOf("_")+1);
	    	//alert("favouriteid : "+favouriteid);
	    	if(favouriteid>0)
	    	{
	    		var treeObj = $.fn.zTree.getZTreeObj(treeId);   //获取树的对象
	    		treeObj.selectNode(treeNode);     //节点设为选中
	    		//"删除此收藏夹，将会删除与此收藏夹有关的所有信息，是否确定？"
				/*if(confirm(favourite.favouritepanel.deletetopic))
				{
			        deleteItem(favouriteid);
			    }*/
				top.Dialog.confirm(favourite.favouritepanel.deletetopic,function(){
					deleteItem(favouriteid,treeId,treeNode);
				});
			}
			else
			{
				//"当前目录不可删除!"
				top.Dialog.alert(favourite.favouritepanel.deleteerror);
			}
		}
		return false;  //返回值定为false，因为删除树节点操作已经执行过，不需要再执行了
	}
	function beforeEditName(treeId, treeNode)
	{
	    //alert("treeId : "+treeNode.id);
	    var favouriteid = treeNode.id;
	    if(favouriteid.indexOf("_")>-1)
	    {
	    	favouriteid = favouriteid.substring(favouriteid.lastIndexOf("_")+1);
	    	//alert("favouriteid : "+favouriteid);
	    	if(favouriteid>0)
	    	{
	    		var treeObj = $.fn.zTree.getZTreeObj(treeId);   //获取树的对象
	    		treeObj.selectNode(treeNode);     //节点设为选中
				edit(favouriteid);
			}
			else
			{
				//"当前目录不可编辑!"
				top.Dialog.alert(favourite.favouritepanel.editerror);
			}
		}
		return false;
	}
	function beforeRename(event, treeId, treeNode)
	{
		return false;
	}
	function onRemove(event, treeId, treeNode)
	{
		
	}
	function onRename(event, treeId, treeNode)
	{
		return false;
	}
	function setTreeDocField(nodeId) {
	    var treeId = nodeId;
	    //alert("nodeId : "+nodeId);
	    if(nodeId.indexOf("_")>-1)
	    	treeId = nodeId.substring(nodeId.lastIndexOf("_")+1);
	    //alert("treeId : "+treeId);
		$("#SearchForm").attr("action", "FavouriteTreeTab.jsp");
		$("#hdnid").val(treeId);
		//alert($("#hdnid").val());
		$("#SearchForm")[0].submit();
	}
	jQuery(document).ready(function(){
		setTreeDocField("-1");
	});
	function edit(favouriteid)
	{
		var url = "/favourite/FavouriteOperateTab.jsp?isdialog=1&favouriteid="+favouriteid;
		var title = favourite.favouritepanel.edittitle;//"编辑收藏目录"
		openDialog(url,title,500,250);
	}
	function deleteItem(favouriteid,treeId,treeNode)
	{
		var timestamp = (new Date()).valueOf();
	    var params = "action=delete&favouriteid="+favouriteid+"&ts="+timestamp;
	    jQuery.ajax({
	        type: "POST",
	        url: "/favourite/FavouriteOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
	        	var treeObj = $.fn.zTree.getZTreeObj(treeId);  //树的对象
				treeObj.removeNode(treeNode);   //删除节点
	        }
	    });
	}

	/**右键菜单的对象*/
	TreeRightcontent = function(treeId,treeNode){
		this.treeId = treeId;
		this.treeNode = treeNode;
	}

	TreeRightcontent.prototype = {
		//编辑
		editItem : function (){
			beforeEditName(this.treeId,this.treeNode);
		},
		//删除
		deleteItem : function(){
			if(beforeRemove(this.treeId,this.treeNode)){
				var treeObj = $.fn.zTree.getZTreeObj(this.treeId);  //树的对象
				treeObj.removeNode(this.treeNode);   //删除节点
			}
		}
	};

	var _treeRightClick = new TreeRightcontent();  //右键菜单的实例

	//树的右键点击事件
	function onRightClick(event,treeId,treeNode){
		var treeObj = $.fn.zTree.getZTreeObj(treeId);   //获取树的对象
		treeObj.selectNode(treeNode);     //节点设为选中
	    _treeRightClick = new TreeRightcontent(treeId,treeNode);  //重新实例化对象

		var childdoc = document.getElementById("rightMenuIframe").contentWindow.document;  //右键菜单的iframe
		jQuery("#menuTable>div:gt(2)",childdoc).each(function(index,ele){    //将除了编辑和删除的其他菜单均隐藏
			jQuery(ele).css("display","none");
		});
		if(treeId && treeNode)   //选中节点时才显示右键菜单
		{
			showRightClickMenu(event);	   //显示右键菜单
		}
	}
	
	

</SCRIPT>