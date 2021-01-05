<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    String id=Util.null2String(request.getParameter("capitalgroupid"));
    String queryStr= request.getQueryString();
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/zTreeStyle_cpt_wev8.css" type="text/css">

</HEAD>
</HTML>
<BODY style="overflow:hidden;">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:parent.btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout>
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item>
			<div id="ztreeDiv" style="overflow-y:auto!important;height:150px!important;width:100%;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
		<wea:item attributes="{'isTableList':'true'}">
			<table height="100%" width="100%" cellspacing="0" cellpadding="0" >
			    <tr>
			    	<td>
			    		<IFRAME name=optFrame id=optFrame width=100% height="320px" frameborder=no scrolling=auto src="/cpt/capital/CapitalBrowserList.jsp?<%=queryStr %>">
						    	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
						</IFRAME>
			    	</td>
			    </tr>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align:center;">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="parent.btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.btncancel_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<script type="text/javascript">
	 $(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
		//$('#ztreeDiv').perfectScrollbar();
	 });

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp<%if(!id.equals("")){%>?id=<%=id%>&init=y<%}%>";
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		data: {
			simpleData: {
				enable: true,   //返回的json数据为简单数据类型，非复杂json数据类型
				idKey:"id",     //tree的标识属性
				pIdKey:"pId",   //父节点标识属性
				rootPId: 0      //顶级节点的父id
			}
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[];
	var isInit=false;
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		//alert(msg)
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "com_0", null);
	    
	    if (node != undefined && node != null ) {
	    if(!isInit){
	    	treeObj.selectNode(node);
	    	isInit =true;	
	    }
	    	//zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	    onClick(treeNode.id);
	};
	
	//单击树形菜单中的每一项选中时 onClick() 方法应该和 zTreeOnClick()方法写在一个Script里面 这样在谷歌中才能把选中的节点的值传入到onClick()中
	//2012-13-13 ypc 修改
	function onClick(id){
		var array = id.split("_");
		id = array[array.length-1]
	    window.parent.document.SearchForm.capitalgroupid.value=id;
	    window.parent.document.SearchForm.submit();
	}
	
</SCRIPT>
</BODY>
</HTML>

