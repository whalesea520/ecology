<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.ldap.LdapUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script src="/wui/common/jquery/jquery_wev8.js" type="text/javascript"></script>
<link href="/wui/theme/<%=session.getAttribute("SESSION_TEMP_CURRENT_THEME") %>/jquery/plugin/passwordStrength/password_strength_wev8.css" rel="stylesheet" type="text/css" />
    <script src="/wui/theme/<%=session.getAttribute("SESSION_TEMP_CURRENT_THEME") %>/jquery/plugin/passwordStrength/jquery.passwordStrength_wev8.js" type="text/javascript"></script>
		<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var parentDialog = parent.parent.getDialog(parent);
		$(document).ready(function(){
			var $pwd = $('input[name="passwordnew"]');					   
			$pwd.passwordStrength();
		});
		function showLog(){
			new MFCommon().showDialog("/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=421","<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>");
		}
		</script>
		<style type="text/css">
		.ShowMsg {
    background-color: #FDFFEA;
    border: 1px solid #D2EA00;
    color: #333333;
    display: inline-block;
    margin-left: 2px;
    padding: 2px 5px;

		}
		</style>
</head>
<%
String isrsaopen = Util.null2String(Prop.getPropValue("openRSA","isrsaopen"));//是否开启RSA
String isDialog = Util.null2String(request.getParameter("isdialog"),"0");
String showClose = Util.null2String(request.getParameter("showClose"),"true");
String passwordold = Util.null2String(request.getParameter("passwordold"));
String mode=Util.null2String(request.getParameter("mode"));
String frompage = Util.null2String(request.getParameter("frompage"));
String canpass = Util.null2String(request.getParameter("canpass"));
String RedirectFile = Util.null2String(request.getParameter("RedirectFile"));
String id = String.valueOf(user.getUID());//增强安全性，通过Url修改id无效。打开的始终当前用户id。
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(409,user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String needfav ="1";
String needhelp ="";
String message = Util.null2String(request.getParameter("message"));
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String openPasswordLock = settings.getOpenPasswordLock();
String passwordComplexity = settings.getPasswordComplexity();
int minpasslen=settings.getMinPasslen();
String usbType= settings.getUsbType();
String needusbHt = settings.getNeedusbHt();
String userUsbType="";
String usbstate="1";//禁用
String mainDactylogramImgSrc="/images/loginmode/5_wev8.gif";
String assistantDactylogramImgSrc="/images/loginmode/5_wev8.gif";
String hasMainDactylogram = "0";
String hasAssistantDactylogram = "0";
String isSystemManager = "1";
//String account = "";
String loginid = "";
String isADAccount = "";
RecordSet.executeSql("select loginid,serial,usbstate,userUsbType,dactylogram,assistantdactylogram,isADAccount from HrmResource where id = "+id );
if(RecordSet.next()){
	//account = RecordSet.getString("account");
	loginid =  RecordSet.getString("loginid");
	isADAccount = RecordSet.getString("isADAccount");
    isSystemManager = "0";
    usbstate=String.valueOf(RecordSet.getInt("usbstate"));
	userUsbType=Util.null2String(RecordSet.getString("userUsbType"));
	if(userUsbType.equals("")){
		userUsbType=usbType;
	}
	mainDactylogramImgSrc = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
	assistantDactylogramImgSrc = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
	hasMainDactylogram = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"0":"1";
	hasAssistantDactylogram = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"0":"1";
}
if(isSystemManager.equals("1")){
    RecordSet.executeSql("select dactylogram,assistantdactylogram from HrmResourceManager where id = "+id );
    if(RecordSet.next()){
        mainDactylogramImgSrc = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
	      assistantDactylogramImgSrc = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"/images/loginmode/5_wev8.gif":"/images/loginmode/4_wev8.gif";
	      hasMainDactylogram = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"0":"1";
	      hasAssistantDactylogram = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"0":"1";
    }
}
usbstate = Util.null2String(usbstate);

String canmodifydactylogram = settings.getCanModifyDactylogram();


RecordSet.executeSql("select needSynPassword,isuseldap from ldapset");
String needSynPassword = "";
String isuseldap = Prop.getPropValue(GCONST.getConfigFile(), "authentic");
if(RecordSet.next()) {
	needSynPassword = RecordSet.getString("needSynPassword");
}
if("ldap".equals(isuseldap) && "1".equals(isADAccount)) {
	mode = "1";
}

session.setAttribute("changepwd","yes");
%>
<BODY scroll="no">
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%
if(!isfromtab){
	if(frompage.length()<=0){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResource.jsp?id="+id+",_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	}else{
		/*if("1".equals(canpass)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+","+RedirectFile+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}else{
			request.getSession().setAttribute("changepwd","n");
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/login/Logout.jsp,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}*/
	}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=password name=frmMain style="MARGIN-TOP: 3px" action=HrmResourceOperation.jsp method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type=hidden name=operation value="changepassword">
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=frompage value="<%=frompage%>">
<input type=hidden name=RedirectFile value="<%=RedirectFile%>">
<input type=hidden name=isfromtab value="<%=isfromtab%>">  
<input type=hidden name=loginid value="<%=loginid%>">
<input name="adtype" value="<%=mode %>" type="hidden"></input>
<wea:layout type="2col">
<%
String attr = "";
if(!isfromtab)attr="{'groupDisplay':''}";
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>' attributes="<%=attr %>">
<% if(message.equals("1")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(16092,user.getLanguage())%></font>
</wea:item>
<%}else if(message.equals("2")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlNoteName(17,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("3")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(23987,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("4")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000">
<%
RecordSet.executeSql("select passwordpolicy from ldapset");
if(RecordSet.next()) {
	out.println(RecordSet.getString("passwordpolicy"));
}
%></font> 
</wea:item>
<%}else if(message.equals("5")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81825,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("6")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81826,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("7")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81827,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("8")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81795,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage())%></font> 
</wea:item>
<%}else if(message.equals("9")) {%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81796,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685,user.getLanguage())%></font> 
</wea:item>
<%} else if(message.equals("10")) {
%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(81848,user.getLanguage())%></font> 
</wea:item>
<%} else if(message.equals("184")) {
%>
<wea:item attributes="{'colspan':'full'}">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(131434,user.getLanguage())%></font> 
</wea:item>
<%}%>

<wea:item><%=SystemEnv.getHtmlLabelName(32738,user.getLanguage())%></wea:item>
<wea:item><INPUT class=inputstyle id=passwordold type=password style="width: 150px;"
  name=passwordold onchange='checkinput("passwordold","passwordoldimage")'>
	<SPAN id=passwordoldimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(27303,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle id=passwordnew type=password style="width: 150px"
    name=passwordnew onchange='checkinput("passwordnew","passwordnewimage")'> <span id=passwordnewimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span>

		<%
			String title = "";
		  if(passwordComplexity.equals("1")){
				title = SystemEnv.getHtmlLabelName(24080,user.getLanguage());
			}else if(passwordComplexity.equals("2")){
				title = SystemEnv.getHtmlLabelName(24081,user.getLanguage());
			}
		%>
		<%if(!passwordComplexity.equals("0")){ %>
		<script type="text/javascript">
		$(document).ready(function(){
			var $pwd = $('input[name="passwordnew"]');
			$pwd.passwordStrength();
		});
		</script>
		<div style="width: 350px;height: 28px" class="ShowMsg">
    	<%=title %><br>
    	<table><tr style="height:2px"><td id="passwordStrengthDiv" class="is0"></td></tr></table>
    </div>
    <%} %>
		</wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(32739,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle id=confirmpassword type=password style="width: 150px"
      name=confirmpassword onchange='checkinput("confirmpassword","confirmpasswordimage")'>
        <span id=confirmpasswordimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></wea:item>
        
  <wea:item></wea:item>

 </wea:group>
<%if(GCONST.getONDACTYLOGRAM()){%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(32864,user.getLanguage())%>'>
	<wea:item>
	<%=SystemEnv.getHtmlLabelName(22143,user.getLanguage())%><br>
	<%if(canmodifydactylogram.equals("1")){%>(<font color="red">
	<%=SystemEnv.getHtmlLabelName(22144,user.getLanguage())%>)</font><%}%>
	</wea:item>
	<wea:item><a <%if(canmodifydactylogram.equals("1")){%>style="cursor:hand" onclick="FingerEnroll('maindactylogram')"<%}%>><img width=80 height=100 src='<%=mainDactylogramImgSrc%>' align="absmiddle" border="0"></a></wea:item>
	<wea:item><a <%if(canmodifydactylogram.equals("1")){%>style="cursor:hand" onclick="FingerEnroll('assistantdactylogram')"<%}%>><img width=80 height=100 src='<%=assistantDactylogramImgSrc%>' align="absmiddle" border="0"></a></wea:item>
	<%if(canmodifydactylogram.equals("1")){%>
	<wea:item><%if(hasMainDactylogram.equals("1")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('maindactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></font></a><%}%></wea:item>
	<wea:item><%if(hasAssistantDactylogram.equals("1")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('assistantdactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%></a></font><%}%></wea:item>
	<%}%>
	<input type="hidden" id="maindactylogram" name="maindactylogram" value="">
	<input type="hidden" id="assistantdactylogram" name="assistantdactylogram" value="">
	
</wea:group>
<%}%>
</wea:layout>
 </FORM>
<%
if(GCONST.getONDACTYLOGRAM())
{
%>
<object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
<%
}
%>
<%
if("1".equals(isrsaopen)){
 %>
<script  type="text/javascript" src="/js/rsa/jsencrypt.js"></script>
<script  type="text/javascript" src="/js/rsa/rsa.js"></script>
<%} %>
<script language=javascript>  
var openStatus = 0;
function OpenDevice()
{
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0)
    {
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0)
        {
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}
//--------------------------------------------------------------//
// 登记指纹模板
//--------------------------------------------------------------//
function FingerEnroll(hiddenname){
	OpenDevice();
	if(openStatus==1){
		dtm.InputParam = "";
		iRet = dtm.EnrollSimple();
		if(iRet != 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22147,user.getLanguage())%>");
		}else{
	  	document.all(hiddenname).value=dtm.strInfo;
	  	frmMain.operation.value=hiddenname;
	  	frmMain.submit();
		}
		CloseDevice();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22148,user.getLanguage())%>");
	}
	
}
function delDactylogram(hiddenname){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
  	frmMain.operation.value=hiddenname;
  	frmMain.submit();
	}
}

function submitData() {
	
	if(checkpassword ()){
		var flag = true;
		<%if("1".equals(needusbHt) && "0".equals(usbstate) && "2".equals(userUsbType)){%>
			flag = changeKeyPassWd(); 
			if(flag) {
			   window.parent.parent.password = document.getElementById("confirmpassword").value;
			   window.top.password = document.getElementById("confirmpassword").value;
			}
		<%}%>
		if(flag == true){
			var checkpass = CheckPasswordComplexity();
			if(checkpass)
			{
				if("1" == "<%=mode%>" && "y" != "<%=needSynPassword%>") {
					window.top.Dialog.alert("AD<%=SystemEnv.getHtmlLabelName(81828,user.getLanguage())%>");
					return;
				}
			<%
			if("1".equals(isrsaopen)){
			%>
			var passwordold = jQuery("input[name='passwordold']");
			var passwordnew = jQuery("input[name='passwordnew']");
			var confirmpassword = jQuery("input[name='confirmpassword']");
			passwordnew.val(__RSAEcrypt__.rsa_data_encrypt(passwordnew.val()));
			confirmpassword.val(__RSAEcrypt__.rsa_data_encrypt(confirmpassword.val()));
			passwordold.val(__RSAEcrypt__.rsa_data_encrypt(passwordold.val()));
			<%}%>
				frmMain.submit();
			}
		}		
	}
}
function CheckPasswordComplexity()
{
	var ins = document.getElementById("passwordnew");
	var ics = document.getElementById("confirmpassword");
	var cs = "";
	if(ics)
	{
		cs = ics.value;
	}
	//window.top.Dialog.alert(cs);
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
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31863,user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
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
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83716,user.getLanguage())%>");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
function checkpassword() {
if(!check_form(password,"passwordold,passwordnew,confirmpassword")) 
    return false;
if(password.passwordnew.value.length<<%=minpasslen%>){
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");
return false;
    }
if(password.passwordnew.value != password.confirmpassword.value) {
    window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
    return false;
}
return true;
	}
	</script>
		<%if("1".equals(needusbHt) && "0".equals(usbstate) && "2".equals(userUsbType)){%>
		<script language=javascript>  
			function changeKeyPassWd(){
				<%if(!isIE.equals("true")){%>
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83061, user.getLanguage())%>");
					return false;
				<%}%>
				var flag = false;
				var ret = changeKeyPW();
				if(ret == 1){
					flag = true;
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21608, user.getLanguage())%>"+", "+"<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
				}

				return flag;
			}
			</script>
<OBJECT id=htactx name=htactx 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
<script language="javascript">
	function changeKeyPW(){
		try{
			var ret = 1;
			var hCard = htactx.OpenDevice(1);//打开设备
			if(hCard == 0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83717, user.getLanguage())%>");
				return 0;
			}
			
			try{
				htactx.VerifyUserPin(hCard, (""+password.passwordold.value));//校验口令
				htactx.ChangeUserPin(hCard, (""+password.passwordold.value), (""+password.passwordnew.value));
				return ret;
			}catch(e){
				window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(83720, user.getLanguage())%>");
				htactx.CloseDevice(hCard);
				return 0;
			}
		}catch(e){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83717, user.getLanguage())%>");
			return 0;
		}
	}
		</script>
		<%}%>

<%if("1".equals(isDialog)){ %>
	</div>
	<%if(showClose.equals("true")){%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col" needLogin="false">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" class="e8_btn_cancel" onclick="parentWin.closeDialog('<%=canpass.equals("1")?RedirectFile:""%>');">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<%} %>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	 </BODY>
    </HTML>
