
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
	String type = Util.null2String(request.getParameter("type"));// top left 
	String mode = Util.null2String(request.getParameter("mode"));  //visible hidden 默认为hidden
	int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
    String resourceType = Util.null2String((String)request.getParameter("resourceType"));
	String isCustom = Util.null2String(request.getParameter("isCustom"));


	String saved = Util.null2String(request.getParameter("saved"));
    int companyid = Util.getIntValue(request.getParameter("companyid"),0);
    int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int sync = Util.getIntValue(request.getParameter("sync"),0);

	
    
   
    
    int userId = 0;
    userId = user.getUID();
    
    //判断总部菜单维护权限
    if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
    	if(companyid>0||"1".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	if(companyid==0&&subCompanyId==0&&resourceId==0&&"".equals(resourceType)) companyid = 1;
    }
    
    //判断分部菜单维护权限
    if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    	if(subCompanyId>0||"2".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	CheckSubCompanyRight newCheck = new CheckSubCompanyRight();
    	int[] subcomids = newCheck.getSubComByUserRightId(userId,"SubMenu:Maint");
    	if(subCompanyId==0&&companyid==0&&resourceId==0&&"".equals(resourceType)){
        	if(subcomids!=null&&subcomids.length>0) subCompanyId = subcomids[0];
        	else {
        		response.sendRedirect("/notice/noright.jsp");
                return;
        	}
    	}
    	//for TD.4374
    	if(subCompanyId>0&&companyid==0){
	    	boolean tmpFlag = false;
	    	for(int i=0;i<subcomids.length;i++){
	    		if(subCompanyId == subcomids[i]){
	    			tmpFlag = true;
	    			break;
	    		}
	    	}
	    	if(!tmpFlag) {
	    		response.sendRedirect("/notice/noright.jsp");
	            return;
	    	}
    	}
    }

    if(companyid>0||subCompanyId>0){
    	resourceId = (companyid>0?companyid:subCompanyId);
    	resourceType = (companyid>0?"1":"2");
    }


    String oldCheckedString = "";
    String oldIdString = "";

    String imagefilename = "/images/hdMaintenance_wev8.gif";

	

	String titlename="";
	if("left".equals(type))		titlename=SystemEnv.getHtmlLabelName(17596,user.getLanguage());
	else if("top".equals(type))		titlename=SystemEnv.getHtmlLabelName(20611,user.getLanguage());


	String menuTitle="";
    if(resourceType.equals("1")) {
		menuTitle= (Util.toScreen(CompanyComInfo.getCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("2")){
		menuTitle = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("3")) {
		menuTitle = user.getLastname();
	}

	//menuTitle=menuTitle+titlename;

    
    String needfav = "1";
    String needhelp = "";

    boolean isShowSyncInfo = false;
    
    if(resourceType.equals("2")) isShowSyncInfo = true;


	String ownerid="";
		 if("1".equals(resourceType)){/*总部 z* 分部 s*  个人 r*  */
			ownerid="z" + resourceId;
		} else if("2".equals(resourceType)){
			ownerid="s" + resourceId;
		}else if("3".equals(resourceType)){
			ownerid="r" + resourceId;
		}	

	
    
%>



<HTML>
 <HEAD>
   <TITLE> New Document </TITLE>
	<style  id="thisStyle">
		.clsTxt{
			display:none;
		}
		span{
			display: inline-block;
		}
		.spanTitle{
			font-size: 13px;
			font-weight: bold;
			height: 29px;
			line-height: 161%;
			position: absolute;
			top: 5px;
		}
		#closeBtn{
			position: absolute;
			top: 8px;
			right: 5px;
		}
	</style>

	<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
 </HEAD>
 <BODY>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="75px">					
				</td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(84129,user.getLanguage())%>" class="btn batchSubmit middle" onclick="synchAll();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(84130,user.getLanguage())%>" class="btn batchSubmit middle" onclick="onAdd('0','null','<%=menuTitle %>');" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="btn batchSubmit middle" onclick="onSave(this)"/>
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:12px;font-weight:bold;display:inline-block;display:-moz-inline-stack;line-height:40px;width:156px;text-align:center;"><%=menuTitle+" "+SystemEnv.getHtmlLabelName(32127,user.getLanguage()) %></span> 
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">

		</div>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		

		RCMenu += "{<span id=spanOrder>"+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"</span>,javascript:order(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		

		RCMenu += "{<span id=spanExOrCo stat='co'>"+SystemEnv.getHtmlLabelName(20606,user.getLanguage())+"</span>,javascript:ExOrCo(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		if("visible".equals(mode)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(20766,user.getLanguage())+",javascript:hiddenNoVisbleMenu(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		} else {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(20767,user.getLanguage())+",javascript:showNoVisbleMenu(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;			
		}
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(20608,user.getLanguage())+",javascript:synchAll(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form name="frmAdd" method="post" action="SystemMenuMaintperation.jsp">		
	<div  id="menu_head" style="overflow:hidden;">
	    <div id="menu_content" style="overflow:hidden;">	
			<ul id="menutree" class="ztree" style="background-color:#FFFFFF;overflow:hidden;" ></ul>
		</div>
	</div>		
	</form>

 </BODY>
</HTML>
	<LINK REL=stylesheet type=text/css HREF=/wui/theme/ecology8/skins/default/wui_wev8.css>
	<!-- for zTree -->
    <!-- <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script> -->
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.exedit.min_wev8.js"></script>
	<!-- for scrollbar -->
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
	<!--For modalbox -->
	<link rel="stylesheet" href="/js/modalbox/dhtmlwindow_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/js/modalbox/modal_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/modalbox/dhtmlwindow_wev8.js"></script>
	<script type="text/javascript" src="/js/modalbox/modal_wev8.js"></script>
	
<script type="text/javascript">
	$(document).ready(function(){
		jQuery('#menu_head').perfectScrollbar();
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	})
	
	function menuBeforeDrop(treeId, treeNodes, targetNode, moveType) {
		if(treeNodes[0]){
			var viewIndex = 0;
			if(moveType=='inner') viewIndex = targetNode.viewIndex;
			else if(moveType=='prev') viewIndex = targetNode.viewIndex - 1;
			else if(moveType=='next') viewIndex = targetNode.viewIndex + 1;
			jQuery.post("SystemMenuMaintoperation.jsp",
			{"type":"top","operate":"menuDrag","moveType":moveType,
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
		//zTree.updateNode(treeNodes[0]);
		//zTree.updateNode(targetNode);
		//zTree.reAsyncChildNodes(null, "refresh");
		
	}
	
	function addHoverDom(treeId, treeNode){
		var aObj = $("#" + treeNode.tId + "_a");
		$("#oprate_div_" +treeNode.id).css("display","inline-block");
		if ($("#oprate_div_"+treeNode.id).length>0) return;
		var delStr = treeNode.id<0?"<a onclick=\"onDel('"+treeNode.id+"','"+treeNode.tId+"');\" title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>'><span class='operHoverSpan operHover_hand operHoverSpan_hover'>&nbsp;<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>&nbsp;</span></a>":"<a title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>'><span class='operHoverSpan operHoverSpan_hover'>&nbsp;<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>&nbsp;</span></a>";
		var oprateStr = "<div id='oprate_div_"+treeNode.id+"' style='margin-left: 176px;display:none' class='hoverDiv'>&nbsp;&nbsp;&nbsp;"+
			"<a onclick=\"onAdd('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>'><span class='operHoverSpan operHover_hand operHoverSpan_hover'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>&nbsp;</span></a>"+
			"<a onclick=\"onEdit('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %>'><span class='operHoverSpan operHover_hand operHoverSpan_hover'>&nbsp;<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %>&nbsp;</span></a>"+
			delStr+
			"<a onclick=\"onLimitations('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(33466,user.getLanguage()) %>'><span class='operHoverSpan operHover_hand operHoverSpan_hover'>&nbsp;<%=SystemEnv.getHtmlLabelName(33466,user.getLanguage()) %>&nbsp;</span></a>";
		aObj.append(oprateStr);
		$("#oprate_div_" +treeNode.id).css("display","inline-block");
	}
	
	function removeHoverDom(treeId, treeNode){
		$("#oprate_div_" +treeNode.id).hide();
		if ($("#oprate_div_"+treeNode.id).length>0) return;
	}
	
	function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
		var nodes; 
		if(treeNode){
			nodes = treeNode.children;			
		}else{
			var zTree = $.fn.zTree.getZTreeObj(treeId);
			nodes = zTree.getNodes();
		}
		if(nodes){
			for (var i=0, l=nodes.length; i < l; i++) {
		    	if($("#" + nodes[i].tId + "_a").width()<180){
		    		$("#" + nodes[i].tId + "_a").width($("#" + nodes[i].tId).width()-56);
		    	}
			}
		}
	}	
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=1&resourceId=1&parentid="+treeNode.id+"&mode=visible&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "SystemMenuMaintListJSON.jsp?type=<%=type%>&resourceType=1&resourceId=1&parentid=0&mode=visible&" + new Date().getTime() + "=" + new Date().getTime();
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
				onDrop: menuOnDrop
			},
			check: {
				enable: true,       //启用checkbox或者radio
				autoCheckTrigger: true,
				chkStyle: "checkbox",  //check类型为checkbox
				chkboxType: { "Y" : "ps", "N" : "ps" } 
			},
			view: {
				addHoverDom:addHoverDom,
				removeHoverDom: removeHoverDom,
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
		
	    var showStr = "";
	    var hideStr = "";
		var nodes = treeObj.getCheckedNodes(false);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		for (var i=0; i<nodes.length; i++) {
			hideStr = hideStr+nodes[i].id+",";
		}
		nodes = treeObj.getCheckedNodes(true);
		for (var i=0; i<nodes.length; i++) {
			showStr = showStr+nodes[i].id+",";
		}
	    return showStr + "^,^"+ hideStr;
	}

</script>

<script type="text/javascript">
	var addwin,editwin,Limitationswin;
	function onEdit(menuId,treeMenuId,menuText){
		var url="/systeminfo/menuconfig/MenuMaintenanceEdit.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&edit=sub&sync=1";
		
		if(menuId<0) url="/systeminfo/menuconfig/CustomMenuName.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1";
		
		editwin=dhtmlmodal.open("agreebox", "iframe", url, "<%=SystemEnv.getHtmlLabelName(20603,user.getLanguage())%>:"+menuText, "width=500px,height=310px,center=1,resize=1,scrolling=0", "recal") ; 
		
		editwin.onclose=function(){	
			var sText=this.contentDoc.getElementById("sText").value;
			var iconUrl=this.contentDoc.getElementById("iconUrl").value;
			document.getElementById(treeMenuId+"_span").innerHTML=sText;
			if(iconUrl!="" && iconUrl!=null)	document.getElementById(treeMenuId+"_ico").src=iconUrl;
			return true;
		}
	}



	function onAdd(parentMenuId,treeMenuId,parentMenuText){
		addwin=dhtmlmodal.open("agreebox", "iframe", "/systeminfo/menuconfig/MenuMaintenanceAdd.jsp?type=<%=type%>&id="+parentMenuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1", "<%=SystemEnv.getHtmlLabelName(20604,user.getLanguage())%>:"+parentMenuText, "width=500px,height=310px,center=1,resize=1,scrolling=0", "recal")

		addwin.onclose=function(){ 			
			var sText=this.contentDoc.getElementById("sText").value;
			var sIcon=this.contentDoc.getElementById("sIcon").value;
			var curMenuid=this.contentDoc.getElementById("curMenuid").value;
			var linkAddress=this.contentDoc.getElementById("linkAddress").value;	
			var customMenuViewIndex=this.contentDoc.getElementById("customMenuViewIndex").value;
			
			var treeObj = $.fn.zTree.getZTreeObj("menutree");
			var node = treeObj.getNodeByTId(treeMenuId);
			var newNode = {"id":curMenuid,"name":sText,"icon":sIcon,"linkAddress":linkAddress,"viewIndex":customMenuViewIndex};
			newNode = treeObj.addNodes(node, newNode);
			
			return true;
		}
			
	}
	
	function onLimitations(menuId,treeMenuId,menuText){
		var url="SystemMenuMaintLimit.jsp?type=<%=type%>&menuId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
		Limitationswin = dhtmlmodal.open("agreebox", "iframe", url, "<%=SystemEnv.getHtmlLabelName(33466,user.getLanguage())%>:"+menuText, "width=500px,height=310px,center=1,resize=1,scrolling=0", "recal") ;
		Limitationswin.onclose=function(){ return true;}
	}


	function onDel(menuId,treeMenuId){
		if(isdel()){
			var treeObj = $.fn.zTree.getZTreeObj("menutree");
			var thisNode=treeObj.getNodeByTId(treeMenuId);			
				if(thisNode.isParent){
					if(confirm("<%=SystemEnv.getHtmlLabelName(20830,user.getLanguage())%>")){
						GetContent("/systeminfo/menuconfig/MenuMaintenanceOperation.jsp?type=top&infoId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&method=delthisall");
						treeObj.removeChildNodes(thisNode);
						treeObj.removeNode(thisNode);
					}
				} else {
					GetContent("/systeminfo/menuconfig/MenuMaintenanceOperation.jsp?type=top&infoId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&method=del");
					treeObj.removeNode(thisNode);
				}
		}
	}

	function isdel(){
		var str = "<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>?";
	   if(!confirm(str)){
		   return false;
	   }
       return true;
   }
   
   function  GetContent(url){	
	   jQuery.post(url,function(data){})
  	}

 function onSave(obj){
	 obj.disabled=true;
	 var str = onSaveJavaScript();
	 
	 strArr = str.split("^,^");
	 //alert(strArr[0]+" == "+strArr[1]);
	 jQuery.post("SystemMenuMaintoperation.jsp?menushowids="+strArr[0]+"&menuhideids="+strArr[1]+"&operate=isvisible&type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>",function(data){obj.disabled=false;})
 }



  function order(obj){
		var style=document.styleSheets["thisStyle"].rules[0].style.display;
		if(style=="none"){
			document.styleSheets["thisStyle"].rules[0].style.display='';
			obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(20605,user.getLanguage())%>";
		}else {
			document.styleSheets["thisStyle"].rules[0].style.display='none';
			obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>";
		}
  }


   function  ExOrCo(obj){
	   var objSpan=obj.lastChild;
	   if(objSpan.stat=="co") {
			objSpan.stat="ex";
		    var treeObj = $.fn.zTree.getZTreeObj("menutree");
			treeObj.expandAll(true);
			objSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(20607,user.getLanguage())%>";
	   } else {
			objSpan.stat="co";
			var treeObj = $.fn.zTree.getZTreeObj("menutree");
			treeObj.expandAll(false);
			objSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(20606,user.getLanguage())%>";
	   }

   }

 function synchAll(obj){
	 if(confirm("<%=SystemEnv.getHtmlLabelName(20764,user.getLanguage())%>")) {
		 obj.disabled=true;
		 window.location="MenuMaintenanceOperation.jsp?type=<%=type%>&resourceId=<%=subCompanyId%>&subCompanyId=<%=subCompanyId%>&resourceType=<%=resourceType%>&isCustom=<%=isCustom%>&chkSynch=1&mode=synchall"	
	 }
 }
</script>




