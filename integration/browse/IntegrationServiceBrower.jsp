
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<script type="text/javascript">

	</script>
</HEAD>
<%
int uid=user.getUID();
String selectedids=Util.null2String(request.getParameter("selectedids"));
%>
<!-- onload="initTree()" --> 
<BODY scroll="no">
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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<%if(userightmenu_self == 1){%>
	    <script>
	     rightMenu.style.visibility='hidden'
	    </script>
	<%} %>


    </DIV>
<%--
	<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
		<TR class=Line1><TH colspan="4" ></TH></TR>
		<TR>
			<TD colspan="4" WIDTH="100%"heigt="499px">
				<div id="deeptree" style="height:499px;width:100%;overflow:scroll;">
					<ul id="ztreedeep" class="ztree" ></ul>
				</div>
			</TD>
		</TR>
	</TABLE>
--%>

	<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
		<TR class=Line1><TH colspan="4" ></TH></TR>
		<TR>
			<TD colspan="4" WIDTH="100%">
				<!-- <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
                  -->

				<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
					<ul id="ztreedeep" class="ztree"></ul>
				</div>

			</TD>
		</TR>
	</TABLE>

    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="zd_btn_submit" onclick="onSave();" style="width: 50px!important;">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_cancle" onclick="onClear();" style="width: 50px!important;">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="onCancel();" style="width: 50px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</BODY>
</HTML>

<script type="text/javascript">
	//该页面仿照/hrm/tree/DepartmentSingleXML.jsp页面而来
	//<!--

	var selectedids = "<%=selectedids%>";
	var cxtree_id = "<%=selectedids%>";//默认选中的项目
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
	    return "/integration/browse/IntegrationServiceBrowerXMl.jsp?"+ new Date().getTime() + "=" + new Date().getTime();
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
		//点击文字，选择单选按钮
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		//alert(treeNode.value);
		//document.getElementById("msgbox").innerHTML=treeNode.value;
		treeObj.checkNode(treeNode, true, false);
	};
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	//成功后，选中默认的节点
	 var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    var node = treeObj.getNodeByParam("id", cxtree_id, null);
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	treeObj.checkNode(node, true, true);
	    	document.getElementById("msgbox").innerHTML=node.value;
	    }

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
		var resultStr = nameStr + "$" + idStr;
	    return resultStr;
	}
	var dialog = top.getDialog(window);
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0],name:returnVBArray[1]};
	        if(dialog){
				dialog.callback(returnjson);
			}else{  
				window.parent.returnValue = returnjson;
				window.parent.close();
			}
	    } else {
	        onCancel();
		}
	    
    }
    function onClear() {
		if(dialog){
			dialog.callback({id:"",name:""});
		}else{  
			window.parent.returnValue = {id:"",name:""};
			window.parent.close();
		}
	}
	
	function onCancel(){
		var dialog = top.getDialog(window);   //弹出窗口的引用，用于关闭页面
		if(dialog)dialog.close();
		else window.parent.close();
	}
//-->
</SCRIPT>
