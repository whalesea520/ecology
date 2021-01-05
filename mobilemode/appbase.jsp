
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
MobileAppBaseManager mobileAppBaseManager=MobileAppBaseManager.getInstance();
String id=Util.null2String(request.getParameter("id"));
int idInt = Util.getIntValue(id,0);
MobileAppBaseInfo appbaseInfo = mobileAppBaseManager.get(idInt);

String err=Util.null2String(request.getParameter("err"));
String refresh = Util.null2o(request.getParameter("refresh"));
int subCompanyId=Util.getIntValue(Util.null2String(appbaseInfo.getSubcompanyid()));
if(mmdetachable.equals("1")){
	subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
    if(subCompanyId == -1){
        subCompanyId = user.getUserSubCompany1();
    }
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读

boolean canEdit = (idInt > 0 && operatelevel >= 1);
boolean canAdd = (operatelevel == 2);
if(!canEdit && !canAdd){//无编辑或新建权限
	response.sendRedirect("/notice/noright.jsp");
}
%>


<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>
*{
	font: 12px Microsoft YaHei;
}
a{
	text-decoration: none !important;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: middle;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 5px 5px 10px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_tblForm .e8_tblForm_field .subcompany_div{
	display:inline-block;
	width:224px;
	background-image: url(/wui/theme/ecology8/skins/default/general/browser_wev8.png);
    background-position: right center;
    background-repeat: no-repeat;
    background-size: 16px;
    cursor: pointer;
}
.e8_label_desc{
	color: #aaa;
}
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
#addPicDiv{
	background-color: rgb(93, 156, 236);
	color: rgb(255, 255, 255);
	cursor: pointer;
	display: inline-block;
	font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
	font-size: 12px;
	font-weight: bold;
	height: 30px;
	line-height: 30px;
	padding-bottom: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 0px;
}
#previewDiv{
	background: url("/mobilemode/images/mec/img-space2_wev8.png") no-repeat;
	width: 32px;
	height: 32px;
	border: 1px solid rgb(204,204,204);
	background-color: #fff;
	border-radius: 4px;
	margin-top: 5px;
}
#previewImg{
	width: 100%;
	height: 100%;
	border-radius: 4px;
}
#appnameTip,#subCompanyNameTip{
	color:red;
	font-size: 12px;
	font-family: 'Microsoft YaHei', Arial;
	display: none;
}
</style>
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	parent.refreshWithAppBaseCreated();
}
</script>
<script>
function onSave(){
	var appnameObj = document.getElementById("appname");
	var appnameV = appnameObj.value;
	if($.trim(appnameV) == ""){
		$("#appnameTip").show();
		appnameObj.focus();
		return;
	}
	
	<%if(mmdetachable.equals("1")){%>
		var subCompanyId = $("#subCompanyId").val();
		if(subCompanyId == ""){
			$("#subCompanyNameTip").show();
			return;
		}
	<%}%>
	
	enableAllmenu();
	$(".loading").show();
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=Save");
	document.frmMain.submit();
}
function onPublish(){
	enableAllmenu();
	$(".loading").show(); 
	document.getElementById("ispublish").value="1";
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=Save");
	document.frmMain.submit();
}
function unPublish(){
	document.frmMain.operation.value="Save";
	enableAllmenu();
	$(".loading").show(); 
	document.getElementById("ispublish").value="2";
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=Save");
	document.frmMain.submit();
}
function onDelete(){
	var appnameObj = document.getElementById("appname").value;
	if(confirm("<%=SystemEnv.getHtmlLabelName(127418,user.getLanguage())%>")) { //你确定删除此移动应用吗？
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=Delete");
		document.frmMain.submit();
	}
}
function onWaste(){
	var appnameObj = document.getElementById("appname").value;
	if(confirm("<%=SystemEnv.getHtmlLabelName(127420,user.getLanguage())%>")) { //你确定废弃此移动应用吗？
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=waste");
		document.frmMain.submit();
	}
}
function onClose(){
	top.closeTopDialog();
}
function addPic(){
	var pic_pathV = $("#picpath").val();
	var url = "/mobilemode/picset.jsp?pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>"; //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#picpath").val(picPath);
		$("#previewImg").show().attr("src", picPath);
	};
}
function checkInput(eleId){
	var v = $("#" + eleId).val();
	if($.trim(v) != ""){
		$("#" + eleId + "Span").html("");
		$("#" + eleId + "Tip").hide();
	}else{
		$("#" + eleId + "Span").html("<img align='absMiddle' src='/images/BacoError_wev8.gif'/>");
	}
}
function selectSubCompany(skinid){
	var winHight = jQuery(window).height();
	var winWidth = jQuery(window).width();
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 580;
	dialog.Height = 630;
	dialog.normalDialog = false;
	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=MobileModeSet:All&isedit=1";
	dialog.callbackfun = function (paramobj, id1) {
		if(id1){
			var id = id1.id;
			var name = id1.name;
			$("#subCompanyName").val(name);
			$("#subCompanyId").val(id);
		}
		checkInput('subCompanyName');
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
	dialog.Drag = false;
	dialog.show();
}
</script>
</HEAD>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(operatelevel == 2 && idInt > 0) {
    	if(appbaseInfo.getIspublish()!=1){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(114,user.getLanguage())+",javascript:onPublish(),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} ";
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(81999,user.getLanguage())+",javascript:onWaste(),_self} ";//废弃
    		RCMenuHeight += RCMenuHeightStep ;
    	}else{
            RCMenu += "{"+SystemEnv.getHtmlLabelName(127383,user.getLanguage())+",javascript:unPublish(),_self} " ;//下架
            RCMenuHeight += RCMenuHeightStep ;
    	}   	
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<FORM id=weaver name=frmMain method=post target="_self"  enctype="multipart/form-data">
<input type=hidden name=operation id="operation">
<input type=hidden name=id value="<%=id%>">
<input type=hidden name="ispublish" id="ispublish" value="<%=appbaseInfo.getIspublish() %>">
<%
if("1".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(28472,user.getLanguage())+"</a>");		
}else if("2".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(21089,user.getLanguage())+"</a>");		
}
%>
<table class="e8_tblForm">
	<tr>
		<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
		<td class="e8_tblForm_field">
			<% String appname = Util.null2String(appbaseInfo.getAppname()); %>
			<input type="text" style="width:80%;" id="appname" name="appname" value="<%=appname%>" onchange="checkInput('appname');"/>
			<span id="appnameSpan">
				<% if(appname.trim().equals("")){ %>
				<img align="absMiddle" src="/images/BacoError_wev8.gif" />
				<% } %>
			</span>
			<span id="appnameTip"><%=SystemEnv.getHtmlLabelName(125393,user.getLanguage())%><!-- 请填写名称 --></span>
		</td>
	</tr>
	<tr style="display: none;">
		<td class="e8_tblForm_label" width="20%">发布状态<div class="e8_label_desc">发布到e-mobile服务器</div></td>
		<td class="e8_tblForm_field">
			<span><%=appbaseInfo.getIspublish() == 0?"待发布":"" %>
          	<%=appbaseInfo.getIspublish() == 1?"发布":"" %>
           	<%=appbaseInfo.getIspublish() == 2?"下架":"" %>
          	</span>
		</td>
	</tr>
	<tr>
		<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%><div class="e8_label_desc"></div></td><!-- 图标 -->
		<td class="e8_tblForm_field">
			<div id="addPicDiv" onclick="addPic();"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%><!-- 选择图片 --></div>
					
			<div id="previewDiv">
            	<img id="previewImg" <%if(Util.null2String(appbaseInfo.getPicpath()).trim().equals("")){%> style="display: none;" <%}else{%> src="<%=Util.null2String(appbaseInfo.getPicpath()) %>" <%}%>>
            </div>
            
            <INPUT type="hidden" name="picpath" id="picpath" value="<%=Util.null2String(appbaseInfo.getPicpath()) %>">
            <!-- 
			<INPUT type="file" name="picpath" id="picpath" value="<%=Util.null2String(appbaseInfo.getPicpath()) %>">
			 -->
		</td>
	</tr>
	<%if(mmdetachable.equals("1")){%>
	<tr  >
		<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%><!-- 所属分部 --></td>
		<td class="e8_tblForm_field">
		<div class="subcompany_div" onclick="selectSubCompany()">
		<input type="text" style="width:200px;" readonly="readonly" id="subCompanyName" name="subCompanyName" value="<%=SubCompanyComInfo.getSubCompanyname(""+subCompanyId)%>"/>
		<input type="hidden" name="subCompanyId" id="subCompanyId" value="<%=""+subCompanyId %>" />
		</div>
		<span id="subCompanyNameSpan">
			<% if(subCompanyId == -1){ %>
			<img align="absMiddle" src="/images/BacoError_wev8.gif" />
			<% } %>
		</span>
		<span id="subCompanyNameTip"><%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 --></span>
		</td>
	</tr>
	<%}else{ %>
	<input type="hidden" name="subCompanyId" id="subCompanyId" value="<%=""+subCompanyId %>" />
	<%} %>
	<tr>
		<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td><!-- 顺序-->
		<td class="e8_tblForm_field">
			<INPUT name="showorder" style="width:200px;" id="showorder" value="<%=appbaseInfo.getShoworder() %>">
		</td>
	</tr>
	
	<tr>
		<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td><!-- 描述 -->
		<td class="e8_tblForm_field">
			<textarea name="descriptions" id="descriptions" style="font-family: 'Microsoft YaHei', Arial;width: 80%;height:50px;overflow:auto;"><%=Util.null2String(appbaseInfo.getDescriptions()) %></textarea>
		</td>
	</tr>
	
</TABLE>
</FORM>

<div class="e8_zDialog_bottom">
	<button type="button" class="e8_btn_submit" onclick="onSave()"><%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%><!-- 保存 --></button>
	<%if(operatelevel == 2 && idInt > 0){
		if(appbaseInfo.getIspublish()!=1){%>
			<button type="button" class="e8_btn_delete" onclick="onDelete()"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!-- 删除 --></button>
			<button type="button" class="e8_btn_delete" onclick="onWaste()"><%=SystemEnv.getHtmlLabelName(81999,user.getLanguage())%><!-- 废弃 --></button>
		<%}
	}%>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
</div>
 </body>
</html>