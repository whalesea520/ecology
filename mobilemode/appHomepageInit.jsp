<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomSearchService"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppFormUI"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppUIManager"%>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileTemplateManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String templateType = Util.null2String(request.getParameter("templateType"));
if(id==0)return;
MobileTemplateManager mobileTemplateManager=MobileTemplateManager.getInstance();
List<Map> templateMaps=MobileTemplateManager.getInstance().getTemplateList(templateType);
int idInt = 0;
int appid = 0;
String refresh = "0";
if("homepage".equals(templateType)){
	MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
	AppHomepage appHomepage=mobileAppHomepageManager.getAppHomepage(id);
	idInt=appHomepage.getId()==null?0:appHomepage.getId();
	appid=appHomepage.getAppid();
	refresh = Util.null2o(request.getParameter("refresh"));
}else if("formuilist".equals(templateType)){
	idInt = id;
}
int cheindex=0;
int templateSize=0;
for(int i=0;i<templateMaps.size();i++){
	Map map =  templateMaps.get(i);	
	String enable=Util.null2String(map.get("enable"));
	if("true".equalsIgnoreCase(enable)){
		cheindex=i+1;
		templateSize++;
	}
}
int pagenum = templateSize/2+templateSize%2;
%>
<html>
<head>
	<title></title>
<style>
html,body{
	height:100%;
	overflow:hidden;
}
ul{
	list-style: none;
	margin: 0;
	padding: 15px 15px;
	width: 2000px;
}
ul li{
	width: 320px;
	float: left;
	margin: 0 19px;
}
ul li div{
	font-family: 'Microsoft YaHei', Arial;
}
.templateName{
	font-size: 18px;
	padding: 5px 0 0 0;
}
.templateDesc{
	font-size: 12px;
	line-height: 17px;
	color: #aaa;
	padding: 5px 0;
}

.divBtn{
	width: 100px;
	padding: 5px 0;
	margin: 5px 0;
	background-color: #2d89ef;
	color: #fff;
	font-family: 'Microsoft YaHei', Arial;
	font-size: 14px;
}
.imgPreviewdiv{
	position: relative;
	margin: 0px;
	padding: 0px;
	width: 320px;
	height: 160px;
	border: 2px solid #fff;
	overflow: hidden;
}
.imgPreview{
	width: 320px;
	height: 160px;
}
.checked{
	width: 23px;
	height: 23px;
	position: absolute;
	right:0px;
	bottom: 0px; 
	background: url("/mobilemode/images/template/ok_wev8.png") no-repeat;
	display: none;
}
.templateName_sel{
	color : #2d89ef;
}
.imgPreviewdiv_sel{
	border:0px solid rgb(114,173,9);
}
.imgPreviewdiv_sel .checked{
	display: block;
}

#prev{
	position: absolute;
	top: 45%;
	left: 10px;
	width: 19px;
	height: 36px;
	background: url("/mobilemode/images/template/arrowL_wev8.png"); 
	cursor: pointer;
}
#next{
	position: absolute;
	top: 45%;
	right: 7px;
	width: 19px;
	height: 36px;
	background: url("/mobilemode/images/template/arrowR_wev8.png"); 
	cursor: pointer;
}


	</style>
	<script>
	if('<%=refresh%>'=='1'){
		top.callTopDlgHookFn();
	}
	function init(index){
		$("#index").val(index);
		enableAllmenu();
		$(".loading").show(); 
		
		var action = '';
		var templateType = '<%=templateType%>';
		if(templateType == 'homepage'){
			action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=initHomepage");
		}else if(templateType == 'formuilist'){
			action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppUIAction", "action=formUIListInit");
		}
		document.frmMain.action= action;
		document.frmMain.submit();
	}
	
	function initold(){
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=initHomepage");
		document.frmMain.submit();
	}
	
	var cml = 0;
	//模板页数
	var pagenum = <%=pagenum%>;
	//每页宽度
	var pagewidth = 715;
	$(document).ready(function ($) {
		$("#prev").click(function(){
			cml -= -pagewidth;
			if(cml > 0){
				cml = 0;
				return;
			}
			$("ul.a").animate({marginLeft:  cml+"px"}, "normal");
			togglePageButton()
		});
		
		$("#next").click(function(){
			cml += -pagewidth;
			if(cml < (-pagewidth * (pagenum - 1))){
				cml = (-pagewidth * (pagenum - 1));
				return;
			}
			$("ul.a").animate({marginLeft:  cml+"px"}, "normal");
			togglePageButton()
		});
		togglePageButton();
		
	});
	
	function togglePageButton(){
		if(cml==0){
			$("#prev").hide();
		}else{
			$("#prev").show();
		}
		if(cml==(-1*pagewidth*(pagenum-1))){
			$("#next").hide();
		}else{
			$("#next").show();
		}
	}

	</script>
</head>
  
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	//RCMenu += "{初始化,javascript:initold(),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain method=post target="_self" >
<input type="hidden" id="id" name=id value="<%=idInt%>">
<input type="hidden" id="appid" name="appid" value="<%=appid%>">
<input type="hidden" id="index" name="index" value="<%=cheindex%>">
<div id="prev">

</div>
<div id="next">

</div>
<ul class="a">
<%
for(int i=0;i<templateMaps.size();i++){
	Map map =  templateMaps.get(i);
	String name=Util.null2String(map.get("name"));
	String url=Util.null2String(map.get("url"));
	String desc=Util.null2String(map.get("desc"));
	String crname=Util.null2String(map.get("crname"));
	String crdate=Util.null2String(map.get("crdate"));
	if("".equals(desc)){
		desc= "系统默认提供的模板，快速创建App页面，可根据添加的模块自动生成导航栏。";
	}
	if("".equals(name))name="模板"+(i+1);
	String enable=Util.null2String(map.get("enable"));
	boolean isexist = false;
	String divclass1="";
	String divclass2="";
	if("true".equalsIgnoreCase(enable)){
		isexist = true;
		divclass1 =" templateName_sel";
		divclass2 =" imgPreviewdiv_sel";
	%>
		<li>
			<div class="templateName<%=divclass1%>" ><%=name%></div>
			<div class="templateDesc"><%=desc%></div>
			<img class="imgPreview" src=<%=url%> />
			<div class="templateDesc"><%=crname%> 创建于<%=crdate%></div>
			<button class="divBtn" type="button" onclick="init(<%=i+1%>)">选择模板</button>
		</li>
	<%
	}
	%>

<%
}
%>
</ul>
</FORM>
</body>
</html>
