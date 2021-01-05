
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/mobilemode/init.jsp"%>
<%
if(!HrmUserVarify.checkUserRight("MobileModeSet:All", user)){
	return;
}
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
if(mmdetachable.equals("1")){
	if(subCompanyId == -1){
		subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
	    if(subCompanyId == -1){
	        subCompanyId = user.getUserSubCompany1();
	    }
	}
}else{
	subCompanyId = -1;
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读
if(operatelevel < 2){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>
*{
	font: 12px Microsoft YaHei;
}
html,body{
	height: 100%;
	margin: 0px;
	padding: 0px;
	overflow: hidden;
}
.divBtn{
	width: 80px;
	padding: 5px 0;
	margin-left:10px;
	background-color: #2d89ef;
	color: #fff;
	font-family: 'Microsoft YaHei', Arial;
	font-size: 12px;
	line-height: 18px;
}
.divBtnDisabled{
	background-color: #E9E9E9 !important;
}
.subCompany-choose{
	font-size: 14px;
	text-align:center;
	margin-bottom:20px;
	display:table;
}
.subCompany-choose div{
	display:inline-block;
    height: 30px;
    line-height: 30px;
    padding: 0 5px;
    color:#000;
    display:table-cell;
}

.subCompany-choose div:nth-child(2){
	padding-right: 20px;
    background-image: url(/wui/theme/ecology8/skins/default/general/browser_wev8.png);
    background-position: right center;
    background-repeat: no-repeat;
    background-size: 16px;
    cursor:pointer;
    border-bottom: 1px solid #e8e8e8;
    min-width:50px;
}
</style>
<script>
function onClose(){
	top.closeTopDialog();
}

function importwf(){
	var parastr="filename";
	var filename = document.frmMain.filename.value;
	var pos = filename.length-4;
	<%if(mmdetachable.equals("1")){%>
	var subCompanyId = $("#subCompanyId").val();
	if(subCompanyId == ""){
		alert("<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%>");//请选择分部
		return;
	}
	<%}%>
	if(filename==null||filename==''){
		alert("<%=SystemEnv.getHtmlLabelName(127672,user.getLanguage())%>");//请先选择文件
	}else{
		if(filename.lastIndexOf(".jar")==pos || filename.lastIndexOf(".zip")==pos){
			clearMessage();
			disabledBtn();
			document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.appio.imports.MobileAppioAction", "action=import");
			document.frmMain.submit();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(81992,user.getLanguage())%>");//选择文件格式不正确，请选择zip文件！
			return;
		}
	}
}

function clearMessage(){
	var upload_faceico = document.getElementById("upload_faceico");
	var upload_faceicoDoc = upload_faceico.contentWindow.document;
	if(upload_faceicoDoc && upload_faceicoDoc.body){
		upload_faceicoDoc.body.innerHTML = "";
	}
}

function disabledBtn(){
	$("#uploadBtn").attr("disabled","disabled").addClass("divBtnDisabled");
}

function enabledBtn(){
	$("#uploadBtn").removeAttr("disabled").removeClass("divBtnDisabled");
}
function selectSubCompany(){
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
			
			$("#subCompanyName").html(name);
			$("#subCompanyId").val(id);
		}
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%>";//选择分部
	dialog.Drag = false;
	dialog.show();
}
function changeAgentContent(){
        document.getElementById("inputFileAgent").value = document.getElementById("filename").value;
    }
</script>
</HEAD>
<body>
<FORM style="MARGIN-TOP: 0px;padding:25px 25px 20px 25px;" name=frmMain method=post action="" enctype="multipart/form-data" target="upload_faceico">
	<%if(mmdetachable.equals("1")){%>
	<div class="subCompany-choose">
		<div><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>:<!-- 所属分部 --></div>
		<div onclick="selectSubCompany()">
		<span id="subCompanyName"><%if(subCompanyId == -1){%>
			<%=SystemEnv.getHtmlLabelName(82181,user.getLanguage())%><!-- 请选择分部 -->
		<%}else{%>
			<%=SubCompanyComInfo.getSubCompanyname(""+subCompanyId) %>
		<% } %></span>
		<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId %>"/>
		</div>
	</div>
	<%}else{%>
	<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId %>"/>
	<%} %>
	<input  type=file  name="filename" id="filename" style="display:none" onchange="changeAgentContent()">
	<input type="text" value="" disabled id="inputFileAgent" />
	<input type="button" onclick="document.getElementById('filename').click()" value="<%=SystemEnv.getHtmlLabelName(125333,user.getLanguage())%>" /><!-- 选择文件  -->
	<button type="button" id="uploadBtn" class="divBtn" onclick="importwf()"><%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%></button><!-- 开始导入  -->
</FORM>
<div style="overflow:hidden;height:200px;">
	<div style="float:left;height:100%;margin-left: 25px;vertical-align:middle;">Message：</div>
	<div style="float:left;height:100%;"><iframe id="upload_faceico" name="upload_faceico" style="height:100%;border:0px;"></iframe></div>
</div>
</body>
</html>