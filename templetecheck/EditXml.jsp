<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.templetecheck.XMLUtil" %>
<%@ page import="weaver.templetecheck.FileUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}
 
</script>
<%

	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
	FileUtil fileUtil = new FileUtil();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";
	String menuTitle = "";
	
	String path = Util.null2String(request.getParameter("fpath"));//文件路径
	File file = new File(fileUtil.getPath(path));
	boolean filexists = true;
	boolean isxml = true;
	if(!file.exists()&&!"".equals(path)) {
		filexists = false;
	} else {
		XMLUtil xmlutil = new XMLUtil(path);
		if(xmlutil!=null) {
			String xmlstr = xmlutil.getXMLString();
			if(xmlstr != null) {
				isxml = true;
			}
		}
	}
	
	//读取配置文件，过滤部分不能编辑的文件
	String exclude = "";
	boolean excludestatus = true;
	try {
		Properties pro = new Properties();
		FileInputStream in = new FileInputStream(fileUtil.getPath(GCONST.getRootPath()+"templetecheck"+File.separatorChar+"exclude"+File.separatorChar+"exclude.properties"));
		pro.load(in);
		exclude = pro.getProperty("exclude");
		in.close();
	} catch(Exception e) {
		filexists = false;
		e.printStackTrace();
	}
	String[] excludeArr = exclude.split(",");
	for(int i = 0; i < excludeArr.length;i++) {
		String excludepath = excludeArr[i];
		excludepath  = excludepath.replaceAll("\\\\","/");//替换一个分隔符  防止windows和linux的环境不一样，存在差异
		String temppath = path.replaceAll("\\\\","/");//替换一个分隔符  防止windows和linux的环境不一样，存在差异
		
		if(temppath.indexOf(excludepath)>=0) {
			excludestatus = false;
			break;
		}
	}
	
	
	path  = path.replaceAll("\\\\","/");
	String confirmnote = "请确认文件已做好备份，部分文件修改之后，需要重启服务才能生效";
	if(path!=null && path.indexOf("web.xml") > 0) {
		confirmnote += "（web.xml修改之后将自动重启服务）";
	}
%>

<HTML>
	<HEAD>
		<TITLE>Edit Xml</TITLE>
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
.tab_box  {
	overflow:hidden!important;
}
</style>

</HEAD>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY style="overflow:hidden;">
	<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="编辑XML文件" />
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style='display:none;'>高级搜索</span>&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<div id="tabDiv" >
	   <span style="font-size:14px;font-weight:bold;"></span> 
	</div>
	<div class="cornerMenuDiv"></div>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>
	<form name="frmAdd" method="post">
	<wea:layout>
		<wea:group context="文件路径">
		<wea:item>文件路径<span style="color:red">（编辑前请先备份文件）</span></wea:item>
		<wea:item>
		<wea:required id="pathimage" required="true" value="<%=path %>">
			<input class="inputstyle" name="path" id="path" onchange='checkinput("path","pathimage")' value="<%=path%>"></input>
		</wea:required>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width:100%;max-width:120px!important;" class="e8_btn_top" value="显示XMl树形结构" onclick="showxmltree()"/>&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" id="expandbtn" style="width:100%;max-width:120px!important;<%if(path==null||"".equals(path)){%>display:none<%}%>" class="e8_btn_top" value="展开节点" onclick="expandall()"/>
		</wea:item>
		</wea:group>
	<wea:group context="XML树形结构">
	<wea:item attributes="{colspan:'full',id:'tableitem'}">
            <div id="menu_content" style="overflow:hidden;margin: 0 auto;margin-left:50px!important;">
			<ul id="menutree" class="ztree"  style="overflow:hidden;"></ul>
       		</div>
	</wea:item>
	</wea:group>
	</wea:layout>
	</form>
</div>
</BODY>
</HTML>


<script type="text/javascript">

	$(document).ready(function(){
		jQuery('#menu_content').perfectScrollbar();
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		$("#tableitem").removeClass("fieldName");
		
		var filexists = "<%=filexists%>";
		if("false" == filexists) {
			top.Dialog.alert("文件不存在");
			return;
		}
		
		var excludestatus = "<%=excludestatus%>";
		if("false" == excludestatus) {
			top.Dialog.alert("该文件无编辑权限，请手动编辑");
			return;
		}
		var isxml = "<%=isxml%>";
		if("false" == isxml) {
			top.Dialog.alert("XML文件格式错误");
			return;
		}
		window.onresize = adjust; 
	});
	
	function adjust() {
		var docheight = $(document.body).height();
		var mheight = docheight*0.7;
		$("#menu_content").css("height",mheight+"px");
	}
	
	//显示Xml文件属性结构
	function showxmltree() {
		var path = $("#path").val();

		if(""==path) {
			top.Dialog.alert("请输入文件路径");
			return;
		} else {
			if(path.indexOf(".xml") <= 0) {
				top.Dialog.alert("非XML文件");
				return;
			}
			window.location.href="EditXml.jsp?fpath="+path;
		}
		//显示“展开节点”按钮
		$("#expandbtn").show();
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
		var xpath = treeNode.xpath;
		
		if(treeNode.canEdit){
			var delStr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/del_1_wev8.png' onclick=\"onDel('"+treeNode.id+"','"+treeNode.tId+"');\" title='删除' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/del_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/del_1_wev8.png'\"/>";
			oprateStr = "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/add_1_wev8.png' onclick=\"onAdd('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='添加' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/add_1_wev8.png'\"/>"+
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/edit_1_wev8.png' onclick=\"onEdit('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='编辑' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/edit_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/edit_1_wev8.png'\"/>";
				if(treeNode.id=="root") {//根节点不能删除
					oprateStr = oprateStr+"<input type='hidden' id='xpath_"+treeNode.id+"' value=\""+xpath+"\"/>";
				} else {
					oprateStr = oprateStr + delStr+"<input type='hidden' id='xpath_"+treeNode.id+"' value=\""+xpath+"\"/>";
				}
				
			
		}else{
			oprateStr = "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/add_1_wev8.png' onclick=\"onAdd('"+treeNode.id+"','"+treeNode.tId+"','"+treeNode.name+"');\" title='添加' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/add_1_wev8.png'\"/>"+
				"<input type='hidden' id='xpath_"+treeNode.id+"' value=\""+xpath+"\"/>";
		}
		
		jQuery(aObj).append(oprateStr);
	}
	
	function removeHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		//$("#oprate_div_" +treeNode.id).hide();
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
	}
	
	var flag = 1;
	var nodearrys = new Array();
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
	
	//全部展开/收缩
	var i = 0;
	function expandall() {
		var treeObj = $.fn.zTree.getZTreeObj("menutree");
		if(i%2==0) {
			treeObj.expandAll(true);
			$("#expandbtn").val("全部收缩");
			var docheight = $(document.body).height();
			var mheight = docheight*0.7;
			$("#menu_content").css("height",mheight+"px");
		} else {
			treeObj.expandAll(false);
			$("#expandbtn").val("全部展开");
		}
		i++;
	}
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		var path = "<%=path%>";
		if(path == "") {
			return;
		}
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "selectXmlNodeJson.jsp?parentid="+treeNode.id+"&mode=visible&fpath=<%=path%>&isedit=true&e=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "selectXmlNodeJson.jsp?parentid=0&mode=visible&fpath=<%=path%>&isedit=true&e=" + new Date().getTime();
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
				//onAsyncSuccess: menuOnAsyncSuccess,
				/*onClick: zTreeOnClick*/
			},
			check: {
				enable: false,       //启用checkbox或者radio
				autoCheckTrigger: true,
				chkStyle: "checkbox",  //check类型为checkbox
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
		var fpath = "<%=path%>";
		if(fpath=="") {
			return;
		}
		var filexists = "<%=filexists%>";	
		var excludestatus = "<%=excludestatus%>";
		if(filexists&&excludestatus) {//文件已存在；并且有编辑权限才显示文件内容
			$.ajax({
				url : "selectXmlNodeJson.jsp?parentid=0&mode=visible&path=<%=path%>&isedit=true&e=" + new Date().getTime(),
				dataType : "json",
				success : function(data) {
					try {
						$.fn.zTree.init($("#menutree"), setting, data);
						menuOnAsyncSuccess(event, "menutree", "", "");
						
					} catch(e) {
						top.Dialog.alert("文件加载失败！");
					}

					//var treeObj = $.fn.zTree.getZTreeObj("menutree");
				}
			});
		}

		

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
						path : "<%=path%>",
					},
					dateType : "json",
					success : function(res){
						var data = eval("("+res+")");
						if("ok"==data.status) {
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
			dialog.closeByHand();
		}else{
			parentWin.closeDialog();
		}  
	}
	//删除节点
	function onDel(treeNodeid,treeNodetId) {
		top.Dialog.confirm("确定删除？",function(){
			var xpath = $("#xpath_"+treeNodeid).val();
			$.ajax({
				url : "EditXmlOperation.jsp",
				data :  {
					fpath : "<%=path%>",
					xpath : xpath,
					operate : "delete",
				},
				dateType : "json",
				success : function(res){
					var data = eval("("+res+")");
					var path = $("#path").val();
					if(data.status=="ok") {
						
						window.location.href="EditXml.jsp?fpath="+path;
						return;
					} else {
						
					}
				}
			});
		});
	}
	//编辑节点
	function onEdit(treeNodeid,treeNodetId) {
		var xpath = $("#xpath_"+treeNodeid).val();
		showDialog("编辑节点","/templetecheck/EditNode.jsp?isedit=1&xpath="+xpath+"&fpath=<%=path%>","800px","700px","500px");
	}
	//新增节点
	function onAdd(treeNodeid,treeNodetId) {
		var xpath = $("#xpath_"+treeNodeid).val();
		showDialog("新增子节点","/templetecheck/EditNode.jsp?isedit=0&xpath="+xpath+"&fpath=<%=path%>","800px","700px","500px");
	}
	
	

</script>

<script type="text/javascript">
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog;
		if(typeof dialog  == 'undefined' || dialog==null){
			Show_dialog = new window.top.Dialog();
		}
		
		//var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = 600;
	 	Show_dialog.Height = 550;
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
 
//屏蔽回车事件
$(document).keydown(function(event){
	  switch(event.keyCode){
	     case 13:return false; 
	     }
});
</script>