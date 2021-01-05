
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
	type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>

</HEAD>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(575,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
String opend = Util.null2String(request.getParameter("opend"));
String parentid = Util.null2String(request.getParameter("parentid"));
String sectors = Util.null2String(request.getParameter("sectors"));
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("EditSectorInfo:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),''} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("SectorInfo:Log", user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+145+",_self} " ;
    }else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:doLog(),_self} " ;
    }
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<%if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %>" class="e8_btn_top"  onclick="openDialog(0,'','','0')"/>&nbsp;&nbsp;
			<%}if(HrmUserVarify.checkUserRight("EditSectorInfo:Edit", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="onSave(this)"/>&nbsp;&nbsp;
			<%} %>
			&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<form name="frmAdd" method="post" action="SystemMenuMaintperation.jsp">
	<div id="menu_content" style="overflow:hidden;height:500px;">
		<ul id="menutree" class="ztree"  style="overflow: hidden;"></ul>
	</div>
</form>
</BODY>
</HTML>
<LINK REL=stylesheet type=text/css
	HREF=/wui/theme/ecology8/skins/default/wui_wev8.css>
<!-- for zTree -->
<!-- <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script> -->
<link rel="stylesheet"
	href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/CustomResourcezTreeStyle_wev8.css"
	type="text/css">
<script type="text/javascript"
	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
<script type="text/javascript"
	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript"
	src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<!-- for scrollbar -->
<link rel="stylesheet" type="text/css"
	href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<!--For zDialog-->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<!--For modalbox -->
<link rel="stylesheet" href="/js/modalbox/dhtmlwindow_wev8.css"
	type="text/css" />
<link rel="stylesheet" href="/js/modalbox/modal_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/modalbox/dhtmlwindow_wev8.js"></script>
<script type="text/javascript" src="/js/modalbox/modal_wev8.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		jQuery('#menu_content').perfectScrollbar();
		//jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
	});
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
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
					parent: true,
					leaf: false
				}
			},
			callback: {
				onAsyncSuccess: menuOnAsyncSuccess,
				beforeDrop: menuBeforeDrop,
				onDrop: menuOnDrop
			},
			check: {
				enable: false,       //启用checkbox或者radio
				autoCheckTrigger: true,
				chkStyle: "checkbox",  //check类型为checkbox
				chkboxType: { "Y" : "ps", "N" : "ps" } 
			},
			view: {
				showLine: false,
				showIcon: false,
				selectedMulti: false
			}
	};

	var zNodes =[];
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#menutree"), setting, zNodes);
	});

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/CRM/Maint/SectorInfoOperation.jsp?parentid="+treeNode.id+"&method=getTreeJson&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/CRM/Maint/SectorInfoOperation.jsp?parentid=0&method=getTreeJson&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	}
	var firstAsyncSuccessFlag = 0;
	var asyncflag = 1;
	function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
		var nodes; 
		var opend = "<%=opend%>";
		var sectors = "<%=sectors%>";
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		if(treeNode){
			nodes = treeNode.children;
		}else{
			nodes = zTree.getNodes();
		}
		var rei = 0;
		if(nodes){
			for (var i=0, l=nodes.length; i < l; i++) {
		    	jQuery("#" + nodes[i].tId + "_a").width(jQuery("#menutree").width()-35)
		    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
				.bind("mouseleave",function(){removeHoverDom(treeId, this);});
			}
		}
		jQuery('#menu_content').height(document.body.clientHeight);
		jQuery('#menu_content').perfectScrollbar('update');
		if(opend !="" && sectors != "")
		{
			var sec = sectors.split(",");
			for(var z=0;z<nodes.length;z++)
			{
				if(sec[asyncflag] != "" && sec[asyncflag] == nodes[z].id)
				{
					zTree.expandNode(nodes[z], true);  
					zTree.selectNode(nodes[z]);
				}
			}	
			asyncflag +=1;
		}
		
	}
	
	function menuBeforeDrop(treeId, treeNodes, targetNode, moveType) {
		if(treeNodes[0]){
			var viewIndex = 0;
			if(moveType=='inner') viewIndex = targetNode.viewIndex;
			else if(moveType=='prev') viewIndex = targetNode.viewIndex - 1;
			else if(moveType=='next') viewIndex = targetNode.viewIndex + 1;
			jQuery.post("SectorInfoOperation.jsp",
			{"operate":"menuDrag","moveType":moveType,
			"curMenuId":treeNodes[0].id,"tarMenuId":targetNode.id,
			"tarviewIndex":viewIndex,"tarparentId":targetNode.parentId},
			function (data){});
			return true;
		}
		return false;
	};
	
	
	
	function menuOnDrop(event, treeId, treeNodes, targetNode, moveType){
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		zTree.cancelSelectedNode(treeNodes[0]);
		if(moveType == "inner")
		{
			treeNodes[0].parentId = targetNode.id;
		}
		if(moveType == "next" || moveType == "prev")
		{
			treeNodes[0].parentId = targetNode.parentId;
		}
	}
	
	function addHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		var scrolltop = 0;

		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").show();
		if (jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").length>0){
			return;
		}
		
		var delStr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/del_1_wev8.png' onclick=\"doDel('"+treeNode.id+"');\" title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/del_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/del_1_wev8.png'\"/>";
		var oprateStr = "";
		oprateStr += "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/add_1_wev8.png' onclick=\"openDialog('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"','0');\" title='<%=SystemEnv.getHtmlLabelNames("82,605",user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/add_1_wev8.png'\"/>"+
			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/edit_1_wev8.png' onclick=\"openDialog('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"','1','"+treeNode.parentId+"');\" title='<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/edit_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/edit_1_wev8.png'\"/>";
		
		if(!treeNode.isParent)
			oprateStr += delStr;
			oprateStr += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		jQuery(aObj).append(oprateStr);
	}
	function removeHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		//$("#oprate_div_" +treeNode.id).hide();
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
		
	}
</script>

<script type="text/javascript">

	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	function openDialog(nodeid,treeid,nodename,isnew,parentid)
	{
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "";
		if(!!nodeid)
		{
			url = "/CRM/Maint/AddSectorInfo.jsp?parentid="+nodeid+"&parentname="+nodename;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(575 ,user.getLanguage()) %>:"+nodename;
		}
		else
		{
			url = "/CRM/Maint/AddSectorInfo.jsp";
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(575 ,user.getLanguage()) %>";
		}
		if(isnew=='1')
		{
			
			var url = "/CRM/Maint/EditSectorInfo.jsp?id="+nodeid;
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,575" ,user.getLanguage()) %>";
		}
		dialog.Width = 420;
		dialog.Height = 240;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//删除 add by Dracula @2014-1-26
	function doDel(id)
	{	
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
			jQuery.post("/CRM/Maint/SectorInfoOperation.jsp?method=delete&id="+id,function(msg){
				if(jQuery.trim(msg) !=""){
					window.top.Dialog.alert(msg);
				}else{
					location.reload();
				}
			});
		});
			
	}
	
	function onSave(obj)
	{
		obj.disabled=true;
	 	var str = onSaveJavaScript();
	 	jQuery.post("/CRM/Maint/SectorInfoOperation.jsp?menushowids="+str+"&method=sort",
	 	function(data){
	 		obj.disabled=false;
 			if(data.indexOf("OK")!=-1)
 				location.reload();
 		});
	}
	
	function onSaveJavaScript(){
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
	    var showStr = "^,^";
	    var nodes = treeObj.getCheckedNodes(false);
		for (var i=0; i<nodes.length; i++) {
			showStr = showStr+nodes[i].id+"||"+nodes[i].parentId+"^,^";
		}
		
	    return showStr;
	}
	
	//打开单条记录的日志
	function doLog(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem="+215;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>";
		dialog.Width = 600;
		dialog.Height =550;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
</script>



