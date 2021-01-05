
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.file.*,weaver.hrm.common.*" %>
<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<%@page import="java.util.List"%>
<%@page import="java.util.UUID"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.hrm.settings.ChgPasswdReminder"%>
<%@page import="weaver.hrm.settings.HrmSettingsComInfo"%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<%@page import="weaver.login.VerifyLogin"%>

<!DOCTYPE HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/js/jquery.fullscreenBackground.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>


<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">




<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<%String isMobileTest =Util.null2String(request.getParameter("isMobileTest"));
int languageid = Util.getIntValue(request.getParameter("languageid"),7);
weaver.hrm.HrmUserVarify.invalidateCookie(request,response);
String timeZone = (String)request.getSession().getAttribute("timeZone");
String weaver_login_type=Util.null2String(request.getSession(true).getAttribute("weaver_login_type"));
%>

<script type="text/javascript">
jQuery.ajax({
	url:"/dateformat/timezonelogin.jsp?timeZoneOffset="+new Date().getTimezoneOffset(),
	type:"get",
	dataType:"text",
	error:function(xhr,msg,e){
		if(window.console)console.log("wui/main.jsp#timezone.jsp error!");
	}
});
  //浏览器版本不支持跳转
  var isMobileTest="<%=isMobileTest%>";
  var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  var osVersion=$.client.version;                                //操作系统版本
  var browserOS=$.client.os;
  
  function accessFilter(){
     //禁止iphone、ipad、android访问
	  if(isMobileTest!="1"&&(browserOS=="iPhone/iPod"||browserOS=="iPad"||browserOS=="Android")){
	     window.location.href="/wui/common/page/sysRemind.jsp?labelid=2&browserOS="+browserOS;
	     return ;
	  }   
	  //禁止windows下safari访问   
	  if((browserName == "Safari"&&browserOS=="Windows")){   
	   //  window.location.href="/wui/common/page/sysRemind.jsp?labelid=3&browserOS="+browserOS+"&browserName="+browserName; 
	    // return ;
	  }   
	  if((browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5&&browserOS!="Windows")){
		    window.location.href="/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+$.client.browserVersion.version;
	        return ;
	  }
	  //禁止IE8以下浏览器访问，并提示安装IE8
	  if(browserName == "IE"&&browserVersion<8&&!document.documentMode){
	     window.location.href="/wui/common/page/sysRemind.jsp?labelid=4";
         return ;
     }
	  
  }
  
  accessFilter();
  
</script>
<%
String ldapmode = Util.null2String(Prop.getPropValue("weaver","authentic"));//是否配置LDAP集成

String isrsaopen = Util.null2String(Prop.getPropValue("openRSA","isrsaopen"));//是否开启RSA
int showQRCodeSec = Util.getIntValue(new BaseBean().getPropValue("Others" , "SHOWQRCODESEC"));
if(showQRCodeSec<=0)showQRCodeSec=30;//默认30秒

String dlflg = request.getParameter("dlflg");
if (dlflg != null && "true".equals(dlflg)) {
    String fontFileName = "USBkeyTool.rar";
    String fontFilePath = "wui/theme/ecology8/page/resources/";
    
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
    try {
    	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
		if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
			projectPath += "/";
		}
        String filepath = projectPath + fontFilePath + fontFileName;

        response.reset();
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.setHeader("Content-disposition", "attachment;filename=\"" + fontFileName + "\"");
        
        bis = new BufferedInputStream(new FileInputStream(filepath));
        bos = new BufferedOutputStream(response.getOutputStream());
        
        byte[] buff = new byte[2048];
        int bytesRead;
        while ((bytesRead = bis.read(buff, 0, buff.length)) != -1) {
            bos.write(buff, 0, bytesRead);
        }
        bos.flush();
        //out.clear();
        out = pageContext.pushBody();
    } catch(IOException e) {
        e.printStackTrace();
    } finally {
        if (bis != null) {
            try {
                bis.close();
                bis = null;
            } catch (IOException e) {
            }
        }
        
        if (bos != null) {
            try {
                bos.close();
                bos = null;
            } catch (IOException e) {
            }
        }
    }
    return;
}

String logintype = Util.null2String(request.getParameter("logintype")) ;
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
String backgroundUrl="";
String logo="";
String recordcode="";
int extendloginid=0;

String sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplate WHERE loginTemplateid=?";  

if(templateId.equals("")||templateId.equals("0")){
	sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplate WHERE isCurrent='1'";  
    rs.executeQuery(sqlLoginTemplate1);

}else{
    rs.executeQuery(sqlLoginTemplate1,templateId);

}

	
if(rs.next()){
    templateId=rs.getString("loginTemplateId");
    templateType = rs.getString("templateType");
    imageId = rs.getString("imageId");
    imageId2 = rs.getString("imageId2");
    loginTemplateTitle = rs.getString("loginTemplateTitle");
    backgroundColor = rs.getString("backgroundColor");
	recordcode =  rs.getString("recordcode");
    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
}


if(!"".equals(imageId))
	backgroundUrl=imageId;
else{
	backgroundUrl = "/wui/theme/ecology8/page/images/login/bg_wev8.jpg";
}
if(!"".equals(imageId2)){
	logo = imageId2;
}else{
	logo = "/wui/theme/ecology8/page/images/login/logo_wev8.png";
}
%>

<%
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

String qccode = UUID.randomUUID().toString();

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
            out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+SystemEnv.getHtmlLabelName(84244,languageid)+"<br/><span id=\"updateratespan\">"+MathUtil.div(currentFile*100,fileList,2)+"</span>%</div>');</script>");
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
        $.post("LoginOperation.jsp?method=add&cx="+cx,null,function(data){

        	var mins = data;
            var bx = mins.indexOf(",0,");
            if(bx == -1){
                bx = mins.indexOf(",");
                var dx = mins.lastIndexOf(",");
                $("#updateratespan").html(mins.substring(bx+1, dx));
                setTimeout("checkIsAlive()", 5000);
                ///document.all("updateratespan").innerHTML = mins.substring(bx+1, dx);
                ///setTimeout("checkIsAlive()", 5000);
            }else{
                //alert("cx = " + mins);
                self.location.reload();
            }

        })
        /*
        ajax.open("POST", "LoginOperation.jsp?method=add&cx="+cx, true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send();
        ajax.onreadystatechange = function(){
            if (ajax.readyState == 4) {
                if(ajax.status == 200){
                    //k("isAlive = " + ajax.responseText);
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
        }*/
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
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+SystemEnv.getHtmlLabelName(84245,languageid)+suc.getUpgreadLogPath()+SystemEnv.getHtmlLabelName(84247,languageid)+"</div>');</script>");
    return;
}
//升级过程中异常中止
if (upgreadeStatus==2) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+SystemEnv.getHtmlLabelName(84250,languageid)+"</div>');</script>");
    return;
}
//升级程序执行异常
if (upgreadeStatus==3) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>"+SystemEnv.getHtmlLabelName(84252,languageid)+"</div>');</script>");
    return;
}

//String templateId="",templateType="",imageId="",loginTemplateTitle="";
//int extendloginid=0;



//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
// add by dongping for TD1340 in 2004.11.05
// add a cookie in our system
Cookie ckTest = new Cookie("testBanCookie","test");
ckTest.setMaxAge(-1);
ckTest.setPath("/");
response.addCookie(ckTest);

//xiaofeng, usb硬件加密 


ChgPasswdReminder reminder = new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
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
String disLoginId = loginid;
String message0 = Util.null2String(request.getParameter("message")) ;

int focusflg = 0;
String usbMsgparam = Util.null2String(request.getParameter("usbparammsg")) ;


//处理发过动态密码后   刷新页面 不重新发送的问题  20931
if((message0.equals("57") || message0.equals("101")) && loginid.equals("")){
     loginid = "";
     message0 = "";
     }
String message=message0;
if(message0.equals("nomatch")) message = "";
int _messageIV = Util.getIntValue(message0);
boolean transMSG = _messageIV == 16 || _messageIV == 17;
if(!message.equals("")) message = transMSG ? SystemEnv.getHtmlLabelName(124919, languageid) : SystemEnv.getErrorMsgName(_messageIV,languageid) ;

if("16".equals(message0)){
	String isADAccount = "";
	rs.executeQuery("select isADAccount from hrmresource where loginid=?",loginid);
	if(rs.next()) {
		isADAccount = rs.getString("isADAccount");
	}
    if("1".equals(OpenPasswordLock)){
    	if(ldapmode == null || ldapmode.equals("") || ("ldap".equals(ldapmode) && !"1".equals(isADAccount))) {
	        loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
	  			rs.executeQuery("select id from HrmResourceManager where loginid=?",loginid);
	  			if(!rs.next()){
		        String sql = "select sumpasswordwrong from hrmresource where loginid=?";
		        rs1.executeQuery(sql,loginid);
		        rs1.next();
		        int sumpasswordwrong = Util.getIntValue(rs1.getString(1));
		        int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
		        int leftChance = sumPasswordLock-sumpasswordwrong;
		        if(leftChance==0){
		            sql = "update HrmResource set passwordlock=1,sumpasswordwrong=0 where loginid=?";
		            rs1.executeUpdate(sql,loginid);
		            message0 = "110";
		        }else{
		            message = SystemEnv.getHtmlLabelName(24466,languageid)+leftChance+SystemEnv.getHtmlLabelName(24467,languageid);
		        }
	  			}
	    }
    }
    focusflg = 1; 
}
session.removeAttribute("tmploginid1");
if(message0.equals("16")) {
    loginid = "";
	 disLoginId = "";
} 
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,languageid)+SystemEnv.getHtmlLabelName(81913,languageid)+validitySec+SystemEnv.getHtmlLabelName(81914,languageid);
    focusflg = 2;
} else if(message0.equals("730")){
	message = SystemEnv.getHtmlLabelName(84255,languageid);
	message0 = "";
} else if(message0.equals("556")){
	message = "短信发送失败,请查看短信模板配置";
	message0 = "";
}
if(message0.equals("110")) 
{
    loginid = "";
    int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,languageid)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,languageid)+"，"+SystemEnv.getHtmlLabelName(24594,languageid);
    focusflg = 1;
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}

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
//CA
if("-21".equals(message0)){
	message = "UKEY"+ SystemEnv.getHtmlLabelName(127353,languageid);
}
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();//0: 否,1: 是
int validatetype=settings.getValidatetype();//验证码类型，0：数字；1：字母；2：汉字
int islanguid = 7;//7: 中文,9: 繁体中文,8:英文
Cookie[] systemlanid= request.getCookies();
for(int i=0; (systemlanid!=null && i<systemlanid.length); i++){
    //System.out.println("ck:"+systemlanid[i].getName()+":"+systemlanid[i].getValue());
    if(systemlanid[i].getName().equals("languageidweaver")){
        islanguid = Util.getIntValue(systemlanid[i].getValue(), 0);
        break;
    }
}
if(islanguid == 7){
	islanguid = languageid;
}
boolean ismuitlaguage = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
    VerifyLogin.checkLicenseInfo();
    multilanguage = (String)staticobj.getObject("multilanguage") ;
}
//if("y".equals(multilanguage)){
//ismuitlaguage = true;
//}

int enLanguage = GCONST.getENLANGUAGE();
int twLanguage = GCONST.getZHTWLANGUAGE();
if(enLanguage==0 && twLanguage==0) {
ismuitlaguage = false;
} else {
ismuitlaguage = true;
}

ismuitlaguage = LanguageComInfo.isMultiLang() ;

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

<script language="javascript">
function addCssByStyle(cssString){
	var doc=document;
	var style=doc.createElement("style");
	style.setAttribute("type", "text/css");

	if(style.styleSheet){// IE
		style.styleSheet.cssText = cssString;
	} else {// w3c
		var cssText = doc.createTextNode(cssString);
		style.appendChild(cssText);
	}

	var heads = doc.getElementsByTagName("head");
	if(heads.length) {
		heads[0].appendChild(style);
	} else {
		doc.documentElement.appendChild(style);
	}
}

//alert( window.navigator.userAgent+"%%%"+jQuery.client.version +"%%%"+jQuery.client.browser+"%%%"+$.client.os+"&&&&&"+jQuery.client.getOsVersion())
var osV = jQuery.client.version; 
var isIE = jQuery.client.browser=="Explorer"?"true":"false";

if (osV < 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont_wev8.css";
	addCssByStyle("input { Line-height:100%!important;}");
}
</script> 
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 End -->

<!--[if IE 6]>
	<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min_wev8.js'></script>
<![endif]-->

<!--超时跳转,跳出iframe黄宝2011/5/25-->
<script type="text/javascript">
  if(top.location != self.location) top.location=self.location;
</script> 
<%
if("1".equals(isrsaopen)){
 %>
<script  type="text/javascript" src="/js/rsa/jsencrypt.js"></script>
<script  type="text/javascript" src="/js/rsa/rsa.js"></script>
<%} %>
<SCRIPT language=javascript1.1>
//<!--
function checkall()
{ 
<%
if("1".equals(isrsaopen)){
%>
  	 __RSAEcrypt__. rsa_encrypt(checkall_1);
<%}else{
%>
	checkall_1();
<% }%>
}

function enterCheck(){
  if(window.event.keyCode == 13) {
  	checkall();
  	if(window.event && window.event.preventDefault){
		window.event.preventDefault();
	}else{
		window.event.returnValue = false;//注意加window
	}
   }
}
function checkall_1()
{ 
    var dactylogram = "";
    if(document.all("dactylogram")) dactylogram = document.all("dactylogram").value;
    if(dactylogram == ""){
    var i=0;
    var j=0;
    var errMessage="";
    var languageid =jQuery("#islanguid").val();
if (form1.loginid.value=="") {
	errMessage=errMessage+languageMap[16647]+"\n";
	i=i+1;
}
if (form1.userpassword.value=="") {
	errMessage=errMessage+languageMap[16648]+"\n";
	j=j+1;
}
if (i>0){
     //window.top.Dialog.alert(errMessage);form1.loginid.focus(); return false ;
     //showmsg(errMessage);
     showmsg(errMessage);
     return false ;
}else if(j>0){
    //window.top.Dialog.alert(errMessage);form1.userpassword.focus(); return false ;
     showmsg(errMessage);
     return false ;
}

<%if(needusb!=null&&needusb.equals("1")){%>
if(userUsbType=="1"){
   if(!checkusb1()){
     return false ;
   }
}else if(userUsbType=="2"){
   if(!checkusb2()){
     return false ;
   }
}else if(userUsbType=="3"){
   if(!checkusb3()){
     return false ;
   }
}
<%}%>
//  else { form1.submit() ; }

}

<%
if("1".equals(isrsaopen)){
%>
var pwd = jQuery("input[name='userpassword']");
pwd.val(__RSAEcrypt__.rsa_data_encrypt(pwd.val()));
<%}%>

$(document.form1).submit() ;
}


function showmsg(mess,func) {
		var diag = new window.top.Dialog({
	        Width: 300,
	        Height: 80,
	        normalDialog:false,
	        Modal:true
	    });
		diag.Title = languageMap[15172];
	    diag.CancelEvent = function () {
	        diag.close();
        	if (func) func();
	    };
	    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
			<tr><td align="right"><img id="Icon_" src="' + IMAGESPATH + 'icon_alert_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
				<td align="left" id="Message_" style="font-size:9pt">' + mess + '</td></tr>\
		</table>';
		diag.ShowButtonRow=true;
		diag.normalDialog= false;
		diag.show();
   	 	diag.getDialogDiv().style.zIndex = 99999;
    	jQuery(diag.getContainer()).css("overflow-y","auto");
	    diag.okButton.style.display = "none";
	    diag.e8SepLine.style.display = "none";
	    diag.cancelButton.value = languageMap[826];
	    diag.cancelButton.focus();
}


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
            document.all("dactylogramLoginImgId").src="//wui/theme/ecology8/page/images/loginmode/3_wev8.gif";
            if(intervalID2!=0) window.clearInterval(intervalID2);
            intervalID2=setTimeout("init()", 100);
        }else{
            if("<%=message0%>"=="nomatch") document.all("dactylogramLoginImgId").src="//wui/theme/ecology8/page/images/loginmode/2_wev8.gif";
            else document.all("dactylogramLoginImgId").src="//wui/theme/ecology8/page/images/loginmode/1_wev8.gif";
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
    window.top.Dialog.alert(methodtype);
    document.getElementById("loginid").disabled = true;
}

//add by sean.yang 2006-02-09 for TD3609
function changeMsg(msg, ele)
{
	var languageid = document.getElementById("islanguid").value;
    if(msg==0){
    	<%if(ismuitlaguage){%>
		$("#validatecodeDiv").css("left", ($(ele).offset().left + $(ele).width() + 10) + "px");
		$("#validatecodeDiv").css("top", $(ele).offset().top + "px");
		$("#validatecodeDiv").show();
		<%}%>
        if(document.getElementById("validatecode").value==languageMap[84270]) { 
            document.all.validatecode.value='';
        }
    }else if(msg==1){
    	<%if(ismuitlaguage){%>
    	$("#validatecodeDiv").hide();
    	<%}%>
        if(document.getElementById("validatecode").value=='') { 
			document.getElementById("validatecode").value=languageMap[84270];
        }
    }
}
// added by wcd 2014-12-19
var pswdDialog;
var common = new MFCommon();
common.initDialog({width:600,height:400,showMax:false,checkDataChange:false});
function forgotPassword(){
	var languageid = document.getElementById("islanguid").value;
	var thisTitle = languageMap[127899];
	pswdDialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=forgotPassword&languageid="+languageid,thisTitle);
}
		
function resetPassword(loginid){
	if(pswdDialog) pswdDialog.close();
	pswdDialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=resetPassword&loginid="+loginid,languageMap[31479]);
}
// -->
</SCRIPT>


<script language="JavaScript">
function click(e) {
	if($.browser.msie){
		if (event.button == 2 || event.button == 3){
			alert(languageMap[16641])
			return false;
		}
	}else{
		if (e.which == 2 || e.which == 3){
			alert(languageMap[16641])
			return false;
		}
	} 
   
}
document.onmousedown=click
</script>
<%if(needusb!=null&&needusb.equals("1")){%>
    <script language="JavaScript">
        function checkusb1(){ 
          //验证威步key
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
              return  false;    
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
              return  false;    
            }   
				return true;     
         }
         </script>
         <script language="JavaScript">
             function checkusb3(){
             var languageid = document.getElementById("islanguid").value; 
               //需要输入动态口令
			   if(jQuery("#tokenAuthKey").val()==""||jQuery("#tokenAuthKey").val()==languageMap[127901]){
     					showmsg(languageMap[127901]);
			        jQuery("#tokenAuthKey").focus();
			        return false;
			   }else if(!isdigit(jQuery("#tokenAuthKey").val())){
     					showmsg(languageMap[127902]);
					jQuery("#tokenAuthKey").focus();
					return false;
			   }else if(jQuery("#tokenAuthKey").val().length!=6){
     					showmsg(languageMap[127903]);
					jQuery("#tokenAuthKey").focus();
					return false; 
			   }
				return true;
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
                //验证海泰key
				var showError = languageMap[132147]+'<a href="/wui/theme/ecology8/page/login.jsp?dlflg=true" target="_blank"><%=SystemEnv.getHtmlLabelName(84260,languageid)%></a><%=SystemEnv.getHtmlLabelName(84262,languageid)%>';
                try{
                    rnd = Math.round(Math.random()*1000000000);
                    //alert(rnd);
                    form1.rnd.value=rnd;
                    var returnstr = getUserPIN();
                    if(returnstr != undefined && returnstr != ""){
                        form1.username.value= returnstr;
                        var randomKey = getRandomKey(rnd)
						if(randomKey != undefined && randomKey != ""){
							form1.serial.value= randomKey;
						}else{
							form1.serial.value= '0';
							showmsg(showError);
							return false;
						}
                        //alert(randomKey);
                    }else{
                        form1.serial.value= '0';
						showmsg(showError);
						return false;
                    }
                }catch(err){
                    form1.serial.value= '0';
                    form1.username.value= '';
					showmsg(showError);
						return false;
                }
				return true;
            }
        </script>
        <OBJECT id="htactx" name="htactx" 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px;display:none"></OBJECT>
        <script language="javascript">
	function getUserPIN(){
	  try{
	  	var vbsserial="";
	  	var hCard = htactx.OpenDevice(1);//打开设备
	  	if(hCard==0){
	  		//showmsg(languageMap[132147])
	  		return vbsserial;
	  	}
	  	
	  	try{
		  	vbsserial = htactx.GetUserName(hCard)//获取用户名
		  	htactx.CloseDevice(hCard)
		  	return vbsserial;
		  }catch(e){
		  	//showmsg(languageMap[132147]+"2");
		  	htactx.CloseDevice(hCard);
		  	return vbsserial;
		  }
	  }catch(e){
	  	//showmsg(languageMap[132147]);
	  	htactx.CloseDevice(hCard);
	  	return vbsserial;
	  }
	}
	
	function getRandomKey(randnum){
		try{
			var hCard = htactx.OpenDevice(1);//打开设备
			if(hCard == 0 ){
				//showmsg(languageMap[132147]+"4");
				return "";
			}
			try{
				var Digest = htactx.HTSHA1(randnum, (""+randnum).length);
				Digest = Digest+"04040404" //对SHA1数据进行补码
				htactx.VerifyUserPin(hCard, (""+form1.userpassword.value)) //校验口令
		   	var EnData = htactx.HTCrypt(hCard, 0, 0, Digest, Digest.length)//DES3加密SHA1后的数据
		   	htactx.CloseDevice(hCard);
		   	return EnData;
		  }catch(e){
		  	htactx.CloseDevice(hCard);
		  	return "";
		  }
		}catch(e){
			//showmsg(languageMap[132147]+"4");
			return "";
		}
	}
        </script>
 <%}%>
</script>



<script type="text/javascript">
$(document).ready(function() {
    $(function() {
        
        if($("#syslangul").length>0&&$("#syslangul").find("li").length==1){
        	$("#langDiv").hide();
        	$("#qrcodeDiv").removeClass("left").addClass("right").addClass("m-r-20")
        }
        
		//alert($("label.overlabel").length)
		$("label.overlabel").overlabel();

       	var iconImg="/wui/theme/ecology8/page/wui/theme/ecology8/page/images/login/s_wev8.png"
        var iconImg_over="/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/s2_wev8.png"
    
       
        
        $("#login").bind("mouseover", function() {
            $(this).removeClass("lgsm");
            $(this).addClass("lgsmMouseOver");
        });
        $("#login").bind("mouseout", function() {
            $(this).removeClass("lgsmMouseOver");
            $(this).addClass("lgsm");
        });
        
        $(".crossNav a").hover(function() {
            $(this).css("background-position", "0 -29px");
        }, function() {
            $(this).css("background-position", "0 0px");
        });
        
        //检测微软雅黑字体在客户端是否安装
        //fontDetection("sfclsid", $("input[name='fontName']").val());
        //检测用户当前浏览器及其版本
        ieVersionDetection();
        setRandomBg();
    });
    //焦点设置
    //$("input[name='loginid']").focus();
    //----------------------------------
    // form表单提交时check
    //----------------------------------
    
});


function setRandomBg() {
    var imgArray=new Array();
    var imgPath="";
    <%
    List imageId2List=Util.TokenizerString(imageId2,",");
    for(int i=0;i<imageId2List.size();i++){
    	String imgId2Temp=(String)imageId2List.get(i);
    %>
    imgArray[<%=i%>]="<%=imgId2Temp%>";	 
    <%}%>
    var discnt = <%=imageId2List.size()%>;
    
    if(discnt==0){ //系统默认图片
       imgArray=new Array("bg2_wev8.png","bg3_wev8.png");
       discnt=2;
       imgPath="/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/"
    }else          //用户自定义图片
       imgPath="/LoginTemplateFile/";
        
    var i = Math.floor(Math.random()*discnt);
    var j = Math.floor(Math.random()*discnt);
    var k = Math.floor(Math.random()*discnt);
    
    var img1="",img2="",img3="";
    if(discnt>3){
	    while (i >= discnt ) {
	        i = Math.floor(Math.random()*discnt);
	    }
	    while (j >= discnt || j == i) {
	        j = Math.floor(Math.random()*discnt);
	    }
	    while (k >= discnt || k == i || k == j) {
	        k = Math.floor(Math.random()*discnt);
	    }
	    img1=imgArray[i];
        img2=imgArray[j];
        img3=imgArray[k];
    }else if(discnt==3){
        img1=imgArray[0];
        img2=imgArray[1];
        img3=imgArray[2];
    }else if(discnt==2){
        img1=imgArray[0];
        img2=imgArray[1];
    }else if(discnt==1){
        img1=imgArray[0];
    }
    
    if(discnt>=3){
	    $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat center");
	    $("#disimg2").css("background", "url(" +imgPath+img3+ ") no-repeat center");
    }else if(discnt==2){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat center");
    }else if(discnt==1){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
    }
}

function ieVersionDetection() {
    if(navigator.userAgent.indexOf("MSIE")>0){ //是否是IE浏览器 
        if(navigator.userAgent.indexOf("MSIE 6.0") > 0){ //6.0
            $("#ieverTips").show();
            return;
        } 
    }
    $("#ieverTips").hide();
}

function fontDetection(objectId, fontName) {
    //加载系统字体
    getSFOfStr(objectId);

    if(!isExistOTF(fontName)) {
        $("#fontTips").show();
    } else {
        $("#fontTips").hide();
    }
}

//---------------------------------------------
// System font detection.  START
//---------------------------------------------
/**
 * detection system font exists.
 * @param fontName font name
 * @return true  :Exist.
 *         false :Does not Exist
 */
function isExistOTF(fontName) {
    if (fontName == undefined 
            || fontName == null 
            || fontName.trim() == '') {
        return false;
    }
    
    if (sysfonts.indexOf(";" + fontName + ";") != -1) {
        return true;
    }
    return false;
};

/**
 * getting to the system font string.
 * @param objectId object's id
 * @return system font string.
 */
function getSFOfStr(objectId) {
    var sysFontsArray = new Array();
    sysFontsArray = getSystemFonts(objectId);
    for(var i=0; i<sysFontsArray.length; i++) {
        sysfonts += sysFontsArray[i];
        sysfonts += ';'
    }
}
//-------------------------------------------
// Save the system font string, 
// used for multiple testing.
//-------------------------------------------
var sysfonts = ';';

/**
 * getting to the system font list
 *
 * @param objectId The id of components of the system font.
 * @return fonts list
 */
function getSystemFonts(objectId) {
    var a = document.all(objectId).fonts.count;
    var fArray = new Array();
    for (var i = 1; i <= document.all(objectId).fonts.count; i++) {
        fArray[i] = document.all(objectId).fonts(i)
    }
    return fArray
}

/**
 * Returns a string, with leading and trailing whitespace
 * omitted.
 * @return  A this string with leading and trailing white
 *          space removed, or this string if it has no leading or
 *          trailing white space.
 */
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//---------------------------------------------
// System font detection.  END
//---------------------------------------------
</script>

<STYLE TYPE="text/css">
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:12px;
}


body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:11px;
    /*font-family:"微软雅黑","宋体"!important;*/ 
}

.loginContainer{
	width:300px;
	height:330px;
	background:url(/wui/theme/ecology8/page/images/login/login-bg_wev8.png);
}

.loginTitle{
	color:#828282;
	font-weight:500px;
	font-size:18px;
	padding-top:10px;
	padding-bottom:20px;
}

/*For slide*/
.slideDivContinar { height: 436px; width: 100%; padding:0; margin:0; overflow: hidden }
.slideDiv {height:436px; width: 100%;top:0; left:0;margin:0;padding:0;}


/*For Input*/
.inputforloginbg{ width:172px;height:21px;border:none;}
.inputforloginbg input{border:none;height:15px;background:none;}

.lgsm {width:124px;height:36px;background:url(/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}
.lgsmMouseOver {width:124px;height:36px;background:url(/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}

.crossNav{width:100%;height:30px;position:absolute;margin-top:105px;padding-left:30px;padding-right:30px;}



  .input_out{
	height:36px;
	width:248px;
	line-height:36px;
  }

  .input_inner{
	height:36px;
	width:248px;
	line-height:36px;
	margin-top:1px;
	font-size:14px;
	
  }
  
</STYLE>

</head>
<body style="padding:0;margin:0;margin:0;padding:0;" scroll="no">

<!--style="background:url('<%=backgroundUrl %>') center bottom;"-->
<div class="w-all h-all center" style="background:url('<%=backgroundUrl %>') center bottom;background-size: 100% 100%">
	<div class="h-150">&nbsp;</div>
	<div class=" center " style="width: 600px">
		<div>
			<img class=" " style="max-width:400px;max-height:150px;border:0;margin:0" src="<%=logo %>"/>
		</div>
		<div style="height:35px">&nbsp;</div>
		<form id="form1" name="form1" action="/login/VerifyLogin.jsp" method="post"  onkeydown="enterCheck()"  >
                <INPUT type="hidden" value="/wui/theme/ecology8/page/login.jsp?templateId=<%=templateId %>&logintype=<%=logintype%>&gopage=<%=gopage%>" name="loginfile">
                <INPUT type="hidden" name="logintype" value="<%=logintype %>">
                <input type="hidden" name="fontName" value="<%=SystemEnv.getHtmlLabelName(84210,7)%>">
                <input type=hidden name="message" value="<%=message0 %>">
                <input type=hidden name="gopage" value="<%=gopage%>">

			    <input type=hidden name="formmethod" value="<%=formmethod%>">
			    <INPUT type=hidden name="rnd" >
                <INPUT type=hidden name="serial"> 
                <INPUT type=hidden name="username">
                <input type="hidden" name="isie" id="isie">
		<div class="h-15 w-300 center">
			<div class="p-l-30 font14 colorfff left w-140" id="messageDivOld" style="text-align: left;">
			&nbsp;
			</div>
			<%if(ismuitlaguage){%>
				<div class="left w-30" id="qrcodeDiv" style="display: <%=logintype.equals("2")?"none":"" %>"><img id="qrcode" class="hand"  src="/wui/theme/ecology8/page/images/login/qrcode_wev8.png"></div>
				<div class="last p-r-15  "  style="" id="langDiv">
					<span class="hand w-80 " id="selectLan" style="text-align:left; color:#D5E7E4;height: 20px;line-height: 20px;"><span class="text" style="padding-left:10px;"><%
						if(islanguid==0){
							out.println(LanguageComInfo.getLanguagename("7"));
						}else{
							out.println(LanguageComInfo.getLanguagename(islanguid+""));
							}
					%></span><span class="right">▼</span></span>
					
					<input id="islanguid" name="islanguid" type="hidden" value="<%=islanguid %>">
					<ul class="absolute hide" id="syslangul">
							<%=LanguageComInfo.getLiLan(islanguid) %> 
					</ul>
				</div>
			
			<%}else{ %>
				<div class="last  w-20 p-r-30" id="qrcodeDiv" style="display: <%=logintype.equals("2")?"none":"" %>"><img id="qrcode" class="hand"  src="/wui/theme/ecology8/page/images/login/qrcode_wev8.png"></div>
				
				<input id="islanguid" name="islanguid" type="hidden" value="7">
			<%} %>
			
		
			<div class="clear" style="height: 0px;">&nbsp;</div>
			
		</div>
		
                
		<div id="normalLogin" class="p-l-5">
			<table width="600px;" style="position: absolute;">
				
				<tr>
					<td class="center" style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;background-repeat: no-repeat;background-position: center center;">
					<div class="relative center" style="height:45px;width:280px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/username_wev8.png">	
					   <label for="loginid" class="overlabel" id="for_loginid"><%=SystemEnv.getHtmlLabelName(2024,languageid)%></label>
					   <input class="input" name="loginid" id="loginid" value="<%=disLoginId %>" style="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-10 ">
					<div class="font12  colorfff left center absolute " style="width:580px;line-height: 0px" id="messageDiv" ><nobr>
			&nbsp;
				<%
                 if(message0.equals("45")){
				%>
					<%=SystemEnv.getHtmlLabelName(84259,languageid)%><a href="/wui/theme/ecology8/page/login.jsp?dlflg=true" target="_blank"><%=SystemEnv.getHtmlLabelName(84260,languageid)%></a><%=SystemEnv.getHtmlLabelName(84262,languageid)%>
				<%} else if(message0.equals("16") && usbMsgparam.equals("1")){
					focusflg = 1;
				%>
					<%=SystemEnv.getHtmlLabelName(84264,languageid)%><a href="/wui/theme/ecology8/page/login.jsp?dlflg=true" target="_blank"><%=SystemEnv.getHtmlLabelName(84260,languageid)%></a><%=SystemEnv.getHtmlLabelName(84266,languageid)%>
				<%} else if(message0.equals("122")){ //
					focusflg = 1;
				%>
				    <%=SystemEnv.getHtmlLabelName(84268,languageid)%>&nbsp;<a href='/login/syncTokenKey.jsp?languageid=<%=languageid %>'><%=SystemEnv.getHtmlLabelName(84269,languageid)%></a> 
				<%}else {
				
				%>
					<span name="errorMessage" id="errorMessage"><%=message %></span>
				<%} %>
				<nobr/>
			</div>
					</td>
				</tr>
				<tr>
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;background-repeat: no-repeat;background-position: center center;">
					<div class="relative center" style="height:45px;width:280px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	
					   <label for="userpassword" class="overlabel" id="for_userpassword"><%=SystemEnv.getHtmlLabelName(409,languageid)%></label>
					   <input class="input" style=""  name="userpassword" id="userpassword" type="password" autocomplete="off">
					 </div>
					</td>
				</tr>
				
				<tr id="ca_pin_tr_height" style="display:none;"><td class="h-10"></td></tr>
				<tr id="ca_pin_tr" style="display:none;">
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;background-repeat: no-repeat;background-position: center center;">
						<div class="relative center" style="height:45px;width:280px;">
					   		<img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	
					   		<label for="caPin" class="overlabel" id="for_caPin"><%=SystemEnv.getHtmlLabelName(83869,languageid)+"UKEY"%></label>
					   		<input class="input" style="" type="password" id="caPin" type="text">
					   		<input type="hidden" id="ca_msg" value='<%="error:UKEY"+SystemEnv.getHtmlLabelName(127353,languageid) %>' />
					 	</div>
					</td>
				</tr>
				
				<tr>
					<td class="h-10"></td>
				</tr>
				<!-- 验证码 -->
				<tr<%if(needvalidate!=1){ %>display:none<%} %>'>
					<%if(needvalidate==1){%>
					<td style="">
						<div style="width:280px;" class="center">
							<div class="relative left " style="width:135px;height:38px;margin-left: 10px;background: url('/wui/theme/ecology8/page/images/login/input_1_wev8.png') no-repeat;background-repeat: no-repeat;background-position: center center;">
							<label for="validatecode" style="left:20px!important;line-height:38px!important;" class="overlabel" id="for_validatecode"><%=SystemEnv.getHtmlLabelName(84270,languageid)%></label>
							<input type="text" id="validatecode" name="validatecode" class="input1"  style=";width:135px;height:38px;">	
							
							</div>
							<div class="right" style="margin-right:10px;">
						  	<a href="javascript:changeCode()"><img border=0 id='imgCode' align='absmiddle' style="width:112px;height:38px;" src='/weaver/weaver.file.MakeValidateCode' ></a>
						  	<script>
						  	  var seriesnum_=0;
						  	 function changeCode(){
						  	 	seriesnum_++;
						  		setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum_)',50); 
						  	 }
						  	</script>
							</div>
							<div class="clear"></div>
						</div>
					</td>
					<%}%>											
				</tr>	
				<tr style='height:26px;display:none' id="trTokenAuthKey">
					<td id="tdTokenAuthKey" style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;background-repeat: no-repeat;background-position: center center;">
						<div class="relative center" style="height:45px;width:280px;">
						   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	
						   <label for="tokenAuthKey" id="for_tokenAuthKey"   class="overlabel"><%=SystemEnv.getHtmlLabelName(84271,languageid)%></label>
						   <input type="text" id="tokenAuthKey" name="tokenAuthKey"   class="input">
						 </div>
					</td>
				</tr>
				<tr style="display:none">
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;">
					<div class="relative center" style="height:45px;width:280px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	<input class="input" style=""  name="" id="" type="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-50 relative right" style="height:30px;width:280px;">
						<label class="overlabel" style="cursor:pointer;" onclick="forgotPassword()" id="forgotpassword"><%=SystemEnv.getHtmlLabelName(81614,languageid)%></label>
					</td>
				</tr>
				<tr style="">
					<td >
						<input type="button" name="login" id="login" onclick="checkall()" value="<%=SystemEnv.getHtmlLabelName(674,languageid)%>" class="hand" tabindex="3" style="background: url('/wui/theme/ecology8/page/images/login/btn_login_wev8.png');height:45px;width:280px;border:0px;font-size: 14px;color: #578197;letter-spacing:2px;font-family:Arial,Helvetica,sans-serif,SimSun;">
					</td>
				</tr>
			</table>
			
		</div>
		
		<div id="qrcodeLogin" class="hide">
			<div class="h-10">&nbsp;</div>
			<div class="center" >
				<div id="qrcodeImg" class="center relative"  style="padding-top:20px;padding-left:20px;width:145px;height:145px;background: url(/wui/theme/ecology8/page/images/login/qrcodebg_wev8.png);background-position: center center;background-repeat: no-repeat"></div>
			</div>
			<div class="h-10">&nbsp;</div>
			<div style="color:#D5E7E4">
				<label id="qrcodePrompt">
				<%=SystemEnv.getHtmlLabelName(84272,languageid)%>
				</label>
			</div>
			<div class="h-10">&nbsp;</div>
            <div>
                <input type="button" name="backbtn" id="backbtn" value="<%=SystemEnv.getHtmlLabelName(131938,languageid)%>" class="hand"  style="background: url('/wui/theme/ecology8/page/images/login/iconnormal.png');color:white;padding-left:20px;height:36px;font-size:14px;width:145px;border:0px;">
            </div>
		</div>
	   </form>
	</div>
	<div class="e8login-recordcode">
		<style type="text/css">
			.e8login-recordcode {
				height:60px;
				position:absolute;
				bottom:0;
				width:100%;
				left:0;
				text-align:center;
				line-height: 60px;
			}
			.e8login-recordcode-view {
				height: 40px;
				min-width: 600px;
				text-align: center;
				line-height: 40px;
				color: #FFFFFF;
				display: inline-block;
				vertical-align: middle;
			}
            .e8login-recordcode-view a{
                color: #d5e7e4;
            }
			.e8login-recordcode-view>p {
				margin: 0px;
			}
		</style>
		<div class="e8login-recordcode-view"><%=recordcode%></div>
	</div>
</div>

<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px;"><OBJECT ID="sfclsid" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>

<style type="text/css">
	html,body{
		height:100%;
	}
	.input{
		left:50px;
		top:10px;
		height:25px;
		width:210px;
		background:transparent!important;
		color:#ffffff!important;
		border:0px;
		position:absolute;
		font-size: 15px;
		outline:none;
	}
	
	
	
	
	.input1{
		left:30px;
		height:25px;
		width:210px;
		background:transparent!important;
		color:#ffffff!important;
		border:0px;
		position:absolute;
		font-size: 15px;
		outline:none;
	}
	.langOver{
		color:#797E81!important;
	}
	

	.overlabel{
		position:absolute;
		z-index:1;
		font-size:14px;
		left:50px;
		font-size:14px;
		color:#D5E7E4!important;
		line-height: 40px!important;
		
	}
	#qrcodeImg table{
		position:absolute;
		top:10px;
		left: 10px;
	}
	#syslangul{
		width:80px;
		list-style: none;
		
		background: #f3fbf9;
		z-index: 1000;
		margin: 0px;
		padding: 0px;
		top:20px;
	}
	#syslangul li{
		text-align: left;
		height:20px;
		line-height:20px;
		cursor:pointer;
		color:#646767;
		padding-left: 9px;
		
	}
	
	#syslangul .selected{
		color:#ffffff!important;
		background: #4695c4!important;
	}
	
	.selectLanOver{
		background: #ecf4f7;
		color:#646767!important;

		
	}

    #background-image img{
        height:100% !important;
        width:100% !important;
    }

</style>
<script type="text/javascript">

var qrCodeGetCount = 0 ;
jQuery(document).ready(function () {
	var fflg = <%=focusflg %>;
	$("label.overlabel").overlabel();
    if(navigator.userAgent.toUpperCase().indexOf("MSIE 8.0")>0){
        $(".w-all").css("background","");
        $(".w-all").css("background-size","");
        $("#background-image").show();
        $("#background-image").fullscreenBackground();
    }else{
        $("#background-image").hide();
    }
	if (fflg == 0) {
    	$("input[name='loginid']").focus();
    	$(".overlabel[for='loginid']").css( { 'text-indent': '-10000px' });
    	$("input[name='loginid']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png') center center no-repeat")
	} else if (fflg == 1) {
    	$("input[name='userpassword']").focus();
    	$(".overlabel[for='userpassword']").css( { 'text-indent': '-10000px' });
    	$("input[name='userpassword']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png') center center no-repeat")
	} else if (fflg == 2) {
    	$("input[name='tokenAuthKey']").focus();
    	$(".overlabel[for='tokenAuthKey']").css( { 'text-indent': '-10000px' });
    	$("input[name='tokenAuthKey']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png') center center no-repeat")
	}
	
	
	
	jQuery(".input").bind("blur",function(){
    	$(this).parents("td").css("background","url('/wui/theme/ecology8/page/images/login/input_wev8.png') center center no-repeat")
    })
    jQuery(".input").bind("focus",function(){
    	$(this).parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png') center center no-repeat")
    })
    
    jQuery("#qrcode").hover(
    	function(){
    		$(this).attr("src","/wui/theme/ecology8/page/images/login/qrcodeOver_wev8.png")
    	},
    	function(){
    		$(this).attr("src","/wui/theme/ecology8/page/images/login/qrcode_wev8.png")
    	});
    	
    jQuery("#login").hover(
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/btnLoginOver_wev8.png)")
    	},
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/btn_login_wev8.png)")
    	});
    jQuery("#backbtn").hover(
        function(){
            $(this).css("background","url(/wui/theme/ecology8/page/images/login/iconhot.png)")
        },
        function(){
            $(this).css("background","url(/wui/theme/ecology8/page/images/login/iconnormal.png)")
        });
    jQuery("#qrcode").bind("click",function(){
    	$("#normalLogin").hide();
    	$("#messageDivOld").hide();
    	$("#qrcodeDiv").hide();
    	$("#langDiv").removeClass("last").removeClass("p-r-30")
    	$("#qrcodeLogin").show();
    	qrCodeGetCount = 0 ;
    });
    
    jQuery("#backbtn").bind("click",function(){
    	$("#normalLogin").show();
    	$("#messageDivOld").show();
    	$("#qrcodeDiv").show();
    	$("#langDiv").addClass("last").addClass("p-r-15")
    	$("#qrcodeLogin").hide();
    })
    
    $('#qrcodeImg').qrcode({
			render	: "div",
			text	: "ecologylogin:<%=qccode%>,actionName:QR_LOGIN,randomNumber:<%=qccode%>,bizSN:<%=qccode%>",
			size:125,
            background : "none",
            fill : "#424345"
		});
	loginInterval = window.setInterval(function () {
			getloginstatus("<%=qccode %>");
		}, 1000);	
	
	$("#selectLan").bind("click",function(event){
		var left = jQuery(this).offset().left;
    	var top = jQuery(this).offset().top+20;
		$("#syslangul").show();
		$("#syslangul").css("left",left+"px");
		$("#syslangul").css("top",top+"px");
		$(this).addClass("selectLanOver");
		event.stopPropagation();
		
	});
	$("#syslangul").find("li").hover(function(){
		$("#syslangul").find(".selected").removeClass("selected");
		$(this).addClass("selected");
	},function(){
		
	})
	
	$("#syslangul").find("li").bind("click",function(){
		var langlid = $(this).attr("lang");
		setSyslangulChange(langlid)
		$("#islanguid").val($(this).attr("lang"));
		$("#selectLan").find(".text").text($(this).text());
		$("#syslangul").hide();
		$(this).addClass("selected");
		$("#selectLan").removeClass("selectLanOver")
	})
	
	$(document).bind("click",function(){
		$("#syslangul").hide();
		$("#selectLan").removeClass("selectLanOver")
	})
	setSyslangulChange($("#islanguid").val())
});
var languageMap = {};
function setSyslangulChange(languageid){
    jQuery.ajax({
        url : "/wui/common/page/changeLanguageInfo.jsp",
        type : "post",
        processData : false,
        data : "languageid="+languageid,
        dataType : "html",
        cache:false,
        success: function (data){
            $.each(JSON.parse(data),function(index,item){
            	if(item.key != ""){
	                if(item.id=="674"||item.id=="131938"){
	                    jQuery("#"+item.key).val(item.value);
	                }else{
	                    jQuery("#"+item.key).html(item.value);
	
	                }
            	}
                languageMap[item.id] = item.value;
            })
        }
    });
    if("8"==languageid){
        jQuery("#forgotpassword").css("left","0px");
    }else{
        jQuery("#forgotpassword").css("left","50px");
    }
    jQuery("#login").css("letter-spacing","2px");
}
function getloginstatus(key) {
		var langid = $("#islanguid").val();
		if(!$("#qrcodeLogin").is(":hidden")){
			qrCodeGetCount ++;
			if(qrCodeGetCount >= <%=showQRCodeSec%>){
				$('#backbtn').click();
				return;
			}
			jQuery.ajax({
	            url: "/mobile/plugin/login/QCLoginStatus.jsp?langid="+langid+"&loginkey=" + key + "&rdm=" + new Date().getTime(),
	            dataType: "text", 
	            contentType : "charset=UTF-8", 
	            error:function(ajaxrequest){}, 
	            success:function(content){
					if (jQuery.trim(content) != '0' && jQuery.trim(content) != '9') {
						//alert("Successful user login!");
						if(jQuery.trim(content)==""){
							content = "/wui/main.jsp";
						}
						window.clearInterval(loginInterval);
						window.location.href = jQuery.trim(content);
					}
	            }
	        });
	        }
	}
  
// added by wcd 2015-01-07 动态密码过期 start
var vNumber = Number("<%=validitySec%>");
function pJob(){
	if(document.all("errorMessage")){
		if(languageMap[20289]){
			document.all("errorMessage").innerHTML = languageMap[20289]+languageMap[81913]+(vNumber--)+languageMap[81914];	
		}
		if(vNumber <= 0){
			document.all("message").value = "";
			document.all("errorMessage").innerHTML = languageMap[84255];
			return;
		}
		setTimeout("pJob()",1000);
	}
}
// added by wcd 2015-01-07 动态密码过期 end
function getUserUsbType(){
  var loginid=jQuery("#loginid").val();
  if(loginid!=""){
      loginid=encodeURIComponent(loginid);
      //根据填写的用户名检查是否启用动态口令 
   jQuery.post("/login/LoginOperation.jsp?method=checkTokenKey",{"loginid":loginid},function(data){
      userUsbType=jQuery.trim(data);
      if(userUsbType=="3"){
   	  //$("#tokenAuthKey").remove();
         $("#trTokenAuthKey").show();
         //$("#tdTokenAuthKey").find("div").append('<input type="text" id="tokenAuthKey" name="tokenAuthKey"   class="input">');
         $("#for_tokenAuthKey").overlabel();
      }else{
         $("#trTokenAuthKey").hide();
        //$("#tokenAuthKey").remove();
      }      
   });
  }
}
 
var userUsbType="0";
jQuery(document).ready(function(){
<%
if(weaver_login_type.equalsIgnoreCase("ADSSO")){
%>

	clearAuthenticationCache();
	<%
}
	%>
	$("#isie").val(isIE);
	//需要usb验证，且采用的是动态口令
	if("<%=needusb%>"=="1"){
		jQuery("#loginid").bind("blur",function(){
 			getUserUsbType();
			if(document.all("errorMessage")) document.all("errorMessage").innerHTML = "";
			var _message = document.all("message");
			if(_message && _message.value == "101"){
				_message.value = "";
			}
		});
		getUserUsbType();
	}else{
		jQuery("#loginid").bind("blur",function(){
			if(document.all("errorMessage")) document.all("errorMessage").innerHTML = "";
			var _message = document.all("message");
			if(_message && _message.value == "101"){
				_message.value = "";
			}
		});
	}

	jQuery.getScript('/wui/common/js/cacheck.js?t='+new Date().getTime(),function(){
		var checkall_bak = checkall ;
		window.checkall = function(){
			SafeEngineCtlObj.submit() ;
		}
		SafeEngineCtlObj.ajaxCheck('loginid','form1','login','<%=settings.getNeedca() %>',checkall_bak);
	})
	
	if("<%=message0%>" == "101"){
		$("input[name='userpassword']").focus();
		pJob();
	}
	if($("input[name='loginid']").val() != ''){
    	$(".overlabel[for='loginid']").css( { 'text-indent': '-10000px' });
	}
	if ($("input[name='userpassword']").val() != '') {
    	$(".overlabel[for='userpassword']").css( { 'text-indent': '-10000px' });
	} 
})


 //清除所有cookie函数  
        function clearAuthenticationCache() {  
            document.execCommand("ClearAuthenticationCache");  
          }  

jQuery(window).bind("resize",function(){
	jQuery(".overlabel-wrapper").css("position","relative");
})
</script>

<div id="background-image">
    <img src="<%=backgroundUrl%>" alt=""  />
</div>

</body>
</html>
