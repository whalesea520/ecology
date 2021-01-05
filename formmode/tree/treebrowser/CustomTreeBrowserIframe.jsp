
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<TITLE></TITLE>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/tree/treebrowser/ztree/js/jquery.ztree.core-3.5_wev8.js"></script>
	<script type="text/javascript" src="/formmode/tree/treebrowser/ztree/js/jquery.ztree.excheck-3.5_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/tree/treebrowser/ztree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<style> a {poorfish:expression(this.onclick=function kill(){return false})} </style>
</HEAD>
	<%
	String typeid = Util.null2String(request.getParameter("type"));
	String selectedids = Util.null2String(request.getParameter("selectedids"));
	String treerootnode = Util.null2String(request.getParameter("treerootnode"));
	treerootnode = java.net.URLEncoder.encode(treerootnode,"utf-8");
	
	if("NULL".equals(selectedids)){
		selectedids = "";
	}
	String browsertype = "";
	if(!typeid.isEmpty()&&typeid.indexOf("_")!=-1){
		String[] arr = typeid.split("_");
		typeid = arr[0];
		browsertype = arr[1];
	}
	String isview = Util.null2String(request.getParameter("isview"));
	String treeBrowserSql = "select * from mode_customtree where id="+typeid;
	rs.executeSql(treeBrowserSql);
	String id = typeid;
	String showtype = "1";//显示样式  1：单选  2：多选 
	String isselsub = "0";//多选时是否选中子项
	String isonlyleaf = "0";//仅叶子节点允许选择 
	if(rs.next()){
		isselsub = Util.null2String(rs.getString("isselsub"));
		isonlyleaf = Util.null2String(rs.getString("isonlyleaf"));
		
	}else{
		out.print("<div style='padding:10px;font-size:15px;'>"+SystemEnv.getHtmlLabelName(82265,user.getLanguage())+"<div>");//后台树形已删除，请联系系统管理员！
		return;
	}
	if(browsertype.equals("256")){//单选
		showtype = "1";
	}else if(browsertype.equals("257")){//多选
		showtype = "2";
	}else{
		out.print("<div style='padding:10px;font-size:15px;'>"+SystemEnv.getHtmlLabelName(82266,user.getLanguage())+"<div>");//未处理浏览类型，请联系系统管理员！
		return;
	}
	
	String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
	String sql = "select * from mode_customtree where id = " + id;
	rs.executeSql(sql);
	while(rs.next()){
		expandfirstnode = Util.null2String(rs.getString("expandfirstnode"));
	}
	
	boolean isNeedExpandAll = false;//是否展开所有节点
	if(!selectedids.isEmpty()){
		isNeedExpandAll = true;
	}
	
	%>
<BODY>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
    	if(!isview.equals("1")){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;//确定
	        RCMenuHeight += RCMenuHeightStep ;
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;//清除
	        RCMenuHeight += RCMenuHeightStep ;
    	}
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;//取消
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div id="CustomTreeDiv" style="height:85%;width: 100%;overflow: auto;">
		<ul id="CustomTree" class="ztree"></ul>
	</div>
	
	
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="/formmode/tree/CustomTreeRight.jsp" method="get" target="contentframe">
		<input class=inputstyle type="hidden" name="mainid" id="mainid" value="<%=id%>">
		<input class=inputstyle type="hidden" name="name" id="name" value="">
		<input class=inputstyle type="hidden" name="pid" id="pid" value="0<%=CustomTreeData.Separator %>0">
	</FORM>
	
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
			<%if(!isview.equals("1")){ %>
				<input type="button" class=zd_btn_submit  id=btnok onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"><!-- 确定 -->
				<input type="button" class=zd_btn_submit  id=btnclear onclick="onClear();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"><!-- 清除 -->
			<%} %>
    		<input type="button" class=zd_btn_submit  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
</BODY>
	<SCRIPT type="text/javascript">
	var dialog;
	var parentWin;
	try{
		parentWin = window.parent.parent.parent.getParentWindow(parent);
		dialog = window.parent.parent.parent.getDialog(parent);
		if(!dialog){
			parentWin = parent.parentWin;
			dialog = parent.dialog;
		}
	}catch(e){
		
	}
	var firstclick = 0;
	var expandfirstnode = "<%=expandfirstnode%>";
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		var url = "";
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	url = "/formmode/tree/treebrowser/CustomTreeBrowserAjax.jsp?id=<%=id%>&init=false&showtype=<%=showtype%>&isselsub=<%=isselsub%>&isonlyleaf=<%=isonlyleaf%>&treerootnode=<%=treerootnode%>&selectedids=<%=selectedids%>&time=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	url = "/formmode/tree/treebrowser/CustomTreeBrowserAjax.jsp?id=<%=id%>&init=true&showtype=<%=showtype%>&selectedids=<%=selectedids%>";
	    }
	    if (!!window.ActiveXObject || "ActiveXObject" in window){
	    url=encodeURI(url); // qc:351461 解决ie不自动编码
	    }
	    return url;
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl,    //ajax的url
			type:"post",
			autoParam: ["id=pid","name=name"]
		},
		<%if(showtype.equals("1")){%>
		check: {
			enable:true,
			chkStyle:"radio",
			radioType:"all"
		},
		<%}else{%>
		check: {
			enable:true,
			chkStyle:"checkbox",
			<%if(isselsub.equals("1")){%>
				chkboxType: { "Y" : "s", "N" : "s" }
			<%}else{%>
				chkboxType: { "Y" : "", "N" : "" }
			<%}%>
		},
		<%}%>
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
			<%if(showtype.equals("2")){%>
			beforeCheck: zTreeBeforeCheck,//勾选前事件
			<%}%>
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};
	var zNodes =[];
	var asyncForAll = false;
	var curStatus  = "";
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#CustomTree"), setting, zNodes);
		if(<%=isNeedExpandAll%>){
			setTimeout(function(){expandAll()},500);
		}
	});
	
	
	
	function expandAll() {
			var zTree = $.fn.zTree.getZTreeObj("CustomTree");
			if (asyncForAll) {
				zTree.expandAll(true);
			} else {
				expandNodes(zTree.getNodes());
			}
		}
		function expandNodes(nodes) {
			if (!nodes) return;
			curStatus = "expand";
			var zTree = $.fn.zTree.getZTreeObj("CustomTree");
			for (var i=0, l=nodes.length; i<l; i++) {
				zTree.expandNode(nodes[i], true, false, false);
				if (nodes[i].isParent && nodes[i].zAsync) {
					expandNodes(nodes[i].children);
				} 
			}
			
		}
		
		function asyncNodes(nodes) {
			if (!nodes) return;
			curStatus = "async";
			var zTree = $.fn.zTree.getZTreeObj("CustomTree");
			for (var i=0, l=nodes.length; i<l; i++) {
				if (nodes[i].isParent && nodes[i].zAsync) {
					asyncNodes(nodes[i].children);
				} else {
					goAsync = true;
					zTree.reAsyncChildNodes(nodes[i], "refresh", true);
				}
			}
		}
		

		//--------
	
		
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "field_0", null);
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    }
	    
	    <%if(showtype.equals("2")&&isselsub.equals("1")){%>
		if(treeNode&&!<%=isNeedExpandAll%>){
	    	var status = treeNode.getCheckStatus();
	    	if(status!=null){
	    		if(status.checked==true){
	    			var nodes = treeNode.children;
	    			for(var i=0;i<nodes.length;i++){
	    				if(nodes[i].chkDisabled==false){
		    				treeObj.checkNode(nodes[i], true, false);
	    				}
	    				if (nodes[i].isParent) {
							treeObj.expandNode(nodes[i]);//展开子节点
						}
	    			}
	    		}
	    	}
	    }
		<%}%>
			
	    <%if(isNeedExpandAll){%>
		    if (curStatus == "expand") {
				expandNodes(treeNode.children);
			} else if (curStatus == "async") {
				asyncNodes(treeNode.children);
			}
	    <%}else{%>
			//默认展开一级节点
		    if(firstclick==0&&expandfirstnode==1){
				$("#CustomTree_1_switch")[0].click();
				firstclick++;
		    }
	    <%}%>
	}
	
	function zTreeBeforeCheck(treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);//展开子节点
		}
	    
	    <%if(showtype.equals("2")&&isselsub.equals("1")){%>
	    	if (treeNode.isParent&&treeNode.children) {
	    		expandNodeByCustom(treeId,treeNode.children);
	    	}
	    <%}%>
	    
	    return true;
	};
	
	function expandNodeByCustom(treeId,nodes){
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		for(var i=0;i<nodes.length;i++){
   			var treeNode = nodes[i];
   			if (treeNode.isParent) {
				treeObj.expandNode(treeNode);//展开子节点
			}
   		}
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
			
		}
	    <%if(showtype.equals("1")){%>
	    	<%if(isonlyleaf.equals("1")){%>
		    	if (!treeNode.isParent) {
			   		treeObj.checkNode(treeNode, true, false);
			    }
			<%}else{%>
				treeObj.checkNode(treeNode, true, false);
			<%}%>
		<%}%>
	};
	
	function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("CustomTree");
		var nodes = treeObj.getCheckedNodes(true);
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		var url = "";
		for (var i=0; i<nodes.length; i++) {
			idStr +=","+ nodes[i].id;
			url = nodes[i].nodeurl;
			var tempNodeName = nodes[i].name;
        	tempNodeName = tempNodeName.replace(new RegExp(/(<)/g),"&lt;")
        	tempNodeName = tempNodeName.replace(new RegExp(/(>)/g),"&gt;")
			if(!dialog){
				nameStr +=","+ tempNodeName;
			}else{
				if(url==""){
					nameStr +=",<a title='"+nodes[i].name+"'>"+ tempNodeName+"</a>";
				}else{
					nameStr +=",<a target='_blank' href='"+url+"' title='"+nodes[i].name+"'>"+ tempNodeName+"</a>";
				}
			}
		}
		if(idStr==""){
			idStr = "";
		}else{
			idStr = idStr.substring(1,idStr.length);
			nameStr = nameStr.substring(1,nameStr.length);
		}
		var resultStr = idStr + "$" + nameStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var tempinfo = "";
			for(var i=1;i<returnVBArray.length;i++){
			    tempinfo += returnVBArray[i]+"$";
			}
			tempinfo = tempinfo.substring(0,tempinfo.length-1);
			var returnjson = {id:returnVBArray[0], name:tempinfo};
	        if(dialog){
				 try{
				     dialog.callback(returnjson);
				 }catch(e){}
				 
				 try{
				     dialog.close(returnjson);
				 }catch(e){}
			    
			}else{  
				window.parent.parent.parent.returnValue=returnjson;
				window.parent.parent.parent.close();
			}
	    } else {
	    	onClear();
		}
    }
    
    function btncancel_onclick(){
     	if(dialog){
		    dialog.close();
		}else{  
		    window.parent.parent.parent.close();
		}
    }
    
    function onClear() {
	    var returnjson = {id:"", name:""};
	        if(dialog){
				 try{
				     dialog.callback(returnjson);
				 }catch(e){}
				 
				 try{
				     dialog.close(returnjson);
				 }catch(e){}
			    
			}else{  
				window.parent.parent.parent.returnValue=returnjson;
				window.parent.parent.parent.close();
			}
	}
	
    jQuery(function($){
    	setTimeout(function(){
    		var height = $("body").height()-$("#zDialog_div_bottom").height();
    		$("#CustomTreeDiv").height(height-10);
    	},1000);
    });
	</SCRIPT>
</HTML>