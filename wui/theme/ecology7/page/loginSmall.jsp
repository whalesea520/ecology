
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>

<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<%
String dlflg = request.getParameter("dlflg");
String usernamep = request.getParameter("username");
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
int extendloginid=0;


%>

<%
String formmethod = "post";
if(!"".equals(Util.null2String(BaseBean.getPropValue("ldap", "domain")))){
    formmethod = "get";
}
String host = Util.getRequestHost(request);
GCONST.setHost(host);
String acceptlanguage = request.getHeader("Accept-Language");
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




int upgreadeStatus= suc.getUpgreadStatus();
//升级过程中脚本执行出错
if (upgreadeStatus==1) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>升级不成功，升级脚本错误，错误日志位于"+suc.getUpgreadLogPath()+"处，请联系供应商！</div>');</script>");
    return;
}
//升级过程中异常中止
if (upgreadeStatus==2) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>升级不成功，升级过程中服务器异常中止或者重启了Resin服务，请联系供应商！</div>');</script>");
    return;
}
//升级程序执行异常
if (upgreadeStatus==3) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress_wev8.gif\"><br/>升级不成功，升级程序错误，请联系供应商！</div>');</script>");
    return;
}

//String templateId="",templateType="",imageId="",loginTemplateTitle="";
//int extendloginid=0;

String sqlLoginTemplate = "SELECT * FROM SystemLoginTemplate WHERE isCurrent='1'";  

rs.executeSql(sqlLoginTemplate);
if(rs.next()){
    templateId=rs.getString("loginTemplateId");
    templateType = rs.getString("templateType");
    imageId = rs.getString("imageId");
    loginTemplateTitle = rs.getString("loginTemplateTitle");
    extendloginid = rs.getInt("extendloginid");
    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
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
String needusb=settings.getNeedusb();
String usbType = settings.getUsbType();
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String OpenPasswordLock = settings.getOpenPasswordLock();

String needdactylogram = settings.getNeedDactylogram(); 
//String canmodifydactylogram = settings.getCanModifyDactylogram();
String loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
String message0 = Util.null2String(request.getParameter("message")) ;
//处理发过动态密码后   刷新页面 不重新发送的问题  20931
if((message0.equals("57") || message0.equals("101")) && loginid.equals("")){
     loginid = "";
     message0 = "";
     }
String message=message0;
if(message0.equals("nomatch")) message = "";
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message0),7) ;
if("16".equals(message0)){
    if("1".equals(OpenPasswordLock)){
        loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
  			rs.executeSql("select id from HrmResourceManager where loginid='"+loginid+"'");
  			if(!rs.next()){
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
	            message = SystemEnv.getHtmlLabelName(24466,7)+leftChance+SystemEnv.getHtmlLabelName(24467,7);
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
    message=SystemEnv.getHtmlLabelName(20289,7);
}
if(message0.equals("110")) 
{
    loginid = "";
    int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,7)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,7)+"，"+SystemEnv.getHtmlLabelName(24594,7);
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}
String logintype = Util.null2String(request.getParameter("logintype")) ;
if(logintype.equals("")) logintype="1";

//IE 是否允许使用Cookie
String noAllowIe = Util.null2String(request.getParameter("noAllowIe")) ;
if (noAllowIe.equals("yes")) {
    message = "IE阻止Cookie";
}

//用户并发数错误提示信息
if (message0.equals("26")) { 
    message = SystemEnv.getHtmlLabelName(23656,7);
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
boolean ismuitlaguage = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
    VerifyLogin.checkLicenseInfo();
    multilanguage = (String)staticobj.getObject("multilanguage") ;
}
if(multilanguage.equals("y")){
    ismuitlaguage = true;
}
%>

<%
if(message0.equals("46")){
%>
<script language="JavaScript">
flag=confirm('您可能还没有为usb令牌安装驱动程序，安装请按确定')
if(flag){
    <%if("1".equals(usbType)){%>
        window.open("/weaverplugin/WkRt.exe")
    <%}else{%>
        window.open("/weaverplugin/HaiKeyRuntime.exe")
    <%}%>
}
</script>
<%}%>
<%@page import="weaver.login.VerifyLogin"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=loginTemplateTitle %></title>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery_wev8.js"></SCRIPT>


<SCRIPT language=javascript1.1>
var flag_now = true;//标志是否当前用户。true：是。false：否。
// 验证用户登录
function checkall()
{ 
    var dactylogram = "";
    if(document.all("dactylogram")) dactylogram = document.all("dactylogram").value;
    if(dactylogram == ""){
		var i=0;
		var j=0;
		var errMessage="";
		if (form1_login.loginid.value=="") {errMessage=errMessage+"请输入用户名:";i=i+1;}
		if (form1_login.userpassword.value=="") {errMessage=errMessage+"请输入密码\n";j=j+1;}
		if (i>0){
			$("#msg_show").html(errMessage);form1_login.loginid.focus(); return false ;
		}else if(j>0){
			$("#msg_show").html(errMessage);form1_login.userpassword.focus(); return false ;
		}
		form1_login.username.value = "<%=usernamep%>";
		//验证登录的是否是同一个账号
        if(form1_login.username.value != ""  &&  form1_login.loginid.value !=       form1_login.username.value){
		   
		   if(window.confirm("您好,您不是当前登录用户;\r您登录后,当前用户信息会丢失,是否继续?")){
			    $("#msg_show").html("正在验证,请稍候...");
				<%if(needusb!=null&&needusb.equals("1")){%>
				  checkusb();
				<%}%>
               flag_now = false;
				//ajax验证用户登录
				var ctxpath ='<%=request.getContextPath()%>';
				//获取表单所有的信息
				var queryString = jQuery("#form1_login").serialize();
				$.post(ctxpath+'/login/VerifyLoginSmall.jsp',queryString,checkall_callback);
			}else{
			    return false;
			}
		}else{
		    <%if(needusb!=null&&needusb.equals("1")){%>
				checkusb();
			<%}%>
		    flag_now = true;
			//ajax验证用户登录
			var ctxpath ='<%=request.getContextPath()%>';
			//获取表单所有的信息
			var queryString = jQuery("#form1_login").serialize();
			$("#msg_show").html("正在验证,请稍等...");
			$.post(ctxpath+'/login/VerifyLoginSmall.jsp',queryString,checkall_callback);
		}

	}
}

function diag_qx_click(){
	parent.window.location.reload();
}

//去掉字符串前后的空格
 String.prototype.trim=function(){   
    return this.toString().replace(/(^\s*)|(\s*$)/g, "");   
} 


//ajax验证用户登录回调函数
function checkall_callback(databack){
   var message = databack.trim();//后台返回的信息
   if(message == "success"){//表示登录成功
      if(flag_now){		
		  //清除账号和密码
		  $("#msg_show").html("正在验证,请稍候...");
		  form1_login.get_focus.focus();
		   parentDialog.close();
	  }else{
	      parent.window.location.reload();
	  }
   }else if(message == "45"){//表示需要插入USBKEY
      //alert("请插入USBKEY,谢谢");
	  $("#msg_show").html("请插入USBKEY,谢谢");
   }else if(message == "19"){//表示License问题
      //alert("请验证license是否过期,谢谢");
	  $("#msg_show").html("请验证license是否过期,谢谢");
   }else if(message == "dactylogram_n"){//表示需要指纹登录
      //alert("请认真获取指纹,谢谢");
	 $("#msg_show").html("请认真获取指纹,谢谢");
   }else{//表示用户名或密码不正确
      //alert("账号或密码不正确!");
	 $("#msg_show").html("账号或密码不正确！");
   }
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
                form1_login.submit();
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
    document.getElementById("loginid").disabled = true;
}

//add by sean.yang 2006-02-09 for TD3609
function changeMsg(msg)
{
    if(msg==0){
        if(document.all.validatecode.value=='请输入以下验证码') 
            document.all.validatecode.value='';
    }else if(msg==1){
        if(document.all.validatecode.value=='') 
            document.all.validatecode.value='请输入以下验证码';
    }
}
// -->
</SCRIPT>



<%if(needusb!=null&&needusb.equals("1")){%>
    <%if("1".equals(usbType)){%>
    <script language="JavaScript">
        function checkusb(){ 
          try{
            rnd=Math.round(Math.random()*1000000000);
            form1_login.rnd.value=rnd;
            wk = new ActiveXObject("WIBUKEY.WIBUKEY");
            MyAuthLib=new ActiveXObject("WkAuthLib.WkAuth");
            wk.FirmCode = <%=firmcode%>;
            wk.UserCode = <%=usercode%>;
            wk.UsedSubsystems = 1;
            wk.AccessSubSystem() ;
            if(wk.LastErrorCode==17){      
              form1_login.serial.value='0';
              return;      
            }      
           if(wk.LastErrorCode>0){
              throw new Error(wk.LastErrorCode);
              }    
            wk.UsedWibuBox.MoveFirst();
            MyAuthLib.Data=wk.UsedWibuBox.SerialText;     
            MyAuthLib.FirmCode = <%=firmcode%>;
            MyAuthLib.UserCode = <%=usercode%>;
            MyAuthLib.SelectionCode= rnd;
            MyAuthLib.EncryptWk();
            form1_login.serial.value= MyAuthLib.Data;   
            }catch(err){
              form1_login.serial.value= '1';      
              return;      
            }        
         }
         </script>
    <%}else{%>
        <script language="JavaScript">
            function checkusb(){
                try{
                    rnd = Math.round(Math.random()*1000000000);
                    form1_login.rnd.value=rnd;
                    var returnstr = getUserPIN();
                    if(returnstr != undefined && returnstr != ""){
                        form1_login.username.value= returnstr;
                        var randomKey = getRandomKey(rnd);
                        form1_login.serial.value= randomKey;
                    }else{
                        form1_login.serial.value= '0';
                    }
                }catch(err){
                    form1_login.serial.value= '0';
                    form1_login.username.value= '';
                    return;
                }
            }
        </script>
        <OBJECT id="htactx" name="htactx" 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
                <script language="javascript">
				function getUserPIN(){
				  try{
				  	var vbsserial="";
				  	var hCard = htactx.OpenDevice(1);//打开设备
				  	if(hCard==0){
				  		alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
				  		return vbsserial;
				  	}
				  	
				  	try{
					  	vbsserial = htactx.GetUserName(hCard)//获取用户名
					  	htactx.CloseDevice(hCard);
					  	return vbsserial;
					  }catch(e){
					  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2");
					  	htactx.CloseDevice(hCard);
					  	return vbsserial;
					  }
				  }catch(e){
				  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌");
				  	htactx.CloseDevice(hCard);
				  	return vbsserial;
				  }
				}
				
				function getRandomKey(randnum){
					try{
						var hCard = htactx.OpenDevice(1);//打开设备
						if(hCard == 0 ){
							alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
							return "";
						}
						try{
							var Digest = htactx.HTSHA1(randnum, (""+randnum).length);
							Digest = Digest+"04040404"; //对SHA1数据进行补码
							htactx.VerifyUserPin(hCard, (""+form1_login.userpassword.value)); //校验口令
					   	var EnData = htactx.HTCrypt(hCard, 0, 0, Digest, Digest.length);//DES3加密SHA1后的数据
					   	htactx.CloseDevice(hCard);
					   	return EnData;
					  }catch(e){
					  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌5");
					  	htactx.CloseDevice(hCard);
					  	return "";
					  }
					}catch(e){
						alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
						return "";
					}
				}
        </script>
    <%}%>
 <%}%>
</script>



<script type="text/javascript">




function ieVersionDetection() {
    if(navigator.userAgent.indexOf("MSIE")>0){ //是否是IE浏览器 
        if(navigator.userAgent.indexOf("MSIE 6.0") > 0){ //6.0
            $("#ieverTips").show();
            return;
        } 
    }
    $("#ieverTips").hide();
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

.title{font-family: '微软雅黑', tahoma, sans-serif;FONT-SIZE: 11px;}
.grey{FONT-SIZE: 13px;color:#666666;font-family: '微软雅黑', tahoma, sans-serif;}
input{
    background: #FFFFFF;
    border: 1px solid #CCCCCC;
    color: #000000;
    font-family: verdana, tahoma, sans-serif;
    font-size: 0.95em;}
.username{
    background-image:url(/wui/theme/ecology7/skins/default/rightbox/userlog_username_wev8.gif);
 background-position: 1px 1px;
 background-repeat:no-repeat;
 padding-left:20px;
 height:20px;
 FONT-SIZE: 12px;}
.password{
    background-image:url(/wui/theme/ecology7/skins/default/rightbox/userlog_password_wev8.gif);
 background-position: 1px 1px;
 background-repeat:no-repeat;
 padding-left:20px;
 height:20px;
 FONT-SIZE: 12px;}

</STYLE>

</head>



<body >

<form name="form1_login" id="form1_login"  >
    <INPUT type="hidden" value="/wui/theme/ecology7/page/login.jsp?logintype=1" name="loginfile">
    <INPUT type="hidden" name="logintype" value="1">
    <input type="hidden" name="fontName" value="微软雅黑">
    <input type=hidden name="message" value="<%=message0 %>">
	<INPUT type=hidden name="rnd" >
	<INPUT type=hidden name="serial"> 
	<INPUT type=hidden name="username">
<table height="140px"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr >
    <td class="grey"><img src="/wui/theme/ecology7/skins/default/rightbox/userlog_warning_wev8.gif" width="16" height="16" align="absmiddle"> <span id="msg_show">请输入登录的用户名和密码<span></td>
  </tr>
  <tr >
    <td class="title">用户名:</td>
  </tr>
  <tr >
    <td><input name="loginid" type="text" class="username" size="30"></td>
  </tr>
  <tr>
    <td></td>
  </tr>
  <tr >
    <td class="title">密&nbsp;&nbsp;&nbsp;码:</td>
  </tr>
  <tr >
    <td><input name="userpassword"  id="tipLogPwd" type="password" class="password" size="30"
	onkeydown="if(event.keyCode == 13){checkall();}">
    <!--
	<span onclick="password1=form1_login.userpassword;form1_login.userpassword.value='';showkeyboard();Calc.password.value=''">
	 <img title="软键盘" style="border:none;cursor:hand" alt="" src="/wui/theme/ecology7/page/images/softkeyboard_wev8.gif" border="0"/>
	 </span>
	 -->
  </td>
  </tr>
  
<tr id="trImgCode" style='height:56px;<%if(needvalidate!=1){ %>display:none<%} %>'><td> 	
<%if(needvalidate==1){%>
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" ><tr>
		<td style="width:110px;">
		   <div class="input_out" style="width: 100px;height:19px;"> 
			<label for="validatecode" id="for_validatecode" class="overlabel"><%=SystemEnv.getHtmlLabelName(84270,7)%></label>
			<input type="text" id="validatecode" name="validatecode"  style="width:100px;height:19px;">	
		   </div>
		</td>
		<td style="text-align:left;">
			<a href="javascript:changeCode()"><img  id="imgCode" border=0 align='absmiddle' style="width:96px;height:38px;" src='/weaver/weaver.file.MakeValidateCode'></a>
		   <script>
			 var seriesnum_=0;
			 function changeCode(){
				seriesnum_++;
				setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum_)',50); 
			 }
			</script>
		</td>
	</tr></table>
		<%}%>											
</td></tr>
  
  <tr >
    <td ><input type="button" name="button" id="get_focus" style="height:22px;width:50px;font-family: '微软雅黑', tahoma, sans-serif;FONT-SIZE: 12px;"  value="确&nbsp;&nbsp;定" onclick="checkall()">
	 &nbsp;&nbsp;&nbsp;&nbsp; <input type="button" name="button" style="height:22px;width:50px;font-family: '微软雅黑', tahoma, sans-serif;FONT-SIZE: 12px;"  value="取&nbsp;&nbsp;消" onclick="diag_qx_click()">
	</td>
  </tr>
</table>

</form>

</body>
</html>



