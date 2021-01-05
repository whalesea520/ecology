
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />

<%

String excludeId=Util.null2String(request.getParameter("excludeId"));

String keywordId=Util.null2String(request.getParameter("keywordId"));

String nodeid="keyword_"+keywordId;

boolean exist=false;

String keywordName=WorkflowKeywordComInfo.getKeywordName(keywordId);
if(!keywordName.equals("")){
	exist=true;
}
else{
	exist=false;
}

if(!exist){
	nodeid=null;
}

%>

<HTML>
<HEAD>
    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
    <script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
    <%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<script type="text/javascript">
		window.FIXTREEHEIGHT = 389;
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16978",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->WorkflowKeyWordBrowserSingle.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
		
		function onClose(){
			if(dialog){
				dialog.close();
			}else{
		    	window.parent.close();
		    }	
		}
	</script>
</HEAD>



<BODY style="overflow:hidden;">
<div class="zDialog_div_content" style="overflow:hidden;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden';
    </script>
<%}%>
    </DIV>
   <div id="deeptree">
   	<ul id="ztreedeep" class="ztree"></ul>
   </div>
  </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=0  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>                                      
</BODY>
</HTML>



<script type="text/javascript">
	//<!--
	var cxtree_id = "<%=nodeid %>";
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/sendDoc/WorkflowKeywordBrowserSingleXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/sendDoc/WorkflowKeywordBrowserSingleXML.jsp?excludeId=<%=excludeId%><%if(keywordId!=null){%>&init=true&keywordId=<%=keywordId%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
			chkboxType: { "Y" : "", "N" : "" } 
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
	    var node = treeObj.getNodeByParam("id", cxtree_id, null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	treeObj.checkNode(node, true, true);
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
			nameStr = nodes[i].nodeid;
			idStr = nodes[i].name;
		}
		var arraytemp = nameStr.split("_");
	
	    var resultStr = "0";
	    if(arraytemp.length > 1) {
	    	resultStr = arraytemp[1];;
	    }
	
		var strtmp2 = "";
		for(var i=0;i<arraytemp.length;i++){
			if(i>2){
				strtmp2 = strtmp2 + "_" + arraytemp[i];
			}
		}
		resultStr = resultStr + "$" + idStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
			if(dialog){
				try{
					dialog.callback({id:returnVBArray[0], name:returnVBArray[1]});
				}catch(e){}
				try{
					dialog.close({id:returnVBArray[0], name:returnVBArray[1]});
				}catch(e){}
			}else{
		        window.parent.returnValue  = returnjson;
		        window.parent.close();
		    }
	    } else {
	    	if(dialog){
	    		dialog.close();
	    	}else{
	        	window.parent.close();
	        }     
		}
    }
    
    function onClear() {
    	if(dialog){
    		try{
				dialog.callback({id:"", name:""});
			}catch(e){}
			try{
				dialog.close({id:"", name:""});
			}catch(e){}
    	}else{
		    window.parent.returnValue = {id:"", name:""};
		    window.parent.close();
		}
	}
	//-->
</SCRIPT>