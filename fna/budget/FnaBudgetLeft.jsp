<%@page import="weaver.fna.maintenance.FnaCostCenter"%>

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
	<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js?r=2"></script>
	<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
	<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
<style type="text/css"><%for(int i=0;i<200;i++){%>
#ascrail200<%=i%>{left:211px!important;}<%}%>
</style>
</head>
<%
    boolean canedit = HrmUserVarify.checkUserRight("FnaBudget:View", user);

	RecordSet rs = new RecordSet();
	boolean fnaBudgetOAOrg = false;//OA组织机构
	boolean fnaBudgetCostCenter = false;//成本中心
	rs.executeSql("select * from FnaSystemSet");
	if(rs.next()){
		fnaBudgetOAOrg = 1==rs.getInt("fnaBudgetOAOrg");
		fnaBudgetCostCenter = 1==rs.getInt("fnaBudgetCostCenter");
	}

	int showtype = 111;
	String optionSpanName1 = SystemEnv.getHtmlLabelName(33062,user.getLanguage());//组织机构
	String optionSpanName2 = SystemEnv.getHtmlLabelName(515,user.getLanguage());//成本中心
	String optionSpanName = "";	
	if(fnaBudgetOAOrg && fnaBudgetCostCenter){
		optionSpanName = optionSpanName1;
		showtype = 111;
	}else if(fnaBudgetOAOrg){
		optionSpanName = optionSpanName1;
		showtype = 111;
	}else if(fnaBudgetCostCenter){
		optionSpanName = optionSpanName2;
		showtype = 222;
	}

    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "";
    String needfav = "1";
    String needhelp = "";
%>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<input type="hidden" id="showtype" value="<%=showtype %>" />

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType" style="width: 120px">
					<span><img id="currentImg" style="vertical-align:middle;" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
					<span>
						<div id="e8typeDiv" style="width:auto;height:auto;position:relative;">
							<span id="optionSpan" title="<%=optionSpanName %>" onclick="__e8InitTreeSearch();"><%=optionSpanName %></span>
							<%if(fnaBudgetOAOrg && fnaBudgetCostCenter){ %>
							<span style="width:16px;height:16px;padding-left:8px;cursor:pointer;" onclick="showE8TypeOption();">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
							<%} %>
						</div>
					</span>
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
				<ul style="margin: 0; border: 0; padding: 0;" id="fnaWfTree" class="ztree"></ul>
			</div>
		</td>
	</tr>
</table>
<%	if(fnaBudgetOAOrg && fnaBudgetCostCenter){ %>
	<ul id="e8TypeOption" class="e8TypeOption">
<%
	if(fnaBudgetOAOrg){
%>
		<li onclick="changeShowType(this,111);">
			<span id="showspan1" class="e8img"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text" title="<%=optionSpanName1 %>"><%=optionSpanName1 %></span>
		</li>
<%	}
	if(fnaBudgetCostCenter){
%>
		<li onclick="changeShowType(this,222);">
			<span id="showspan2" class="e8img e8imgSel"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text" title="<%=optionSpanName2 %>"><%=optionSpanName2 %></span>
		</li>
	</ul>
<%
	}
}
%>

<FORM id=weaver name=frmmain action="/fna/budget/FnaBudgetGrid.jsp" method=post STYLE="margin-bottom:0" target="optFrame">
    <input type="hidden" id="organizationtype" name="organizationtype" value="" />
    <input type="hidden" id="organizationid" name="organizationid" value="" />
</FORM>

</body>
<SCRIPT language="javascript">
function changeShowType(obj,showtype){
	jQuery("div[id^='ascrail20']").remove();
	var title = jQuery(obj).find(".e8text").html();
	var title1 = jQuery(obj).find(".e8text").attr("title");
	jQuery("#optionSpan").html(title);
	jQuery("#optionSpan").attr("title",title1);
	if(title.length>4){
		var spwidth = 30*title.length;
		if(spwidth>180)spwidth=180;
		jQuery(".leftType").width(spwidth);	
	}
	jQuery("#virtualtype").val(showtype);
	jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
	jQuery("span[id^='showspan']").each(function(){
		jQuery(this).addClass("e8imgSel");
	});
	jQuery("#showspan"+showtype).removeClass("e8imgSel");
	jQuery("#showtype").val(showtype);
	showE8TypeOption();

	jQuery("#e8_loading").hide();
	jQuery("#div_flowMenuDiv").html("<ul style=\"margin: 0; border: 0; padding: 0;\" id=\"fnaWfTree\" class=\"ztree\"></ul>");
	global_clickId = "";
	isFirstLoad = true;
	onlyFnaWf_onclick();
	__e8InitTreeSearch();
}

function URLencode(sStr) {
	return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}

function e8_custom_search_for_tree(_searchStr_lowerCase){
	var _url = "/fna/budget/FnaBudgetLeftAjax.jsp"
	if(jQuery("#showtype").val()=="222"){
		_url = "/fna/budget/FnaBudgetLeftFccAjax.jsp"
	}

	if(_searchStr_lowerCase==null||_searchStr_lowerCase==""){
		jQuery("#e8_loading").hide();
		jQuery("#div_flowMenuDiv").html("<ul style=\"margin: 0; border: 0; padding: 0;\" id=\"fnaWfTree\" class=\"ztree\"></ul>");
		global_clickId = "";
		isFirstLoad = true;
		onlyFnaWf_onclick();
	}else{
		_data = "_searchStr_lowerCase="+_searchStr_lowerCase;
		jQuery.ajax({
			url : _url,
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(_json){
			    try{
					var _zNodes = eval(_json);
					jQuery("#e8_loading").hide();
					jQuery("#div_flowMenuDiv").html("<ul style=\"margin: 0; border: 0; padding: 0;\" id=\"fnaWfTree\" class=\"ztree\"></ul>");
			    	var _setting = {
		    			data: {
		    				simpleData: {enable: true}
		    			},
		    			callback: {
		    				onClick: fnaWfTree_onClick
		    			}
		    		};
			    	jQuery.fn.zTree.init(jQuery("#fnaWfTree"), _setting, _zNodes);
			    	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
			    	treeObj.expandAll(true); 
			    }catch(e1){
			    	alert(e1);
			    }
			}
		});	
	}
}

function __e8InitTreeSearch(){
	var organizationtype = "";
	if(jQuery("#showtype").val()=="222"){
		organizationtype = "fccType";
	}
	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
	treeObj.cancelSelectedNode();
	parent.document.getElementById("optFrame").src = "/fna/budget/FnaBudgetGrid.jsp?organizationtype="+organizationtype;
}

function quickQry(qname){
	//alert("quickQry qname="+qname);
}

var global_clickId = "";
function do_reAsyncChildNodes(_id,_clickId){
	try{
		//alert("do_reAsyncChildNodes _id="+_id+";_clickId="+_clickId);
		global_clickId = _clickId;
		var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
		var nodes = treeObj.getNodesByParam("id", _id, null);
		nodes[0].isParent = true;
		treeObj.reAsyncChildNodes(nodes[0], "refresh");
	}catch(ex){}
}

var setting = {
	async: {
		enable: true,
		url:"/fna/budget/FnaBudgetLeftAjax.jsp",
		autoParam:["id2"],
		otherParam:{"otherParam":"0"},
		dataFilter: filter
	},	
	callback: {
		onClick: fnaWfTree_onClick,
		onAsyncSuccess: fnaWfTree_onAsyncSuccess
	}
};

var settingFcc = {
	async: {
		enable: true,
		url:"/fna/budget/FnaBudgetLeftFccAjax.jsp",
		autoParam:["id2"],
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
		jQuery("#subjectId").val("0");
		//alert("fnaWfTree_onClick id="+treeNode.id);
		
		var idArray = (treeNode.id+"").split("_");
		var idType = idArray[0];
		var id = idArray[1];

		var orgType = "";
		var orgId = "";
		if(idType=="c"){
			orgType = "0";
			orgId = "1";
		}else if(idType=="s"){
			orgType = "1";
			orgId = id;
		}else if(idType=="d"){
			orgType = "2";
			orgId = id;
		}else if(idType=="fccType"){
			orgType = "fccType";
			orgId = id;
		}else if(idType=="fcc"){
			orgType = "<%=FnaCostCenter.ORGANIZATION_TYPE %>";
			orgId = id;
		}else{
			return;
		}
		
		jQuery("#organizationtype").val(orgType);
		jQuery("#organizationid").val(orgId);
	    document.frmmain.submit();
	}catch(e){
		alert(e.message);
	}
}

var isFirstLoad = true;
function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
	try{
		var _clickId = global_clickId;
		global_clickId = "";
		
		var treeObj = jQuery.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.getNodes();
		if(nodes.length==1 && isFirstLoad){
			isFirstLoad = false;
			var _a = treeObj.expandNode(nodes[0], true, false, true);
			treeObj.selectNode(nodes[0]);
			treeObj.cancelSelectedNode(nodes[0]);
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
	if(jQuery("#showtype").val()=="222"){
		jQuery.fn.zTree.init(jQuery("#fnaWfTree"), settingFcc);
	}else{
		jQuery.fn.zTree.init(jQuery("#fnaWfTree"), setting);
	}
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