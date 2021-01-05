<%@page import="org.json.JSONObject"%>
<%@page import="weaver.filter.XssUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet4" class="weaver.conn.RecordSet" scope="page"/>
<%
XssUtil xssUtil = new XssUtil();

int tabId = Util.getIntValue(request.getParameter("tabId"), 1);

int filterlevel = Util.getIntValue(request.getParameter("level"),0);
String displayarchive=Util.null2String(request.getParameter("displayarchive"));//是否显示封存科目
String fromWfFnaBudgetChgApply=Util.null2String(request.getParameter("fromWfFnaBudgetChgApply")).trim();//=1：来自系统表单预算变更申请单
int orgType = Util.getIntValue(request.getParameter("orgType"),-1);
int orgId = Util.getIntValue(request.getParameter("orgId"),-1);
int orgType2 = Util.getIntValue(request.getParameter("orgType2"),-1);
int orgId2 = Util.getIntValue(request.getParameter("orgId2"),-1);
int fromFnaRequest = Util.getIntValue(request.getParameter("fromFnaRequest"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));


int enableDispalyAll=0;
String separator ="";
int subjectBrowseDefExpanded = 0;//单科目浏览框默认展开
recordSet4.executeSql("select * from FnaSystemSet");
while(recordSet4.next()){
	enableDispalyAll = recordSet4.getInt("enableDispalyAll");
	separator = recordSet4.getString("separator");
	subjectBrowseDefExpanded = Util.getIntValue(recordSet4.getString("subjectBrowseDefExpanded"), 0);
}

%>
<HTML><HEAD>
	<script type="text/javascript">
	FIXTREEHEIGHT=450;
	</script>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css?r=3" type="text/css">
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js?r=2"></script>

	<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
	
	<style type="text/css">
		.advancedSearch1{
			display:-moz-inline-box;
			display: inline-block;
			cursor:pointer;
			position: relative;
			z-index:2;
			color:#888686;
			margin-bottom:0px;
			height:21px;
			padding-left:5px;
			padding-right:5px;
			line-height:21px;
			font-size:12px;
			border-top:1px solid #F5F2F2;
			border-right:1px solid #F5F2F2;
			border-bottom:1px solid #F5F2F2;
			background-color:#fff;
		}
		.advancedSearch{height:23px}
		.advancedSearch.click{height:23px}
		.e8_select_tr{background-color: #dff1ff;}
		.searchImg1{
			display:inline;
			cursor:pointer;
			padding-left:5px !important;
			padding-right:5px !important;
		}
		.e8_box_s {
			height: 496px;
			width: 568px;
			padding-left: 2px;
		}
		.e8_box_bottommenu{
			border-bottom: 0px;
			border-right: 1px solid #ccc;
			border-left: 1px solid #ccc;
			width:342px;}
		
		.e8_box_d {
			height: 496px;
			width: 263px;
		}
		
		.e8_box_s thead td,.e8_box_d thead td {
			background-color: #ffffff;
			border-bottom: 1px solid #ffffff;
			white-space: nowrap;
			color: #000;
		}
		
		.e8_box_topmenu {
			width: 100%;
			height: 20px;
			border: none;
			line-height: 20px;
			text-align: left;
			border-collapse: collapse;
		}
		
		.e8_box_topmenu input {
			height: auto;
			width: auto;
		}
		
		.e8_box_middle {
			overflow: hidden;
			position: relative;
			border: 1px solid #dadedb;
			border-bottom: 0px;
		}
		.e8_box_slice{
			height: 487px;
			width: 57px;
			vertical-align: middle;
		}
		.e8_first_arrow{
			margin-top: 135px;
		}
		.e8_box_topmenu thead td {
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		.searchInputSpan{
			top: 0px;
			height:23px;
		}
		.e8_box_s  td{
	    vertical-align: middle;
	    text-align: left;
	    border-bottom: 0px;
	    height:30px;
	    color:#242424;
	    overflow:hidden;
	    text-overflow:ellipsis;
	    /*white-space: nowrap;*/
		}
		.e8_box_d  td{
	    vertical-align: middle;
	    text-align: left;
	    border-bottom: 0px;
	    height:30px;
	    color:#242424;
	    overflow:hidden;
	    text-overflow:ellipsis;
	    /*white-space: nowrap;*/
		}
	  .overlabel{
		position:absolute;
		z-index:1;
		font-size:12px;
		font-weight:normal;
		color:#dadedb!important;
		line-height: 22px!important;
	}
	.e8_box_source tr{
		height: 32px;
	}
	.e8_box_source tr td{
		padding-left:15px;
	}
	</style>
<!--[if IE]>
<style>
	#overFlowDivTree{
		overflow: auto!important;
		overflow-y: auto!important;
	}
</style>
<![endif]-->
</head>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
%>
<body scroll="auto">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:parent.onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

		<div id="dialog">
			<div id="colShow">
					<table class="e8_box_srctop e8_box_topmenu">
						<thead>
							<tr>
								<td>
									<span id="searchblockspan" style="width: 564px;display: inline-block;">
										<span class="searchInputSpan" style="position:relative;width: 570px">
											<label for="qryName" class="overlabel" style="text-indent: 0px; cursor: text; margin-left: 5px;">
												<%=SystemEnv.getHtmlLabelNames("197,15409", user.getLanguage())%></label>
											<input type="text" class="searchInput middle" id="qryName" name="qryName" value="<%="" %>" 
												onkeyup="jsSourceSearch(this);" onfocus="onSearchFocus();" onblur="onSearchFocusLost();" 
												style="vertical-align: top;width: 535px">
											<span class="middle searchImg"><img class="middle" style="vertical-align:top;margin-top:2px;" 
												src="/images/ecology8/request/search-input_wev8.png"></span>
										</span>
									</span>
								</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<div id="e8_box_source_quick" style="display: none;">
										<div class="e8_box_middle ps-container" id="src_box_middle" style="width: 572px;height:470px;overflow: auto;">
											<table id="e8_box_source_tb123" class="e8_box_source" style="border-collapse: collapse;border-spacing:0px;width: 100%;">
											</table>
										</div>
									</div>
								<%
								if(tabId==2){
								%>
									<ul style="margin: 0; border: 0; padding: 0;" id="fnaWfTree" class="ztree"></ul>
								<%
								}
								%>
								</td>
							</tr>
						</tbody>
					</table>
			</div>
		</div>
					
	<input class=inputstyle type="hidden" type="text" id="separator" name="separator" value="<%=(enableDispalyAll==1?separator:"")%>">
</body>
<SCRIPT language="javascript">
String.prototype._fnaReplaceAll123 = function(reallyDo, replaceWith, ignoreCase) {
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);
    } else {
        return this.replace(reallyDo, replaceWith);
    }
}

var _dfLoadTreeNode = true;

function quickQry(qname){
	//alert("quickQry qname="+qname);
}



jQuery(document).ready(function(){
	resizeDialog(document);
<%
if(tabId==1){
%>
	var _tbObj = jQuery("#e8_box_source_tb123");
	_tbObj.html("");
	jQuery("#e8_box_source_quick").show();
	loadDfData();
<%
}else if(tabId==2){
%>
	onlyFnaWf_onclick();
<%
}
%>
});

<%
if(tabId==2){
%>
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
		url:"/fna/maintenance/BudgetfeeTypeBrowserNewTreeAjax.jsp",
		autoParam:["id"],
		otherParam:{"qryType":"2",
			"level":"<%=filterlevel %>","displayarchive":<%=JSONObject.quote(displayarchive) %>,
			"fromWfFnaBudgetChgApply":<%=JSONObject.quote(fromWfFnaBudgetChgApply) %>,"orgType":"<%=orgType %>","orgId":"<%=orgId %>","orgType2":"<%=orgType2 %>","orgId2":"<%=orgId2 %>",
			"fromFnaRequest":"<%=fromFnaRequest %>","workflowid":"<%=workflowid %>","fieldid":"<%=fieldid %>","billid":"<%=billid %>",
			"sqlwhere":<%=JSONObject.quote(xssUtil.put(sqlwhere)) %>},
		dataFilter: filter
	},
	callback: {
		onClick: fnaWfTree_onClick,
		onAsyncSuccess: fnaWfTree_onAsyncSuccess
	}
};

function fnaWfTree_onClick(event, treeId, treeNode, clickFlag) {
	try{
		if(treeNode.canSelect==1){
			var idArray = (treeNode.id+"").split("_");
			var idType = idArray[0];
			var id = idArray[1];
			var _trunStr = {"id":id, "name":treeNode.fullName,"flag":2};
			parent.onSave2(_trunStr);
		}
	}catch(e){
		alert(e.message);
	}
}

function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
<%if(subjectBrowseDefExpanded==1){%>
	try{
		var _clickId = global_clickId;
		global_clickId = "";
		
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.getNodes();
		if(nodes.length>=1 && _dfLoadTreeNode){
			_dfLoadTreeNode = false;
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
<%}%>
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
<%
}
%>


var hiddenfield = "id,type,nodeid,nodenum"; //隐藏字段
var container;

function onSearchFocus(){
	var qryName = jQuery("#qryName");
	if(qryName.val()==""){
		var _tbObj = jQuery("#e8_box_source_tb123");
		_tbObj.html("");
		jQuery(".overlabel").hide();
		jQuery("#overFlowDivTree").hide();
		jQuery("#e8_box_source_quick").show();
 	}
}

function onSearchFocusLost(){
	var qryName = jQuery("#qryName");
	if(qryName.val()==""){
		var _tbObj = jQuery("#e8_box_source_tb123");
		_tbObj.html("");
		jQuery(".overlabel").show();
	<%if(tabId==1){%>
		jQuery("#e8_box_source_quick").show();
		loadDfData();
	<%}else{%>
		jQuery("#e8_box_source_quick").hide();
		jQuery("#overFlowDivTree").show();
	<%}%>
 	}
}


var timeout = null;
function jsSourceSearch(){
	clearTimeout(timeout);
	timeout = setTimeout(function(){
		var qryName = jQuery("#qryName");
		var _data = "qryType=1&qryName="+encodeURI(qryName.val())+
			"&level=<%=filterlevel %>&displayarchive="+<%=JSONObject.quote(displayarchive) %>+
			"&fromWfFnaBudgetChgApply="+<%=JSONObject.quote(fromWfFnaBudgetChgApply) %>+
			"&orgType=<%=orgType %>&orgId=<%=orgId %>&orgType2=<%=orgType2 %>&orgId2=<%=orgId2 %>&fromFnaRequest=<%=fromFnaRequest %>&workflowid=<%=workflowid %>"+
			"&fieldid=<%=fieldid %>&billid=<%=billid %>&sqlwhere="+<%=JSONObject.quote(xssUtil.put(sqlwhere)) %>;
		loadTbSubjectData(_data);
	}, 400);
}

function loadDfData(){
	var _data = "qryType=0"+
		"&level=<%=filterlevel %>&displayarchive="+<%=JSONObject.quote(displayarchive) %>+
		"&fromWfFnaBudgetChgApply="+<%=JSONObject.quote(fromWfFnaBudgetChgApply) %>+
		"&orgType=<%=orgType %>&orgId=<%=orgId %>&orgType2=<%=orgType2 %>&orgId2=<%=orgId2 %>&fromFnaRequest=<%=fromFnaRequest %>&workflowid=<%=workflowid %>"+
		"&fieldid=<%=fieldid %>&billid=<%=billid %>&sqlwhere="+<%=JSONObject.quote(xssUtil.put(sqlwhere)) %>;
	loadTbSubjectData(_data);
}

function loadTbSubjectData(_data){
	var separator = $GetEle("separator").value;
	jQuery.ajax({
		url : "/fna/maintenance/BudgetfeeTypeBrowserNewTreeAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
			var _tbObj = jQuery("#e8_box_source_tb123");
			_tbObj.html("");
	    	var _dataArray = _json.dataArray;
	    	var _dataArrayLen = _dataArray.length;
	    	for(var i=0;i<_dataArrayLen;i++){
	    		var _id = _dataArray[i].id;
	    		var _name = _dataArray[i].fullName;
    			_tbObj.append(jQuery("<tr onclick=\"parent.onSave1('"+_id+"','"+_fnaReplaceToHtml(_name)+"');\""+
    	    			" onmouseout=\"parent.onmouseout_td(this);\""+
    	    			" onmouseover=\"parent.onmouseover_td(this);\">"+
    	    				"<td>"+_fnaReplaceToHtml(_name)+"</td>"+
    	    			"</tr>"));
	    	}
		}
	});
}



function _fnaReplaceToHtml(str){
	str = str._fnaReplaceAll123("&","&amp;")
		._fnaReplaceAll123('"',"&quot;")
		._fnaReplaceAll123("'","&apos;")
		._fnaReplaceAll123("<","&lt;")
		._fnaReplaceAll123(">","&gt;");
	return str;
}
</script>
</html>























