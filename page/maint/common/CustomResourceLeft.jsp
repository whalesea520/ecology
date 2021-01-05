<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#dirtree").css("height", jQuery(document.body).height());
	});
}
</script>
<!-- end by cyril on 2008-12-29 for td:9831 -->
</HEAD>


<%

boolean canEdit=false;
if(HrmUserVarify.checkUserRight("homepage:Maint", user)){
	canEdit = true;
}

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String dir = Util.null2String(request.getParameter("dir"));
String isDialog = Util.null2String(request.getParameter("isDialog"));
String isSingle = Util.null2String(request.getParameter("isSingle"));
%>

<BODY style="background:#F8F8F8">
<FORM NAME=CustomResourcehForm STYLE="margin-bottom:0;width:100%;height:100%;" action="CustomResourceTabs.jsp" method=post target=contentlistframe>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="dir_content" class="flowMenusTd" style="overflow-y:auto;width:100%;height:100%">	
	<ul id="dirtree" class="ztree" style="background-color:#F8F8F8;overflow-x:hidden;padding:0px;" />
</div>
  <input class=inputstyle type="hidden" id="currentDir" name="currentDir" value="<%=dir%>">
  <input class=inputstyle type="hidden" id="dir" name="dir" value="<%=dir%>">
  <input class=inputstyle type="hidden" id="isDialog" name="isDialog" value="<%=isDialog%>">
  <input class=inputstyle type="hidden" id="isSingle" name="isSingle" value="<%=isSingle%>">
	<!--########//Search Table End########-->
</FORM>
<!-- for zTree -->
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/FilezTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<!-- for scrollbar -->
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
	function addHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		var scrolltop = 0;
		
		if(jQuery("#show_Div_"+tId).attr("class").indexOf("curSelectedNode")==-1)
			jQuery("#show_Div_"+tId).css({"background":"#DEF0FF"});
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").show();
		if (jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").length>0){
			return;
		}
		
		if(<%=canEdit%>){
		var	oprateStr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='/images/homepage/add_1_wev8.png' onclick=\"createDir('"+treeNode.name+"','"+treeNode.id+"','"+treeNode.dirrealpath+"');\" title='<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>' onmouseover=\"this.src='/images/homepage/add_2_wev8.png'\" onmouseout=\"this.src='/images/homepage/add_1_wev8.png'\"/>"+
			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='/images/homepage/edit_1_wev8.png' onclick=\"renameDir('"+treeNode.name+"','"+treeNode.id+"','"+treeNode.dirtype+"','"+treeNode.dirrealpath+"');\" title='<%=SystemEnv.getHtmlLabelName(84074,user.getLanguage())%>' onmouseover=\"this.src='/images/homepage/edit_2_wev8.png'\" onmouseout=\"this.src='/images/homepage/edit_1_wev8.png'\"/>"+
			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='/images/homepage/del_1_wev8.png' onclick=\"deleteDir('"+treeNode.name+"','"+treeNode.id+"','"+treeNode.dirtype+"','"+treeNode.dirrealpath+"');\" title='<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>' onmouseover=\"this.src='/images/homepage/del_2_wev8.png'\" onmouseout=\"this.src='/images/homepage/del_1_wev8.png'\"/>"+
			"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		
		jQuery(aObj).append(oprateStr);
		}
	}
	
	function removeHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		
		jQuery("#show_Div_"+tId).css({"background":"transparent"});
		if(jQuery("#show_Div_"+tId).attr("class").indexOf("curSelectedNode")!=-1)
			jQuery("#show_Div_"+tId).css({"background":"#0D93F6"});
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
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
		    	var aWidth = jQuery("#" + nodes[i].tId + "_a").width();
		    	if(aWidth<180 || aWidth==0){
		    		jQuery("#" + nodes[i].tId + "_a").width(228)
			    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
					.bind("mouseleave",function(){removeHoverDom(treeId, this);});
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
	    	return "CustomResourceListJSON.jsp?dir="+treeNode.dirrealpath+"&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "CustomResourceListJSON.jsp?dir=&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		callback: {
			onClick: setSelectDir,
			onAsyncSuccess: menuOnAsyncSuccess
		},			
		view: {
			showLine: false,
			showIcon: false,
			selectedMulti: false
		}
	};

	var zNodes =[];
	$(document).ready(function(){
		if(!$("#oTd1").is(":hidden"))
			$(".flowMenusTd").show();
		//初始化zTree
		$.fn.zTree.init($("#dirtree"), setting, zNodes);
	})
	
	function setSelectDir(event, treeId, treeNode){
		event = jQuery.event.fix(event);
		var obj = event.target;
		jQuery("li div a span").css({"color":"#333"});
	    jQuery("#file").val(treeNode.name);
	    jQuery("#dir").val(treeNode.dirrealpath);
	    jQuery("li div").css({"background":"transparent"})
	    jQuery("#show_Div_"+treeNode.tId).css({"background":"#0D93F6"})
	    .find("#"+treeNode.tId+"_span").css({"color":"#FFF"});
	    if(obj.tagName=="IMG")return;
	    document.CustomResourcehForm.submit();
	}
	
	function createDir(file,filedirid,dirrealpath){	 
	 	var title = "<%=SystemEnv.getHtmlLabelName(84075,user.getLanguage())%>"; 
	 	var url = "/page/maint/common/ImageDirEdit.jsp?method=createDir&currentDir=" + dirrealpath + "&date=" + new Date().getTime();
	 	showDialog(title,url,500,200,false);
	 	stopDefault(event);
	}
	
	function renameDir(file,filedirid,dirtype,dirrealpath){	
		if(dirtype=="sys"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84076,user.getLanguage())%>");
			return;
		}
	 	var title = "<%=SystemEnv.getHtmlLabelName(84074,user.getLanguage())%>"; 
	 	
	 	var url = "/page/maint/common/ImageDirEdit.jsp?method=renameDir&dirname="+file+"&currentDir=" + dirrealpath + "&date=" + new Date().getTime();
	 	showDialog(title,url,500,200,false);
	}
	
	//阻止事件(包括冒泡和默认行为)
	function stopDefault(e) {
	    if(e.preventDefault) {
	      e.preventDefault();
	      e.stopPropagation();
	    }else{
	      e.returnValue = false;
	      e.cancelBubble = true;
	    }
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
	
	function deleteDir(file,filedirid,dirtype,dirrealpath){
		if(dirtype=="sys"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84076,user.getLanguage())%>");
			return;
		}
	    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		    jQuery.post("/weaver/weaver.page.maint.common.CustomResourceServlet?method=deleteDir&currentDir=" + dirrealpath,
		    function(data){
		    	if(data.indexOf("SUCCESS")!=-1) location.reload();
		    	else alert("<%=SystemEnv.getHtmlLabelName(84077,user.getLanguage())%>");
		    });
	    });
	}


</script>
</BODY>
</HTML>