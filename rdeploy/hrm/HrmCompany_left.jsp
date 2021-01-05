<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.JSONArray"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<style>
.ztree li span.button.add {
    background-image:url("/rdeploy/assets/img/hrm/addDept.png");
    margin-left: 2px;
    margin-right: 0px;
}
.ztree li span.button.edit1 {
    background-image:url("/rdeploy/assets/img/hrm/edit.png");
    margin-left: 2px;
    margin-right: 0px;
}
.ztree li span.button.remove1 {
    background-image:url("/rdeploy/assets/img/hrm/deleteDept.png");
    margin-left: 2px;
    margin-right: 0px;
}
.ztree li span.button.add1 {
    background-image:url("/rdeploy/assets/img/hrm/addDept.png");
    margin-left: 2px;
    margin-right: 0px;
}
.ztree li span.button.noline_close {
    background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
}
.ztree li span.button.noline_open  {
    background: rgba(0, 0, 0, 0) none repeat scroll 0 0;
}
.ztree li a.curSelectedNode{
	width: 100%;
	height:35px!important;
	margin-left:-500px;
	padding-left:500px;
	padding-top: 1px!important;
}
.ztree li a{
    max-height:35px;
    min-height:35px;
}
.ztree li span {
    color:#545454;
}

</style>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />

	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.core-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.excheck-3.5.min_wev8.js"></script>
	<script type="text/javascript" src="js/jquery.ztree.exedit-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/jquery.ztree.exhide-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/hrm/ztree/js/ajaxmanager_wev8.js"></script>
	<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
			<link rel="stylesheet" href="/hrm/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
function showE8TypeOption(closed){
	if(closed){
		jQuery("#e8TypeOption").hide();
	}else{
		jQuery("#e8TypeOption").toggle();
	}
	if(jQuery("#e8TypeOption").css("display")=="none"){
		jQuery("span.leftType").removeClass("leftTypeSel");
		var src = jQuery("#currentImg").attr("src");
		if(src){
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
	}else{
		jQuery("span.leftType").addClass("leftTypeSel");
		jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+10);
		var src = jQuery("#currentImg").attr("src");
		if(src){
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
	}
	return;
}
</script>
<style>
</style>
</HEAD>
<%
String rightStr=Util.null2String(request.getParameter("rightStr"));
String zxnodeid = Util.null2String(request.getParameter("nodeid"));

String nodeid = "1";

String sumcomId = Util.null2String(request.getParameter("subcomid"));

boolean isHrmAdmim = true;

if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
    isHrmAdmim =false;
}

boolean isDeptAdmim = false;

if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
    isDeptAdmim =true;
}
%>
<BODY onclick="window.parent.closeInfo();">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=HrmCompanyDsp&id=1&fromHrmTab=1" method=post target="contentframe">
<table style="height: 100%;width: 100%;">
	<tr>
		<td style="max-height: 600px;">
			<div id="scrollcontainer" style="overflow:hidden;height:auto;">
			   <div style="height:100%;">
				<div class="zTreeDemoBackground left">
				 <ul id="treeDemo" class="ztree" style="height: 100%;max-height: 600px;"></ul>
				</div>
			   </div>
			</div>
		</td>
	</tr>
	<% if(isHrmAdmim){ %>
	<tr>
		<td id="menu2" style="padding-left: 22px;height: 37px;padding-top: 0px;">
		  <a href="javascript:search(2)" style="color:#545454;"><img src="/rdeploy/assets/img/hrm/wenhao.png"  align="absMiddle"> <%=SystemEnv.getHtmlLabelName(125177,user.getLanguage())%></a>
		</td>
	</tr>
	<tr>
		<td id="menu3" style="padding-left: 22px;height: 37px;color:#545454;">
			<a href="javascript:search(3)" style="color:#545454;"><img src="/rdeploy/assets/img/hrm/newuser.png" align="absMiddle"> <%=SystemEnv.getHtmlLabelName(125178 ,user.getLanguage())%></a>
		</td>
	</tr>
	<tr>
		<td id="menu4"  style="padding-left: 22px;height: 37px;color:#545454;">
			<a href="javascript:search(4)" style="color:#545454;"><img src="/rdeploy/assets/img/hrm/wuxiao.png"  align="absMiddle"><%=SystemEnv.getHtmlLabelName(125179 ,user.getLanguage())%></a>
		</td>
	</tr>
	<%} %>
</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="id" >  
  <input class=inputstyle type="hidden" name="type" >  
  <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="1">
	<!--########//Search Table End########-->
	</FORM>
<script language="javascript">
var cxtree_id = "";
		var virtualtype = "";	
		//zTree配置信息
		var setting = {
			async: {
				enable: true,       //启用异步加载
				dataType: "text",   //ajax数据类型
				url: getAsyncUrl    //ajax的url
			},
			check: {
				enable: true,       //启用checkbox或者radio
				chkStyle: "checkbox",  //check类型为radio
				radioType: "all",   //radio选择范围
				chkboxType: { "Y" : "", "N" : "" } 
			},
			view: {
				expandSpeed: "",   //效果
				fontCss: getFont,
				showTitle: false,
				nameIsHTML: true,
				showLine: false,
				dblClickExpand: false,
				addDiyDom: addDiyDom,
				<% if(isDeptAdmim){%>
				addHoverDom: addHoverDom,
				<%}%>
				removeHoverDom: removeHoverDom
			},
			callback: {
			  <% if(isDeptAdmim){%>
				onClick: zTreeOnClick,   //节点点击事件
				//onCheck: zTreeOnCheck,
				//onDblClick:zTreeOnDblClick,
				//onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
				beforeRemove: beforeRemove,
				beforeEditName: beforeEditName,
				beforeRename: beforeRename
				<%}else{%>
				onClick: zTreeOnClick
				<%}%>
			}
			<% if(isDeptAdmim){%>
			,edit: {
				removeTitle: "<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
				renameTitle: "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>",
				enable: true,
				editNameSelectAll: false,
				showRemoveBtn: true,
				showRenameBtn: true,
				showAddBtn: true
			}
			<%}%>
		};
		
		var log, className = "dark";
		/**
		 * 获取url（alax方式获得子节点时使用）
		 */
		function getAsyncUrl(treeId, treeNode) {
			var alllevel = jQuery("#alllevel").val();
			    if (treeNode && treeNode.isParent) {
			    	return "hrmtreeXML.jsp?f_weaver_belongto_userid=&f_weaver_belongto_usertype=&sqlwhere=&selectedids=&id=" + treeNode.id + "&type="+treeNode.type+"&alllevel=" +alllevel+"&isNoAccount=&"+ new Date().getTime() + "=" + new Date().getTime();
			    } else {
			    	//初始化时
			    	return "hrmtreeXML.jsp?subcomid=<%=sumcomId %>";
			    }
				
		};
		
		var newCount = 1;
		var thisTreeNode;
		function addHoverDom(treeId, treeNode) {
		    var thisClass = "add";
			var sObj = $("#" + treeNode.tId + "_span");
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span class='button "+thisClass+"' id='addBtn_" + treeNode.tId
				+ "' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>' onfocus='this.blur();'></span>";
			sObj.after(addStr);
			var btn = $("#addBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				thisTreeNode = treeNode;
				deptAdd(treeNode.name,treeNode.id,treeNode.type);
				//var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				//zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:"new node" + (newCount++)});
				return false;
			});
		};
		function removeHoverDom(treeId, treeNode) {
			$("#addBtn_"+treeNode.tId).unbind().remove();
		};
		var thisEditTreeNode;
		function beforeEditName(treeId, treeNode) {
			//className = (className === "dark" ? "":"dark");
			//showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.selectNode(treeNode);
			thisEditTreeNode = treeNode;
			deptEdit(treeNode,treeNode.getParentNode());
			return false;
		}
		function beforeRemove(treeId, treeNode) {
			
			
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.selectNode(treeNode);
			onDelete(treeId, treeNode ,zTree); 
			return false;
			//return parent.Dialog().confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
		}
		
		function makeSure(treeId, treeNode ,zTree){
		   window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125180,user.getLanguage())%> "+ treeNode.name + "<%=SystemEnv.getHtmlLabelName(84498,user.getLanguage())%>",function(){
				$.ajax({
					 data:{"departmentname":treeNode.name,"id":treeNode.id,"other":"<%=user.getUID()%>"},
					 type: "post",
					 cache:false,
					 url:"RdDeptOperationAjax.jsp",
					 dataType: 'json',
					 success:function(data){
						 if(data.success == "0"){
							   zTree.removeNode(treeNode);
						 }else{
						 	 if(data.flag == "1"){
							 	 window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125181,user.getLanguage())%>");
						 	 }else if(data.flag == "2"){
							 	 window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125182,user.getLanguage())%>");
						 	 }else{
							 	 window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125183,user.getLanguage())%>");
						 	 }
						 }
					}	
			    });
				return true;
			},function(){
				return false;
			});
		}
		function onDelete(treeId, treeNode ,zTree){
				//jQuery(".curSelectedNode").css("background-color","");
				//jQuery(".curSelectedNode").removeClass("curSelectedNode");
				Validator.departmentIsUsed(treeNode.id,function checkHasChildDepartmentCallback(data){
			 	if(data){
			 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33594, user.getLanguage())%>");
		             return;
			 	}
				 Validator.checkHasJob(treeNode.id,function checkHasJobCallback(data){
				 	if(data){
				 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81685, user.getLanguage())%>");
			             return;
				 	}
				 	Validator.checkHasChildDepartment(treeNode.id,function checkHasChildDepartmentCallback(data){
				 	if(data){
				 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82376, user.getLanguage())%>");
			             return;
				 	}
				 	makeSure(treeId, treeNode, zTree);
				 }) ;
				
				 }) ;
			 }) ;
		}
		function beforeRename(treeId, treeNode, newName, isCancel) {
			//className = (className === "dark" ? "":"dark");
			//showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
			if (newName.length == 0) {
				//alert("节点名称不能为空.");
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				setTimeout(function(){zTree.editName(treeNode)}, 10);
				return false;
			}
			return true;
		}
		
	  function getFont(treeId, node) {
			return node.font ? node.font : {};
		}
	 function addDiyDom(treeId, treeNode) {
		if (treeNode.type == "com") {
			if(virtualtypedatas==null)return;
			var aObj = $("#" + treeNode.tId + "_a");
			var editStr = "<select class='selDemo' id='diyBtn_" +treeNode.id+ "'>";			
			for(var i=0;i<virtualtypedatas.length;i++){
				if(virtualtype==virtualtypedatas[i].id){
					editStr+="<option value='"+virtualtypedatas[i].id+"' selected>"+virtualtypedatas[i].name+"</option>";
				}
				else
					editStr+="<option value='"+virtualtypedatas[i].id+"'>"+virtualtypedatas[i].name+"</option>";
			}
			editStr+="</select>";
			aObj.after(editStr);
			beautySelect(jQuery(".selDemo"));
			$("#" + treeNode.tId + "_span").hide();
			$("#" + treeNode.tId + "_a").attr('style','display : inline');
			var btn = $("#diyBtn_"+treeNode.id);
		  if (btn) btn.bind("change", function(){changeVirtualType(jQuery(this).val());});
		}
	}
var selectNode;
function zTreeOnClick(event, treeId, treeNode) {
		selectNode = treeNode;
		//if(!event.ctrlKey){
			//清除之前所选节点
		//	var treeObj = $.fn.zTree.getZTreeObj(treeId);
		//	nodes = treeObj.getCheckedNodes(true);
		//	for (var j=0, l=nodes.length; j<l; j++) {
		//		var node = nodes[j];
		//		$("#" + node.tId+"_a").attr('style','background-color : #ffffff'); 
		//		//$("#" + node.tId + "_a").attr('style','display : inline');
		//		treeObj.checkNode(node, false, true);
		//	}
		//}
	   // 用于解决双击时候会调用两次单击事件的问题
    if (treeNode.clickTimeout) {
        clearTimeout(treeNode.clickTimeout);
        treeNode.clickTimeout = null;
    } else {
        treeNode.clickTimeout = setTimeout(function() {
            triggerNodeClick(treeId, treeNode);
            treeNode.clickTimeout = null;
        }, 250);
    }
	};

	function triggerNodeClick(treeId, treeNode){
		for(var i=2;i<5;i++){
	    	jQuery("#menu"+i).css("background-color","");
		}
		window.parent.closeInfo();
		if(treeNode.type == "com"){
			setSubcompany(treeNode.id);
		}else if(treeNode.type == "subcom"){
			setSubcompany(treeNode.id);
		}else{
			setDepartment(treeNode.id);
		}
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
	  if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		//if(treeNode.checked){
			//treeObj.checkNode(treeNode, false, true);
			//$("#" + treeNode.tId+"_a").attr('style','background-color : #ffffff;');  
		//}else{
			//treeObj.checkNode(treeNode, true, true);
			//$("#" + treeNode.tId+"_a").attr('style','background-color : #dff1ff;margin-left:-500px;padding-left:500px;width: 100%;'); 
		//}
		//jsBtnChange();
	}
	
	function jsBtnChange(){
			var container = $("#colShow");	
			var tabid = $("#tabid").val();				 
			var srcitemschecked = null;
			var srcitems = null;
			//最近、组织结构、常用组 
			/*
   		if(tabid==0||tabid==3||tabid==4){
   			jQuery("#singleArrowTo").attr('style','margin-top : 165px'); 
   			jQuery("#multiArrowFrom").attr('style','margin-top : 160px'); 
   		}else{
   			jQuery("#singleArrowTo").attr('style','margin-top : 135px'); 
   			jQuery("#multiArrowTo").attr('style','margin-top : 135px'); 
   		}*/
     		
			if(tabid==3||tabid==4){
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				srcitemschecked = treeObj.getCheckedNodes(true);
				srcitems = treeObj.getNodes();
				jQuery("#multiArrowTo").hide();
			}else{
				srcitemschecked = container.find("input[type='checkbox'][name='srcitem']:checked");
				srcitems = container.find("input[type='checkbox'][name='srcitem']");
			}			
			var destitemschecked = container.find("input[type='checkbox'][name='destitem']:checked");
			var destitems = container.find("input[type='checkbox'][name='destitem']");
			
			//alert("srcitems=="+srcitems.length+"destitem=="+destitems.length);
			//console.log("srcitems=="+srcitems.length+"destitem=="+destitem.length);
			if(srcitemschecked.length>0){
				jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4-h_wev8.png");
			}else{
		  	jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4_wev8.png");
		  }
		  if(srcitems.length>0){
				jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6-h_wev8.png");
			}else{
		  	jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6_wev8.png");
		  }
		  
		  if(destitemschecked.length>0){
				jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5-h_wev8.png");
			}else{
		  	jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5_wev8.png");
		  }
		  
			if(destitems.length>0){
				jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7-h_wev8.png");
			}else{
		  	jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7_wev8.png");
		  }
		  
		}
function initTree(){
 $.fn.zTree.init($("#treeDemo"), setting); 	

}
var virtualtypedatas = null;

$(function(){
    initTree();
     jQuery('#scrollcontainer').perfectScrollbar();
});




function changeShowType(obj,showtype){
	var title = jQuery(obj).find(".e8text").html();
	var title1 = jQuery(obj).find(".e8text").attr("title");
	jQuery("#optionSpan").html(title);
	jQuery("#optionSpan").attr("title",title1);
	jQuery("#virtualtype").val(showtype);
	jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
	jQuery("span[id^='showspan']").each(function(){
		jQuery(this).addClass("e8imgSel");
	});
	jQuery("#showspan"+showtype).removeClass("e8imgSel");
	showE8TypeOption();
	initTree();
	setCompany("com_"+showtype);
}
	
function showcom(node){
}
function check(node){
}


function setCompany(nodeid){
	comid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	document.all("departmentid").value="";
	document.all("subCompanyId").value="";
	//document.all("id").value=comid;
	document.all("tabid").value=0;
	document.all("type").value=1;
	var virtualtype = jQuery("#virtualtype").val();
	if(virtualtype=="1"){
		document.SearchForm.action="HrmResourceList.jsp";
	}else{
		document.SearchForm.action="HrmResourceList.jsp";
	}
	//document.SearchForm.submit();
}

function setSubcompany(nodeid){ 
	subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	document.all("companyid").value="";
	document.all("departmentid").value="";
	document.all("subCompanyId").value=subid;
	document.all("tabid").value=0;
	document.all("id").value="";
	document.all("type").value=1;
	var virtualtype = jQuery("#virtualtype").val();
	if(virtualtype=="1"){
		document.SearchForm.action="HrmResourceList.jsp";
	}else{
		document.SearchForm.action="HrmResourceList.jsp";
	}
	document.SearchForm.submit();
}

function setDepartment(nodeid){
	if(document.all("id").value == nodeid){
		return ;
	}
	deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	document.all("subCompanyId").value="";
	document.all("companyid").value="";
	document.all("departmentid").value=deptid;
	document.all("tabid").value=0;
	document.all("id").value=deptid;
	document.all("type").value=1;
	var virtualtype = jQuery("#virtualtype").val();
	if(virtualtype=="1"){
		document.SearchForm.action="HrmResourceList.jsp";
	}else{
		document.SearchForm.action="HrmResourceList.jsp";
	}
	document.SearchForm.submit();
}









	var dialog = null;
	var depName ="";
	var supDepName = "";
function deptAdd(deptName,supdepid,type){
		if(type == "subcom"){
			supdepid = 0;
		}
		supDepName = deptName;
		
		if(dialog==null){
			dialog = new window.top.Dialog();
		}
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,124",user.getLanguage())%>";
	    dialog.URL = "hrm/RdDeptAdd.jsp?supName="+deptName+"&subcompanyid1=<%=sumcomId %>&supdepid="+supdepid+"&type="+type+"&method=add";
		dialog.Width = 390;
		dialog.Height = 220;
		dialog.Drag = true;
		dialog.normalDialog = false;
		dialog.textAlign = "center";
		dialog.show();
	}
	
function deptEdit(treenode,supnode){ 
		var supdepid = supnode.id;
		if(supnode.type == "subcom"){
			supdepid = 0;
		}
		supDepName = supnode.name;
		
		if(dialog==null){
			dialog = new window.top.Dialog();
		}
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,124",user.getLanguage())%>";
	    dialog.URL = "hrm/RdDeptAdd.jsp?id="+treenode.id+"&departmentname="+treenode.name+"&supName="+supnode.name+"&subcompanyid1=<%=sumcomId %>&supdepid="+supdepid+"&method=edit";
		dialog.Width = 390;
		dialog.Height = 220;
		dialog.Drag = true;
		dialog.normalDialog = false;
		dialog.textAlign = "center";
		dialog.show();
	}
	
function getNewDeptId(id,subId){
	var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	zTree.addNodes(thisTreeNode, {id:id, pId:subId, name:depName,type:"dept",icon:"#"});
}

function setEditDeptValue(name){
	var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	thisEditTreeNode.name = name;
	zTree.updateNode(thisEditTreeNode);
}


function getdepName(){
	return depName;
}
function setdepName(name){
	depName=name;
}
function getSupdepName(){
	return supDepName;
}

var arrayl=[2,3,4];
function search(state){
	document.all("subCompanyId").value="";
	document.all("companyid").value="";
	document.all("departmentid").value="";
	document.all("tabid").value=0;
	document.all("id").value="";
	document.all("type").value=state;
	document.SearchForm.action="HrmResourceList.jsp";
	document.SearchForm.submit();
	
	window.parent.closeInfo();
	for(var i=2;i<5;i++){
	  if(state == i){
	    jQuery("#menu"+i).css("background-color","#dff1ff");
	  }else{
	    jQuery("#menu"+i).css("background-color","");
	  }
	}
	//jQuery(".curSelectedNode").css("background-color","");
	jQuery(".curSelectedNode").removeClass("curSelectedNode");
	
}
</script>
</BODY>
</HTML>