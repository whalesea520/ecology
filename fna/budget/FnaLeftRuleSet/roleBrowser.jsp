<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String guid1 = UUID.randomUUID().toString();

RecordSet rs1 = new RecordSet();

StringBuffer zNodes = new StringBuffer();

int idx = 0;
String sql1 = "SELECT a.* from HrmRoles a ORDER BY a.rolesname";
//out.println(sql1+"<br>");
rs1.executeSql(sql1);
while (rs1.next()) {
	RecordSet rs2 = new RecordSet();

	String _id1 = Util.null2String(rs1.getString("id")).trim();
	String _name1 = rs1.getString("rolesmark");

	if (idx > 0) {
		zNodes.append(",");
	}

	String chkDisabled1 = "chkDisabled:false";

	String isChecked1 = "checked:false";

	String isOpen1 = "open:false";
	
	zNodes.append("{" + "id:" + JSONObject.quote(_id1) + ","
			+ "name:" + JSONObject.quote(_name1) + "," + isOpen1 + "," + isChecked1 + ","
			+ chkDisabled1 + "," + "icon:"
			+ JSONObject.quote("/images/treeimages/subCopany_Colse_wev8.gif") + "}");
	idx++;
}
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css?r=3" type="text/css">
	<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js?r=2"></script>
 </HEAD>
  <BODY style="text-align: center;">
	<ul id="fnaFeeTypeTree" class="ztree"></ul>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </BODY>
 </HTML>


<script type="text/javascript">

var setting = {
	check: {
		enable: false,
		chkStyle: "radio",
		radioType: "all"
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		onClick: fnaWfTree_OnClick
	}
};

function fnaWfTree_OnClick(event, treeId, treeNode) {
	if(treeNode.level==0){
		//alert("[ onCheck ] (" + treeNode.id + "; " + treeNode.level + "; " + treeNode.name + "; " + treeNode.checked+" )");
	    window.parent.returnValue = {id:treeNode.id,name:treeNode.name,path:""};
	    window.parent.close();
	}
}

function onlyFnaWf_onclick(_this){
	var zNodes = [<%=zNodes %>];
	jQuery.fn.zTree.init(jQuery("#fnaFeeTypeTree"), setting, zNodes);
}

jQuery(document).ready(function(){
	onlyFnaWf_onclick(jQuery("#onlyFnaWf")[0]);
});
</script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery(".btn_style").hover(function(){
		mm_style_onhover(this,1);
	},function(){
		mm_style_onhover(this,2);
	});
});
function mm_style_onhover(_obj,_type){
	_obj = jQuery(_obj);
	if(_type==2){
		_obj.removeClass("btn_style_focus");
	}else{
		_obj.addClass("btn_style_focus");
	}
}
function btnok_onclick(){
	//alert("btnok_onclick()");
	var checkNodeIds = "";
	var checkNodeNames = "";
	var zTree = jQuery.fn.zTree.getZTreeObj("fnaFeeTypeTree");
	var checkNodeArray = zTree.getCheckedNodes(true);
	var checkCount = checkNodeArray;
	if(checkCount.length > 0){
		//alert(checkNodeArray[i].name+"="+checkNodeArray[i].getCheckStatus().half);
		checkNodeIds += checkNodeArray[0].id;
		checkNodeNames += checkNodeArray[0].name;
	    window.parent.returnValue = {id:checkNodeIds,name:checkNodeNames,path:""};
	    window.parent.close();
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(1011,user.getLanguage()) %>");//请先选择记录，再进行该操作
	}
} 
function btnclear_onclick(){
	//alert("btnclear_onclick()");
     window.parent.returnValue = {id:"",name:"",path:""};
     window.parent.close();
}  
function btnclose_onclick(){
    window.parent.returnValue = null; 
    window.parent.close();
}
</script>
<style>
.btn_style_focus{
	background-color: #EEEEEE;
}
.btn_style{
	border: #d2d2d2 1px solid;
	margin: 0px;
	padding: 0px;
	width: 60px;
	color: #808080;
	font-family: 微软雅黑;
	text-align: center;
	cursor: pointer;
}
</style>