<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String result = Util.null2String(request.getParameter("result"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<style>
/*
	作用描述：给INPUT添加美化的样式，兼容IE8,IE9,FF,chrome,safari等
	效果描述；
		- 1.边框带圆角
		- 2.指定INPUT高度
		- 3.INPUT文本上下居中，添加左边距
		- 4.背景色为白色
		- 5.当INPUT获得光标的时候，边框高亮显示天蓝色。
		- 6.IE7下没有高亮效果
		- 7.chrome下聚焦后边框是2px。
*/
.onlyAlpha{
	border:1px solid #d6dae0;
	border:1px solid #d6dae0 \9;/*IE*/
	width:80px;
	text-align:center;
	height:40px;/*非IE高度*/
	height:40px \9;/*IE高度*/
	padding-left:5px; /*all*/
	line-height:20px \9;/*IE*/
	-moz-border-radius:3px;/*Firefox*/
	-webkit-border-radius:3px;/*Safari和Chrome*/
	border-radius:3px;/*IE9+*/
	background-color:white;
	outline:none;
}
.onlyAlpha:focus{/*IE8+*/
	border-color:#78BAED;
	[;outline:1px solid #78BAED;/*chrome*/
}
</style>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=result%>"=="1"){
	parentWin.doHrmImportView();
}
function doSubmit(){
	if(check_form(frmMain,'lastname,mobile')){
		frmMain.submit();
	}
}

jQuery(document).ready(function(){
 jQuery(".onlyAlpha").onlyAlpha();
 jQuery(".onlyNum").onlyNum();
 jQuery("#u915").hide();
})
jQuery.fn.onlyAlpha = function () {
    jQuery(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122))
            return true;
        else
            return false;
    }).focus(function () {
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
        var clipboard = window.clipboardData.getData("Text");
        if (/^[a-zA-Z]+$/.test(clipboard))
            return true;
        else
            return false;
    });
};

jQuery.fn.onlyNum = function () {
    jQuery(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 48 && keyCode <= 57))
            return true;
        else
            return false;
    }).focus(function () {
    //禁用输入法
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
    //获取剪切板的内容
        var clipboard = window.clipboardData.getData("Text");
        if (/^\d+$/.test(clipboard))
            return true;
        else
            return false;
    });
};
function jsToUpperCase(obj){   
  obj.value = obj.value.toUpperCase();   
}

document.onclick = function(e) {
 e = window.event || e; // 兼容IE7
 obj = $(e.srcElement || e.target);
 // 点击区域位于当前节点
 if (obj.attr('id') == 'u1113_img') {
  if ($('#u915').is(':hidden')) {
   $('#u915').show();
  } else {
   $('#u915').hide();
  }
 }else{
  //不是当前节点
  $('#u915').hide(); 
 }
};
</script>
</head>
<body style="text-align: center;">
<%
String id="",lastname="",sex="",telephone="",mobile="",email="", firstrow="";
String sql = " select id,lastname,sex,telephone,mobile,email,firstRow from HrmImportFieldSetting where resourceid = "+user.getUID();
rs.executeSql(sql);
while(rs.next()){
	id = Util.null2String(rs.getString("id"));
	lastname = Util.null2String(rs.getString("lastname"));
	sex = Util.null2String(rs.getString("sex"));
	telephone = Util.null2String(rs.getString("telephone"));
	mobile = Util.null2String(rs.getString("mobile"));
	email = Util.null2String(rs.getString("email"));
	firstrow = Util.null2String(rs.getString("firstRow"));
}
%>
<FORM id=weaver name=frmMain action="HrmImportOperation.jsp" method=post enctype="multipart/form-data">
<input type=hidden id="operation" name=cmd value="save">
<input type=hidden id="operation" name=id value="<%=id %>">
<div style="padding-left: 50px;padding-top: 10px;width: 582px;">
<table  style="width: 100%;text-align: center;"><tr><td><font style="font-size:14px;color:#526268"><%=SystemEnv.getHtmlLabelName(125336,user.getLanguage()) %></font></td></tr></table>
<div style="border:1px solid #d0dbe0;margin-top: 10px;">
<table style="width: 100%;table-layout:fixed;border-collapse:collapse;text-align: center;">
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>
	<tbody>
		<tr style="background-color: #f1f6f7;height: 50px;">
			<td style="border-bottom:1px solid #d0dbe0;"><font style="color:#68868d"><%=SystemEnv.getHtmlLabelName(33198,user.getLanguage()) %></font></th>
			<td style="border-left:1px solid #d0dbe0;border-bottom:1px solid #d0dbe0;"><font style="color:#68868d"><%=SystemEnv.getHtmlLabelName(125337,user.getLanguage()) %>
				<img id="u1113_img" src="img/u1113.png" style="vertical-align: middle;width: 24px;height: 24px;cursor:pointer"></font></th>
		</tr>
		<tr style="height: 50px;">
			<td style="border-bottom:1px solid#f2f7f8;"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage()) %><font color="red">*</font></td>
			<td style="border-left:1px solid #f2f7f8;border-bottom:1px solid#f2f7f8;">
				<INPUT class="inputstyle onlyAlpha" type=text maxLength=20 size=30 name=lastname id="lastname" value="<%=lastname %>" onkeyup="jsToUpperCase(this);" onfocus="" >
			</td>
		</tr>
		<tr style="height: 50px;">
			<td style="border-bottom:1px solid#f2f7f8;"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage()) %><font color="red">*</font></td>
			<td style="border-left:1px solid #f2f7f8;border-bottom:1px solid#f2f7f8;">
				<INPUT class="inputstyle onlyAlpha" type=text maxLength=20 size=30 name=mobile id="mobile" value="<%=mobile %>" onkeyup="jsToUpperCase(this);">
			</td>
		</tr>
		<tr style="height: 50px;">
			<td style="border-bottom:1px solid#f2f7f8;"><%=SystemEnv.getHtmlLabelName(416,user.getLanguage()) %></td>
			<td style="border-left:1px solid #f2f7f8;border-bottom:1px solid#f2f7f8;">
				<INPUT class="inputstyle onlyAlpha" type=text maxLength=20 size=30 name=sex id="sex" value="<%=sex %>" onkeyup="jsToUpperCase(this);">
			</td>
		</tr>
		<tr style="height: 50px;">
			<td style="border-bottom:1px solid#f2f7f8;"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %></td>
			<td style="border-left:1px solid #f2f7f8;border-bottom:1px solid#f2f7f8;">
				<INPUT class="inputstyle onlyAlpha" type=text maxLength=20 size=30 name=telephone id="telephone" value="<%=telephone %>" onkeyup="jsToUpperCase(this);"
			</td>
		</tr>
		<tr style="height: 50px;">
			<td style="border-bottom:0px"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage()) %></td>
			<td style="border-left:1px solid #f2f7f8;">
				<INPUT class="inputstyle onlyAlpha" type=text maxLength=20 size=30 name=email id="email" value="<%=email %>" onkeyup="jsToUpperCase(this);">
			</td>
		</tr>
	</tbody>
</table>
</div>
<table width="100%;"style="padding-top: 10px">
	<tr><td style="font-size: 12px;color:#526268"><span style="display: inline-block;width: 35px"></span><%=SystemEnv.getHtmlLabelName(125338,user.getLanguage()) %><input class="inputstyle onlyNum" style="border-color: #5d9ffe;width: 50px;text-align: center;" type=text name="firstrow" id="firstrow" value="<%=firstrow %>"><%=SystemEnv.getHtmlLabelName(125339,user.getLanguage()) %></td></tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<div id="u915" style="position: absolute;left: 105px;top: 105px;width: 476px;height: 279px;border:#909090 1px solid;background:#fff;color:#333;
	filter:progid:DXImageTransform.Microsoft.Shadow(color=#909090,direction=120,strength=3);/*ie*/
-moz-box-shadow: 2px 2px 10px #909090;/*firefox*/
-webkit-box-shadow: 2px 2px 10px #909090;/*safari或chrome*/
box-shadow:2px 2px 10px #909090;/*opera或ie9*/">
	<img id="u915_img" class="img" src="img/eg.gif" tabindex="0" style="outline: none;">
</div>
</body>
</<HTML>