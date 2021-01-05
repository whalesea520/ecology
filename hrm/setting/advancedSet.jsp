
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
				 weaver.hrm.common.*,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!-- Added by wcd 2014-12-22 -->
<%
if(!HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script type="text/javascript">
var common = new MFCommon();
jQuery(document).ready(function(){
	jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:false,
	    	needInitBoxHeight:false,
	    	needFix:true,
	    	hideSelector:"#seccategorybox",
	    	containerHide:true
	});
	    
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
	});

function jsSyndynapass(){
	 $.ajax({
     type: "post",
     url: "HrmSecuritySynDefault.jsp", 
     data: {"cmd":"syndynapassdefault","needdynapassdefault":jQuery("#needdynapassdefault").val(),"needdynapass":jQuery("#needdynapass").val()},
     success: function(msg) {
 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
     },
     error: function() {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
     }
 });
}

function jsSynUsbSetCA(){
	 $.ajax({
	     type: "post",
	     url: "HrmSecuritySynDefault.jsp", 
	     data: {"cmd":"synusbsetdefaultCA","needCA":jQuery("#needCA").val(),"needCADefault":jQuery("#needCADefault").val()},
	     success: function(msg) {
	 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
	     },
	     error: function() {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
	     }
	 });
}

function jsSyndynapass1(){
	 $.ajax({
     type: "post",
     url: "HrmSecuritySynDefault.jsp", 
     data: {"cmd":"syndynapassdefault","needdynapassdefault":jQuery("#needdynapassdefault").val(),"needdynapass":jQuery("#needdynapass").val()},
     success: function(msg) {
     	alert("11")
     },
     error: function() {
     }
 });
}

function jsSynUsbSetHt(){
	try{
	 $.ajax({
		 type: "post",
		 url: "HrmSecuritySynDefault.jsp", 
		 data: {"cmd":"synusbsetdefaultHt","needusbHt":jQuery("#needusbHt").val(),"needusbdefaultHt":jQuery("#needusbdefaultHt").val()},
		 success: function(msg) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
		 },
		 error: function() {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
		 }
	 });
	}catch(e){alert(e);}
}

function jsSynUsbSetDt(){
	try{
	$.ajax({
		 type: "post",
		 url: "HrmSecuritySynDefault.jsp", 
		 data: {"cmd":"synusbsetdefaultDt","needusbDt":jQuery("#needusbDt").val(),"needusbdefaultDt":jQuery("#needusbdefaultDt").val()},
		 success: function(msg) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
		 },
		 error: function() {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
		 }
	 });
	 }catch(e){alert(e);}
}

function jsSynMobileShowSet(){
	 $.ajax({
    type: "post",
    url: "HrmSecuritySynDefault.jsp", 
    data: {"cmd":"SynMobileShowSet","mobileShowTypeDefault":jQuery("#mobileShowTypeDefault").val()},
    success: function(msg) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
    },
    error: function() {
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
    }
});
}
</script>
</head>
<%
ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String valid=settings.getValid();
String remindperiod=settings.getRemindperiod();

String needusb=settings.getNeedusb();
String needusbdefault=settings.getNeedusbdefault();
String usbType = settings.getUsbType();
String needusbHt = settings.getNeedusbHt();
String needusbdefaultHt = settings.getNeedusbdefaultHt();
String needusbDt = settings.getNeedusbDt();
String needusbdefaultDt =settings.getNeedusbdefaultDt();

String needCa = settings.getNeedca() ;
String needcadefault = settings.getNeedcadefault() ;


String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String relogin=settings.getRelogin();
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();
int validatetype=settings.getValidatetype();
int validatenum=settings.getValidatenum();

int minpasslen=settings.getMinPasslen();
//dynapass
int needdynapass=settings.getNeeddynapass();
int needdynapassdefault=settings.getNeeddynapassdefault();
int dynapasslen=settings.getDynapasslen(); 
if(dynapasslen==0)dynapasslen=6;//默认6位
String dypadcon=settings.getDypadcon(); 
String validitySec = Tools.vString(settings.getValiditySec(), "120");

String needdactylogram = settings.getNeedDactylogram(); 
String canmodifydactylogram = settings.getCanModifyDactylogram();

String needusbnetwork = settings.getNeedusbnetwork();//是否启用usb网段策略

boolean canedit = HrmUserVarify.checkUserRight("OtherSettings:Edit", user) ;

String imagefilename = "/images/hdSystem_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(17563,user.getLanguage()) ;
String needhelp="";

String PasswordChangeReminder = Util.null2String(settings.getPasswordChangeReminder());
if("".equals(PasswordChangeReminder)){
	PasswordChangeReminder = "0";
}
String ChangePasswordDays = settings.getChangePasswordDays();
String DaysToRemind = settings.getDaysToRemind();

//密码锁定
String openPasswordLock = Util.null2String(settings.getOpenPasswordLock());
//锁定密码错误次数
String sumPasswordLock = Util.null2String(settings.getSumPasswordLock());
//密码复杂度
String passwordComplexity = Util.null2String(settings.getPasswordComplexity());
//移动电话隐私设置
String mobileShowSet = Util.null2String(settings.getMobileShowSet());
String mobileShowType = Util.null2String(settings.getMobileShowType());
String mobileShowTypeDefault = Util.null2String(settings.getMobileShowTypeDefault());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*密码规则(),密码变更提醒,强制修改密码,密码锁定,重复登录,网段策略,USB加密保护	,动态密码保护,登录验证码*/		
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="divContent">
<FORM id=frmMain name=frmMain method=post action="HrmSettingOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<input name="cmd" type="hidden" value="SecurityAdSave">
	<wea:layout type="2col" attributes="{'cws':'30%,70%','expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32491,user.getLanguage())%>' attributes="{'samePair':'dynapasssetting'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="needdynapass" name="needdynapass"  value="1" onclick='change1()' <% if(needdynapass==1) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}"><%=SystemEnv.getHtmlLabelName(32507,user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}">
				<select id="needdynapassdefault" name="needdynapassdefault" style="width:200px">
					<option value=0 <%if(needdynapassdefault==0){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if(needdynapassdefault==1){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
					<option value=2 <%if(needdynapassdefault==2){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
				</select>
				&nbsp;
				<input name="btnSyndynapass" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>" onclick="jsSyndynapass()">
				<span style="margin-left:10px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83874,user.getLanguage())%>" /></span>
			</wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}"><%=SystemEnv.getHtmlLabelName(20280,user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}">
			<% if(canedit) { %>
			<input accesskey=Z id=dynapasslen name=dynapasslen  value="<%=dynapasslen%>" maxlength="1" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle" style="width: 222px;">
			<% } else {%>
			<%=dynapasslen%>
			<%}%>
		  </wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}"><%=SystemEnv.getHtmlLabelName(21993,user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}">
			<% if(canedit) { %>
			<select name="dypadcon" <%=!canedit?"disabled":""%> style="width: 200px">
				<option value="0" <%=dypadcon.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%></option>
				<option value="1" <%=dypadcon.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%></option>
				<option value="2" <%=dypadcon.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(21994,user.getLanguage())%></td>
			</select>
			<% } else {
				if(dypadcon.equals("0")){
					out.print(SystemEnv.getHtmlLabelName(607,user.getLanguage()));
				}else if(dypadcon.equals("1")){
					out.print(SystemEnv.getHtmlLabelName(18729,user.getLanguage()));
				}else if(dypadcon.equals("2")){
					out.print(SystemEnv.getHtmlLabelName(21994,user.getLanguage()));
				}
			}%>
		  </wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}"><%=SystemEnv.getHtmlLabelNames("15030,81913,27954,81914",user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'dynapasssettingitem'}">
			<% if(canedit) { %>
			<wea:required id="validitySecspan" required='<%=validitySec.length() == 0%>'>
			<input accesskey=Z id="validitySec" name="validitySec"  value="<%=validitySec%>" maxlength="10" onKeyPress="ItemPlusCount_KeyPress()" onBlur="checkinput('validitySec','validitySecspan');checknumber('validitySec');checkcount1(this)" onChange="common.checkNumber('validitySec');" onchange="checkinput('validitySec','validitySecspan')" class="InputStyle" style="width: 222px;">
			</wea:required>
			<% } else {%>
			<%=validitySec%>
			<%}%>
		  </wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%>' attributes="{'samePair':'Gusbtypediv'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="needusbHt" name="needusbHt"  value="1" onclick='change(this)' <% if(needusbHt.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>	
		  <wea:item attributes="{'samePair':'usbtypedivHt'}"><%=SystemEnv.getHtmlLabelName(32507,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'usbtypedivHt'}">
				<select id="needusbdefaultHt" name="needusbdefaultHt" style="width:200px">
					<option value=0 <%if(needusbdefaultHt.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if(needusbdefaultHt.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
					<option value=2 <%if(needusbdefaultHt.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
				</select>
				&nbsp;
				<input name="btnSynUsbSetHt" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>" onclick="jsSynUsbSetHt()">
				<span style="margin-left:10px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83875,user.getLanguage())%>" /></span>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32896,user.getLanguage())%>'>
		  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="needusbDt" name="needusbDt"  value="1" onclick='changeDt(this)' <% if(needusbDt.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>	
		  <wea:item attributes="{'samePair':'usbtypedivDt'}"><%=SystemEnv.getHtmlLabelName(32507,user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':'usbtypedivDt'}">
				<select id="needusbdefaultDt" name="needusbdefaultDt" style="width:200px">
					<option value=0 <%if(needusbdefaultDt.equals("0")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if(needusbdefaultDt.equals("1")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
					<option value=2 <%if(needusbdefaultDt.equals("2")){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
				</select>
				&nbsp;
				<input name="btnSynUsbSetByDt" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>" onclick="jsSynUsbSetDt()">
				<span style="margin-left:10px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(83876,user.getLanguage())%>" /></span>
			</wea:item>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(381991,user.getLanguage())%>' attributes="{'groupDisplay':'none','itemAreaDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="needCA" name="needCA"  value="1" onclick='changeCA(this)' <% if("1".equals(needCa)) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>	
		  <wea:item attributes="{'samePair':'needCA'}"><%=SystemEnv.getHtmlLabelName(32507,user.getLanguage())%></wea:item>
		  <wea:item attributes="{'samePair':'needCA'}">
				<select id="needCADefault" name="needCADefault" style="width:200px">
					<option value=0 <%if("0".equals(needcadefault)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if("1".equals(needcadefault)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
					<option value=2 <%if("2".equals(needcadefault)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></option>
				</select>
				&nbsp;
				<input name="btnSynUsbSetByCA" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>" onclick="jsSynUsbSetCA()">
				<span style="margin-left:10px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName( 32506 ,user.getLanguage())%>" /></span>
		  </wea:item>
		</wea:group>
		
		</wea:layout>
		<input type="hidden" name="needusb" value="0">
		<input type="hidden" name="needusbdefault" value="0">
		<input type="hidden" name="usbType" value="0">
  </FORM>
</div>
</BODY>
<script language="javascript">
jQuery(document).ready(function(){
	if(jQuery("#needusbHt").attr("checked")){
		showEle("usbtypedivHt");
	}else{
		hideEle("usbtypedivHt");
	}
	if(jQuery("#needusbDt").attr("checked")){
		showEle("usbtypedivDt");
	}else{
		hideEle("usbtypedivDt");
	}
	if(jQuery("#needdynapass").attr("checked")){
		showEle("dynapasssettingitem");
	}else{
		hideEle("dynapasssettingitem");
	}

	if(jQuery("#needCA").attr("checked")){
		showEle("needCA");
	}else{
		hideEle("needCA");
	}
	
	if(frmMain.needdynapass.checked){
		showGroup("dynapasssetting");
	}
})
function hideEleSpan(name){
	var span = $GetEle(name);
	if(span) span.style.display = "none";
}
function showEleSpan(name){
	var span = $GetEle(name);
	if(span) span.style.display = "";
}
function jsChangeValid(){
	var obj = document.frmMain.valid;
	hideEleSpan("trRemindperiod");
	if(obj.checked)	showEleSpan("trRemindperiod");;
}

function jsPasswordChangeReminder(){
	var obj = document.frmMain.PasswordChangeReminder;
	hideEleSpan("trPasswordRemind");
	if(obj.checked){
		showEleSpan("trPasswordRemind");
	}
}

function onSubmit() {
	if(document.getElementById("dynapasslen") && document.getElementById("dynapasslen").value > 8){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(26018,user.getLanguage())%>');
		document.getElementById("dynapasslen").focus();
		return;
	}
	var validitySec = document.getElementById("validitySec");
	if(document.frmMain.needdynapass.checked && validitySec && validitySec.value == ""){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>');
		validitySec.focus();
		return;
	}
	frmMain.submit();
}

function change(obj){
	if(obj.checked){
		showEle("usbtypedivHt");
	}else{
		hideEle("usbtypedivHt");
	}
 }

function changeDt(obj){
	if(obj.checked){
		showEle("usbtypedivDt");
	}else{
		hideEle("usbtypedivDt");
	}
 }

function changeCA(obj){
	if(obj.checked){
		showEle("needCA");
	}else{
		hideEle("needCA");
	}
 }
 
function change1(){
	/*var obj = document.frmMain.needdynapass;
	if(obj.checked){
		hideGroup("Gusbtypediv");		
		document.getElementById("needusb").checked = false;
		disOrEnableSwitch("#needusb",true);
	}else{
		showGroup("Gusbtypediv");
		disOrEnableSwitch("#needusb",false);
	}*/
	
	if(jQuery("#needdynapass").attr("checked")){
		showEle("dynapasssettingitem");
	}else{
		hideEle("dynapasssettingitem");
	}
}
 function change2(){
 	var obj = document.frmMain.needvalidate;
 	if(obj.checked)
	 showEleSpan("validatediv");
 	else
	 hideEleSpan("validatediv");
 }
 
 function setOpenPasswordLock(o)
 {
	if(o.checked){
 		showEleSpan("sumPasswordLockTr");
 	}
 	else{
 		hideEleSpan("sumPasswordLockTr");
 	}
 }
 
 function mobileShowSetChange(obj)
 {
 
	 if(obj.checked)
	 	showEleSpan("mobileShowSetDiv");
	 else
		hideEleSpan("mobileShowSetDiv");
 }
</script>
</HTML>
