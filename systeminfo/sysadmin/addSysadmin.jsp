
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.sysadmin.*"%>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String result = Util.null2String(request.getParameter("result"));
%>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String passwordComplexity = settings.getPasswordComplexity();
int minpasslen=settings.getMinPasslen();
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name="frmmain" action="sysadminOperation.jsp" method="post">
<INPUT type="hidden" name="method" value="add">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(17888,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=Inputstyle maxLength=20 size=20 id="lastname" name="lastname" value="" onchange='checkinput("lastname","lastnameimage")'><SPAN id="lastnameimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=Inputstyle maxLength=60 size=20 id="loginid" name="loginid" value="" onchange='checkinput("loginid","loginidimage")'><SPAN id="loginidimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%if(result.equals("false")){%><div style="color:#FF0000 "><%=SystemEnv.getHtmlNoteName(64,user.getLanguage())%></div><%}%></SPAN></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
		<wea:item><INPUT type="password" class=Inputstyle maxLength=100 size=20 id="password" name="password" value="" onchange='checkinput("password","passwordimage")'><SPAN id="passwordimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("20970,85",user.getLanguage())%></wea:item>
		<wea:item><INPUT class=Inputstyle maxLength=255 size=60 name="description" value="" onchange='checkinput("description","descriptionimage")'><SPAN id="descriptionimage"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></SPAN></wea:item>
		<%-- 
		<wea:item><%=SystemEnv.getHtmlLabelNames("633,141",user.getLanguage())%></wea:item>
		<wea:item>
		<brow:browser viewType="0" name="subcompanyids" browserValue="" 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?show_virtual_org=-1&selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp?show_virtual_org=-1&type=164" browserSpanValue="">
      </brow:browser>
		</wea:item>--%>
	</wea:group>
</wea:layout>
</FORM>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</body>
<SCRIPT language="JavaScript">
function checkData(){
	jQuery.ajax({
		url:"/hrm/ajaxData.jsp",
		type:"POST",
		dataType:"json",
		async:true,
		data:{
			cmd:"checksysadmin",
			lastname:jQuery("#lastname").val(),
			loginid:jQuery("#loginid").val()
		},
		success:function(data){
			if(data.result=="1"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82478,user.getLanguage())%>");   
				return;		
			}else if(data.result=="2"){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82479,user.getLanguage())%>");   
				return;				
			}else{
				document.frmmain.submit();	
			}
		}
	});
}
				
function doSave(obj) {	
	if (check_form(frmmain,"loginid,password,description")) {
		var password = jQuery("#password").val();
		if(password.length<<%=minpasslen%>){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");   
    	return ;                
    }
		var checkpass = CheckPasswordComplexity();
		if(checkpass)
		{
			checkData();
		}
	}
}
function CheckPasswordComplexity()
{
	var ins = document.getElementById("password");
	var ics = document.getElementById("password");
	var cs = "";
	if(ics)
	{
		cs = ics.value;
	}
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863, user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716, user.getLanguage())%>");
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
</SCRIPT>
</html>
