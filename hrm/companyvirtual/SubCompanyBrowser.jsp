
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->SubcompanyBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String excludeid=Util.null2String(request.getParameter("excludeid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
String nodeid=null;
%>
<BODY scroll="no">
<div class="zDialog_div_content">
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
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>
   <FORM NAME=select STYLE="margin-bottom:0" action="SubcompanyBrowser1.jsp" method=post>
       <input class=inputstyle type=hidden name=type value="<%=type%>">
       <input class=inputstyle type=hidden name=id value="<%=id%>">
       <input class=inputstyle type=hidden name=level value="<%=level%>">
       <input class=inputstyle type=hidden name=subid value="<%=subid%>">
       <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
       <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
       <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
       <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
             <TR>
                 <TD colspan="4" width="100%">
                   <!-- <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" /> -->
                   <div id="deeptree" style="height:100%;width:100%;overflow:auto;">
                   	<ul id="ztreedeep" class="ztree"></ul>
                   </div>
                 </TD>
             </TR>
       </TABLE>
   </FORM>
    </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
					<input type="button" class=zd_btn_submit accessKey=2  id=btnclear onclick="onClear()" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
	        <input type="button" class=zd_btn_submit class=btnReset  id=btncancel  onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
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
	var appendimg = 'Home';
	var appendname = 'selObj';
	var allselect = "all";
	var selectedids = "<%=selectedids%>";
	var virtualtype = "<%=virtualtype%>";
	var cxtree_id = "";
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "com_"+selectedids;
	}
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/companyvirtual/DepartmentSingleXML.jsp?virtualtype="+virtualtype+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/companyvirtual/SubcompanySingleXML.jsp?virtualtype="+virtualtype+"&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
	   
	    //默认展开第一级
			try{
				var root = jQuery("button.root_close");
				root.click();
			}catch(e){}
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
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
			}else{
				window.parent.returnValue = returnjson;
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
    
    function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	  	window.parent.close();
		}
    }
    
    function onClear() {
      var returnjson = {id:"",name:""};
			if(dialog){
				try{
          dialog.callback(returnjson);
			     }catch(e){}
			
			try{
			     dialog.close(returnjson);
			 }catch(e){}
			}else{
				window.parent.returnValue = returnjson;
		  	window.parent.close();
			}
	}
	//-->
</SCRIPT>