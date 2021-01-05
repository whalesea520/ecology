
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
<script type="text/javascript">
FIXTREEHEIGHT=180;
</script>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css?r=3" type="text/css">
	<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js?r=2"></script>
<script type="text/javascript">
	function refreshTreeMain(id,parentId,needRefresh){
		if(needRefresh!=false)needRefresh=true;
		refreshTree(id,parentId,{
			needRefresh:needRefresh,
			url:"DocCategoryTreeLeft.jsp",
			fn:e8_initTree
		});
	}
</script>
</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
%>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<ul style="margin: 0; border: 0; padding: 0;" id="fnaWfTree" class="ztree"></ul>

</body>
<SCRIPT language="javascript">

function quickQry(qname){
	//alert("quickQry qname="+qname);
}


var global_clickId = "";
function do_reAsyncChildNodes(_id,_clickId){
	try{
		//alert("do_reAsyncChildNodes _id="+_id+";_clickId="+_clickId);
		var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
		if(_id.indexOf("0_") == 0){
			treeObj.reAsyncChildNodes(null, "refresh");
		}else{
			global_clickId = _clickId;
			var nodes = treeObj.getNodesByParam("id", _id, null);
			nodes[0].isParent = true;
			treeObj.reAsyncChildNodes(nodes[0], "refresh");
		}
	}catch(ex){}
}

var setting = {
	async: {
		enable: true,
		url:"/fna/browser/costCenter/costCenterByWfBrowdef/costCenterByWfBrowdefMultiTreeAjax.jsp",
		autoParam:["id"],
		otherParam:{"otherParam":"0"},
		dataFilter: filter
	},
	callback: {
		onClick: fnaWfTree_onClick,
		onAsyncSuccess: fnaWfTree_onAsyncSuccess
	}
};

function fnaWfTree_onClick(event, treeId, treeNode, clickFlag) {
	try{
		jQuery("#fccId").val("0");
		//alert("fnaWfTree_onClick id="+treeNode.id);
		
		var idArray = (treeNode.id+"").split("_");
		var idType = idArray[0];
		var id = idArray[1];
	    //parent.showMultiDialog(id);
	    parent.jQuery("#fccId").val(id);
	    parent.btnOnSearch();
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
	jQuery.fn.zTree.init(jQuery("#fnaWfTree"), setting);
}

jQuery(document).ready(function(){
	onlyFnaWf_onclick();
});

    function onExtend(img, id, level, islast) {
        if (level == 0) {
            if (document.getElementById("first_level").style.display == "none") {
                //img.src = "/images/xp/openfolder_wev8.png";
                document.getElementById("first_level").style.display = "block";
            } else {
                //img.src = "/images/xp/folder_wev8.png";
                document.getElementById("first_level").style.display = "none";
            }
        } else if (level == 1) {
            if (document.getElementById("second_level_" + id).style.display == "none") {
                if (islast) img.src = "/images/xp2/Lminus_wev8.png";
                else img.src = "/images/xp2/Tminus_wev8.png";
                document.getElementById("second_level_" + id).style.display = "block";
            } else {
                if (islast) img.src = "/images/xp2/Lplus_wev8.png";
                else img.src = "/images/xp2/Tplus_wev8.png";
                document.getElementById("second_level_" + id).style.display = "none";
            }
        }
    }
    function onParent(id, level) {
        document.frmmain.action = "FnaBudgetfeeTypeView.jsp?parent=" + id + "&level=" + level;
        document.frmmain.operation.value = "search";
        document.frmmain.submit();
    }
    
</script>
</html>