
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>

    <link href="/css/Weaver_wev8.css" rel="stylesheet" type="text/css" >
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("67",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
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
int uid=user.getUID();
String type=Util.null2String(request.getParameter("nodetype"));
String id=Util.null2String(request.getParameter("id"));

String para=Util.null2String(request.getParameter("para"));
String isRemember = "false";
String remeStr = "" ;
String mainCateStr = ",";
String subCateStr = ",";
if(!"".equals(para) && !"0".equals(para) && !"remember0".equals(para)){
	if(para.startsWith("remember")){
		para = para.substring(8);
	}
	isRemember = "true";
	String[] secFieldIdArray=Util.TokenizerString2(para,",");
	for(int strIndex=0;strIndex<secFieldIdArray.length;strIndex++){
		String tempSecFieldId = secFieldIdArray[strIndex];
		remeStr +="secField_"+tempSecFieldId+".parentElement.getElementsByTagName(\"INPUT\")[0].checked=true;"
				+"secField_"+tempSecFieldId+".style.color='red';";
				
		String tempSubFieldId = SecCategoryComInfo.getSubCategoryid(tempSecFieldId);
		subCateStr += tempSubFieldId+",";
		mainCateStr += SubCategoryComInfo.getMainCategoryid(tempSubFieldId)+",";
	}
}
String treeDocFieldIds="";
String needPeop="";
Cookie[] cks= request.getCookies();
String rem=null;   
String nodeid=null;
String nodeids=null;
for(int i=0;i<cks.length;i++){
	//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("doclistmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}if(rem!=null&&rem.length()>1)
nodeids=rem.substring(1);
if(nodeids!=null){
 if(nodeids.indexOf("|")>-1){
  nodeid=nodeids.substring(nodeids.lastIndexOf("|")+1);
 }else
  nodeid=nodeids;
}

boolean exist=true;


String[] ids=Util.TokenizerString2(nodeids,"|");


String splitflag=Util.null2String(request.getParameter("splitflag"));
if("".equals(splitflag)) splitflag = ",";
%>


<BODY>
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
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
       
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
    %>	
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
    
    </DIV>

<FORM NAME=select STYLE="margin-bottom:0" action="CategoryBrowser.jsp" method=post>
	<input class=inputstyle type=hidden name=id value="<%=id%>">
	<input class=inputstyle type=hidden name=type value="<%=type%>">

	  <wea:layout attributes="{'formTableId':'BrowseTable'}">
	   	<wea:group context="" attributes="{'groupDisplay':'none'}">
	   		<wea:item attributes="{'isTableList':'true'}">
				<input type="hidden" name="selObj">
				<div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
	                <ul id="ztreedeep" class="ztree"></ul>
	            </div>
	   		</wea:item>
		</wea:group>
	  </wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave();">
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
	var selectallflag=true;
	var isremember = "<%=isRemember%>";
	var selectedids = "<%=para%>";
	var cxtree_id = "<%=para%>";
	var cxtree_ids;
	if(selectedids!="0"&&selectedids!=""){
		cxtree_id = "<%=para%>";
		cxtree_ids = cxtree_id.split(',');
		cxtree_id = cxtree_ids[0];
	} 
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/category/MutilCategoryBrowserXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/category/MutilCategoryBrowserXML.jsp?needPeop=<%=needPeop%>&mainCateIds=<%=mainCateStr%>&subCateIds=<%=subCateStr%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
			chkStyle: "checkbox",  //check类型为checkbox
			chkboxType: { "Y":"", "N": ""} 
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onCheck: zTreeOnCheck,
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});

	var flagre='false';
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
	};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);

	    if (selectallflag) {
	    	 if (treeNode != undefined && treeNode != null) {
	 		    if (treeNode.checked) {
	 			    var childrenNodes = treeNode.childs;
	 		    	for (var i=0; i<childrenNodes.length; i++) {
	 		    		treeObj.checkNode(childrenNodes[i], true, false);
	 				}
	 		    }
	 	    }
	    }
		var node = null;
		
	    if (cxtree_ids != undefined && cxtree_ids != null && flagre=='false') {
			flagre='true';
		    for (var z=0; z<cxtree_ids.length; z++) {
				node = treeObj.getNodeByParam("id", "secField_" + cxtree_ids[z], null);
			    if (node != undefined && node != null ) {
			    	treeObj.selectNode(node);
			    	treeObj.checkNode(node, true, false);
			    }
		    }
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
			if (nodes[i].id.indexOf("secField_") != -1) {
				nameStr += "," + nodes[i].value;
				idStr += "," + nodes[i].name;
			}
		}
		
		resultStr = nameStr + "$" + idStr;
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
    
    function onClear() {
	    if(dialog){
	    	var returnjson = {id:"", name:""};
			try{
	    	dialog.callback(returnjson);
			}catch(e){}
			try{
	    	dialog.close(returnjson);
			}catch(e){}
	    }else{
		    window.parent.returnValue = {id:"", name:""};
		    window.parent.close();
		}
	}

	function onClose(){
	    
		if(dialog){
	    	try{
	    	dialog.close();
			}catch(e){}
	    }else{
		    window.parent.close();
		}
	
	}
	
	function needSelectAll(flag, obj){
		selectallflag = flag;
	   
	   	var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
	   	var type = { "Y":"", "N": ""};
	   	if(selectallflag){
	   		type = { "Y":"s", "N": "s"};
	   	}
	   	treeObj.setting.check.chkboxType = type;
	   	var i = $(obj).html().indexOf('>');
	   	if(selectallflag){
	        a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
	    } else{
	    	a = $(obj).html().substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
	    }
		$(obj).html(a);
	}
	
	function zTreeOnCheck(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);

		var nodes = treeNode.childs;
		
		if (nodes == null || nodes == undefined) {
			treeObj.reAsyncChildNodes(treeNode, "refresh");
		} else {
			if (selectallflag && treeNode.checked) {
		    	for (var i=0; i<nodes.length; i++) {
			    	if (nodes[i].checked) {
			    		treeObj.checkNode(nodes[i], false, false);	
			    	}
			    	treeObj.checkNode(nodes[i], true, false);
				}
			}
		}
	}
	
	function check() {}
	//-->
</SCRIPT>



