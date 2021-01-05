
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
		<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("493",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->CityBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}
		catch(e){}
	</script>
</HEAD>
<%
int uid=user.getUID();
String selectedids = Util.null2String(request.getParameter("selectedids"));
//System.out.println("nodeid:"+nodeid);

%>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<div class="zDialog_div_content">
<DIV align=right style="display:none">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%    
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;       
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>	
    </DIV>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=select STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">     
	<TR class=Line1><TH colspan="4" ></TH></TR>
	<TR>
		<TD height="98%" colspan="4" width="100%">
		  <div id="deeptree" style="height:100%;width:100%;overflow:auto;">
		  	<ul id="ztreedeep" class="ztree"></ul>
		  </div>
		</TD>
 	</TR>   
	<tr style="height: 25px"><td></td></tr>
</TABLE>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class=zd_btn_submit type="button" accessKey=O  id=btnok onclick="onSave()" value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
					<input class=zd_btn_submit type="button" accessKey=2  id=btnclear onclick="onClear()" value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
					<input class=zd_btn_submit type="button" accessKey=T  id=btncancel onclick="btncancel_onclick()" value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</FORM>
</BODY>
</HTML>

<script language="javaScript">
//to use deeptree,you must implement following methods 
function initTree(){
//deeptree.init("/hrm/tree/CitySingleXML.jsp?init=true&type=glob");
}

</script>



<script type="text/javascript">
	//<!--
	var cxtree_id = "city_<%=selectedids%>";
	
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/tree/CitySingleXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/tree/CitySingleXML.jsp?init=true&type=glob" + "&" + new Date().getTime() + "=" + new Date().getTime();
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
	    } else {
	    	treeObj.expandNode(treeObj.getNodes()[0], true, false, true);
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
	    if(trunStr) {
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
	    	window.parent.returnValue = returnjson;
	    	window.parent.close();
			}   
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
	    	window.parent.parent.returnValue = returnjson;
	    	window.parent.parent.close();
			}
	}
	
	function btncancel_onclick(){
		if(dialog){
			dialog.close();
		}else{
	    window.parent.parent.close();
		}
	}
	//-->
</SCRIPT>