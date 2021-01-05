
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileAppHomepageManager"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.mobile.ui.model.AppHomepage"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
int subCompanyId=-1;
if(mmdetachable.equals("1")){
	subCompanyId=Util.getIntValue(Util.null2String(session.getAttribute("mobilemode_defaultSubCompanyId")),-1);
    if(subCompanyId == -1){
        subCompanyId = user.getUserSubCompany1();
    }
}
int operatelevel = getCheckRightSubCompanyParam("MobileModeSet:All",user,mmdetachable ,subCompanyId);//权限等级-> 2完全控制 1 编辑 0 只读
if(operatelevel < 1){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
MobileAppHomepageManager mobileAppHomepageManager=MobileAppHomepageManager.getInstance();
int id=NumberHelper.string2Int(request.getParameter("id"),0);
int appid=NumberHelper.string2Int(request.getParameter("appid"),0);
AppHomepage appHomepage = mobileAppHomepageManager.getAppHomepage(id);

String err=Util.null2String(request.getParameter("err"));
String refresh = Util.null2o(request.getParameter("refresh"));
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
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	//parent.refreshWithAppBaseCreated();
}
</script>
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
	document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileAppHomepageAction", "action=create");
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
<% String pagename = Util.null2String(appHomepage.getPagename()); %>
<input type="hidden" id="pagename" name="pagename" value="<%=pagename %>">
<input type="hidden" id="pagedesc" name="pagedesc" value="<%=Util.null2String(appHomepage.getPagedesc())  %>">
</FORM>
<table class="e8_tblForm">
	<tr>
		<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td><!-- 名称 -->
		<td class="e8_tblForm_field">
			<input type="text" style="width:80%;" id="pagenameshow" name="pagenameshow" value="<%=pagename %>" onchange="checkInput('pagenameshow');"/>
			<span id="pagenameSpan">
				<% if(pagename.trim().equals("")){ %>
				<img align="absMiddle" src="/images/BacoError_wev8.gif" />
				<% } %>
			</span>
			<span id="pagenameTip"><%=SystemEnv.getHtmlLabelName(125393,user.getLanguage())%><!-- 请填写名称 --></span>
		</td>
	</tr>
	<tr>
		<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td><!-- 描述 -->
		<td class="e8_tblForm_field">
			<textarea name="pagedescshow" id="pagedescshow" style="font-family: 'Microsoft YaHei', Arial;width: 80%;height:50px;overflow:auto;"><%=Util.null2String(appHomepage.getPagedesc()) %></textarea>
		</td>
	</tr>
	<tr>
		<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(127550,user.getLanguage())%><!-- 是否为首页 --></td>
		<td class="e8_tblForm_field">
			<%="1".equals(StringHelper.null2String(appHomepage.getIshomepage()))?SystemEnv.getHtmlLabelName(82677,user.getLanguage()):SystemEnv.getHtmlLabelName(82676,user.getLanguage())%><!-- "是":"否" -->
		</td>
	</tr>
</TABLE>

<div class="e8_zDialog_bottom">
	<button type="button" class="e8_btn_submit" onclick="onSave()"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%><!-- 保存 --></button>
	<button type="button" class="e8_btn_cancle" onclick="onClose()"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%><!-- 取消 --></button>
</div>
 </body>
</html>