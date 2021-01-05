<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>

<HTML><HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree3.5/css/zTreeStyle/FilezTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.excheck.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree3.5/js/jquery.ztree.exedit.min_wev8.js"></script>
	<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
	<style type="text/css">
	.ztree li{line-height:normal;}
	.ztree li a {height:auto;}
	</style>
</head>
<%
boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

String guid1 = UUID.randomUUID().toString();

int fnaType = Util.getIntValue(request.getParameter("fnaType"), 1);
int LabelId = 33062;
if(fnaType==2){
	LabelId = 515;
}

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
if(!"".equals(nameQuery)){
	session.setAttribute("AuditSettingLeft.jsp_nameQuery_"+guid1, nameQuery);
}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form2" method="post"  action="/fna/budget/AuditSettingLeft.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<wea:layout type="table" attributes="{'cols':'2','groupDisplay':'none'}">
	<wea:group context="">
		<wea:item type="thead">
			<span id="spanTd1" style="width: 100%;"><%=SystemEnv.getHtmlLabelName(LabelId,user.getLanguage()) %></span>
		</wea:item>
		<wea:item type="thead">
			<span id="spanTd2" style="width: 100%;"><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage()) %></span>
		</wea:item>
		
		<wea:item>
			<ul style="margin: 0; border: 0; padding: 0; width: 100%;" id="fnaWfTree" class="ztree"></ul>
		</wea:item>
	</wea:group>
</wea:layout>

</form>
<span style="right: 0;"></span>
</body>
<SCRIPT language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//快速（高级）搜索事件
function onBtnSearchClick(){
	form2.submit();
}

function doSaveAudit(nodeName, nodeId, wfId, wfName, synSubOrg){
	var _data = "nodeId="+nodeId+"&wfId="+wfId+"&synSubOrg="+synSubOrg;
	
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/budget/AuditSettingLeftOp.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
		    	if(_json.flag){
		    		var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
					var node = treeObj.getNodesByParam("id", nodeId, null);
					node.workflowid = wfId;
					node.workflowname = wfName;
					do_reAsyncChildNodes(_json.reloadId,_json.reloadId);
		    	}
		    	top.Dialog.alert(_json.msg);
		    }catch(e1){
		    	top.Dialog.alert(e1.msg);
		    }
		}
	});	
}

var g_nodeName = "";
var g_nodeId = "";

function onShowFlowID_callback(event,datas,name,_callbackParams){
	var nodeName = g_nodeName;
	var nodeId = g_nodeId;
	g_nodeName = "";
	g_nodeId = "";
	if(datas!=null) {
	<%if(fnaType==2){%>
		doSaveAudit(nodeName, nodeId, datas.id, datas.name, "true");
	<%}else{%>
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage()) %>?",
				function(){
					doSaveAudit(nodeName, nodeId, datas.id, datas.name, "true");
				},function(){
					doSaveAudit(nodeName, nodeId, datas.id, datas.name, "false");
				}
			);
	<%}%>
	}
}

function onShowFlowID(nodeName, nodeId, _obj){
	g_nodeName = nodeName;
	g_nodeId = nodeId;
	showModalDialogForBrowser(_obj,'/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put("where formid=154")%>','#','xxxxx',true,1,'',
		{name:'xxxxx',hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onShowFlowID_callback}
	);
}

function addHoverDom(treeId, aObj){
	removeHoverDom(treeId, aObj);
	
	var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
	var treeNode = jQuery.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
	var scrolltop = 0;

	try{
		jQuery("#show_Div_"+tId).removeClass("curSelectedNode");
	}catch(ex1){}
	if(jQuery("#show_Div_"+tId).attr("class").indexOf("curSelectedNode")==-1)
		jQuery("#show_Div_"+tId).css({"background":"#DEF0FF"});
	jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").show();
	if (jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").length>0){
		return;
	}
	
	//<BUTTON id=SelectFlowID class=Browser onclick="onShowFlowID('0','268|1|')"></BUTTON>
	var _styleStr = "margin-right: 200px;float:rigth;";
	if(treeNode.workflowname!=null&&treeNode.workflowname!=""){
		_styleStr = "";
	}
	
	var td2 = jQuery("#spanTd2").parent();
	var showDiv = jQuery("#show_Div_"+tId);
	var padding_left = showDiv.css("padding-left");
	if(padding_left==null||padding_left==""){
		padding_left = "0";
	}
	var td2_width = parseInt(td2.width())+parseInt(padding_left.replace("px",""));
	
	
	var	oprateStr = 
		"<div id='z_tree_"+treeNode.id+"_span1' style='float: right;width:50%;padding-right:"+(parseInt(padding_left))+"px;'>"+
			"<img z_tree=\"oprate_div_"+treeNode.id+"\" style='"+_styleStr+"'"+
			" src='/wui/theme/ecology8/skins/default/general/browser_wev8.png' onclick=\"onShowFlowID('"+treeNode.name+"','"+treeNode.id+"',this);\""+
			" onmouseover=\"this.src='/wui/theme/ecology8/skins/default/general/browser_wev8.png'\" onmouseout=\"this.src='/wui/theme/ecology8/skins/default/general/browser_wev8.png'\" />"+
			"<span id=\"z_tree_"+treeNode.id+"_wfName\">"+treeNode.workflowname+"&nbsp;</span>"+
		"</div>";
	//jQuery(aObj).append(oprateStr);
	//fnaWfTree_1_span
	var treeIdx = jQuery(aObj).attr("id").split("_")[1];
	jQuery("#fnaWfTree_"+treeIdx+"_span").append(oprateStr);
	//jQuery("#z_tree_"+treeNode.id+"_wfName").next().remove();
}
//<div id="show_Div_fnaWfTree_1" style="padding-left: 0px; background: rgb(13, 147, 246);" class="curSelectedNode"><span id="fnaWfTree_1_switch" title="" class="button level0 switch noline_open" treenode_switch=""></span><a id="fnaWfTree_1_a" class="level0 curSelectedNode" treenode_a="" onclick="" target="_blank" style="width: 1669px;" title="a"><span id="fnaWfTree_1_ico" title="" treenode_ico="" class="button ico_open" style="background:url(/images/treeimages/global_wev8.gif) 0 0 no-repeat;"></span><span id="fnaWfTree_1_span">a</span><span style="float: right;width:50%;padding-right:0px;"><img z_tree="oprate_div_c_0" style="display: none;" src="/wui/theme/ecology8/skins/default/general/browser_wev8.png" onclick="onShowFlowID('a','c_0');" title="审批流程" onmouseover="this.src='/wui/theme/ecology8/skins/default/general/browser_wev8.png'" onmouseout="this.src='/wui/theme/ecology8/skins/default/general/browser_wev8.png'"><span id="z_tree_c_0_wfName">费用审批流程&nbsp;</span><span></span></span></a></div>

function removeHoverDom(treeId, aObj){
	var tId = aObj.id.substring(0,aObj.id.indexOf("_a"));
	var treeNode = jQuery.fn.zTree.getZTreeObj(treeId).getNodeByTId(tId);
	
	jQuery("#show_Div_"+tId).css({"background":"transparent"});
	if(jQuery("#show_Div_"+tId).attr("class").indexOf("curSelectedNode")!=-1)
		jQuery("#show_Div_"+tId).css({"background":"#0D93F6"});
	jQuery(aObj).find("img[z_tree=oprate_div_"+treeNode.id+"]").hide();
	jQuery(aObj).find("span[id=z_tree_"+treeNode.id+"]").hide();
}


var global_clickId = "";
function do_reAsyncChildNodes(_id,_clickId){
	try{
	<%
	if(!"".equals(nameQuery)){//如果是查询后生产的树，由于只有一层，则始终重新加载整棵树
	%>
		onlyFnaWf_onclick();
	<%
	}else{//如果不是通过查询生成的树，则在js中判断，如果修改的是根目录，则重新加载整棵树，否则，只要重新加载选中的节点即可
	%>
		if(_id=="c_0" || _id=="fcc_0"){
			onlyFnaWf_onclick();
		}else{
			global_clickId = _clickId;
			var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
			var nodes = treeObj.getNodesByParam("id", _id, null);
			//nodes[0].isParent = true;
			var pNode = nodes[0].getParentNode();
			if(pNode==null){
				onlyFnaWf_onclick();
			}else{
				treeObj.reAsyncChildNodes(pNode, "refresh", false);
			}
		}
	<%
	}
	%>
	}catch(ex){}
}

var setting = {
	async: {
		enable: true,
		url:"/fna/budget/<%=(fnaType==2)?"AuditSettingLeftFccAjax.jsp":"AuditSettingLeftAjax.jsp" %>",
		autoParam:["id"],
		otherParam:{"otherParam":"0","guid1":<%=JSONObject.quote(guid1) %>},
		dataFilter: filter
	},
	callback: {
		onAsyncSuccess: fnaWfTree_onAsyncSuccess,
		beforeClick: zTreeBeforeClick
	},			
	view: {
		showLine: false,
		showIcon: true,
		selectedMulti: false
	},
	check: {
		enable: false
	}

};

function zTreeBeforeClick(){
	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
	//treeObj.cancelSelectedNode();
	var nodes = treeObj.getSelectedNode();
	for(var i=0;i<nodes.length;i++) { 
		treeObj.cancelSelectedNode(nodes[0]);
	}
	return false;
}

function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
	try{
		var nodes1; 
		if(treeNode){
			nodes1 = treeNode.children;
		}else{
			var zTree1 = jQuery.fn.zTree.getZTreeObj(treeId);
			nodes1 = zTree1.getNodes();
		}

		try{
			if(nodes1){
				for (var i=0, l=nodes1.length; i < l; i++) {
			    	if(jQuery("#"+nodes1[i].tId+"_a").width()){
			    		jQuery("#"+nodes1[i].tId+"_a").width(jQuery("#"+treeId).width()-20)
				    	.bind("mouseenter",function(){addHoverDom(treeId, this);})
						.bind("mouseleave",function(){removeHoverDom(treeId, this);});
			    		addHoverDom(treeId, jQuery("#"+nodes1[i].tId+"_a")[0]);
			    		removeHoverDom(treeId, jQuery("#"+nodes1[i].tId+"_a")[0]);
			    	}
				}
			}
		}catch(ex1){}
		
		var _clickId = global_clickId;
		global_clickId = "";
		
		var treeObj = jQuery.fn.zTree.getZTreeObj(treeId);
		try{
			var nodes = treeObj.getNodes();
			if(nodes.length==1){
				var _a = treeObj.expandNode(nodes[0], true, false, true);
				treeObj.selectNode(nodes[0]);
			}
		}catch(ex1){}

		try{
			if(_clickId!=""){
				var node = treeObj.getNodesByParam("id", _clickId, null);
				if(node){
					treeObj.reAsyncChildNodes(node[0], "refresh", false);
				}
			}
		}catch(ex1){}
	}catch(e){
		alert(e.message);
	}
}


function filter(treeId, parentNode, childNodes) {
	if (!childNodes) return null;
	for (var i=0, l=childNodes.length; i<l; i++) {
		childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
	}
	return childNodes;
}

function onlyFnaWf_onclick(){
	jQuery.fn.zTree.init(jQuery("#fnaWfTree"), setting);
}

jQuery(document).ready(function(){
	onlyFnaWf_onclick();
});
</script>
</html>