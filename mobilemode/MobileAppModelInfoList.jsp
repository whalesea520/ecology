
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo" %>
<%@ page import="com.weaver.formmodel.mobile.model.MobileAppModelInfo" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppModelManager" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager" %>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String appid=Util.null2String(request.getParameter("appid"));
int idInt = Util.getIntValue(appid,-1);
MobileAppBaseInfo appbaseInfo = MobileAppBaseManager.getInstance().get(idInt);
List<MobileAppModelInfo> appformlist = MobileAppModelManager.getInstance().getAllFormByAppid(idInt);
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String treeFieldId=Util.null2String(request.getParameter("treeFieldId"));
String err=Util.null2String(request.getParameter("err"));
String step = Util.null2String(request.getParameter("step"));
String appname = appbaseInfo.getAppname();
JSONArray jsonArray=new JSONArray();
for(MobileAppModelInfo appform : appformlist) {
	JSONObject jsonObject=new JSONObject();
	jsonObject.put("id",appform.getId());
	jsonArray.add(jsonObject);
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
.active{background-color:#A9A9A9!important;}
html,body{
	height:100%;
	overflow-x:hidden;
}
.mobileappmodel{
	margin-top:10px;
}
.mobileappmodel ul{
	list-style:none;
	margin:0px;
	padding:0px;
}
.mobileappmodel ul li{
	padding: 2px 2px;
	cursor: pointer;
}
.mobileappmodel li a{
	display: block;
	color: #000;
	padding-left: 10px;
	text-decoration: none;
	position: relative;
}
.mobileappmodel ul li.selected{
	background-color: #ddd;
}
.mobileappmodel ul li.selected a{
	color: #000;
}
</style>
<script>
function createMobileModel(id){
	rightMenu.style.visibility = "hidden";
	window.parent.parent.createMobileModel(id);
}

function editMobileModel(){
	if(currMobileModeInfoId==null){
		alert("请新建手机模块！");
	}else{
		createMobileModel(currMobileModeInfoId);
	}
}

function selectMobileModel(id,AElement){
	var $AElement=$("#A_"+id);
	var $li = $AElement.parent();
	$li.siblings().removeClass("selected");
	$li.addClass("selected");
	currMobileModeInfoId=id;
	FormmodeUtil.writeCookie(FormModeConstant._CURRENT_Mobile_MODELINFO, id);
}

var currMobileModeInfoId = null;
$(document).ready(function(){
	var datas=<%=jsonArray.toString()%>;
	currMobileModeInfoId = FormmodeUtil.getLastId(FormModeConstant._CURRENT_Mobile_MODELINFO, datas, "id");
	if(currMobileModeInfoId != null){
		$("#A_" + currMobileModeInfoId).parent().addClass("selected");
	}
})

/**
 * 新建UI
 * 
 */
function createMobileUI(){
	var entityid=currMobileModeInfoId;
	if(entityid==null){
		alert("请新建手机模块！");
	}else{
		window.parent.parent.document.getElementById("rightFrame").src="appuidesign.jsp?entityid="+entityid+"&appid=<%=appid%>";
	}
}
</script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{新建模块,javascript:createMobileModel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{编辑模块,javascript:editMobileModel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{新建UI,javascript:createMobileUI(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="mobileappmodel">
	<ul>
	<%
	for(MobileAppModelInfo appform : appformlist) {
		%>
	<li><a id="A_<%=appform.getId()%>" href="javascript:void(0);" onclick="javascript:selectMobileModel(<%=appform.getId()%>)"><%=appform.getEntityName()%></a></li>
		<%
	}
	%>
	</ul>
</div>
 </body>
</html>