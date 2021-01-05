<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<TITLE></TITLE>

	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script> 

	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
	<style type="text/css">
	.ztree li button.ico_close{
		vertical-align: middle;
		background-image: url("/formmode/images/folder_wev8.png");
	}
	.ztree li button.ico_open{
		vertical-align: middle;
		background-image: url("/formmode/images/folder_wev8.png");
	}
	.ztree li a.curSelectedNode button.ico_close{
		vertical-align: middle;
		background-image: url("/formmode/images/folder_white_wev8.png");
	}
	.ztree li a.curSelectedNode button.ico_open{
		vertical-align: middle;
		background-image: url("/formmode/images/folder_white_wev8.png");
	}
	
	.ztree li button.ico_loading{
		vertical-align: middle;
	}
	.ztree li span {
		vertical-align: middle;
	}
	.ztree li button.ico_docu{
		vertical-align: middle;
		background-image: url("/formmode/images/page_wev8.png");
	}
	.ztree li div.curSelectedNode button.ico_docu{
		vertical-align: middle;
		background-image: url("/formmode/images/page_white_wev8.png");
	}
	.ztree li div.curSelectedNode button.bottom_docu, .ztree li button.bottom_docu, .ztree li button.center_docu{
		background: none !important;
	}
	.ztree .e8HoverZtreeDiv button{
		margin-top: 7px;
	}
	.e8_z_seclevel .e8HoverZtreeDiv button{
		margin-top: 3px;
	}
	.noWarpStyle{
		width:146px;
    	overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
    }
	</style>
</HEAD>
	<%
		String id = Util.null2String(request.getParameter("id"));
		String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
		String searchkeyname = Util.null2String(request.getParameter("searchkeyname"));
		String rootname = Util.null2String(request.getParameter("rootname"));
		String sql = "select * from mode_customtree where id = " + id;
		String treename = "";
		int isRefreshTree = 0;
		int isQuickSearch = 0;
		int showtype = 0;
		rs.executeSql(sql);
		while(rs.next()){
			expandfirstnode = Util.null2String(rs.getString("expandfirstnode"));
			treename = Util.null2String(rs.getString("treename"));
			rootname = Util.null2String(rs.getString("rootname"));
			isRefreshTree = Util.getIntValue(rs.getString("isRefreshTree"),0);
			isQuickSearch = Util.getIntValue(rs.getString("isQuickSearch"),0);
			showtype = Util.getIntValue(rs.getString("showtype"),0);
		}
	%>
<BODY>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	
	<div style="width:100%;height:100%;overflow-y: hidden;">
		<div style="padding:10px;">
			<table>
				<tr>
					<td style="display: table-cell;border-right:0px;height:0px;" class="leftTypeSearch">
						<div style="border-bottom-color: currentColor; border-bottom-width: medium; border-bottom-style: none;" class="topMenuTitle">
							<span class="leftType" onclick="showE8TypeOption();">
								<span>
									<img style="vertical-align: middle;" src="/images/ecology8/request/alltype_wev8.png" width="18">
								</span>
							    <span class="noWarpStyle" title="<%=treename %>"><%=treename %></span>
							</span>
							<%if(isQuickSearch == 1 && showtype == 0){ %>
							<span class="leftSearchSpan">
								<span id="searchblockspan">
									<span style="position: relative;margin-top:6px" class="searchInputSpan">
										<input style="width: 110px; vertical-align: top;" class="leftSearchInput searchInput" type="text" onkeypress="enterSearch();"  name="searchValue" id="searchValue" >
										<span style="right: 0px; position: absolute;" class="middle searchImg"  onclick="quickSearch();" onkeypress="">
											<img style="margin-top: 2px; vertical-align: top;" class="middle" src="/images/ecology8/request/search-input_wev8.png">
										</span>
									</span>
								</span>
							</span>
							<%} %>
						</div>
				    </td>
			    </tr>
			</table>
		</div>
		<div id="searchLoad" style="width:100%;display:none;" id="e8_loading" class="e8_loading"><%=SystemEnv.getHtmlLabelName(126719,user.getLanguage())%></div>
		<ul id="CustomTree" class="ztree" style="padding-bottom: 0px;margin-top: 5px; "></ul>
	</div>
	
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="/formmode/tree/CustomTreeRight.jsp" method="get" target="contentframe">
		<input class=inputstyle type="hidden" name="mainid" id="mainid" value="<%=id%>">
		<input class=inputstyle type="hidden" name="name" id="name" value="">
		<input class=inputstyle type="hidden" name="searchkeyname" id="searchkeyname" value="<%=URLEncoder.encode(searchkeyname,"utf-8") %>">
		<input class=inputstyle type="hidden" name="pid" id="pid" value="0<%=CustomTreeData.Separator %>0">
	</FORM>
	
</BODY>
	<SCRIPT type="text/javascript">
	var firstclick = 0;
	var expandfirstnode = "<%=expandfirstnode%>";
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		var url = "";
		
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	url = "/formmode/tree/CustomTreeAjax.jsp?id=<%=id%>&&init=false&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	url = "/formmode/tree/CustomTreeAjax.jsp?id=<%=id%>&init=true";
	    }
	    return url;
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl,    //ajax的url
			type:"post",
			autoParam: ["id=pid","name=name"]			
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
			addDiyDom:addDiyDom
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onCollapse: zTreeOnCollapse,//折叠
			onExpand :zTreeOnExpand,//展开
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			
		}
	};
	
	var maxWidth;
	
	//计算节点收缩时，最大宽度
	function zTreeOnCollapse(event, treeId, treeNode){
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var rootNode = treeObj.getNodesByParam("id", "0_0", null);
		maxWidth = jQuery(document).width();
		maxWidth = getViewMaxWidth(treeObj,rootNode[0],maxWidth);
		jQuery(".ztreeUlDiv").width(maxWidth);
	}
	
	function getViewMaxWidth(treeObj,treeNode,maxWidth){
		var a1 = jQuery("#"+treeNode.tId+"_a");
		if(a1.length>0){
			var width = a1.get(0).offsetLeft+a1.get(0).clientWidth;
			if(width>maxWidth){
				maxWidth = width;
			}
		}
			
		if(treeNode.isParent&&treeNode.open){
			var childs = treeNode.childs;
			for(var i=0;i<childs.length;i++){
				var nodeObj = childs[i];
				var a = jQuery("#"+nodeObj.tId+"_a");
				if(a.length>0){
					var width = a.get(0).offsetLeft+a.get(0).clientWidth;
					if(width>maxWidth){
						maxWidth = width;
					}
				}
				if(nodeObj.isParent&&nodeObj.open){
					maxWidth = getViewMaxWidth(treeObj,nodeObj,maxWidth);
				}
			}
		}
		return maxWidth;
		
	}
	
	//展开时计算当前节点
	function zTreeOnExpand(event, treeId, treeNode) {
		zTreeOnCollapse(event, treeId, treeNode);
	}
	
	function showWidth(){
		jQuery("#overFlowDivTree").css("overflow","auto");
		jQuery("#overFlowDivTree").parent().css("overflow","hidden");
		
		setTimeout(function(){
			var treeObj = $.fn.zTree.getZTreeObj("CustomTree");
			var rootNode = treeObj.getNodesByParam("id", "0_0", null);
			maxWidth = jQuery(document).width();
			maxWidth = getViewMaxWidth(treeObj,rootNode[0],maxWidth);
			if(maxWidth==0){
				maxWidth = 220;
			}
			jQuery(".ztreeUlDiv").width(maxWidth);		
		},1000);
	}
	
	
	var zNodes =[];
	$(document).ready(function(){
		//初始化zTree
		
		$.fn.zTree.init($("#CustomTree"), setting, zNodes);
		maxWidth = jQuery(document).width();
		showWidth();
		
		var oTable1 = top.jQuery("#oTable1");
		if(oTable1.length>0){
			oTable1.height(top.window.document.body.clientHeight-5);
		}
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "field_0", null);
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	 
	    }

		//默认展开一级节点
	    if(firstclick==0&&expandfirstnode==1){
			$("#CustomTree_1_switch")[0].click();
			firstclick++;
	    }
	    
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setTreeField(treeNode);
	};

	function setTreeField(treeNode) {
		var url = "/formmode/tree/CustomTreeHrefAjax.jsp?mainid=<%=id%>&pid="+encodeURI(treeNode.id)+"&isRefreshTree=<%=isRefreshTree%>";
		jQuery.ajax({
			url : url,
			type : "post",
			processData : false,
			data : "",
			dataType : "text",
			async : true,
			success: function do4Success(msg){
				var returnurl = jQuery.trim(msg);
				
				if(returnurl==""){
					
				}else{//如果返回的url不为空，那么页面跳转
					//if(returnurl.toLowerCase().indexOf("http")>-1){
					//	$("#SearchForm").attr("method","get");
					//}else{
					//	$("#SearchForm").attr("method","post");
					//}
					//$("#SearchForm").attr("action",returnurl);
				   // $("#SearchForm")[0].submit();
				   if(parent.$("#contentframe").length>0){
					   parent.$("#contentframe").attr("src",encodeURI(returnurl));
				   }
				    
				}
			}
		});

	}
	
	function addDiyDom(treeId, treeNode) {
		var aObj = $("#" + treeNode.tId + "_a");
		if ($("#diySpan_"+treeNode.id).length>0) return;
		var editStr = "<span  style='float: right; color: rgb(0, 0, 0);width:20px;'>&nbsp;</span>"
			+"<span class='e8menu_num_block' style='float: right;' id='diySpan_" + treeNode.id
			+ "' title='"+treeNode.name+"' nodeid='"+treeNode.id+"'></span>";
		aObj.append(editStr);
		
	}


	
function refreshTree(id,lastnodeid,newid){
      var zTree = $.fn.zTree.getZTreeObj("CustomTree");
	  if("<%=isRefreshTree%>" == "1"){
	      var ids = id.split("_");
	      if(id=="" || ids[1]==""){
	          var currentNodes = zTree.getNodesByParam("id","0_0");//获得根节点
	          zTree.reAsyncChildNodes(currentNodes[0], "refresh");      
	      }else{
			  var currentNodes = zTree.getNodesByParam("id",id);
			  if(currentNodes.length > 0){			   
		          var parnetInfo = currentNodes[0].getParentNode();	
		          currentNodes[0] = parnetInfo;	                
		          currentNodes[0].isParent = true;
		          zTree.updateNode(currentNodes[0],true);
		          zTree.reAsyncChildNodes(currentNodes[0], "refresh");
		           if(parnetInfo){
		              if(parnetInfo.id != newid && parnetInfo != "" ){
		                  currentNodes[0] = zTree.getNodesByParam("id",newid)[0];
		                  currentNodes[0].isParent = true;
		                  zTree.updateNode(currentNodes[0],true);
		                  zTree.reAsyncChildNodes(currentNodes[0], "refresh");
		              }
		          }			
			      
			      var selectnodes = zTree.getSelectedNodes();
			      if(selectnodes.length>0){
					  var selectedNode = selectnodes[0];
					  var id = selectedNode.id;
					  setTimeout(function(){
					  	selectNodeById(zTree,id);	
					  },100);
			      }  
			  }
	      
	      }
	 }
}

function selectNodeById(zTree,id){
  var currentNodes = zTree.getNodesByParam("id",id);
  if(currentNodes.length==0){
  		setTimeout(function(){
		  	selectNodeById(zTree,id);	
		},100);
		return;
  }
  if(currentNodes.length>0){
  	  var currentNode = currentNodes[0];
	  zTree.selectNode(currentNode,true);	
  }
}

function refreshLastNode(zTree,lastnodeid){
  var currentNodes = zTree.getNodesByParam("id",lastnodeid);
  if(currentNodes.length==0){
  		setTimeout(function(){
		  	refreshLastNode(zTree,lastnodeid);	
		},100);
		return;
  }
  if(currentNodes.length>0){
  	  var currentNode = currentNodes[0];
	  zTree.reAsyncChildNodes(currentNode, "refresh");	
  }
}
	
//删除刷新
function delRefresh(){
    if("<%=isRefreshTree%>" == "1"){       
    	var zTree = $.fn.zTree.getZTreeObj("CustomTree"); 
        var selectnodes = zTree.getSelectedNodes();
        if(selectnodes == ""){
            var currentNodes = zTree.getNodesByParam("id","0_0");//获得根节点
	        zTree.reAsyncChildNodes(currentNodes[0], "refresh");  
        }else{
        	var selectedNode = selectnodes[0];
			var parentNode = selectedNode.getParentNode();
			var id = selectedNode.id;
			var parentNodeId = parentNode.id;			
	        zTree.reAsyncChildNodes(parentNode, "refresh");
	        setTimeout(function(){
				isLeafNode(zTree,id,parentNodeId);	
			},100);
        }
        
    }
}
   
//判断删除节点后该节点是不是叶子节点 如果是则改变parent属性
function isLeafNode(zTree,id,parentNodeId){
  var currentNodes = zTree.getNodesByParam("id",id);
  var parentNodes = zTree.getNodesByParam("id",parentNodeId);
  if(parentNodes.length != 0){
      var parentNode = parentNodes[0];
  	  zTree.reAsyncChildNodes(parentNode, "refresh");
	  if(parentNode.children.length=1){
	       parentNode.isParent = false;
	       zTree.updateNode(parentNode,true);
	       zTree.reAsyncChildNodes(parentNode, "refresh");
	       zTreeOnClick(event,parentNodeId,parentNode);
	  }	
  }
  
  if(currentNodes.length==0){
  		setTimeout(function(){
		  	isLeafNode(zTree,id);	
		},100);
		return;
  }
  if(currentNodes.length>0){
  	  var currentNode = currentNodes[0];
  	  zTree.reAsyncChildNodes(currentNode, "refresh");
	  if(currentNode.children.length=1){
	       currentNode.isParent = false;
	       zTree.updateNode(currentNode,true);
	       zTree.reAsyncChildNodes(currentNode, "refresh");
	  }	
  }
}

//快捷搜索
function quickSearch(){
   var url = "/formmode/tree/QuickSearchInfo.jsp?id=<%=id%>";
   var search = $("#searchValue").val(); 
   if(search != ""){
    jQuery.ajax({
				url:url,
				type:"post",
				dataType:"json",
				data:{search:search,root:"<%=rootname%>"},
				beforeSend:function(){
					$("#CustomTree").css("display","none"); 
					$("#searchLoad").css("display",""); 						
				},
				complete:function(xhr){
					$("#searchLoad").css("display","none");
				},
				success:function(data){
				   zNodes = data;
			       $("#overFlowDivTree").after("<ul id='CustomTree' class='ztree' style='padding-bottom: 0px;margin-top: 5px;'></ul>");
			       $("#overFlowDivTree").remove();         
			       $.fn.zTree.init($("#CustomTree"), setting, zNodes);
				   maxWidth = jQuery(document).width();
				   showWidth();	
				   var oTable1 = top.jQuery("#oTable1");
				   if(oTable1.length>0){
						 oTable1.height(top.window.document.body.clientHeight-5);
				    }
				   }
         })
    
    
    
   }else{
       $("#overFlowDivTree").after("<ul id='CustomTree' class='ztree' style='padding-bottom: 0px;margin-top: 5px;'></ul>");
       $("#overFlowDivTree").remove(); 
       zNodes = []; 
       $.fn.zTree.init($("#CustomTree"), setting, zNodes);
	   maxWidth = jQuery(document).width();
	   showWidth();	
	   var oTable1 = top.jQuery("#oTable1");
	   if(oTable1.length>0){
		  oTable1.height(top.window.document.body.clientHeight-5);
 	   }  
   }
}


function enterSearch(){
    var keyCode = null;
    if(event.keyCode){ 
        keyCode = event.keyCode; 
    }   
    if(keyCode == 13) {
        quickSearch();
        return false;
    }
    return true;
}

 

</SCRIPT>

<style>
	.ztree li a{
		width: auto;	
	}
	.e8HoverZtreeDiv{
		width: auto;
	}
	
	#overFlowDivTree{
		overflow-x:auto;
	}
</style>
</HTML>