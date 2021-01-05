

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String id =Util.null2String(request.getParameter("id"));	
String menutype= Util.null2String(request.getParameter("menutype"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));

String closeDialog = Util.null2String(request.getParameter("closeDialog"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

//分权判断
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("portaldetachable")),0);
int operatelevel=-1;
boolean hasRight = false;
if(detachable==1){
 //   String deptid=ResourceComInfo.getDepartmentID(user.getUID()+"");
 //   String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid);
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HeadMenu:Maint",Util.getIntValue(subCompanyId));
    if(!(operatelevel>0))
    	operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"SubMenu:Maint",Util.getIntValue(subCompanyId));
}else{
	boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
	boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  
	if(HeadMenuhasRight || SubMenuRight){
		operatelevel=2;
		hasRight=true;
	}
}
if(!(operatelevel>0)){
	response.sendRedirect("/notice/noright.jsp") ;
}
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
//分权判断结束

	rs.executeSql("select * from menucenter where id='"+id+"'");
	rs.next();
	String menuname=rs.getString("menuname");
	String menudesc=rs.getString("menudesc");
	subCompanyId=rs.getString("subcompanyid");
	subCompanyId="".equals(subCompanyId)?"0":subCompanyId;
%>

<html>
  <head>

	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
  </head>
<body style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33497,user.getLanguage())%>"/> 
		</jsp:include>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%  
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
   	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(),_self} " ;
   	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onGoBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%
boolean isUsed =false; // 该菜单是否被使用
rs.execute("select id from hpelementsetting where name = 'menuIds' and value='"+id+"'");
if(rs.next()){
	isUsed = true;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onSave(this)">
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

<form method="post" action="MenuOperate.jsp" name="frmEdit">
<input type="hidden" name="method" id="method" value="edit">
<input type="hidden" name="menuid" value="<%=id%>">
<input type="hidden" name="isUsed" id="isUsed" value="<%=isUsed %>">
<textarea id='txtNodes' name='txtNodes' style="width:100%;height:300px;display:none"></textarea>
	<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
      <wea:item>
        <wea:required id="menunamespan" required="true" value='<%=menuname%>'>
         <input type="text" class="inputstyle" id="menuname" name="menuname" value="<%=menuname%>"/>
         </wea:required>
         <span id="checkTitleName" style="color: red;display: none;">(<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>)</span><!-- 标题已经存在 -->
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
      <wea:item>
         <input type="text" class="inputstyle" id="menudesc" name="menudesc" value="<%=menudesc%>"/>
      </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(19054,user.getLanguage())%></wea:item>
      <wea:item>
         <select id="menutype" name="menutype" style="width:90px;" onchange="changeMenutype(this.value);">
			<option value="1" <%="1".equals(menutype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23021,user.getLanguage())%></option>
			<option value="2" <%="2".equals(menutype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(23022,user.getLanguage())%></option>
		</select>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
      
      <wea:item>
        <select id="subType" style="float:left;width:90px;" onchange="changeSubType(this.value);">
			<option value="1" <%=!"0".equals(subCompanyId)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(81649,user.getLanguage())%></option>
			<option value="0" <%="0".equals(subCompanyId)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32646,user.getLanguage())%></option>
		</select>
		<span id="subCompanySpan" style="float:left;margin-left:10px;"> 
		<brow:browser viewType="0" name="subCompanyId" browserValue='<%=subCompanyId %>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subCompanyId) %>'></brow:browser>
		</span>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(33525,user.getLanguage())%></wea:item>
      <wea:item>
         <div id="menu_content" style="height:340px">
			<ul id="menutree" class="ztree"  style="overflow: hidden;padding:0;"></ul>
		</div>
      </wea:item>
     </wea:group>
</wea:layout>
</form>
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
</body>
</html>
<!-- for scrollbar -->
<link rel="stylesheet" type="text/css"
	href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript"
	src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<!-- for zTree -->
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/CustomResourcezTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
var checkField = "menuname";
	$(document).ready(function(){
		if("<%=menutype%>"=="1")jQuery("#outsubCompanyIddiv").parents("TR:first").hide();
		else checkField="menuname,subCompanyId";
		if("<%=subCompanyId%>"=="0"){
			checkField = "menuname";
			jQuery("#subCompanySpan").hide();
		}
		resizeDialog(document);
		//jQuery('#menu_content').perfectScrollbar();

		var closeDialog = "<%=closeDialog%>";
		if(closeDialog=="close"){
			var dialog = parent.getDialog(window);
			//parentWin.location.reload();
			dialog.currentWindow.location.reload();
			onCancel();
		}
	});
	
	jQuery('#menu_content').perfectScrollbar();
	
	function onCancel(){
		var dialog = parent.getDialog(window);
		dialog.close();
	}
	
	function onDelMenu(id,menuid){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			jQuery.post("/page/maint/menu/MenuOperate.jsp?method=delMenu&menuid="+menuid+"&id="+id,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onAddMenu(id,menuid){
		var title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>";
		var url = "/page/maint/menu/MenuEditInfo.jsp?method=addMenu&menutype=<%=menutype%>&menuid="+menuid+"&id="+id;
		showDialog(title,url,600,500,false);
	}
	
	function onEditMenu(id,menuid){
		var title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>";
		var url = "/page/maint/menu/MenuEditInfo.jsp?method=editMenu&menutype=<%=menutype%>&menuid="+menuid+"&id="+id;
		showDialog(title,url,600,500,false);
	}
	
	function onShare(menuId,customid,menuText){
		var url="/systeminfo/menuconfig/MenuMaintenanceShare.jsp?type=custom&customid="+customid+"&id="+menuId+"&resourceId=1&resourceType=3&edit=sub&sync=1&subCompanyId=<%=subCompanyId%>&e=" + new Date().getTime();
		
	 	var title = "<%=SystemEnv.getHtmlLabelName(33466, user.getLanguage())%>:"+menuText; 
	 	showDialog(title,url,650,380,false);
	}
	
	
	function onLink(menuId,link){
		window.open(link);
	}
	
	function changeSubType(value){
		if(value=="0"){
			checkField = "menuname";
			jQuery("#subCompanyId").val("0");
	        jQuery("#subcompanyid_span").html("");
			jQuery("#subCompanySpan").hide();
		}else if(value=="1"){
			checkField="menuname,subCompanyId";
			jQuery("#subCompanySpan").show();
		}
	}
	
	function changeMenutype(value){
		if(value=="1"){
			checkField = "menuname";
			jQuery("#subCompanyId").val("-1");
	        jQuery("#subcompanyid_span").html("");
			jQuery("#outsubCompanyIddiv").parents("TR:first").hide();
		}else if(value=="2"){
			checkField="menuname,subCompanyId";
			jQuery("#outsubCompanyIddiv").parents("TR:first").show();
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

	function addHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		var scrolltop = 0;

		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").show();
		if (jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").length>0){
			return;
		}
		
		var	oprateStr = "<img style=\"margin-left:40px;\" z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/add_1_wev8.png' onclick=\"onAddMenu('"+treeNode.id+"','"+treeNode.menutype+"');\" title='<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/add_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/add_1_wev8.png'\"/>";
		if(treeNode.id!=0){
			oprateStr += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/edit_1_wev8.png' onclick=\"onEditMenu('"+treeNode.id+"','"+treeNode.menutype+"');\" title='<%=SystemEnv.getHtmlLabelName(26473, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/edit_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/edit_1_wev8.png'\"/>";
			if("<%=menutype%>"=="2")oprateStr += "&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/setting_1_wev8.png' onclick=\"onShare('"+treeNode.id+"','"+treeNode.menutype+"','"+treeNode.name+"');\" title='<%=SystemEnv.getHtmlLabelName(33466, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/setting_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/setting_1_wev8.png'\"/>";
			if(!treeNode.isParent&&treeNode.id!=1)oprateStr +="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/del_1_wev8.png' onclick=\"onDelMenu('"+treeNode.id+"','"+treeNode.menutype+"');\" title='<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/del_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/del_1_wev8.png'\"/>";
			if(treeNode.menuhref!=""&&treeNode.menuhref!="#")
				oprateStr+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img z_tree=\"oprate_div_"+treeNode.id+"\" src='<%=basePath%>/images/homepage/menu/link_1_wev8.png' onclick=\"onLink('"+treeNode.id+"','"+treeNode.menuhref+"');\" title='<%=SystemEnv.getHtmlLabelName(16208, user.getLanguage())%>' onmouseover=\"this.src='<%=basePath%>/images/homepage/menu/link_2_wev8.png'\" onmouseout=\"this.src='<%=basePath%>/images/homepage/menu/link_1_wev8.png'\"/>";
		}
		jQuery(aObj).append(oprateStr);
	}
	
	function removeHoverDom(treeId, aObj){
		var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
		var treeNode = $.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
		//$("#oprate_div_" +treeNode.id).hide();
		jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
	}
	var firstAsyncSuccessFlag=0;
	function menuOnAsyncSuccess(event, treeId, treeNode, msg) {
		if(firstAsyncSuccessFlag==0){
			try{
				var zTree = $.fn.zTree.getZTreeObj(treeId);
				var selectNode = zTree.getSelectedNodes();
				var nodes = zTree.getNodes();
				zTree.expandNode(nodes[0],true);
				firstAsyncSuccessFlag = 1;
			}catch(e){}
		}
		var nodes; 
		if(treeNode){
			nodes = treeNode.children;			
		}else{
			var zTree = $.fn.zTree.getZTreeObj(treeId);
			nodes = zTree.getNodes();
		}
		
		if(nodes){
			for (var i=0, l=nodes.length; i < l; i++) {
		    		//$("#" + nodes[i].tId + "_a").width(jQuery("#"+treeId).width()-20);
		    		jQuery("#" + nodes[i].tId + "_a").width(500)
			    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
					.bind("mouseleave",function(){removeHoverDom(treeId, this);});
			}
		}
		//jQuery('#menu_content').height(document.body.clientHeight-80);
		//jQuery('#menu_content').perfectScrollbar('update');
	}

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {	    	
	    	return "/page/maint/menu/MenuTreeGet.jsp?typeid="+treeNode.menutype+"&parentid="+treeNode.id+"&e=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/page/maint/menu/MenuTreeGet.jsp?typeid=<%=id%>&parentid=0&isroot=1&e=" + new Date().getTime();
	    }
	};
	
	function menuBeforeDrag(treeId, treeNodes){
		return treeNodes[0].canEdit
	}
	
	function menuBeforeDrop(treeId, treeNodes, targetNode, moveType) {
		if(moveType=='inner'){
			return false;
		}
		if(treeNodes[0]){
			var canMove = false;
			var srcParentId = treeNodes[0].parentId;
			var targetParentId= targetNode.parentId;
			
			
			if(srcParentId == targetParentId){ // 同级				
				return true;
			
			}else{
				return false;
			}
		}
		return false;
	};
	
	function menuOnDrop(event, treeId, treeNodes, targetNode, moveType){
		var srcIndex = parseInt(treeNodes[0].menuindex);
		var menuindex = parseInt(targetNode.menuindex);
			//移动后节点所在位置:上移节点前，下移节点后
		if(srcIndex > menuindex){
			if(treeNodes[0] == targetNode.getNextNode()){//节点后
				targetNode = treeNodes[0].getNextNode();
			}
		}else{
			if(treeNodes[0] == targetNode.getPreNode()){//节点后
				targetNode = treeNodes[0].getPreNode();
			}
		}
		srcIndex = parseInt(treeNodes[0].menuindex);
		menuindex = parseInt(targetNode.menuindex);
		var srcParentId = treeNodes[0].parentId;
		var targetParentId= targetNode.parentId;
		jQuery.post("MenuOperate.jsp",
		{"type":"<%=id%>","method":"menuDrag",
		"menuid":treeNodes[0].id,"srcindex":srcIndex,
		"targetindex":menuindex,"parentid":srcParentId},
		function (data){});
		if(menuindex>=srcIndex){
			$(targetNode).attr("menuindex", menuindex-1);
			$(treeNodes[0]).attr("menuindex", menuindex);
		}else{
			$(targetNode).attr("menuindex", menuindex+1);
			$(treeNodes[0]).attr("menuindex", menuindex);
		}
		var zTree = $.fn.zTree.getZTreeObj(treeId);
		zTree.cancelSelectedNode(treeNodes[0]); 
	}
	
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
				inner: false//menu成为子节点
			}
		},
		callback: {
			//onClick: setSelectDir,
			onAsyncSuccess: menuOnAsyncSuccess,
			beforeDrop: menuBeforeDrop,
			onDrop: menuOnDrop,
			beforeDrag:menuBeforeDrag
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
	})
	
	function onSave(obj){		
		if(check_form(document.frmEdit,checkField)){
		    var menuname=$("#menuname").val();
		    if(menuname!="<%=menuname%>"){
		       //验证标题是否存在
		       $.post("MenuOperate.jsp?method=checkMenuName&subCompanyId=<%=subCompanyId %>&menutype=<%=menutype%>&menuname="+menuname,{},function(data){
			     if($.trim(data)=="false"){ //不存在
			        saveMenu(obj);
			        $("#checkTitleName").hide();
			     }
			     else
				    $("#checkTitleName").show();
		       });
		    }else
		         saveMenu(obj);
		}
	}

    function saveMenu(obj){
		obj.disabled=true;
		frmEdit.submit();
    }

	function onDel(){	
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			if($("#isUsed").val()=="true"){
				alert("<%=SystemEnv.getHtmlLabelName(22688,user.getLanguage())%>")
				return;
			}
			$("#method").val("del");
			frmEdit.submit();		
		})
	}
</SCRIPT>
