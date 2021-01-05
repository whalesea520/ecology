
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
								 weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript">

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

function jsSynUsbSet(){
	 $.ajax({
     type: "post",
     url: "HrmSecuritySynDefault.jsp", 
     data: {"cmd":"synusbsetdefault","needusb":jQuery("#needusb").val(),"needusbdefault":jQuery("#needusbdefault").val()},
     success: function(msg) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30109,user.getLanguage())%>");
     },
     error: function() {
      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>");
     }
 });
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
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String relogin=settings.getRelogin();
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();
int validatetype=settings.getValidatetype();
int validatenum=settings.getValidatenum();
int numvalidatewrong=settings.getNumvalidatewrong();

int minpasslen=settings.getMinPasslen();
//dynapass
int needdynapass=settings.getNeeddynapass();
int needdynapassdefault=settings.getNeeddynapassdefault();
int dynapasslen=settings.getDynapasslen(); 
if(dynapasslen==0)dynapasslen=6;//默认6位
String dypadcon=settings.getDypadcon(); 

String needdactylogram = settings.getNeedDactylogram(); 
String canmodifydactylogram = settings.getCanModifyDactylogram();

String needusbnetwork = settings.getNeedusbnetwork();//是否启用usb网段策略

String checkUnJob = Util.null2String(settings.getCheckUnJob(),"0");//非在职人员信息查看控制 启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
String checkSysValidate = Util.null2String(settings.getCheckSysValidate(),"0");//系统信息批量设置验证码控制 启用后，系统信息批量设置保存的时候需要输入验证码

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

String loginMustUpPswd = Util.null2String(settings.getLoginMustUpPswd());
String forbidLogin = Util.null2String(settings.getForbidLogin());
String checkkey = Util.null2String(settings.getCheckkey());
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
<!-- 
<div class="e8_box demo2" id='seccategorybox'>
    <ul class="tab_menu">
       	 <li class="current">
        	<a href="#minpasslenSet" onclick="showItemArea('#minpasslenSet');">
        		<%=SystemEnv.getHtmlLabelName(32487,user.getLanguage())%>
        	</a>
        </li>
         <li>
        	<a href="#validSet" onclick="showItemArea('#validSet');">
        		<%=SystemEnv.getHtmlLabelName(18710,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#PasswordChangeReminder" onclick="showItemArea('#PasswordChangeReminder');">
        		<%=SystemEnv.getHtmlLabelName(32488,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#openPasswordLockSet" onclick="showItemArea('#openPasswordLockSet');">
        		<%=SystemEnv.getHtmlLabelName(24706,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#reloginSet" onclick="showItemArea('#reloginSet');">
        		<%=SystemEnv.getHtmlLabelName(32489,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#needusbSet" onclick="showItemArea('#needusbSet');">
        		<%=SystemEnv.getHtmlLabelName(32490,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="#needdynapassSet" onclick="showItemArea('#needdynapassSet');">
        		<%=SystemEnv.getHtmlLabelName(32491,user.getLanguage()) %>
        	</a>
        </li>
	      <li>
        	<a href="#needvalidateSet" onclick="showItemArea('#needvalidateSet');">
        		<%=SystemEnv.getHtmlLabelName(32492,user.getLanguage()) %>
        	</a>
        </li>  
        <li>
        	<a href="#mobileShowSet" onclick="showItemArea('#mobileShowSet');">
        		<%=SystemEnv.getHtmlLabelName(32684,user.getLanguage()) %>
        	</a>
        </li>  
    </ul>
    <div id="rightBox" class="e8_rightBox"></div>
    <div class="tab_box" style="display:none;">
        <div>
        </div>
    </div>
</div>
 -->

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
	<input name="cmd" type="hidden" value="SecuritySave">
	<wea:layout type="2col" attributes="{'cws':'30%,70%','expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(81624,user.getLanguage())%>'>
			<wea:item type="groupHead"><a name="minpasslenSet" id="minpasslenSet"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(20171,user.getLanguage())%></wea:item>
		  <wea:item>
		  <%if(canedit){ %>
			<input type="text" name=minpasslen value="<%=minpasslen%>"  maxlength="50" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle" style="width: 222px">
			<%}else{ %>
				<%=Util.toScreen(minpasslen+"",user.getLanguage())%>
			<%} %>
		  </wea:item>
		  <wea:item attributes="{'samePair':'passwordComplexityTr'}"><%=SystemEnv.getHtmlLabelName(24078,user.getLanguage())%></wea:item>
      <wea:item attributes="{'samePair':'passwordComplexityTr'}">
      	<select name="passwordComplexity" <%=!canedit?"disabled":"" %> style="width: 200px">
      		<option value=0 <%="0".equals(passwordComplexity)?"selected":""%>><%=SystemEnv.getHtmlLabelName(32499,user.getLanguage())%></option>
      		<option value=1 <%="1".equals(passwordComplexity)?"selected":""%>><%=SystemEnv.getHtmlLabelName(24080,user.getLanguage())%>
      		<option value=2 <%="2".equals(passwordComplexity)?"selected":""%>><%=SystemEnv.getHtmlLabelName(24081,user.getLanguage())%>
      	</select>
      </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18710,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id=valid name=valid  value="1" onclick="jsChangeValid()" <% if(valid.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				<span id="trRemindperiod" name="trRemindperiod" style="margin-left:30px;display:<%=valid.equals("1")?"":"none"%>">
					<%=SystemEnv.getHtmlLabelName(18711,user.getLanguage())%>
					<% if(canedit) { %>
						<input accesskey=Z name=remindperiod  value="<%=remindperiod%>" maxlength="50" onKeyPress="ItemPlusCount_KeyPress()" style="width:80px" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
						<%=Util.toScreen(remindperiod,user.getLanguage())%>
					<%}%>
					<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(32488,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id=PasswordChangeReminder name=PasswordChangeReminder onclick="jsPasswordChangeReminder()" value="1" <% if("1".equals(PasswordChangeReminder)) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				<span id="trPasswordRemind" name="trPasswordRemind" style="margin-left:30px;display:<%=PasswordChangeReminder.equals("1")?"":"none"%>">
					<%=SystemEnv.getHtmlLabelName(32500,user.getLanguage())%>
					 <%if(canedit){ %>
						<input  name=ChangePasswordDays value="<%=ChangePasswordDays%>"  maxlength="50" style="width:80px" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
						<%=Util.toScreen(DaysToRemind,user.getLanguage())%>
					<%} %>
					<%=SystemEnv.getHtmlLabelName(32501,user.getLanguage())%>
					,
					<%=SystemEnv.getHtmlLabelName(32502,user.getLanguage())%>
					<%if(canedit){ %>
						<input  name=DaysToRemind value="<%=DaysToRemind%>"  maxlength="50" style="width:80px" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
						<%=Util.toScreen(ChangePasswordDays,user.getLanguage())%>
					<%} %>
					<%=SystemEnv.getHtmlLabelName(32503,user.getLanguage())%>
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(81623,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=loginMustUpPswd  value="1" <%if("1".equals(loginMustUpPswd)){ %>checked<%} %> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(24706,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle id="openPasswordLock" name="openPasswordLock" value="1" <%if("1".equals(openPasswordLock)){ %>checked<%} %> <% if(!canedit) { %>disabled<%}%> onclick="setOpenPasswordLock(this);">
				<span id="sumPasswordLockTr" name="sumPasswordLockTr" style="margin-left:30px;display:<%=openPasswordLock.equals("1")?"":"none"%>">
					<%=SystemEnv.getHtmlLabelName(32504,user.getLanguage())%>
					<%if(canedit){ %>
						<input type="text" class="InputStyle" size=10 maxlength=8 name="sumPasswordLock" style="width:80px;" value="<%=sumPasswordLock %>"  onKeyPress="ItemPlusCount_KeyPress()"  onBlur='checknumber("sumPasswordLock")'>
					<%}else{ %>
							<%=Util.toScreen(sumPasswordLock,user.getLanguage())%>
					<%} %>
					<%=SystemEnv.getHtmlLabelName(32505,user.getLanguage())%>
				</span>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(81625,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(18719,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=relogin  value="1"  <% if(relogin.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(81627,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=forbidLogin  value="1" <%if("1".equals(forbidLogin)){ %>checked<%} %> <% if(!canedit) { %>disabled<%}%>>
				<span style="margin-left:30px;color:red"><%=SystemEnv.getHtmlLabelName(81849,user.getLanguage())%></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(22910,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=needvalidate  value="1" onclick='change2()' <% if(needvalidate==1) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
			</wea:item>
			<wea:item attributes="{'samePair':'validatediv'}"><%=SystemEnv.getHtmlLabelName(18727,user.getLanguage())%></wea:item>
			  <wea:item attributes="{'samePair':'validatediv'}">
					<select name=validatetype <% if(!canedit) { %>disabled<%}%> style="width: 200px">
						<option value="0" <%if(validatetype==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%></option>
						<option value="1" <%if(validatetype==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%></option>
						<option value="2" <%if(validatetype==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18730,user.getLanguage())%></option>
					</select>    
			  </wea:item>
			  <wea:item attributes="{'samePair':'validatediv'}"><%=SystemEnv.getHtmlLabelName(18728,user.getLanguage())%></wea:item>
			  <wea:item attributes="{'samePair':'validatediv'}">
					<select name=validatenum <% if(!canedit) { %>disabled<%}%> style="width: 200px">
						  <option value="4" <%if(validatenum==4) {%>selected<%}%>>4 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
						  <option value="5" <%if(validatenum==5) {%>selected<%}%>>5 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
						  <option value="6" <%if(validatenum==6) {%>selected<%}%>>6 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
					</select>  
			  </wea:item>
			  <wea:item attributes="{'samePair':'111','display':'none'}"><%=SystemEnv.getHtmlLabelName(127384,user.getLanguage())%></wea:item>
			  <wea:item attributes="{'samePair':'111','display':'none'}">
			 		<input name=numvalidatewrong value="<%=numvalidatewrong%>"  maxlength="50" style="width:80px" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
			  </wea:item>
			  <wea:item attributes="{'samePair':'validatediv'}"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></wea:item>
			  <wea:item attributes="{'samePair':'validatediv'}">
				<%if(needvalidate==1){ %>
				<img border=0 id='imgCode' align='absmiddle' style="width:112px;height:38px;" src='/weaver/weaver.file.MakeValidateCode' onclick="javascript:changeCode()">
				<script>
				 function changeCode(){
					$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode"); 
				 }
				</script>
				<%} %>
			  </wea:item>
		</wea:group>
		<%if(GCONST.getONDACTYLOGRAM()){%>
	 	<wea:group context='<%=SystemEnv.getHtmlLabelName(22058,user.getLanguage())%>'>
		  <wea:item><%=SystemEnv.getHtmlLabelName(22062,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=needdactylogram  value="1" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(needdactylogram.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(22063,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=canmodifydactylogram  value="1" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(canmodifydactylogram.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  </wea:item>
		</wea:group>
		<%}%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(32684,user.getLanguage())%>'>
		  <wea:item type="groupHead"><a name="mobileShowSet" id="mobileShowSet"></wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(32685,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name="mobileShowSet" value="1" onclick="mobileShowSetChange(this)" <%=mobileShowSet.equals("1")?"checked":"" %> <% if(!canedit) { %>disabled<%}%>>
				<span id="mobileShowSetDiv" name="mobileShowSetDiv" style="margin-left:30px;display:<%=mobileShowSet.equals("1")?"":"none"%>">
					<%=SystemEnv.getHtmlLabelName(32686,user.getLanguage())%>
					<input type="checkbox" class=InputStyle name="mobileShowType" value="1" <%=mobileShowType.indexOf("1")!=-1?"checked":"" %>><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%>
					<input type="checkbox" class=InputStyle name="mobileShowType" value="2" <%=mobileShowType.indexOf("2")!=-1?"checked":"" %>><%=SystemEnv.getHtmlLabelName(32670,user.getLanguage())%>
					<input type="checkbox" class=InputStyle name="mobileShowType" value="3" <%=mobileShowType.indexOf("3")!=-1?"checked":"" %>><%=SystemEnv.getHtmlLabelName(32671,user.getLanguage())%>
				</span>
			</wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(32687,user.getLanguage())%></wea:item>
			<wea:item>
				<select id="mobileShowTypeDefault" name="mobileShowTypeDefault" style="width: 200px;vertical-align: middle;">
					<option value="1" <%=mobileShowTypeDefault.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></option>
					<option value="2" <%=mobileShowTypeDefault.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32670,user.getLanguage())%></option>
					<option value="3" <%=mobileShowTypeDefault.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32671,user.getLanguage())%></option>
				</select>
				&nbsp;
				<input name="btnSynMobileShowSet" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(32506,user.getLanguage())%>" onclick="jsSynMobileShowSet()">
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20824,user.getLanguage())%>'>
		  <wea:item><%=SystemEnv.getHtmlLabelName(126277,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input type="text" class="InputStyle" size=10 name="checkkey" style="width:300px;" value="<%=checkkey %>">
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(128799,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=checkUnJob  value="<%=checkUnJob %>" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(checkUnJob.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(128800,user.getLanguage())%>" />
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(131444,user.getLanguage())%></wea:item>
		  <wea:item>
				<input type="checkbox" tzCheckbox="true" class=InputStyle name=checkSysValidate  value="<%=checkSysValidate %>" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(checkSysValidate.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
		  	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(131445,user.getLanguage())%>" />
		  </wea:item>
		</wea:group>
		</wea:layout>
  </FORM>
  <br><br>
</div>
</BODY>
<script language="javascript">
jQuery(document).ready(function(){
    
 	if(frmMain.mobileShowSet.checked){
 		showEle("mobileShowSetDiv");
  }else{
   	hideEle("mobileShowSetDiv");
  }
  if(frmMain.needvalidate.checked){
  	showEle("validatediv");
  }else{
   	hideEle("validatediv");
  }
   
  if(jQuery("#openPasswordLock").attr("checked")){
 		showEle("sumPasswordLockTr");
 	}
 	else{
 		hideEle("sumPasswordLockTr");
 	}
 	
 	var isValid = jQuery("#valid").attr("checked");
	var isPasswordChangeReminder = jQuery("#PasswordChangeReminder").attr("checked");

	if(isValid)jQuery("#trRemindperiod").show();
	if(isPasswordChangeReminder){
		jQuery("#trDaysToRemind").show();
		jQuery("#trChangePasswordDays").show();
	}
	
 	//初始化
 	jsPasswordChangeReminder();
 	jsChangeValid();
})

  function usbTypeChange(){
		if(frmMain.usbType.value==1){
			showEle("usbsetting");
		}else{
			hideEle("usbsetting");
		}
   }
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

function onSubmit()
{
	if(document.frmMain.openPasswordLock.checked == true){
		var sumPasswordLock = document.frmMain.sumPasswordLock.value;
		if(sumPasswordLock == null || sumPasswordLock == '' || sumPasswordLock == '0'){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(24082,user.getLanguage())%>0!');
			return;
		}
	}
	if(document.getElementById("dynapasslen") && document.getElementById("dynapasslen").value > 8){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(26018,user.getLanguage())%>');
		document.getElementById("dynapasslen").focus();
		return;
	}
	
	if(document.frmMain.mobileShowSet.checked){
		var hasCheckeda = false;
		jQuery("input[name='mobileShowType']").each(function(){
			if(jQuery(this).attr("checked")){ 
					hasCheckeda = true;
					return;
				}
		});
		if(!hasCheckeda){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>'+'<%=SystemEnv.getHtmlLabelName(32686,user.getLanguage())%>');
			return;
		}
	}
	frmMain.submit();
	
	/*if(jQuery("#needdynapass").attr("checked")){
		jsSyndynapass1();
	}*/
}

function change(obj){
	if(obj.checked){
		showEle("usbtypediv");
		document.getElementById("needdynapass").checked = false;
		disOrEnableSwitch("#needdynapass",true);
		hideGroup("dynapasssetting");
	}else{
		hideEle("usbtypediv");
		disOrEnableSwitch("#needdynapass",false);
		showGroup("dynapasssetting");
	}
	if(frmMain.usbType.value==1 && obj.checked==true){
		showEle("usbsetting");
	}else{
		hideEle("usbsetting");
	}
 }
 
function change1(){
	var obj = document.frmMain.needdynapass;
	if(obj.checked){
		hideGroup("Gusbtypediv");		
		document.getElementById("needusb").checked = false;
		disOrEnableSwitch("#needusb",true);
	}else{
		showGroup("Gusbtypediv");
		disOrEnableSwitch("#needusb",false);
	}
	
	if(jQuery("#needdynapass").attr("checked")){
		showEle("dynapasssettingitem");
	}else{
		hideEle("dynapasssettingitem");
	}
}
 function change2(){
 	var obj = document.frmMain.needvalidate;
 	if(obj.checked)
	 showEle("validatediv");
 	else
	 hideEle("validatediv");
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