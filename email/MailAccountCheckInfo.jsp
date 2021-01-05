<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script src="/wui/common/jquery/jquery_wev8.js" type="text/javascript"></script>
<style>
.err{
	background-color:#E3B1B0;
	margin-left: 10px;
	color: white;
}

.success{
	background-color: #BED393;
	margin-left: 10px;
	color: white;
}

.imgClass{
	text-align: center;
	padding-left: 0px !important;
	background:#F8F8F8;
}

.showerrdiv{
	margin-left: 5px;
	color: red;
}
.errordiv{
	background:url('/email/images/mail_check_error_wev8.png') no-repeat left center;padding-left:18px;display:none;
}
.headline{
	width: 165px;
}
.lineImg{
	margin-top: 3px;
}
</style>
<script type="text/javascript">
<%	
	 String operation = Util.null2String(request.getParameter("operation"));//systemset为后台检测;add为账号添加;update为账号编辑
	 String accountMailAddress = Util.null2String(request.getParameter("accountMailAddress"));
	 String accountId = Util.null2String(request.getParameter("accountId"));
	 String accountPassword = Util.null2String(request.getParameter("accountPassword"));
	 int serverType = Util.getIntValue(request.getParameter("serverType"));
	 String popServer = Util.null2String(request.getParameter("popServer"));
	 int popServerPort = Util.getIntValue(request.getParameter("popServerPort"));
	 String smtpServer = Util.null2String(request.getParameter("smtpServer"));
	 int smtpServerPort = Util.getIntValue(request.getParameter("smtpServerPort"));
	 String isStartTls = Util.null2String(request.getParameter("isStartTls"));
	 String needCheck = Util.null2String(request.getParameter("needCheck"));
	 String getneedSSL = Util.null2String(request.getParameter("getneedSSL"));
	 String sendneedSSL = Util.null2String(request.getParameter("sendneedSSL"));
	 
	 String accountName = Util.null2String(request.getParameter("accountName"));
	 int defaultMailAccountId = Util.getIntValue(request.getParameter("isDefault"));
	 
	 String queryString = Util.null2String(request.getQueryString());
%>	
var operation = "<%=operation%>";
var smtpState = 0, smtpLoginState = 0, popState = 0, popLoginState=0;
var mailState = 0;//邮箱账号整体状态
var checkstate = 0;//是否已经检测结束 0正在进行邮件检测；1为检测结束
var errinfo= {};
var smtperrinfo = {}, smtpLoginrrinfo = {}, smtpterrinfo = {}, poperrinfo = {}, popLoginerrinfo = {};
var arr = ["/email/images/mail_bacocross_wev8.png" ,"/email/images/mail_bacocheck_wev8.png" ];//下标1为通过图片；下表0为未通过图片
jQuery(function(){
	
	jQuery.post("MailAccountCheckInfoOperation.jsp?"+new Date().getTime(),
		{"operation":"<%=operation%>","accountMailAddress":"<%=accountMailAddress%>",
		"accountId":"<%=accountId%>","accountPassword":"<%=accountPassword%>",
		"serverType":"<%=serverType%>","popServer":"<%=popServer%>","popServerPort":"<%=popServerPort%>",
		"smtpServer":"<%=smtpServer%>","smtpServerPort":"<%=smtpServerPort%>","isStartTls":"<%=isStartTls %>",
		"needCheck":"<%=needCheck%>","getneedSSL":"<%=getneedSSL%>","sendneedSSL":"<%=sendneedSSL%>"}
		,function(value){
		
			 checkstate= 1;
			 var data = eval('('+value+')');
			 smtpState=data.smtpState.state;
			 smtpLoginState=data.smtpLoginState.state;
			 if("systemset" != "<%=operation%>") {
				 popState=data.popState.state;
				 popLoginState=data.popLoginState.state;
				 poperrinfo = data.popState.errormess;
				 popLoginerrinfo = data.popLoginState.errormess;
				 jQuery("#psImage").attr("src",arr[popState]);
				 jQuery("#plsImage").attr("src",arr[popLoginState]);
				 
			 }
			 smtperrinfo = data.smtpState.errormess;
			 smtpLoginrrinfo = data.smtpLoginState.errormess;
			 smtpterrinfo = data.smtpLoginState.errormess;
			 
			 jQuery("#ssImage").attr("src",arr[smtpState]);
			 jQuery("#slsImage").attr("src",arr[smtpLoginState]);
			 jQuery("#slstImage").attr("src",arr[smtpLoginState]);
			 mailState = (operation == "systemset"?
			 	Math.min(smtpState , smtpLoginState):Math.min(smtpState , smtpLoginState , popState , popLoginState));
			jQuery("#initMsg").hide();
			jQuery("#resultImage").attr("src",arr[mailState]);
			
			if(1== mailState){
				jQuery("#resultContent").html("<%=SystemEnv.getHtmlLabelNames("34077,23845,16746",user.getLanguage()) %>");
			}else{
				showErrhint();
				jQuery("#resultContent").html("<%=SystemEnv.getHtmlLabelName(82862,user.getLanguage()) %>"); 
			}
			
			if(1 == mailState && ("add"=="<%=operation%>" || "update"=="<%=operation%>")){
				jQuery.post("/email/MailAccountOperation.jsp?<%=queryString%>",function(){
					parent.getParentWindow(window).closeDialog();
				})
			}
			
			if(1 == mailState && ("systemset"=="<%=operation%>")){
				parent.getParentWindow(window).saveInfo();
			}
		
	});
		 	
});



function showErrhint() {
	var showHtml =  "<a href='javascript:showmsg()' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>";
	if(0 == smtpState) {
		jQuery("#ssDiv").html(smtperrinfo.errorHint+"<a href='javascript:showmsg(\""+smtperrinfo.errorString+"\")' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>").show();
	}
	if(0 == smtpLoginState) {
		jQuery("#slsDiv").html("<%=SystemEnv.getHtmlLabelName(82863,user.getLanguage()) %>"+"<a href='javascript:showmsg(\""+smtpLoginrrinfo.errorString+"\")' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>").show();
	}
	if(0 == smtpLoginState) {
		jQuery("#slstDiv").html(smtpterrinfo.errorHint+"<a href='javascript:showmsg(\""+smtpterrinfo.errorString+"\")' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>").show();
	}
	if(0 == popState) {
		jQuery("#psDiv").html(poperrinfo.errorHint+"<a href='javascript:showmsg(\""+poperrinfo.errorString+"\")' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>").show();
	}
	if(0 == popLoginState) {
		jQuery("#plsDiv").html(popLoginerrinfo.errorHint+"<a href='javascript:showmsg(\""+popLoginerrinfo.errorString+"\")' style='color:#fb7831' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a>").show();
	}
}



function showInfo(){
	
	var ssInfo = "<span class='success' id='smtpState'><%=SystemEnv.getHtmlLabelName(82864,user.getLanguage()) %></span>";
	var slsInfo = "<span class='success' id='smtpLoginState'><%=SystemEnv.getHtmlLabelName(82865,user.getLanguage()) %></span>";
	var psInfo = "<span class='success' id='popState'><%=SystemEnv.getHtmlLabelName(82866,user.getLanguage()) %></span>";
	var plsInfo = "<span class='success' id='popLoginState'><%=SystemEnv.getHtmlLabelName(82866,user.getLanguage()) %></span>";
	if(0 == smtpState){
		ssInfo= "<span class='err' id='smtpState'><%=SystemEnv.getHtmlLabelName(82867,user.getLanguage()) %>&nbsp;<%=SystemEnv.getHtmlLabelName(82868,user.getLanguage()) %></span>";
	}
	if(0 == smtpLoginState){
		var value ="<%=SystemEnv.getHtmlLabelName(82869,user.getLanguage()) %>&nbsp;";
		if("0"=="%=needCheck%>"){value +="<%=SystemEnv.getHtmlLabelName(82870,user.getLanguage()) %>&nbsp;";}
		if("1"=="<%=sendneedSSL%>"){value +="<%=SystemEnv.getHtmlLabelName(82871,user.getLanguage()) %>";}
		slsInfo = "<span class='err' id='smtpLoginState'>"+value+"</span>";
	}
	if(0 == popState){82872
		psInfo = "<span class='err' id='popState'><%=SystemEnv.getHtmlLabelName(82873,user.getLanguage()) %><%=serverType%><%=SystemEnv.getHtmlLabelName(82872,user.getLanguage()) %>&nbsp;<%=SystemEnv.getHtmlLabelName(82868,user.getLanguage()) %></span>";
	}
	if(0 == popLoginState){
		var value ="<%=SystemEnv.getHtmlLabelName(82869,user.getLanguage()) %>&nbsp;";
		if("1"=="<%=getneedSSL%>"){value +="<%=SystemEnv.getHtmlLabelName(82871,user.getLanguage()) %>&nbsp;";}
		if("2"=="<%=serverType%>"){value +="<%=SystemEnv.getHtmlLabelName(82874,user.getLanguage()) %>";}
		plsInfo = "<span class='err' id='popLoginState'>"+value+"</span>";
	}
	

	jQuery("#ssDiv").hover(function(){
		jQuery("#ssDiv").append(ssInfo);
	},function(){
		jQuery("#smtpState").remove();
	});
	
	jQuery("#slsDiv").hover(function(){
		jQuery("#slsDiv").append(slsInfo);
	},function(){
		jQuery("#smtpLoginState").remove("");
	});

	
	jQuery("#slstDiv").hover(function(){
		jQuery("#slstDiv").append(slsInfo);
	},function(){
		jQuery("#smtpLoginState").remove("");
	});
	
	if("systemset" != "<%=operation%>"){
		jQuery("#psDiv").hover(function(){
			jQuery("#psDiv").append(psInfo);
		},function(){
			jQuery("#popState").remove("");
		});
		
		jQuery("#plsDiv").hover(function(){
			jQuery("#plsDiv").append(plsInfo);
		},function(){
			jQuery("#popLoginState").remove("");
		});	
	}	
}


function showmsg(mess) {
		jQuery('#errorspan').html(mess);
		
		var diag = new window.top.Dialog();
	 	diag.currentWindow = window;
	 	diag.Width = 260;
		diag.Height = 120;
		diag.Title = "<%=SystemEnv.getHtmlLabelName(82875,user.getLanguage()) %>";
		diag.InnerHtml = jQuery('#errorWinDiv').html();
		diag.ShowButtonRow=false;
		diag.normalDialog= false;
		diag.show();

}
</script>
	

</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82876,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{'cw1':'3%','cw2':'97%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'customAttrs':'class=imgClass'}"><img id="ssImage" class="lineImg"  src="/email/images/loading_wev8.gif"></wea:item>
		<wea:item>
			<table>
				<tr>
					<td>
						<div class="headline" ><%=SystemEnv.getHtmlLabelName(82877,user.getLanguage()) %>(SMTP)</div>
					</td>
					<td>
						<div id="ssDiv" class='errordiv'><%=SystemEnv.getHtmlLabelName(82879,user.getLanguage()) %>、<%=SystemEnv.getHtmlLabelName(82880,user.getLanguage()) %><a href='javascript:showmsg()' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a></div>
					</td>
				</tr>
			</table>
		</wea:item>
		
		<wea:item attributes="{'customAttrs':'class=imgClass'}"><img id="slsImage" class="lineImg" src="/email/images/loading_wev8.gif"></wea:item>
		<wea:item>
			<table>
				<tr>
					<td ><div  class="headline" ><%=SystemEnv.getHtmlLabelName(82878,user.getLanguage()) %>(SMTP)</div></td>
					<td><div id="slsDiv" class='errordiv'><%=SystemEnv.getHtmlLabelName(82863,user.getLanguage()) %><a href='javascript:showmsg()' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a></div></td>
				</tr>
			</table>
		</wea:item>
		
		<wea:item attributes="{'customAttrs':'class=imgClass'}"><img id="slstImage" class="lineImg" src="/email/images/loading_wev8.gif"></wea:item>
		<wea:item>
			<table>
				<tr>
					<td ><div  class="headline" ><%=SystemEnv.getHtmlLabelName(82883,user.getLanguage()) %></div></td>
					<td><div id="slstDiv" class='errordiv'><%=SystemEnv.getHtmlLabelName(82879,user.getLanguage()) %>、<%=SystemEnv.getHtmlLabelName(82880,user.getLanguage()) %><a href='javascript:showmsg()' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a></div></td>
				</tr>
			</table>
		</wea:item>
		
		<%if(!"systemset".equals(operation)){ %>
			<wea:item attributes="{'customAttrs':'class=imgClass'}"><img id="psImage" class="lineImg" src="/email/images/loading_wev8.gif"></wea:item>
			<wea:item>
				<table>
					<tr>
						<td ><div class="headline" ><%=SystemEnv.getHtmlLabelName(82881,user.getLanguage()) %>(<%=serverType==1?"POP3":"IMAP"%>)</div></td>
						<td><div id="psDiv"  class='errordiv'><%=SystemEnv.getHtmlLabelName(82879,user.getLanguage()) %>、<%=serverType==1?"POP3":"IMAP"%><%=SystemEnv.getHtmlLabelName(32286,user.getLanguage()) %><a href='javascript:showmsg()' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a></div></td>
					</tr>
				</table>
			</wea:item>
			
			<wea:item attributes="{'customAttrs':'class=imgClass'}"><img id="plsImage" class="lineImg" src="/email/images/loading_wev8.gif"></wea:item>
			<wea:item>
				<table>
					<tr>
						<td ><div class="headline" ><%=SystemEnv.getHtmlLabelName(82882,user.getLanguage()) %>(<%=serverType==1?"POP3":"IMAP"%>)</div></td>
						<td><div  id="plsDiv" class='errordiv'><%=SystemEnv.getHtmlLabelName(82863,user.getLanguage()) %><a href='javascript:showmsg()' class='showerrdiv'><%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %></a></div></td>
					</tr>
				</table>
			</wea:item>
		<%} %>
	</wea:group>
</wea:layout>

<div id='errorWinDiv' style='display:none'>
	<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">
	   <tbody>
	   		<tr>
				<td align="left"  style="font-size:12px" valign="top">
					<span id='errorspan'></span>
				</td>
			</tr>
		</tbody>
	</table>
</div>

<div style="padding-top: 15px; text-align: center;">
	<span >
		<img id="resultImage" src="/email/images/loading_wev8.gif" align="absmiddle" style="margin-bottom: 2px;"><span style="padding-left: 8px;" id="resultContent"><%=SystemEnv.getHtmlLabelName(22372,user.getLanguage())%></span>
	</span>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
</html>
