
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>

<HTML><HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css?r=3" type="text/css">
<style type="text/css">
#ascrail2000{
	left:211px!important;
}
.xmlFile_ico_docu{
	width:14px!important;
	height:15px!important;
	margin-right:2px; 
	background: url(/images/xmlFile_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlFile_ico_open{
	width:14px!important;
	height:15px!important;
	background: url(/images/xmlFile_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlFile_ico_close{
	width:14px!important;
	height:15px!important;
	background: url(/images/xmlFile_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlAttr_ico_docu{
	width:14px!important;
	height:14px!important;
	margin-right:2px; 
	background: url(/images/xmlAttr_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlAttr_ico_open{
	width:14px!important;
	height:14px!important;
	background: url(/images/xmlAttr_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlAttr_ico_close{
	width:14px!important;
	height:14px!important;
	background: url(/images/xmlAttr_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlNode_ico_docu{
	width:14px!important;
	height:14px!important;
	background: url(/images/xmlNode_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlNode_ico_open{
	width:14px!important;
	height:14px!important;
	background: url(/images/xmlNode_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
.xmlNode_ico_close{
	width:14px!important;
	height:14px!important;
	background: url(/images/xmlNode_wev8.png) no-repeat scroll 0 0 transparent; 
	vertical-align:top; *vertical-align:middle;
}
</style>
	<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js?r=2"></script>
<script type="text/javascript">
	function refreshTreeMain(id,parentId,needRefresh){}
</script>
</head>
<%
    boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user);
	if(!canedit) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
    
    int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
%>
<body scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType" onclick="__e8InitTreeSearch();">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span><%=SystemEnv.getHtmlLabelName(84672,user.getLanguage()) %></span><!-- XML模板 -->
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
		</td>
	</tr>
	<tr>
		<td class="flowMenusTd" style="width:226px;">
			<div id="div_flowMenuDiv" class="flowMenuDiv"  >
				<ul style="margin: 0; border: 0; padding: 0;" id="fnaVoucherXmlTree" class="ztree"></ul>
			</div>
		</td>
	</tr>
</table>

<FORM id=weaver name=frmmain action="/fna/fnaVoucher/fnaVoucherXmlView.jsp" method=post STYLE="margin-bottom:0" target="optFrame">
    <input type="hidden" id="fnaVoucherXmlId" name="fnaVoucherXmlId" value="0" />
    <input type="hidden" id="fnaVoucherXmlContentId" name="fnaVoucherXmlContentId" value="0" />
    <input type="hidden" id="isXmlContent" name="isXmlContent" value="0" />
</FORM>

</body>
<SCRIPT language="javascript">

function __e8InitTreeSearch(){
	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaVoucherXmlTree");
	treeObj.cancelSelectedNode();
	parent.document.getElementById("optFrame").src = "/fna/fnaVoucher/fnaVoucherXmlView.jsp";
}

function quickQry(qname){
	//alert("quickQry qname="+qname);
}


var global_clickId = "";
function do_reAsyncChildNodes(_id,_clickId,_selectedId){
	try{
		//alert("do_reAsyncChildNodes _id="+_id+";_clickId="+_clickId);
		var treeObj = jQuery.fn.zTree.getZTreeObj("fnaVoucherXmlTree");
		if(_id.indexOf("0_") == 0){
			treeObj.reAsyncChildNodes(null, "refresh");
		}else{
			//global_clickId = _clickId;
			global_clickId = _selectedId;
			var nodes = treeObj.getNodesByParam("id", _id, null);
			nodes[0].isParent = true;
			treeObj.reAsyncChildNodes(nodes[0], "refresh");
		}
	}catch(ex){}
}

var setting = {
	async: {
		enable: true,
		url:"/fna/fnaVoucher/fnaVoucherXmlLeftAjax.jsp",
		autoParam:["id"],
		otherParam:{"fnaVoucherXmlId":"<%=fnaVoucherXmlId %>"},
		dataFilter: filter
	},
	callback: {
		onClick: fnaWfTree_onClick,
		onAsyncSuccess: fnaWfTree_onAsyncSuccess
	}
};

function fnaWfTree_onClick(event, treeId, treeNode, clickFlag) {
	try{
		jQuery("#fnaVoucherXmlId").val("0");
		jQuery("#fnaVoucherXmlContentId").val("0");
		jQuery("#isXmlContent").val("0");
		//alert("fnaWfTree_onClick id="+treeNode.id);
		
		var idArray = (treeNode.id+"").split("_");
		var id0 = idArray[0];
		var id1 = idArray[1];
		jQuery("#fnaVoucherXmlId").val(id0);
		jQuery("#fnaVoucherXmlContentId").val(id1);
		if(id1=="0"){
			jQuery("#isXmlContent").val("0");
		}else{
			jQuery("#isXmlContent").val("1");
		}
	    document.frmmain.submit();
	}catch(e){
		alert(e.message);
	}
}

function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
	try{
		var _clickId = global_clickId;
		global_clickId = "";
		
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.getNodes();
		if(nodes.length==1){
			var _a = treeObj.expandNode(nodes[0], true, false, true);
			treeObj.selectNode(nodes[0]);
		}
		
		if(_clickId!=""){
			var node = treeObj.getNodesByParam("id", _clickId, null);
			treeObj.selectNode(node[0]);
		}
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
	jQuery.fn.zTree.init(jQuery("#fnaVoucherXmlTree"), setting);
}

jQuery(document).ready(function(){
	onlyFnaWf_onclick();
});

</script>
</html>