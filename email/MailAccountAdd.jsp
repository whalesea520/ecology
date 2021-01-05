
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
String mailaccountid = Util.null2String(request.getParameter("mailaccountid"), "");
String isFirst = Util.null2String(request.getParameter("isFirst"), "0");
%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/dojo_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
</head>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailAccountSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:getConfig(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("23845,87",user.getLanguage())%>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage()) %>" id="configSpan" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="getConfig()" type="button" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="saveSpan" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="MailAccountSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailAccountOperation.jsp" id="fMailAccount" name="fMailAccount">
<input type="hidden" name="operation" value="add" />
<wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="accountNameSpan" required="true">
				<input type="text" name="accountName" value="<%if("1".equals(isFirst))out.print(mailaccountid); %>" class="inputstyle" style="width:40%" maxlength="50" onchange="checkinput('accountName','accountNameSpan')" />
			</wea:required>
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="accountMailAddressSpan" required="true">
				<input type="text" name="accountMailAddress" value="<%if("1".equals(isFirst))out.print(mailaccountid); %>" class="inputstyle" style="width:40%" maxlength="50" onchange="checkinput('accountMailAddress','accountMailAddressSpan')" />
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("20869,412",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="accountIdSpan" required="true">
				<input type="text" name="accountId" value="<%if("1".equals(isFirst))out.print(mailaccountid); %>" class="inputstyle" style="width:40%" maxlength="50" onchange="checkinput('accountId','accountIdSpan')" />
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("20869,409",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="accountPasswordSpan" required="true">
				<input type="password" name="accountPassword" class="inputstyle" style="width:40%" maxlength="50" onchange="checkinput('accountPassword','accountPasswordSpan')" />
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="MailAccountInfo"></div>
</form>
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

<script language="javascript">
jQuery(document).ready(function(){
	checkinput("accountMailAddress","accountMailAddressSpan");
	checkinput("accountName","accountNameSpan");
	checkinput("accountId","accountIdSpan");
});
		

    function initConfig(){
    	checkinput("popServer","popServerSpan");
    	checkinput("popServerPort","popServerPortSpan");
    	checkinput("smtpServer","smtpServerSpan");
    	checkinput("smtpServerPort","smtpServerPortSpan");
    
    	 jQuery("input[type=checkbox]").each(function(){
    		  if(jQuery(this).attr("tzCheckbox")=="true"){
    		   	jQuery(this).tzCheckbox({labels:['','']});
    		  }
    	 });
         
         __jNiceNamespace__.beautySelect();
    }

	function setPortMsg(){
	 	$G("popServer").value="";
	 	onchangeserverType();
	}


	function Mtrim(str){ //删除左右两端的空格
		 return str.replace(/(^\s*)|(\s*$)/g, "");
	}

function getConfig(){
	if(check_form(fMailAccount,'accountName') && check_form(fMailAccount,'accountMailAddress') && check_form(fMailAccount,'accountId') && check_form(fMailAccount,'accountPassword') && check_form(fMailAccount,'popServer') && check_form(fMailAccount,'smtpServer')){
		if(!checkEmail(Mtrim(dojo.byId("fMailAccount").accountMailAddress.value))){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			dojo.byId("fMailAccount").accountMailAddress.focus();
			return;
		}
		var param =  {accountMailAddress:$G("accountMailAddress").value,accountPassword:$G("accountPassword").value}
		
		jQuery.post("/email/new/GetMailServerConfig.jsp",param,function(data){
			jQuery("#MailAccountInfo").append(data);
			initConfig();
		});
		 jQuery("#configSpan").hide();
		 jQuery("#saveSpan").show();
		 showRCMenuItem(0)
		 showRCMenuItem(2)
		 showRCMenuItem(3)
		 hiddenRCMenuItem(1)
	}
}
 
 jQuery(document).ready(function(){
	setTimeout("hiddenRCMenuItem(0)", 1000);
	setTimeout("hiddenRCMenuItem(2)", 0);
	jQuery("#saveSpan").hide();
	hiddenRCMenuItem(3);
})

 //检测邮箱账号信息
 var diag = null;
function closeDialog(){
	if(diag){
		diag.close();
	}
	parent.getParentWindow(window).closeDialog();
}
function MailAccountSubmit(){
	if(check_form(fMailAccount,'accountName,accountMailAddress,accountId,accountPassword,popServer,popServerPort,smtpServer,smtpServerPort')){
		if(!checkEmail(Mtrim(dojo.byId("fMailAccount").accountMailAddress.value))){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			dojo.byId("fMailAccount").accountMailAddress.focus();
			return false;
		}
		
	 	diag = new window.top.Dialog();
	 	diag.currentWindow = window;
	 	diag.Width = 450;
		diag.Height = 320;
		diag.Title = '<%=SystemEnv.getHtmlLabelNames("20869,22011",user.getLanguage())%>';
		diag.ShowButtonRow=false;
		diag.URL = "/email/MailAccountCheckInfo.jsp?"+jQuery("#fMailAccount").serialize()+"&"+new Date().getTime();
		diag.show();
		jQuery("body").trigger("click");
	}
 	
}

function refreshInfo(){
	parent.getParentWindow(window)._table.reLoad();
}

function changesendSSL() {
	var check = true;
	if(jQuery("#sendneedSSL").is(":checked")) {
		check = false;
    }
    disOrEnableSwitchPage("#isStartTls", check);
	setsmtpServerPort(check);
}

function changereciveSSL() {
	var check = true;
	if(jQuery("#getneedSSL").is(":checked"))
		check = false;
	setpopServerPort(check);
}

function setsmtpServerPort(sendneedSSLcheck) {
	if(sendneedSSLcheck) 
	 	jQuery("#smtpServerPort").val("465");
	else
	 	jQuery("#smtpServerPort").val("25");

}
function setpopServerPort(getneedSSLcheck) {
	var serverType = jQuery("select[name='serverType']").val();
	if(getneedSSLcheck) {
		if(serverType == "1")
			jQuery("#popServerPort").val("995");
		if(serverType == "2")
			jQuery("#popServerPort").val("993");
	}else {
		if(serverType == "1")
			jQuery("#popServerPort").val("110");
		if(serverType == "2")
			jQuery("#popServerPort").val("143");
		
	}
}

    function onchangeserverType(){
    	setsmtpServerPort(jQuery("#sendneedSSL").is(":checked"));
    	setpopServerPort(jQuery("#getneedSSL").is(":checked"));
    }

    function changeIsStartTls(obj) {
        //disOrEnableSwitchPage("#sendneedSSL", !jQuery("#isStartTls").is(":checked"));
    }
    
    // jquery.jnice_wev8.js中的var disOrEnableSwitch = function(disabled){方法
    // 不知道为什么放里面不行，单独抽出来放在页面使用
    function disOrEnableSwitchPage(objId, disabled){
        if(disabled==true||disabled==false){
            jQuery(objId).attr("disabled",disabled);
        }
        if(disabled){
            //jQuery(objId).next("span.tzCheckBox").attr("title",'已禁用').attr('disabled',true);
            var checkbox = jQuery(objId).next("span.tzCheckBox");
            checkbox.removeClass("tzCheckBox ").addClass("tzCheckBox_disabled ");
            checkbox.children("span.tzCBPart").removeClass("tzCBPart").addClass("tzCBPart_disabled");
        }else{
            //jQuery(objId).next("span.tzCheckBox").removeAttr("title").removeAttr('disabled');
            var checkbox = jQuery(objId).next("span.tzCheckBox_disabled");
            checkbox.removeClass("tzCheckBox_disabled ").removeAttr('disabled').addClass("tzCheckBox");
            checkbox.children("span.tzCBPart_disabled").removeClass("tzCBPart_disabled").addClass("tzCBPart");
        }
    }

</script>
<style>
	#rightMenuIframe{
		background-color: transparent; height:<%=RCMenuHeight+6%>!important;
	}
</style>
</body>
