
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.*,weaver.hrm.common.*" %>
<%@ page import="java.net.*" %>


<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>

<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
  //浏览器版本不支持跳转
  var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  var osVersion=$.client.version;                                //操作系统版本
  var browserOS=$.client.os;
  if((browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5&&browserOS!="Windows")){
	  window.location.href="/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+$.client.browserVersion.version;
  }
  
  if(browserName == "IE"&&browserVersion<8&&!document.documentMode){
      window.location.href="/wui/common/page/sysRemind.jsp?labelid=4";
  }
  
  //禁止iphone、ipad访问
  if(browserOS=="iPhone/iPod"||browserOS=="iPad")
     window.location.href="/wui/common/page/sysRemind.jsp?labelid=2&browserOS="+browserOS;
  //禁止windows下safari访问   
  if((browserName == "Safari"&&browserOS=="Windows"))   
     window.location.href="/wui/common/page/sysRemind.jsp?labelid=3&browserOS="+browserOS+"&browserName="+browserName; 
</script>
<%
request.getSession(true).setAttribute("weaver_login_type", "OALogin");
String ldapmode = Util.null2String(Prop.getPropValue("weaver","authentic"));//是否配置LDAP集成
String formmethod = "post";
if(!"".equals(Util.null2String(BaseBean.getPropValue("ldap", "domain")))){
	formmethod = "get";
}
String host = Util.getRequestHost(request);
GCONST.setHost(host);
String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
String hostaddr = "";
String mainControlIp ="";
try
{
 InetAddress ia = InetAddress.getLocalHost();
 hostaddr = ia.getHostAddress();
}
catch(Exception e)
{	
}



mainControlIp = BaseBean.getPropValue(GCONST.getConfigFile() , "MainControlIP");
String qstr = Util.null2String(request.getQueryString());
if(qstr.indexOf("<")!=-1 || qstr.indexOf(">")!=-1 || qstr.toLowerCase().indexOf("script")!=-1) {
	response.sendRedirect("/"+request.getContextPath());
	return;
}
if((!"".equals(mainControlIp)&&hostaddr.equals(mainControlIp))||"".equals(mainControlIp))
{
	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	int filePercent = 0;
	int currentFile = 0, fileList = 0;
	if(threadSysUpgrade.isAlive()){
		currentFile = weaver.system.SystemUpgrade.getCurrentFile();
		fileList = weaver.system.SystemUpgrade.getFileList();
	
	    if(currentFile!=0 && fileList!=0){
			out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
	        out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+ SystemEnv.getHtmlLabelName(84244,7)+"<br/><span id=\"updateratespan\">"+MathUtil.div(currentFile*100,fileList,2)+"</span>%</div>');</script>");
	    }
%>
<script>
	function ajaxinit(){
		var ajax=false;
		try{
			ajax = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				ajax = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(E){
				ajax = false;
			}
		}
		if(!ajax && typeof XMLHttpRequest!='undefined'){
		   ajax = new XMLHttpRequest();
		}
		return ajax;
	}

	var cx = 0;
	setTimeout("checkIsAlive()", 1000);

	function checkIsAlive(){
		var url = 'LoginOperation.jsp';
		var pars = 'method=add&cx='+cx;
		cx++;
		var ajax=ajaxinit();
		ajax.open("POST", "LoginOperation.jsp?method=add&cx="+cx, true);
		ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send();
		ajax.onreadystatechange = function(){
			if (ajax.readyState == 4) {
				if(ajax.status == 200){
					//alert("isAlive = " + ajax.responseText);
					var mins = ajax.responseText;
					var bx = mins.indexOf(",0,");
					if(bx == -1){
						bx = mins.indexOf(",");
						var dx = mins.lastIndexOf(",");
						document.all("updateratespan").innerHTML = mins.substring(bx+1, dx);
						setTimeout("checkIsAlive()", 5000);
					}else{
						//alert("cx = " + mins);
						self.location.reload();
					}
				}
			}
		}
	}
</script>
<%
		return;
	}
}

int upgreadeStatus= suc.getUpgreadStatus();
//升级过程中脚本执行出错
if (upgreadeStatus==1) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+ SystemEnv.getHtmlLabelName(84245,7)+suc.getUpgreadLogPath()+ SystemEnv.getHtmlLabelName(84247,7)+"</div>');</script>");
    return;
}
//升级过程中异常中止
if (upgreadeStatus==2) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+ SystemEnv.getHtmlLabelName(84250,7)+"</div>');</script>");
    return;
}
//升级程序执行异常
if (upgreadeStatus==3) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+ SystemEnv.getHtmlLabelName(84252,7)+"</div>');</script>");
    return;
}

String templateId="",templateType="",imageId="",loginTemplateTitle="";
String isRememberPW ="";//add by wshen 
int extendloginid=0;

String sqlLoginTemplate = "SELECT * FROM SystemLoginTemplate WHERE isCurrent='1'";	

rs.executeSql(sqlLoginTemplate);

if(rs.next()){
	templateId=rs.getString("loginTemplateId");
	templateType = rs.getString("templateType");
	isRememberPW = Util.null2String(rs.getString("isRememberPW"));//add by wshen 
	imageId = rs.getString("imageId");
	loginTemplateTitle = rs.getString("loginTemplateTitle");
	extendloginid = rs.getInt("extendloginid");
	out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
}
String imagePath="";
if(!"".equals(imageId)){
	if(imageId.indexOf("/")==-1){
		imagePath = "/LoginTemplateFile/"+imageId;
	}else{
		imagePath = imageId;
	}
}
//是否使用默认登录页，如果是(logindefault ：1)则不做页面跳转
String loginDefault =Util.null2String(request.getParameter("logindefault"));
if(templateType.equals("site")&&!loginDefault.equals("1")){ //如果是扩展页面需要做跳转
	response.sendRedirect("/page/maint/login/Page.jsp?templateId="+templateId+"&"+request.getQueryString());
	return;
} else if(templateType.equals("H2")){ //如果是扩展页面需要做跳转
    //response.sendRedirect("/wui/page/login.jsp?templateId="+templateId+"&"+request.getQueryString());
	request.getRequestDispatcher("/wui/theme/ecology7/page/login.jsp?templateId=" + templateId + "&" + request.getQueryString()).forward(request, response);
    return;
}else if(templateType.equals("E8")){
	request.getRequestDispatcher("/wui/theme/ecology8/page/login.jsp?templateId=" + templateId + "&" + request.getQueryString()).forward(request, response);
	return;
} 
//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
// add by dongping for TD1340 in 2004.11.05
// add a cookie in our system
Cookie ckTest = new Cookie("testBanCookie","test");
ckTest.setMaxAge(-1);
ckTest.setPath("/");
response.addCookie(ckTest);

//xiaofeng, usb硬件加密 

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
if(settings==null){
    BirthdayReminder birth_reminder = new BirthdayReminder();
    settings=birth_reminder.getRemindSettings();
    if(settings==null){
        out.println("Cann't create connetion to database,please check your database.");
        return;
    }
    application.setAttribute("hrmsettings",settings);
}
String validitySec = Tools.vString(settings.getValiditySec(), "120");
String needusb=settings.getNeedusb();
String needusbHt=settings.getNeedusbHt();
String needusbDt=settings.getNeedusbDt();
needusb = (needusbHt.equals("1") || needusbDt.equals("1")) ? "1" : "0";
String usbType = settings.getUsbType();
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String OpenPasswordLock = settings.getOpenPasswordLock();

String needdactylogram = settings.getNeedDactylogram(); 
//String canmodifydactylogram = settings.getCanModifyDactylogram();
String loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
String message0 = Util.null2String(request.getParameter("message")) ;

int languageid = Util.getIntValue(request.getParameter("languageid"),7);
//处理发过动态密码后   刷新页面 不重新发送的问题  20931
if((message0.equals("57") || message0.equals("101")) && loginid.equals("")){
	 loginid = "";
	 message0 = "";
	 }
String message=message0;
if(message0.equals("nomatch")) message = "";
int _messageIV = Util.getIntValue(message0);
boolean transMSG = _messageIV == 16 || _messageIV == 17;

if(!message.equals("")) message = transMSG ? SystemEnv.getHtmlLabelName(124919,languageid) : SystemEnv.getErrorMsgName(_messageIV,languageid) ;

if("16".equals(message0)){
	String isADAccount = "";
	rs.executeSql("select isADAccount from hrmresource where loginid='"+loginid+"'");
	if(rs.next()) {
		isADAccount = rs.getString("isADAccount");
	}
	
	if("1".equals(OpenPasswordLock)){
		if(ldapmode == null || ldapmode.equals("") || ("ldap".equals(ldapmode) && !"1".equals(isADAccount))) {
			loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
			rs2.executeSql("select id from HrmResourceManager where loginid='"+loginid+"'");
			if(!rs2.next()){
				String sql = "select sumpasswordwrong from hrmresource where loginid='"+loginid+"'";
				rs1.executeSql(sql);
				rs1.next();
				int sumpasswordwrong = Util.getIntValue(rs1.getString(1));
				int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
				int leftChance = sumPasswordLock-sumpasswordwrong;
				if(leftChance==0){
					sql = "update HrmResource set passwordlock=1,sumpasswordwrong=0 where loginid='"+loginid+"'";
					rs1.executeSql(sql);
					message0 = "110";
				}else{
					message = SystemEnv.getHtmlLabelName(24466,languageid)+leftChance+SystemEnv.getHtmlLabelName(24467,languageid);
				}
			}
		}
		
	}
}
session.removeAttribute("tmploginid1");
if(message0.equals("16")) {
	loginid = "";
} 
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,languageid)+SystemEnv.getHtmlLabelName(81913,languageid)+validitySec+SystemEnv.getHtmlLabelName(81914,languageid);
} else if(message0.equals("730")){
	message = SystemEnv.getHtmlLabelName(84255,languageid);
	message0 = "";
}
if(message0.equals("110")) 
{
	loginid = "";
	int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,languageid)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,languageid)+"，"+SystemEnv.getHtmlLabelName(24594,languageid);
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}
String logintype = Util.null2String(request.getParameter("logintype")) ;
if(logintype.equals("")) logintype="1";

//IE 是否允许使用Cookie
String noAllowIe = Util.null2String(request.getParameter("noAllowIe")) ;
if (noAllowIe.equals("yes")) {
	message = "IE"+SystemEnv.getHtmlLabelName(83703,languageid)+"Cookie";
}

//用户并发数错误提示信息
if (message0.equals("26")) { 
	message = SystemEnv.getHtmlLabelName(23656,languageid);
}
if(message0.equals("block")){
	message = SystemEnv.getHtmlLabelName(127896,languageid); 
}
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();//0: 否,1: 是
int validatetype=settings.getValidatetype();//验证码类型，0：数字；1：字母；2：汉字
int islanguid = 0;//7: 中文,9: 繁体中文,8:英文
Cookie[] systemlanid= request.getCookies();
for(int i=0; (systemlanid!=null && i<systemlanid.length); i++){
	//System.out.println("ck:"+systemlanid[i].getName()+":"+systemlanid[i].getValue());
	if(systemlanid[i].getName().equals("Systemlanguid")){
		islanguid = Util.getIntValue(systemlanid[i].getValue(), 0);
		break;
	}
}

//add by wshen 
String isRememberUserName = "0";
String isRememberPwd = "0";
String userPasswordGP="";
isRememberPW="1";
if("1".equals(isRememberPW)){
	for(Cookie cookie : systemlanid){
		if("isRememberUserName".equals(cookie.getName())){
			isRememberUserName = cookie.getValue(); // get the cookie value
		}
		if("isRememberPwd".equals(cookie.getName())){
			isRememberPwd = cookie.getValue(); // get the cookie value
		}
		if("1".equals(isRememberPwd)){
			if("userLoginIdGP".equals(cookie.getName())){
				loginid = cookie.getValue(); // get the cookie value
			}
			if("userPasswordGP".equals(cookie.getName())){
				userPasswordGP = cookie.getValue(); // get the cookie value
			}
		}
		if("1".equals(isRememberUserName)){
			if("userLoginIdGP".equals(cookie.getName())){
				loginid = cookie.getValue(); // get the cookie value
			}
		}
	}
}	
//end add 



boolean ismuitlaguage = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
	VerifyLogin.checkLicenseInfo();
	multilanguage = (String)staticobj.getObject("multilanguage") ;
}else if(multilanguage.equals("y")){
	ismuitlaguage = true;
}
%>

<%
if(message0.equals("46")){
%>
<script language="JavaScript">
flag=confirm('<%=SystemEnv.getHtmlLabelName(83709,languageid)%>')
if(flag){
	<%if("1".equals(usbType)){%>
		window.open("/weaverplugin/WkRt.exe")
	<%}else{%>
		window.open("/weaverplugin/HaiKeyRuntime.exe")
	<%}%>
}
</script>
<%}%>

<%
if(message0.equals("122"))
	message =SystemEnv.getHtmlLabelName(84268,languageid)+"<a href='/login/syncTokenKey.jsp'>"+SystemEnv.getHtmlLabelName(127897,languageid)+"</a>";
%>


<%@page import="weaver.login.VerifyLogin"%><html>
<head>
<title><%=SystemEnv.getHtmlLabelName(84169,languageid)%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
// -->
</script>

</head>
<SCRIPT language=javascript1.1>
//<!--
function checkall()
{ 
	var dactylogram = "";
	if(document.all("dactylogram")) dactylogram = document.all("dactylogram").value;
	if(dactylogram == ""){
	var i=0;
	var j=0;
	var errMessage="";
if (form1.loginid.value=="") {errMessage=errMessage+"<%=SystemEnv.getHtmlLabelName(16647,languageid)%>\n";i=i+1;}
if (form1.userpassword.value=="") {errMessage=errMessage+"<%=SystemEnv.getHtmlLabelName(16648,languageid)%>\n";j=j+1;}
if (i>0){
	alert(errMessage);form1.loginid.focus(); return false ;
}else if(j>0){
	alert(errMessage);form1.userpassword.focus(); return false ;
}

<%if(needusb!=null&&needusb.equals("1")){%>
if(userUsbType=="1")
   checkusb1();
else if(userUsbType=="2")
   checkusb2();
else if(userUsbType=="3")
   return checkusb3();
<%}%>
//  else { form1.submit() ; }
}}

var dactylogramStr = "";
var intervalID = 0;
//--------------------------------------------------------------//
// 采集指纹特征
//--------------------------------------------------------------//
function FingerSample(){
    init();
    if(dactylogramStr==""){
        OpenDevice();
        if(openStatus==1){
            iRet = dtm.GetExtractMBSimple();
            if(iRet != 0){
			          if(intervalID!=0) window.clearInterval(intervalID);
                intervalID = setTimeout("FingerSample()", 2000);
            }else{
                if(intervalID!=0) window.clearInterval(intervalID);
                if(intervalID2!=0) window.clearInterval(intervalID2);
                dactylogramStr = dtm.strInfo;
                document.all("dactylogram").value=dactylogramStr;
                form1.submit();
            }
            CloseDevice();
        }
    }
    if(intervalID!=0) window.clearInterval(intervalID);
    intervalID = setTimeout("FingerSample()", 2000);    
}

var openStatus = 0;
function OpenDevice()
{
    openStatus = 0;
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0){
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0){
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}
function init(){
    try{
        OpenDevice();
        if(openStatus != 1){
            document.all("dactylogramLoginImgId").src="/images/loginmode/3_wev8.gif";
            if(intervalID2!=0) window.clearInterval(intervalID2);
            intervalID2=setTimeout("init()", 100);
        }else{
            if("<%=message0%>"=="nomatch") document.all("dactylogramLoginImgId").src="/images/loginmode/2_wev8.gif";
            else document.all("dactylogramLoginImgId").src="/images/loginmode/1_wev8.gif";
            if(intervalID2!=0) window.clearInterval(intervalID2);
            if(document.getElementById("onDactylogramOrPassword").value==0){
                if(intervalID!=0) window.clearInterval(intervalID);
                intervalID=setTimeout("FingerSample()", 2000);
            }
        }
        CloseDevice();
    }catch(e){}
}
if("<%=needdactylogram%>"=="1"||"<%=message0%>"=="nomatch"){
    if(intervalID!=0) window.clearInterval(intervalID);
    if(intervalID2!=0) window.clearInterval(intervalID2);
		intervalID2=setTimeout("init()", 100);
    intervalID=setTimeout("FingerSample()", 2000);
}
var intervalID2=0;
if(<%=GCONST.getONDACTYLOGRAM()%>&&"<%=needdactylogram%>"=="1") intervalID2=setTimeout("init()", 100);
function changeLoginMode(modeid){
	if(modeid==0){
		document.all("dactylogramLogin").style.display = "";
		document.all("passwordLogin").style.display = "none";
		document.all("loginModeTable").style.margin = "100px 0 0 475px";
		if(intervalID2!=0) window.clearInterval(intervalID2);
		init();
		if(openStatus==1) intervalID=setTimeout("FingerSample()", 2000);
	}
	if(modeid==1){
		document.all("dactylogramLogin").style.display = "none";
		document.all("passwordLogin").style.display = "";
		if("<%=message0%>"=="nomatch"){
		    document.all("loginModeTable").style.margin = "150px 0 0 475px";
		    document.all("loginPasswordTable").style.margin = "0 0 0 570px";
		}else{
		    document.all("loginModeTable").style.margin = "0 0 35px 475px";
		}
		if(intervalID!=0) window.clearInterval(intervalID);
		if(intervalID2!=0) window.clearInterval(intervalID2);
	}
}
function VchangeLoginMode(modeid){
	if(modeid==0){
		document.all("dactylogramLoginV").style.display = "";
		document.all("passwordLoginV").style.display = "none";
		setTimeout("FingerSample()", 500);
	}
	if(modeid==1){
		document.all("dactylogramLoginV").style.display = "none";
		document.all("passwordLoginV").style.display = "";
		if(intervalID!=0) window.clearInterval(intervalID);
	}
}
function changeLoginMethod(methodtype){
    alert(methodtype);
    document.getElementById("loginid").disabled = true;
}

//add by sean.yang 2006-02-09 for TD3609
function changeMsg(msg)
{
    if(msg==0){
        if(document.all.validatecode.value=='<%=SystemEnv.getHtmlLabelName(22909,languageid)%>') 
            document.all.validatecode.value='';
    }else if(msg==1){
        if(document.all.validatecode.value=='') 
            document.all.validatecode.value='<%=SystemEnv.getHtmlLabelName(22909,languageid)%>';
    }
}
// -->

// added by wcd 2014-12-19
var pswdDialog;
var common = new MFCommon();
common.initDialog({width:600,height:400,showMax:false,checkDataChange:false});
function forgotPassword(){
	pswdDialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=forgotPassword","<%=SystemEnv.getHtmlLabelName(127899,languageid)%>");
}
		
function resetPassword(loginid){
	if(pswdDialog) pswdDialog.close();
	pswdDialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=resetPassword&loginid="+loginid,"<%=SystemEnv.getHtmlLabelName(31479,languageid)%>");
}
// -->
</SCRIPT>


<script language="JavaScript">
function click() {
	if (event.button==2){
		alert('<%=SystemEnv.getHtmlLabelName(16641,languageid)%>')
	}
}
document.onmousedown=click
</script>
<%if(needusb!=null&&needusb.equals("1")){%>
	<script language="JavaScript">
		function checkusb1(){ 
		 
		  try{
			rnd=Math.round(Math.random()*1000000000)
			form1.rnd.value=rnd
			wk = new ActiveXObject("WIBUKEY.WIBUKEY")
			MyAuthLib=new ActiveXObject("WkAuthLib.WkAuth")
			wk.FirmCode = <%=firmcode%>
			wk.UserCode = <%=usercode%>
			wk.UsedSubsystems = 1
			wk.AccessSubSystem() 
			if(wk.LastErrorCode==17){      
			  form1.serial.value='0'
			  return      
			  }      
		   if(wk.LastErrorCode>0){
			  throw new Error(wk.LastErrorCode)
			  }    
			wk.UsedWibuBox.MoveFirst()
			MyAuthLib.Data=wk.UsedWibuBox.SerialText     
			MyAuthLib.FirmCode = <%=firmcode%>
			MyAuthLib.UserCode = <%=usercode%>
			MyAuthLib.SelectionCode= rnd
			MyAuthLib.EncryptWk()
			form1.serial.value= MyAuthLib.Data   
			}catch(err){
			  form1.serial.value= '1'      
			  return      
			}        
		 }
		 </script>
         <script language="JavaScript">
             function checkusb3(){
               //需要输入动态口令
			   if(jQuery("#tokenAuthKey").val()==""||jQuery("#tokenAuthKey").val()=="<%=SystemEnv.getHtmlLabelName(127901,languageid)%>"){
			      alert("<%=SystemEnv.getHtmlLabelName(127901,languageid)%>！");
			      jQuery("#tokenAuthKey").focus();
			      return false;
			   }else if(!isdigit(jQuery("#tokenAuthKey").val())){
			      alert("<%=SystemEnv.getHtmlLabelName(127902,languageid)%>");
			      jQuery("#tokenAuthKey").focus();
			      return false;
			   }else if(jQuery("#tokenAuthKey").val().length!=6){
			      alert("<%=SystemEnv.getHtmlLabelName(127903,languageid)%>");   
			      jQuery("#tokenAuthKey").focus();
			      return false; 
			   }    
             }
             function isdigit(s){
				var r,re;
				re = /\d*/i; //\d表示数字,*表示匹配多个数字
				r = s.match(re);
				return (r==s)?true:false;
			}
         </script>		 
		<script language="JavaScript">
			function checkusb2(){
				try{
					rnd = Math.round(Math.random()*1000000000);
					//alert(rnd);
					form1.rnd.value=rnd
					var returnstr = getUserPIN();
					if(returnstr != undefined){
						form1.username.value= returnstr;
						//alert(tusername);
						//alert(tserial);
						var randomKey = getRandomKey(rnd)
						form1.serial.value= randomKey;
						//alert(randomKey);
					}else{
						form1.serial.value= '0';
					}
				}catch(err){
					form1.serial.value= '0';
					form1.username.value= '';
					return;
				}
			}
		</script>
		<OBJECT id=htactx name=htactx 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		<script language=VBScript>
			function getUserPIN()
				Dim vbsserial
				dim hCard
				hCard = 0
				on   error   resume   next
				hCard = htactx.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
					Exit function
				End if
				dim UserName
				on   error   resume   next
				UserName = htactx.GetUserName(hCard)'获取用户名
				If Err.number<>0 Then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2")
					htactx.CloseDevice hCard
					Exit function
				End if

				vbsserial = UserName
				htactx.CloseDevice hCard
				getUserPIN = vbsserial
			End function

			function getRandomKey(randnum)
				dim hCard
				hCard = 0	
				hCard = htactx.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4")
					Exit function
				End if
				dim Digest
				Digest = 0
				on error resume next
					Digest = htactx.HTSHA1(randnum, len(randnum))
				if err.number<>0 then
						htactx.CloseDevice hCard
						Exit function
				end if

				on error resume next
					Digest = Digest&"04040404"'对SHA1数据进行补码
				if err.number<>0 then
						htactx.CloseDevice hCard
						Exit function
				end if

				htactx.VerifyUserPin hCard, CStr(form1.userpassword.value) '校验口令
				'alert HRESULT
				If Err.number<>0 Then
					'alert("HashToken compute")
					htactx.CloseDevice hCard
					Exit function
				End if
				dim EnData
				EnData = 0
				EnData = htactx.HTCrypt(hCard, 0, 0, Digest, len(Digest))'DES3加密SHA1后的数据
				If Err.number<>0 Then 
					'alert("HashToken compute")
					htactx.CloseDevice hCard
					Exit function
				End if
				htactx.CloseDevice hCard
				getRandomKey = EnData
				'alert "EnData = "&EnData
			End function

		</script>
 <%}%>
</script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 onload="<%if(!needdactylogram.equals("1")&&!message0.equals("nomatch")){%>javascripts:form1.<%if(!loginid.equals("")){%>userpassword<%}else{%>loginid<%}%>.focus()<%}%>">
<!--********************************************
超时窗口登录界面 (TD 2227)
hubo,050707-->
<%if(request.getSession(true).getAttribute("layoutStyle")!=null && request.getSession(true).getAttribute("layoutStyle").equals("1")){%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" background="/images_face/login/tablebg_wev8.jpg">
        <form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
          <input type=hidden name="formmethod" value="<%=formmethod%>">
          
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
                  <tr> 
                    <td height="75">&nbsp;</td>
					<td height="75" valign="bottom" style="color:#FF0000;font-size:9pt">
					<span id="errorMessage" name="errorMessage">
					<%
					if(message.equals("")){
						int languageidweaver = Util.getIntValue(Util.getCookie(request,"languageidweaver"),languageid);
						out.println(SystemEnv.getErrorMsgName(19,languageidweaver));
					}else
						out.println(message);
					%>
					</span>
					</td>
                  </tr>
                  <tr> 
                    <td height="20" width="150">
                    </td>
                    <td height="20"> 
                      <input type="text" id="loginid" name="loginid" class="stedit" size="10" value="<%=rci.getLoginID(Util.null2String(Util.getCookie(request,"loginidweaver")))%>" readonly>
                    </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="12"></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150"></td>
                    <td height="20"> 
                      
                    <%
                    if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
                    {
                    %>
                      <input type="text" name="userpassword" class="stedit" value="<%=userPasswordGP%>" size="10" >
                    <%
                    } 
                    else
                    {
                    %>
                    <input type="password" name="userpassword" class="stedit" value="<%=userPasswordGP%>" size="10" >
                    <%
                    }
                    %>
                    </td>
                  </tr>
                  <tr>
                  	<td>
                  	 <!-- 记住密码 、用户名 add by wshen-->
						 <%
						 if("1".equals(isRememberPW)){%>
						<span id="rememberPW" style="margin:15px 0 0 570px">
							<input type='checkbox' name="isRememberUserName" id="isRememberUserName" <%if("1".equals(isRememberUserName)){ %>checked value='1'<%}else{ %>value='0'<%} %>/> 
							<span id="rmbUsn"><%=SystemEnv.getHtmlLabelName(126785,7)%></span>
							<input type='checkbox' name="isRememberPwd" id="isRememberPwd" <%if("1".equals(isRememberPwd)){ %>checked value='1'<%}else{ %>value='0'<%} %>/>
							<span id="rmbPwd"><%=SystemEnv.getHtmlLabelName(126786,7)%></span>
						</span></br>
						<%}%>
                  	</td>
                  </tr>
                  <%if(needvalidate==1){%>
                  <tr> 
                    <td height="18" width="150"></td>
                    <td height="18"> 
                 <input id="validatecode" name="validatecode" type="text" size="15" value="<%=SystemEnv.getHtmlLabelName(22909,languageid)%>" onfocus="changeMsg(0)" onblur="changeMsg(1)"></td>
                     </tr>
                  <tr> 
                  <td height="18" width="150"></td>
                  <td height="18"> 
                 <a href="javascript:changeCode()"><img  id="imgCode" border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode'></a>
						<script>
																   	 var seriesnum_=0;
																  	 function changeCode(){
																  	 	seriesnum_++;
																  		setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum_)',50); 
																  	 }
																  	</script>
                   </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="5"></td>
                  </tr>
                <%}else{%>
                  <tr> 
                    <td colspan="2" height="18">&nbsp; </td>
                  </tr>
                  <%}%>
					<tr> 
							<td height="18" width="150">&nbsp;</td>
							<td style="padding:3 0">
							  <div style="display: none;" id="trTokenAuthKey">
		                          
			                  </div>
								<label style="cursor:pointer;" onclick="forgotPassword()"><%=SystemEnv.getHtmlLabelName(81614,languageid)%></label>
							</td>
					</tr>

                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt; <%=SystemEnv.getHtmlLabelName(674,languageid)%>">
                    </td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
<!--********************************************-->
<%}else{%>
	<%
	
	
	if(templateType.equals("V")){
	%>
<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0"  bgcolor="#FFFFFF">
  <tr> 
    <td width="489" rowspan="2" valign="top" style="<%if(imagePath.equals("")){out.println("background-image:url(/images_face/login/left_wev8.jpg)");}else{out.println("background-image:url("+imagePath+")");}%>;background-repeat:no-repeat"></td>
    <td valign="top"> 

      <div align="left">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="260">&nbsp;</td>
          </tr>
          <tr>
            <td height="217">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" style="background:url(/images_face/login/tablebg_wev8.jpg)no-repeat;"><!-- background="/images_face/login/tablebg_wev8.jpg" -->
        <form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
		  <input type=hidden name="formmethod" value="<%=formmethod%>">
                  
                  <%if(GCONST.getONDACTYLOGRAM()){%>
                  <tr> 
                    <td height="25" colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <font size=2 color="black"><B><%=SystemEnv.getHtmlLabelName(22149,languageid)%> ：</B></font>
                    <input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="0" onclick="VchangeLoginMode(0)" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>checked<%}%>><font color="black"><%=SystemEnv.getHtmlLabelName(127904,languageid)%></font>
                    <input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="1" onclick="VchangeLoginMode(1)" <%if(!needdactylogram.equals("1")){if(!message0.equals("nomatch")){%>checked<%}}else{%>disabled<%}%>><font color="black"><%=SystemEnv.getHtmlLabelName(127905,languageid)%></font>
                    </td>
                  </tr>
                  
                  <tr> 
                    <td height="30" colspan=2>&nbsp;</td>
                  </tr>
                  <%}else{%>
                  <tr> 
                    <td height="42" colspan=2>&nbsp;</td>
                  </tr>
                  <%}%>

                	<tr><td height="126" colspan=2>
                		<div id="dactylogramLoginV" name="dactylogramLoginV" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:''"<%}else{%>style="display:none"<%}%>>
                	<table width="100%">
                		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<img id="dactylogramLoginImgId" src="/images/loginmode/3_wev8.gif">
                	<input type="hidden" id="dactylogram" name="dactylogram" value="">
                		</td></tr>
                	</table>
                	</div>                	
                	
                	<div id="passwordLoginV" name="passwordLoginV" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:none"<%}else{%>style="display:''"<%}%>>
                	<table width="100%">
                  
                  <tr> 
                    <td height="28">&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td height="28" valign="bottom" style="color:#FF0000;font-size:9pt"><span name="errorMessage" id="errorMessage"><%=message %></span></td>
                  </tr>
                	
                  <tr> 
                    <td height="20" width="150">&nbsp;</td>
                    <td height="20"> 
                      <input type="text" id="loginid" name="loginid" value="<%=loginid%>"  class="stedit" size="15">
                    </td>
                  </tr>

                  <tr> 
                    <td colspan="2" height="12"></td>
                  </tr>


                  <tr> 
                    <td height="20" width="150">&nbsp;</td>
                    <td height="20"> 
                    <%
                    if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
                    {
                    %>
                      <input type="text" name="userpassword" class="stedit" value="<%=userPasswordGP %>" size="15" >
                    <%
                    } 
                    else
                    {
                    %>
                    <input type="password" name="userpassword" class="stedit" value="<%=userPasswordGP %>" size="15" >
                    <%
                    }
                    %>
                    </td>
                  </tr>
                  
                  <tr>
                  	<td colspan='2' align='left'>
                  	 <!-- 记住密码 、用户名 add by wshen -->
						 <%
						 if("1".equals(isRememberPW)){%>
						<span id="rememberPW" style="margin:15px 0 0 50px">
							<input type='checkbox' name="isRememberUserName" id="isRememberUserName" <%if("1".equals(isRememberUserName)){ %>checked value='1'<%}else{ %>value='0'<%} %>/> 
							<span id="rmbUsn"><%=SystemEnv.getHtmlLabelName(126785,7)%></span>
							<input type='checkbox' name="isRememberPwd" id="isRememberPwd" <%if("1".equals(isRememberPwd)){ %>checked value='1'<%}else{ %>value='0'<%} %>/>
							<span id="rmbPwd"><%=SystemEnv.getHtmlLabelName(126786,7)%></span>
						</span></br>
						<%}%>
                  	</td>
                  </tr>


                  <%if(needvalidate==1){%>
                  <tr> 
                    <td height="18" width="150">&nbsp;</td>
                    <td style="padding:3 0"> 
                		 <input id="validatecode" name="validatecode" type="text" size="15" value="<%=SystemEnv.getHtmlLabelName(22909,languageid)%>" onfocus="changeMsg(0)" onblur="changeMsg(1)">
					</td>
                  </tr>

 
                  <tr> 
	                  <td height="18" width="150">&nbsp;</td>
	                  <td style="padding:3 0"> 
	                 	<a href="javascript:changeCode1()"><img  id="imgCode1" border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode'></a>
						<script>
																   	 var seriesnum1_=0;
																  	 function changeCode1(){
																  	 	seriesnum1_++;
																  		setTimeout('$("#imgCode1").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum1_)',50); 
																  	 }
																  	</script>
	                   </td>
                  </tr>
					 
              
                <%}%>
					<tr> 
							<td height="18" width="150">&nbsp;</td>
							<td style="padding:3 0">
							  <div style="display: none;" id="trTokenAuthKey">
		                          
			                  </div>
								<%if(ismuitlaguage){%>    
									<select id=islanguid name=islanguid> 	
										<option value=0><%=SystemEnv.getHtmlLabelName(172,languageid)+SystemEnv.getHtmlLabelName(16066,languageid)%></option>
										<%=LanguageComInfo.getSelectLan(islanguid) %>   
								    </select>
								<%}else{
								%>
								<input id="islanguid" name="islanguid" type="hidden" value="7">
								<%
								}%>	
							</td>
					</tr>
					<tr> 
							<td height="18" width="150">&nbsp;</td>
							<td style="padding:3 0">
							  <div style="display: none;" id="trTokenAuthKey">
		                          
			                  </div>
								<label style="cursor:pointer;" onclick="forgotPassword()"><%=SystemEnv.getHtmlLabelName(81614,languageid)%></label>
							</td>
					</tr>

                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt;<%=SystemEnv.getHtmlLabelName(674,languageid)%>">
                    </td>
                  </tr>
                  
                </table></div></td></tr>

                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
            </td>
          </tr>
          <tr>
            <td height="19" background="/images_face/login/url_wev8.jpg">&nbsp;</td>
          </tr>
		  <tr>          
			  <td>	
				 <table width="100%" height=100% border="0" cellspacing="20" cellpadding="0"  bgcolor="#FFFFFF">
				 <tr>
				 <td><span style="line-height: 20px"> <font style="color:#990000;font-weight: bold"><%=SystemEnv.getHtmlLabelName(82060,languageid)%></font><%=SystemEnv.getHtmlLabelName(84226,languageid)%><font style="color:#5F7DD0;font-weight: bold">IE6.0</font><%=SystemEnv.getHtmlLabelName(84228,languageid)%><font style="color:#5F7DD0;font-weight: bold">Microsoft <%=SystemEnv.getHtmlLabelName(84229,languageid)%>(VM)</font>；<%=SystemEnv.getHtmlLabelName(84230,languageid)%>6.0；Microsoft <%=SystemEnv.getHtmlLabelName(84229,languageid)%>(VM)<%=SystemEnv.getHtmlLabelName(84231,languageid)%><a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,languageid)%></font></a><%=SystemEnv.getHtmlLabelName(84232,languageid)+SystemEnv.getHtmlLabelName(127906,languageid)%><%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%><a href="/weaverplugin/Ecologyplugin_tw.exe"><%}else{ %><a href="/weaverplugin/Ecologyplugin.exe"><%} %><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,languageid)%></font></a><%=SystemEnv.getHtmlLabelName(127907,languageid)%></span>
				 </td>
				 </tr>
				 </table>
			  </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
<%
	}else{
%>	
	<form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
		  <input type=hidden name="formmethod" value="<%=formmethod%>">

<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right"><img src="/images_face/login/weaverlogo_wev8.gif" width="325" height="50"></td>
  </tr>
  <tr>
    <td style="height:370px;<%if(imagePath.equals("")){out.println("background-image:url(/images_face/login/loginLanguage_wev8.jpg)");}else{out.println("background-image:url("+imagePath+")");}%>;background-repeat:no-repeat">
   <%if(GCONST.getONDACTYLOGRAM()){%> 	
	 <table id="loginModeTable" <%if(message0.equals("nomatch")||needdactylogram.equals("1")){%>style="margin:100px 0 0 475px;border-collapse:collapse;color:white"<%}else{%>style="margin:0 0 35px 475px;border-collapse:collapse;color:white"<%}%>>
	 	<tr><td>
			<font size=2 color="black"><B><%=SystemEnv.getHtmlLabelName(22149,languageid)%> </B></font>
	 		<input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="0" onclick="changeLoginMode(0)" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>checked<%}%>><font color="black"><%=SystemEnv.getHtmlLabelName(127904,languageid)%></font>
	 		<input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="1" onclick="changeLoginMode(1)" <%if(!needdactylogram.equals("1")){if(!message0.equals("nomatch")){%>checked<%}}else{%>disabled<%}%>><font color="black"><%=SystemEnv.getHtmlLabelName(127905,languageid)%></font>
	 	</td></tr>
	 </table>
	 
	<div id="dactylogramLogin" name="dactylogramLogin" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:''"<%}else{%>style="display:none"<%}%>>
		<img id="dactylogramLoginImgId" src="/images/loginmode/3_wev8.gif" style="margin:1 0 0 475px">
		<input type="hidden" id="dactylogram" name="dactylogram" value="">
	</div>
	<%}%>
	 <div id="passwordLogin" name="passwordLogin" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:none"<%}else{%>style="display:'';position:absolute;posTop:100px;top:78px;margin-top:0px"<%}%>>
	 <table id="loginPasswordTable" style="margin:135px 0 0 560px;border-collapse:collapse;color:red;height: 28px;"><tr><td><span name="errorMessage" id="errorMessage"><%=message %></span>&nbsp;</td></tr></table>
	 
	 <input id="loginid" name="loginid" type="text" size="15" value="<%=loginid%>" style="margin:0px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
	 {
	 %>
	 <input name="userpassword" type="text" size="15" value="<%=userPasswordGP %>" style="margin:6px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 }
	 else
	 {
	 %>
	 <input name="userpassword" type="password" size="15" value="<%=userPasswordGP %>" style="margin:6px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 } 
	 %>
	 
	 <!-- 记住密码 、用户名-->
	<%
		if("1".equals(isRememberPW)){%>
		<span id="rememberPW" style="margin:15px 0 0 570px">
			<input type='checkbox' name="isRememberUserName" id="isRememberUserName" <%if("1".equals(isRememberUserName)){ %>checked value='1'<%}else{ %>value='0'<%} %>/> 
			<span id="rmbUsn"><%=SystemEnv.getHtmlLabelName(126785,7)%></span>
			<input type='checkbox' name="isRememberPwd" id="isRememberPwd" <%if("1".equals(isRememberPwd)){ %>checked value='1'<%}else{ %>value='0'<%} %>/>
			<span id="rmbPwd"><%=SystemEnv.getHtmlLabelName(126786,7)%></span>
		</span></br>
	<%}%>
	 
	     <%if(needvalidate==1){%>
	     <input id="validatecode" name="validatecode" type="text" size="15" style="margin:6px 0 0 560px" value="<%=SystemEnv.getHtmlLabelName(22909,languageid)%>" onfocus="changeMsg(0)" onblur="changeMsg(1)"><br/>
		  <a href="javascript:changeCode2()"><img  id="imgCode2" border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode'  style="margin:6px 0 0 560px"></a>
						<script>
																   	 var seriesnum2_=0;
																  	 function changeCode2(){
																  	 	seriesnum2_++;
																  		setTimeout('$("#imgCode2").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum2_)',50); 
																  	 }
																  	</script>
		 <br/>
		 <div style="display: none;" id="trTokenAuthKey" style='padding:6px 0 0 560px;'>
		       
		 </div>
			<%if(ismuitlaguage){%>
			<select class=InputStyle id=islanguid name=islanguid style="width:100px;margin:6px 0 0 560px">
			<option value=0><%=SystemEnv.getHtmlLabelName(172,languageid)+SystemEnv.getHtmlLabelName(16066,languageid)%></option>
			<%=LanguageComInfo.getSelectLan(islanguid) %>
	       </select></br>
			<%}%>
			<div style="cursor:pointer;width:100px;margin:6px 0 0 560px" onclick="forgotPassword()"><%=SystemEnv.getHtmlLabelName(81614,languageid)%></div></br>
			<button type="submit" style="border:1px #FF0000 solid;BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru_wev8.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:10px 0 0 608px">
		 <%}else{%>
		    <div style="display: none;" id="trTokenAuthKey" style="padding:6px 0 0 560px;">
		        
			</div>
			<%if(ismuitlaguage){%>
			<select class=InputStyle id=islanguid name=islanguid style="width:100px;margin:6px 0 0 560px">
			<option value="0"><%=SystemEnv.getHtmlLabelName(172,languageid)+SystemEnv.getHtmlLabelName(16066,languageid)%></option>
			<%=LanguageComInfo.getSelectLan(islanguid) %>
	       </select></br>
			<%}%>
			<div style="cursor:pointer;width:100px;margin:6px 0 0 560px" onclick="forgotPassword()"><%=SystemEnv.getHtmlLabelName(81614,languageid)%></div></br>
			<button type="submit" style="border:1px #FF0000 solid;BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru_wev8.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:7px 0 0 608px">
		
	<%} %> 
	</div>
	
	 </td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="2%" valign="top"><img src="/images_face/login/copyright_wev8.gif" width="449" height="80"></td>
    <td width="98%">
    <table width="97.5%"  border="0" cellspacing="0" cellpadding="0">
      <tr><td>
             <span style="line-height: 20px; font-size:9pt" cellspacing="50" cellpadding="50"><font style="color:#990000;font-weight: bold"><%=SystemEnv.getHtmlLabelName(82060,languageid)%></font><%=SystemEnv.getHtmlLabelName(84226,languageid)%><font style="color:#5F7DD0;font-weight: bold">IE6.0</font><%=SystemEnv.getHtmlLabelName(84228,languageid)%><font style="color:#5F7DD0;font-weight: bold">Microsoft <%=SystemEnv.getHtmlLabelName(84229,languageid)%>(VM)</font>；<%=SystemEnv.getHtmlLabelName(84230,languageid)%>IE6.0；Microsoft <%=SystemEnv.getHtmlLabelName(84229,languageid)%>(VM)<%=SystemEnv.getHtmlLabelName(84231,languageid)%><a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,languageid)%></font></a><%=SystemEnv.getHtmlLabelName(84232,languageid)+SystemEnv.getHtmlLabelName(127906,languageid)%><%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%><a href="/weaverplugin/Ecologyplugin_tw.exe"><%}else{ %><a href="/weaverplugin/Ecologyplugin.exe"><%} %><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline"><%=SystemEnv.getHtmlLabelName(22012,languageid)%></font></a><%=SystemEnv.getHtmlLabelName(127907,languageid)%></span>
      </td></tr>
    </table>
    </td>
  </tr>
</table>

</form>
<%}}%>

<script type="text/javascript">
// added by wcd 2015-01-08 动态密码过期 start
var vNumber = Number("<%=validitySec%>");
function pJob(){
	if(document.all("errorMessage")){
		document.all("errorMessage").innerHTML = "<%=SystemEnv.getHtmlLabelName(20289,languageid)+SystemEnv.getHtmlLabelName(81913,languageid)%>"+(vNumber--)+"<%=SystemEnv.getHtmlLabelName(81914,languageid)%>";
		if(vNumber <= 0){
			document.all("message").value = "";
			document.all("errorMessage").innerHTML = "<%=SystemEnv.getHtmlLabelName(84255,languageid)%>";
			return;
		}
		setTimeout("pJob()",1000);
	}
}
// added by wcd 2015-01-08 动态密码过期 end
var userUsbType="0";
jQuery(document).ready(function(){
	var isIE = jQuery.client.browser=="Explorer"?"true":"false";
	$("#isie").val(isIE);
	//需要usb验证，且采用的是动态口令
	if("<%=needusb%>"=="1"){
	    //alert(jQuery("#loginid").length);
		jQuery("#loginid").bind("blur",function(){
		    var loginid=jQuery(this).val();
		    if(jQuery(this).val()!=""){ 
		        loginid=encodeURIComponent(loginid);
		        //根据填写的用户名检查是否启用动态口令 
			    jQuery.post("/login/LoginOperation.jsp?method=checkTokenKey",{"loginid":loginid},function(data){
			       userUsbType=jQuery.trim(data);
			      
			       if(userUsbType=="3"){
			    	  $("#tokenAuthKey").remove();
			          $("#trTokenAuthKey").show();
			          $("#trTokenAuthKey").html('<input type="text" id="tokenAuthKey"  name="tokenAuthKey" value="<%=SystemEnv.getHtmlLabelName(127901,languageid)%>" style="width:115px"/>')
			          jQuery("#tokenAuthKey").bind("focus",function(){
			              if(jQuery(this).val()=="<%=SystemEnv.getHtmlLabelName(84271,languageid)%>")
			                 jQuery(this).val("");
			          }).bind("blur",function(){
			              if(jQuery(this).val()=="")
			                 jQuery(this).val("<%=SystemEnv.getHtmlLabelName(84271,languageid)%>");
			          });
			       }else{
			          $("#trTokenAuthKey").hide();
			          $("#trTokenAuthKey").html("");
			       }        
			    });
		    }
			if(document.all("errorMessage")) document.all("errorMessage").innerHTML = "";
			var _message = document.all("message");
			if(_message && _message.value == "101"){
				_message.value = "";
			}
		});
	}else{
		jQuery("#loginid").bind("blur",function(){
			if(document.all("errorMessage")) document.all("errorMessage").innerHTML = "";
			var _message = document.all("message");
			if(_message && _message.value == "101"){
				_message.value = "";
			}
		});
	}
	if("<%=message0%>" == "101"){
		$("input[name='userpassword']").focus();
		pJob();
	}
	
	

	//add by wshen
	$("#isRememberUserName").click(function(){
		if($(this).attr('checked')){
			$(this).val("1");
		}else{
			$(this).val("0");
			$("#isRememberPwd").attr('checked',"");
			$("#isRememberPwd").val("0");
		}
	});
	//add by wshen
	$("#isRememberPwd").click(function(){
		if($(this).attr('checked')){
			$(this).val("1");
			$("#isRememberUserName").attr('checked',"checked");
			$("#isRememberUserName").val("1");
		}else{
			$(this).val("0");
		}
	});
})
</script>
</body>
<%
if(GCONST.getONDACTYLOGRAM())
{
%>
<object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
<%
}
%>
</html>
