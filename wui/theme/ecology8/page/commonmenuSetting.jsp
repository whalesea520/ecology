
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<jsp:useBean id="CompanyComInfo"
	class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String type = Util.null2String(request.getParameter("type"));// top left 
	String mode = Util.null2String(request.getParameter("mode")); //visible hidden 默认为hidden
	int resourceId = Util.getIntValue(request
			.getParameter("resourceId"), 0);
	String resourceType = Util.null2String((String) request
			.getParameter("resourceType"));
	String isCustom = Util
			.null2String(request.getParameter("isCustom"));

	String saved = Util.null2String(request.getParameter("saved"));
	int companyid = Util.getIntValue(request.getParameter("companyid"),
			0);
	int subCompanyId = Util.getIntValue(request
			.getParameter("subCompanyId"), 0);
	int sync = Util.getIntValue(request.getParameter("sync"), 0);
	
	//当前操作节点ID
	String selectids = Util.null2String(request.getParameter("selectids"));
	int userId = 0;
	userId = user.getUID();

	//判断总部菜单维护权限
	if (!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)) {
		if (companyid > 0 || "1".equals(resourceType)) {
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	} else {
		if (companyid == 0 && subCompanyId == 0 && resourceId == 0
				&& "".equals(resourceType))
			companyid = 1;
	}

	//判断分部菜单维护权限
	if (!HrmUserVarify.checkUserRight("SubMenu:Maint", user)) {
		if (subCompanyId > 0 || "2".equals(resourceType)) {
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	} else {
		CheckSubCompanyRight newCheck = new CheckSubCompanyRight();
		int[] subcomids = newCheck.getSubComByUserRightId(userId,
				"SubMenu:Maint");
		if (subCompanyId == 0 && companyid == 0 && resourceId == 0
				&& "".equals(resourceType)) {
			if (subcomids != null && subcomids.length > 0)
				subCompanyId = subcomids[0];
			else {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
		//for TD.4374
		if (subCompanyId > 0 && companyid == 0) {
			boolean tmpFlag = false;
			for (int i = 0; i < subcomids.length; i++) {
				if (subCompanyId == subcomids[i]) {
					tmpFlag = true;
					break;
				}
			}
			if (!tmpFlag) {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
	}

	if (companyid > 0 || subCompanyId > 0) {
		resourceId = (companyid > 0 ? companyid : subCompanyId);
		resourceType = (companyid > 0 ? "1" : "2");
	}
	//out.println("resourceId "+resourceId+" resourceType "+resourceType);

	String oldCheckedString = "";
	String oldIdString = "";

	String imagefilename = "/images/hdMaintenance_wev8.gif";

	String titlename = "";
	if ("left".equals(type))
		titlename = SystemEnv.getHtmlLabelName(17596, user
				.getLanguage());
	else if ("top".equals(type))
		titlename = SystemEnv.getHtmlLabelName(20611, user
				.getLanguage());

	String menuTitle = "";
	if (resourceType.equals("1")) {
		menuTitle = (Util.toScreen(CompanyComInfo.getCompanyname(""
				+ resourceId), user.getLanguage()));
	} else if (resourceType.equals("2")) {
		menuTitle = (Util
				.toScreen(SubCompanyComInfo.getSubCompanyname(""
						+ resourceId), user.getLanguage()));
	} else if (resourceType.equals("3")) {
		menuTitle = user.getLastname();
	}
	menuTitle="";
	//menuTitle=menuTitle+titlename;

	String needfav = "1";
	String needhelp = "";

	boolean isShowSyncInfo = false;

	if (resourceType.equals("2"))
		isShowSyncInfo = true;

	String ownerid = "";
	if ("1".equals(resourceType)) {/*总部 z* 分部 s*  个人 r*  */
		ownerid = "z" + resourceId;
	} else if ("2".equals(resourceType)) {
		ownerid = "s" + resourceId;
	} else if ("3".equals(resourceType)) {
		ownerid = "r" + resourceId;
	}
%>



<HTML>
	<HEAD>
		<TITLE>New Document</TITLE>
		<style id="thisStyle">
.clsTxt {
	display: none;
}

span {
	display: inline-block;
}

.spanTitle {
	font-size: 13px;
	font-weight: bold;
	height: 29px;
	line-height: 161%;
	position: absolute;
	top: 5px;
}

#closeBtn {
	position: absolute;
	top: 8px;
	right: 5px;
}

.checkbox_false_full{
	width:18px!important;
	height:18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_false_full_focus{
	width:18px!important;
	height:18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_true_full{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_true_full_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_true_part_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_true_part{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_wev8.gif")!important;
}

.checkbox_true_disable{
	width:18px!important;
	height:18px!important;
	background-position:0px -20px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_disabled_wev8.gif")!important;
}
.checkbox_false_disable{
	width:18px!important;
	height:18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/checkbox_disabled_wev8.gif")!important;
}
</style>

		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	</HEAD>
	<BODY style="overflow:hidden;">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32127, user.getLanguage()) %>"/> 
		</jsp:include>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
				
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"
						onclick="onSave(this)" />
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage()) %>" class="e8_btn_top"
						onclick="onClear(this)" />
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<%
			/*RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(1290, user.getLanguage())
					+ ",javascript:window.history.go(-1),_self} ";*/
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:onSave(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;

			//RCMenu += "{<span id=spanOrder>"+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"</span>,javascript:order(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;

			//RCMenu += "{<span id=spanExOrCo stat='co'>"+SystemEnv.getHtmlLabelName(20606,user.getLanguage())+"</span>,javascript:ExOrCo(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;

			if ("visible".equals(mode)) {
				//RCMenu += "{"+SystemEnv.getHtmlLabelName(20766,user.getLanguage())+",javascript:hiddenNoVisbleMenu(this),_self} " ;
				//RCMenuHeight += RCMenuHeightStep ;
			} else {
				//RCMenu += "{"+SystemEnv.getHtmlLabelName(20767,user.getLanguage())+",javascript:showNoVisbleMenu(this),_self} " ;
				//RCMenuHeight += RCMenuHeightStep ;			
			}
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(20608,user.getLanguage())+",javascript:synchAll(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="zDialog_div_content" class="zDialog_div_content"  style="overflow:hidden;">		
		<form name="frmAdd" method="post" action="commonmenuoperation.jsp">
			<div id="menu_content" style="overflow:hidden;height:500px;position:relative;">
				<ul id="menutree" class="ztree"  style="overflow: hidden;"></ul>
			</div>
		</form>
		<div id="show_Dialog"></div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
		</wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
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

<script type="text/javascript">
	$(document).ready(function(){
		jQuery('#menu_content').perfectScrollbar();
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		
	})
	
	function menuBeforeDrag(treeId, treeNodes){
		return treeNodes[0].canEdit
	}
	
	function menuBeforeDrop(treeId, treeNodes, targetNode, moveType) {
		if(treeNodes[0]){
			var viewIndex = 0;
			if(moveType=='inner') viewIndex = parseInt(targetNode.viewIndex);
			else if(moveType=='prev') viewIndex = parseInt(targetNode.viewIndex)>0?parseInt(targetNode.viewIndex)+1:parseInt(targetNode.viewIndex)-1;
			else if(moveType=='next') viewIndex = parseInt(targetNode.viewIndex)>0?parseInt(targetNode.viewIndex)-1:parseInt(targetNode.viewIndex)+1;
			jQuery.post("SystemMenuMaintoperation.jsp",
			{"type":"<%=type%>","operate":"menuDrag","moveType":moveType,
			"curMenuId":treeNodes[0].id,"tarMenuId":targetNode.id,
			"tarviewIndex":viewIndex,"tarparentId":targetNode.parentId,
			"resourceId":"<%=resourceId%>","resourceType":"<%=resourceType%>"},
			function (data){});
			return true;
		}
		return false;
	};
	
	function menuOnDrop(event, treeId, treeNodes, targetNode, moveType){
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		zTree.cancelSelectedNode(treeNodes[0]);
	}
	
	function addHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		var scrolltop = 0;
		
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").show();
		if (jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").length>0){
			return;
		}
		/*
		if(treeNode.canEdit){
			var delStr = treeNode.id<0?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/del_1_wev8.png' onclick=\"onDel('"+treeNode.id+"','"+treeNode.tId+"');\" title='<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/del_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/del_1_wev8.png'\"/>":"";
			var	oprateStr = "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/add_1_wev8.png' onclick=\"onAdd('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/add_1_wev8.png'\"/>"+
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/edit_1_wev8.png' onclick=\"onEdit('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/edit_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/edit_1_wev8.png'\"/>"+
				delStr+
				"&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/setting_1_wev8.png' onclick=\"onShare('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(33466, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/setting_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/setting_1_wev8.png'\"/>";
			jQuery(aObj).append(oprateStr);
		}else{
			var	oprateStr = "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/add_1_wev8.png' onclick=\"onAdd('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/add_1_wev8.png'\"/>"+
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			jQuery(aObj).append(oprateStr);
		}
		*/
	}
	
	function removeHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		//$("#oprate_div_" +treeNode.id).hide();
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
	}
	
	var selectids = "<%=selectids%>";//当前操作节点
	var ids = selectids.split(",");
	var flag = 1;
	function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		var nodes; 
		if(treeNode){
			nodes = treeNode.children;
		}else{
			nodes = zTree.getNodes();
		}
		if(nodes){
			for (var i=0, l=nodes.length; i < l; i++) {
		    	jQuery("#" + nodes[i].tId + "_a").width(jQuery("#menutree").width()-35)
		    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
				.bind("mouseleave",function(){removeHoverDom(treeId, this);});
				var n = nodes[i];
				if(n.checked){
					zTree.expandNode(n,true);
				}
			}
		}
		try{
			if(ids.length>1&&flag<=ids.length){
				var node = zTree.getNodeByParam("id", ids[flag], treeNode);
				zTree.expandNode(node,true);
				//zTree.selectNode(node);
				flag ++;
			}
		}catch(e){}
		jQuery('#menu_content').height(document.body.clientHeight-95);
		jQuery('#menu_content').perfectScrollbar('update');
		asyncAll();
	}
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/page/maint/menu/CommonMenuSettingListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid="+treeNode.id+"&mode=visible&e=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	//alert("/page/maint/menu/CommonMenuSettingListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid=0&mode=visible&e=" + new Date().getTime())
	    	return "/page/maint/menu/CommonMenuSettingListJSON.jsp?type=<%=type%>&resourceType=<%=resourceType%>&resourceId=<%=resourceId%>&parentid=0&mode=visible&e=" + new Date().getTime();
	    }
	};
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
					leaf: true
				}
			},
			callback: {
				onAsyncSuccess: menuOnAsyncSuccess,
				beforeDrop: menuBeforeDrop,
				onDrop: menuOnDrop,
				beforeDrag:menuBeforeDrag
				/*onClick: zTreeOnClick*/
			},
			check: {
				enable: true,       //启用checkbox或者radio
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
	
	function onSaveJavaScript(){
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		
	    var showStr = "0,";
	    var hideStr = "0,";
		var nodes = treeObj.getCheckedNodes(true);
		if (nodes != undefined || nodes != "" || nodes.length > 1) {
			for (var i=0; i<nodes.length; i++) {
				showStr = showStr+nodes[i].id+",";
			}
		}
		
		nodes = treeObj.getCheckedNodes(false);
		if (nodes != undefined || nodes != "" || nodes.length > 1) {
			for (var i=0; i<nodes.length; i++) {
				hideStr = hideStr+nodes[i].id+",";
			}
		}
	    return showStr + "^,^"+ hideStr;
	}

</script>

<script type="text/javascript">
	function onEdit(menuId,treeMenuId,menuText){
		var url="/systeminfo/menuconfig/MenuMaintenanceEdit.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&edit=sub&sync=1&subCompanyId=<%=subCompanyId%>&e=" + new Date().getTime();
		
		if(menuId>0) url="/systeminfo/menuconfig/CustomMenuName.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1&&subCompanyId=<%=subCompanyId%>e=" + new Date().getTime();
	 	
	 	var title = "<%=SystemEnv.getHtmlLabelName(20603, user.getLanguage())%>:"+menuText; 
	 	showDialog(title,url,600,380,false);
	}
	
	function onShare(menuId,treeMenuId,menuText){
		var url="/systeminfo/menuconfig/MenuMaintenanceShare.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&edit=sub&sync=1&subCompanyId=<%=subCompanyId%>&e=" + new Date().getTime();
		
	 	var title = "<%=SystemEnv.getHtmlLabelName(33466, user.getLanguage())%>:"+menuText; 
	 	showDialog(title,url,600,380,false);
	}


	function onAdd(parentMenuId,treeMenuId,parentMenuText){
		var url = "/systeminfo/menuconfig/MenuMaintenanceAdd.jsp?type=<%=type%>&id="+parentMenuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1&subCompanyId=<%=subCompanyId%>&e=" + new Date().getTime();;
	 	var title = "<%=SystemEnv.getHtmlLabelName(20604, user.getLanguage())%>:"+parentMenuText; 
		showDialog(title,url,600,380,false);	
	}
	
	function onLimitations(menuId,treeMenuId,menuText){
		var url="/page/maint/menu/SystemMenuMaintLimit.jsp?type=<%=type%>&menuId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	 	var title = "<%=SystemEnv.getHtmlLabelName(18574,user.getLanguage())%>:"+menuText; 
	 	showDialog(title,url,600,380,false);
	}
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}

	function zTreeOnClick(event, treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("menutree");
			zTree.expandNode(treeNode);
	}


   
   function  GetContent(url){	
	   jQuery.post(url,function(data){})
  	}

 function onClear(obj){
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81491,user.getLanguage())%>",function(){
		var zTree = $.fn.zTree.getZTreeObj("menutree");
	 	zTree.checkAllNodes(false);
		jQuery.post("commonmenuoperation.jsp?method=clear",
		 function(data){
	 		
		 });
	});
	 //alert(strArr[0]+" == "+strArr[1]);
	 
 }
 
 function onSave(obj){
 	 obj.disabled=true;
	 var str = onSaveJavaScript();
	 strArr = str.split("^,^");
	 //alert(strArr[0]+" == "+strArr[1]);
	 jQuery.post("commonmenuoperation.jsp?method=save&menushowids="+strArr[0],
	 function(data){
	 	obj.disabled=false;
	 	if(data.indexOf("OK")!=-1){
	 		parent.loadCommonMenu();
	 		onCancel();
	 	}else{
	 		alert(data);
	 	}
	 })
 }


function onCancel(){
	var dialog = parent.getDialog(window);
	dialog.close();
}

function asyncAll() {
			
	var zTree = $.fn.zTree.getZTreeObj("menutree");
	asyncNodes(zTree.getNodes());
}
function asyncNodes(nodes) {
	if (!nodes) return;
	//curStatus = "async";
	var zTree = $.fn.zTree.getZTreeObj("menutree");
	for (var i=0, l=nodes.length; i<l; i++) {
		if (nodes[i].isParent && nodes[i].zAsync) {
			asyncNodes(nodes[i].children);
		} else {
			goAsync = true;
			zTree.reAsyncChildNodes(nodes[i], "refresh", true);
		}
	}
}



</script>