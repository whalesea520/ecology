<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
int id=NumberHelper.string2Int(request.getParameter("id"),0);
int appid=NumberHelper.string2Int(request.getParameter("appid"),0);
AppHomepage appHomepage = mobileAppHomepageManager.getAppHomepage(id);
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
#pagenameTip{
	color:red;
	font-size: 12px;
	font-family: 'Microsoft YaHei', Arial;
	display: none;
}
</style>
<script>
function onSave(){
	var pagenameObj = document.getElementById("pagenameshow");
	var pagenameV = pagenameObj.value;
	if($.trim(pagenameV) == ""){
		$("#pagenameTip").show();
		pagenameObj.focus();
		return;
	}
	document.getElementById("pagename").value = encodeURIComponent(pagenameV);
	var pagedescV = document.getElementById("pagedescshow").value;
	document.getElementById("pagedesc").value = encodeURIComponent(pagedescV);
	$(".loading").show();
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=copy");
	document.frmMain.submit();
}
function onClose(){
	top.closeTopDialog();
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
</script>
</HEAD>
<body>
<FORM id=weaver name=frmMain method=post target="_self">
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=appid value="<%=appid%>">
<% String pagename = Util.null2String(appHomepage.getPagename()) + SystemEnv.getHtmlLabelName(128201,user.getLanguage()); //-复制  %> 
<input type="hidden" id="pagename" name="pagename" value="<%=pagename %>">
<input type="hidden" id="pagedesc" name="pagedesc" value="<%=Util.null2String(appHomepage.getPagedesc())  %>">
</FORM>
<div style="margin: 10px 20px;">
	<div style="margin-bottom:5px;color:rgb(164,169,174);"><%=SystemEnv.getHtmlLabelName(128200,user.getLanguage())%><!-- 输入一个新的名称以复制页面 -->“<%=Util.null2String(appHomepage.getPagename()) %>”</div>
	<div>
		<input type="text" style="width:100%;border:1px solid #ccc; height: 22px;color: #333;" id="pagenameshow" name="pagenameshow" value="<%=pagename %>"/>
		<div id="pagenameTip"><%=SystemEnv.getHtmlLabelName(128202,user.getLanguage())%><!-- 请填写名称 --></div>
		<textarea name="pagedescshow" id="pagedescshow" style="font-family: 'Microsoft YaHei', Arial;width: 80%;height:50px;overflow:auto;display:none;"><%=Util.null2String(appHomepage.getPagedesc()) %></textarea>
	</div>
</div>

<div class="e8_zDialog_bottom" style="position: absolute;right: 0px;bottom:0px;margin-right: 16px;">
	<button type="button" class="e8_btn_submit" onclick="onSave()"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%><!-- 确定 --></button>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
</div>
 </body>
</html>