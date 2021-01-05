<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.templetecheck.XMLUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- for zTree -->
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/CustomResourcezTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckConfigFile"	class="weaver.templetecheck.CheckConfigFile" scope="page" />


<%@ page import="weaver.conn.RecordSet" %>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}

$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("checkfile")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"XML树形结构"
    });
}); 
</script>
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String type = Util.null2String(request.getParameter("type"));// top left 
	String mode = Util.null2String(request.getParameter("mode")); //visible hidden 默认为hidden
	int resourceId = Util.getIntValue(request.getParameter("resourceId"), 1);
	//String resourceType = Util.getIntValue( request.getParameter("resourceType"),1)+"";
	String isCustom = Util.null2String(request.getParameter("isCustom"));

	String saved = Util.null2String(request.getParameter("saved"));
	int companyid = Util.getIntValue(request.getParameter("companyid"),0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), 0);
	int sync = Util.getIntValue(request.getParameter("sync"), 0);

	
	
	//当前操作节点ID
	String selectids = Util.null2String(request.getParameter("selectids"));
	int userId = 0;
	userId = user.getUID();
	String oldCheckedString = "";
	String oldIdString = "";

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";

	String needfav = "1";
	String needhelp = "";
	String menuTitle = "";

	boolean isShowSyncInfo = false;

// 	if (resourceType.equals("2"))
// 		isShowSyncInfo = true;

// 	String ownerid = "";
	
	String path = Util.null2String(request.getParameter("path"));//文件路径
	
	String content = Util.null2String(request.getParameter("content"));//配置内容
	String tabtype = Util.null2String(request.getParameter("tabtype"));
	String ruleid = Util.null2String(request.getParameter("ruleid"));



	
	//判断是否来自于配置文件信息维护 检测配置
	String from = Util.null2String(request.getParameter("from"));
	String detailid ="";
	if("checkconfig".equals(from)) {

		detailid = Util.null2String(request.getParameter("detailid"));
		RecordSet rs = new RecordSet();
		String sql = "select a.attrvalue,b.filepath from configXmlFile a,configFileManager b where b.isdelete=0 and a.configfileid = b.id and a.id="+detailid+" and a.attrvalue is not null "+(rs.getDBType().equals("oracle")?"":" and a.attrvalue <>'' ")+" order by b.filepath";
// 		String sql = "select a.attrvalue,b.filepath from configXmlFile a,configFileManager b where a.configfileid = b.id and a.issystem = '1' and a.id="+detailid+" and a.attrvalue is not null "+(rs.getDBType().equals("oracle")?"":" and a.attrvalue <>'' ")+" order by b.filepath";
		rs.execute(sql);
		if(rs.next()) {
			path = rs.getString("filepath");
		}
	} 
	
	String confirmnote = "请确认文件已做好备份，部分文件修改之后，需要重启服务才能生效";
	if(path!=null && path.indexOf("web.xml") > 0) {
		confirmnote += "<span style='color:red'>（web.xml修改之后将自动重启服务,需要重新登录系统）</span>";
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

.radio_false_full{
	width:18px!important;
	height:18px!important;
	background-position:0px 0px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_false_full_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px 0px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_true_full{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_true_full_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_true_part_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_true_part{
	width:18px!important;
	height:18px!important;
	background-position:0px -18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}

.radio_false_part{
	width:18px!important;
	height:18px!important;
	background-position:0px 0px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}
.radio_false_part_focus{
	width:18px!important;
	height:18px!important;
	background-position:0px 0px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_wev8.gif")!important;
}


.radio_true_disable{
	width:18px!important;
	height:18px!important;
	background-position:0px -20px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_disabled_wev8.png")!important;
}
.radio_false_disable{
	width:18px!important;
	height:18px!important;
	background-image: url("/js/ecology8/jNice/jNice/elements/radio_disabled_wev8.png")!important;
}
</style>

		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>
	<BODY style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
		RCMenu += "{"+"全部展开"+",javascript:expandall(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+"全部收缩"+",javascript:closeall(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmAdd" method="post">
			<div class="e8_box demo2">
					<div class="e8_boxhead">
					<div class="div_e8_xtree" id="div_e8_xtree"></div>
			        <div class="e8_tablogo" id="e8_tablogo"></div>
					<div class="e8_ultab">
							<div class="e8_navtab" id="e8_navtab">
								<span id="objName"></span>
							</div>
				
						</div>
					</div>
					<div class="tab_box">
			        <div>
			            <div id="menu_content" style="overflow:auto;overflow-y:auto;height:500px;position:relative;">
						<ul id="menutree" class="ztree"  style="overflow: hidden;"></ul>
						</div>
			        </div>
		    	</div>	    
			</div>
		</form>
		<div id="show_Dialog"></div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
  		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
						<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="确定">
	        			<input type="button" class=zd_btn_submit accessKey=T  id=btncancel onclick="btncancel_onclick();" value="取消">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	</BODY>
</HTML>


<script type="text/javascript">

	$(document).ready(function(){
		
		//隐藏树形结构滚动条
		$("#ascrail2000").hide();
		
		var docheight = $(document.body).height();
		var mheight = docheight*0.7;
		$("#menu_content").css("height",mheight+"px");
		window.onresize = adjust; 
	});
	function adjust() {
		var docheight = $(document.body).height();
		var mheight = docheight*0.7;
		$("#menu_content").css("height",mheight+"px");
	}
 
	
	function beforeDrop(treeId, treeNodes, targetNode, moveType) {
			return targetNode ? targetNode.drop !== false : true;
		}
	
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
		var	oprateStr = "";
		
		jQuery(aObj).append(oprateStr);
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

	var nodearrys = new  Array();
	//加载每个节点的操作菜单
	function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		var nodes; 
		
		if(treeNode){
			nodes = treeNode.children;
		}else{
			nodes = zTree.getNodes();
		}
		/*if(nodes){
			for (var i=0, l=nodes.length; i < l; i++) {
		    	jQuery("#" + nodes[i].tId + "_a").width(jQuery("#menutree").width()-35)
		    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
				.bind("mouseleave",function(){removeHoverDom(treeId, this);});
			}
		}
		*/
		//获得所有节点
		nodearrys.push(nodes[0]);
		getAllNode(nodes[0]);
		if(nodearrys){
			for (var i=0, l=nodearrys.length; i < l; i++) {
				var tId =  $(nodearrys[i]).attr("tId");
		    	jQuery("#" + tId + "_a").width(jQuery("#menutree").width()-35);
		    	jQuery("#" + tId + "_a").live("mouseenter",function(){addHoverDom("menutree",this);});
				jQuery("#" + tId + "_a").live("mouseleave",function(){removeHoverDom("menutree", this);});
			}
		}
		
		
		//jQuery('#menu_content').height(document.body.clientHeight-35);
		var docheight = $(document.body).height();
		var mheight = docheight*0.7;
		$("#menu_content").css("height",mheight+"px");
		jQuery('#menu_content').perfectScrollbar('update');
		
		 
		
	}
	
	function getAllNode(node) {
		if(node.children) {
			var childrennode = node.children;
			for(var i = 0;i < childrennode.length;i++) {
				var tnode = childrennode[i];
				nodearrys.push(tnode);
				if(tnode.children) {
					getAllNode(tnode);
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
	    	
	    	return "selectXmlNodeJson.jsp?parentid="+treeNode.id+"&mode=visible&path=<%=path.replace("\\","\\\\")%>&e=" + new Date().getTime()+"&from=<%=from%>";
	    } else {
	    	//初始化时
	    	return "selectXmlNodeJson.jsp?parentid=0&mode=visible&path=<%=path.replace("\\","\\\\")%>&e=" + new Date().getTime()+"&from=<%=from%>";
	    }
	};
	//zTree配置信息
	var setting = {
		//async: {
		//	enable: true,       //启用异步加载
		//	dataType: "text",   //ajax数据类型
		//	url: getAsyncUrl    //ajax的url
		//},
		edit: {
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false,
				drag: {
					prev: true,//menu移到上方,
					next: true,//menu移到上方,
					inner: false//menu成为子节点
				}
			},
			data: {
				keep: {
					parent: true,
					leaf: true
				},
				simpleData: {
					enable: true,
					idKey: "id",
					pIdKey: "parentId",
					rootPId: "root"//根节点的pid
				}

			},
			callback: {
				/*onClick: zTreeOnClick*/
			},
			check: {
				enable: true,       //启用checkbox或者radio
				autoCheckTrigger: true,
				chkStyle: "radio",  //check类型为checkbox
				radioType:"all",
				nocheckInherit: true,
				chkboxType: { "Y" : "ps", "N" : "ps" } 
			},
			view: {
				showLine: false,
				showIcon: false,
				selectedMulti: false,
				showTitle:false
			}
	};

	var zNodes =[];
	$(document).ready(function(){
		//初始化zTree
		$.ajax({
			url : "selectXmlNodeJson.jsp?parentid=0&mode=visible&path=<%=path.replace("\\","\\\\")%>&e=" + new Date().getTime()+"&from=<%=from%>",
			dataType : "json",
			success : function(data) {
				try {
					$.fn.zTree.init($("#menutree"), setting, data);
					menuOnAsyncSuccess(event, "menutree", "", "");
				} catch(e) {
					alert(e);
					top.Dialog.alert("文件加载失败！"); 
				}

				//var treeObj = $.fn.zTree.getZTreeObj("menutree");
			}
		});
	});
	
	function onSaveJavaScript(){
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		
	    var showStr = "";
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes != undefined || nodes != "" || nodes.length > 1) {
			for (var i=0; i<nodes.length; i++) {
				showStr = showStr+nodes[i].id+",";
			}
		}
	    return showStr;
	}
	
	function onSave() {
		var str = onSaveJavaScript();
		var strArr = str.split(",");
		if(strArr.length == 0) {
			top.Dialog.alert("请选择配置项的父节点");
			return;
		} else {
			top.Dialog.confirm("<%=confirmnote%>",function(){
				//更具选择的父节点，把配置写入xml文件
				var checkednode = strArr[0];
				
				$.ajax({
					url : "selectXmlNodeOperation.jsp",
					data : {
						nodeid : checkednode,
						detailid : "<%=detailid%>",
						tabtype : "<%=tabtype%>",
						ruleid : "<%=ruleid%>",
						path : "<%=path.replace("\\","\\\\")%>",
						from:"updateConfig"
					},
					dateType : "json",
					success : function(res){
						var data = eval("("+res+")");
						if("ok"==data.status) {
							if(<%=path!=null && path.indexOf("web.xml") > 0%>) {
								top.Dialog.alert("文件修改成功<span style=\"color:red;\">(稍后将自动重启)</span>");
								top.location ="/login/Login.jsp";
								return ;
							}
							top.Dialog.alert("文件修改成功");
							btncancel_onclick();
							return;
						} else {
							top.Dialog.alert("文件修改失败");
							btncancel_onclick();
							return;
						}
					}
				});
			});
		}
	}
	
	function btncancel_onclick() {
		if(dialog){
			parentWin._table.reLoad();
			dialog.closeByHand();
		}else{
			parentWin.closeDialog();
		}
		
	}
	
	//全部展开

	function expandall() {
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		treeObj.expandAll(true);
		var docheight = $(document.body).height();
		var mheight = docheight*0.7;
		$("#menu_content").css("height",mheight+"px");
	}
	
	function closeall() {
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		treeObj.expandAll(false);
	}

</script>

<script type="text/javascript">
	
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
 
 function onCancel(){
	if(dialog){
			dialog.close();
		}else{
	  	    window.parent.close();
	}  
}
</script>