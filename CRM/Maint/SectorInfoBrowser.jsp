<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
 	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</HEAD>

<%
int uid=user.getUID();
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(575,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY style="overflow:hidden;">

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("575",user.getLanguage()) %>'/>
</jsp:include>

<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=0 type=submit onclick="onSave();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

                                          
 <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	<ul id="ztreedeep" class="ztree"></ul>
</div>   
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=o  id=btnclear value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave();">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick()">
				<input type="button" accessKey=1  id=btnclear value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
	   		</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		window.E8EXCEPTHEIGHT = 40;
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

</BODY></HTML>
<script language=javascript>

	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}


	
	var appendimg = 'Home';
	var appendname = 'selObj';
	var allselect = "all";
	var cxtree_id = "";
	
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
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "radio",  //check类型为radio
			radioType: "all",   //radio选择范围
		},
		view: {
				expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
	};


	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
	}
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnValue = {id:returnVBArray[0], name:returnVBArray[1]};
	        if(dialog){
				try{
		            dialog.callback(returnValue);
		      	}catch(e){}
		      	 
			  	try{
			       dialog.close(returnValue);
			   	}catch(e){}
			}else{
	     		window.parent.parent.returnValue = returnValue;
		 		window.parent.parent.close();
			}
	    } else {
	         dialog.close()
		}
    }
    function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		for (var i=0; i<nodes.length; i++) {
			nameStr = nodes[i].id;
			idStr = nodes[i].name;
		}
	    var resultStr = nameStr;
	    
		resultStr = resultStr + "$" + idStr;
	    return resultStr;
	}
	
	function btnclear_onclick(){
	    var returnValue = {id:"",name:""};
		if(dialog){
		try{
            dialog.callback(returnValue);
	       }catch(e){}
		  	try{
		       dialog.close(returnValue);
		   }catch(e){}
		}else{
			window.parent.returnValue = returnValue;
			window.parent.close();
		}
	}
</script>
