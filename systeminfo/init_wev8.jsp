<%
	try{
		response.setBufferSize(1*1024*1024);
	}catch(Exception e){}
%>
<!DOCTYPE HTML>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@page import="weaver.hrm.settings.ChgPasswdReminder"%>
<%@page import="weaver.hrm.settings.HrmSettingsComInfo"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@page import="weaver.login.LicenseCheckLogin"%>
<%@page import="weaver.hrm.online.IPUtil"%>
<html>
<head>
<!-- 
添加至init.css
<style type="text/css">
	html{height:100%;}
</style>
 -->
<%
// 增加参数判断缓存
int isIncludeToptitle = 0;
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
//
User user = HrmUserVarify.getUser (request , response) ;
LicenseCheckLogin licenseCheckLogin = new LicenseCheckLogin();
licenseCheckLogin.setOutLineDate(user.getUID(),IPUtil.getIp(request));

//问题1
TestWorkflowCheck twc=new TestWorkflowCheck();
if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
    /*
    response.sendRedirect("/login/Logout.jsp");
    */
    String forwardurl = twc.reLoginMrg(request, response, request.getRequestURI());
    if (!"".equals(forwardurl)) { 
        response.sendRedirect(forwardurl);
        return;
    }
}
String userOffline = Util.null2String((String)session.getAttribute("userOffline"));	
if(userOffline.equals("1")){
	//强制下线
	String loginfile = Util.getCookie(request , "loginfileweaver") ;
	Map userSessions = (Map) application.getAttribute("userSessions");
	if (userSessions != null) {
		Map logmessages = (Map) application.getAttribute("logmessages");
		if (logmessages != null)logmessages.remove("" + user.getUID());
		session.removeValue("moniter");
		session.removeValue("WeaverMailSet");
		userSessions.remove(user.getUID());
		//session.invalidate();
	}%>
	<script language="javascript">
		window.top.Dialog.alert("<%=SystemEnv.getErrorMsgName(175,user.getLanguage())%>",function(){
			window.top.location="<%="/Refresh.jsp?loginfile="+loginfile+"&message=175"%>";
		});		
	</script>
	<%
  return;
}
if(user == null)  return ;
String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
	session.setAttribute("browser_isie", "true");
}
String agentT = request.getHeader("user-agent");
//if(!"true".equals(isIE)){
//if((agentT.contains("Firefox")||agentT.contains(" Chrome")||agentT.contains("Safari") )&& !agentT.contains("Edge")){
if(agentT.contains("Firefox")||agentT.contains(" Chrome")||agentT.contains("Safari") || agentT.contains("Edge")){	
    isIE = "false";	
}
else{
    isIE = "true";	
}
//}

Log logger= LogFactory.getLog(this.getClass());



//************************************************
//超时或者重启resin服务时，弹出登陆小窗口(TD 2227)
//hubo,050707

//************************************************

String pagepath = request.getServletPath();
if(pagepath.indexOf("HrmResourceOperation.jsp")<0&&pagepath.indexOf("RemindLogin.jsp")<0&&pagepath.indexOf("HrmResourcePassword.jsp")<0){
	String changepwd = (String)request.getSession().getAttribute("changepwd");
	if("n".equals(changepwd)){
		request.getSession().removeAttribute("changepwd");
		response.sendRedirect("/login/Login.jsp");
		return;
	}else if("y".equals(changepwd)){
		request.getSession().removeAttribute("changepwd");
	}
}



//licence信息
String companyNametools="";
LN Licenseinit_1 = new LN();
try{
	Licenseinit_1.CkHrmnum();
}catch(Exception e){
	e.printStackTrace();
	out.println("<script type='text/javascript'> top.location.href='/system/InLicense.jsp?message=6&code=';</script>");
	return;
}
companyNametools = Licenseinit_1.getCompanyname();

//版本信息
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String software = (String)staticobj.getObject("software") ;
if(software == null) software="ALL";
String portal = (String)staticobj.getObject("portal") ;
if(portal == null) portal="n";
boolean isPortalOK = false;
if(portal.equals("y")) isPortalOK = true;
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) multilanguage="n";
boolean isMultilanguageOK = false;
if(multilanguage.equals("y")) isMultilanguageOK = true;

%>

<%
  String fromlogin=(String)session.getAttribute("fromlogin");
  session.removeAttribute("fromlogin");
  if(fromlogin==null) fromlogin="no";

  ChgPasswdReminder reminder0 = new ChgPasswdReminder();
  RemindSettings settings0=reminder0.getRemindSettings();
  String firmcode0=settings0.getFirmcode();
  String usercode0=settings0.getUsercode();

  int needusb0=user.getNeedusb();
  String usbtype0 = settings0.getUsbType();
  String serial0=user.getSerial();

//限制每个用户只能有一个登入的窗口
String frommain = Util.null2String(request.getParameter("frommain")) ;

Map logmessages=(Map)application.getAttribute("logmessages");
String a_logmessage="";
if(logmessages!=null)
	a_logmessage=Util.null2String((String)logmessages.get(""+user.getUID()));

String s_logmessage=Util.null2String((String)session.getAttribute("logmessage"));


//TD2125 by mackjoe 解决数据中心登陆不了问题
if(s_logmessage==null)  s_logmessage="";

String relogin0=Util.null2String(settings0.getRelogin());

String changepwd = (String)session.getAttribute("changepwd");

if(!relogin0.equals("1")&&"yes".equals(changepwd)){
logmessages=(Map)application.getAttribute("logmessages");
logmessages.put(""+user.getUID(),s_logmessage);
if(logmessages!=null)
	a_logmessage=Util.null2String((String)logmessages.get(""+user.getUID()));
}

String layoutStyle = (String)request.getSession(true).getAttribute("layoutStyle");
if(layoutStyle==null) layoutStyle ="";

String rtxFromLogintmp = (String)session.getAttribute("RtxFromLogin");


if("1".equals(user.getLogintype())&&!relogin0.equals("1")&&!fromlogin.equals("yes")&&!frommain.equals("yes")&&!s_logmessage.equals(a_logmessage) && !"true".equals(rtxFromLogintmp)){
	if(layoutStyle.equals("") || !layoutStyle.equals("1")){	//如果是小窗口登录，则不判断是否为当前工作窗口

%>


<script language=javascript>;
top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23274,user.getLanguage())%>",function(){
	window.top.location="/login/Login.jsp";
});
</script>
<%return;}}%>

<%
//流程的三个页面需要使用高版本的jQuery
if (request.getRequestURI().indexOf("/workflow/request/") != -1 &&
        (request.getRequestURI().indexOf("/workflow/request/ManageRequestNoForm") != -1 
                || request.getRequestURI().indexOf("/workflow/request/ViewRequestIframe.jsp") != -1
                || request.getRequestURI().indexOf("/workflow/request/RemarkFrame.jsp") != -1)) {
%>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>	    
<%
} else {
%>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<%
}
%>
<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject_wev8.js"></script>

<%
//模板模式导入
if ((request.getRequestURI().indexOf("/workflow/") != -1 && request.getRequestURI().indexOf("mode") != -1)
        || request.getRequestURI().indexOf("/workflow/request/AddRequest") != -1) {
        %>
<!-- IE下专用vbs（临时） -->
<script language="vbs" src="/js/string2VbArray.vbs"></script>        
        <%
}
%>
<!-- js 整合到 init_wev8.js -->
<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language="javascript"  src="/js/wbusb_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript">
    hs.graphicsDir = '/js/messagejs/highslide/graphics/';
    hs.align = 'center';
    hs.transitions = ['expand', 'crossfade'];
    hs.outlineType = 'rounded-white';
    hs.fadeInOut = true;
</script>
<!-- init.css, 所有css文件都在此文件中引入 -->
<link rel="stylesheet" href="/css/init_wev8.css" type="text/css" />


<script language=javascript>
window["_jsessionid"] = "<%=request.getSession().getId()%>";
function check_conn() {
	return confirm('<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>');
}

function _onViewLog(operateitem,sqlwhere,id){
	if(!sqlwhere)sqlwhere = "";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17480",user.getLanguage())%>";
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&operateitem="+operateitem+"&sqlwhere="+sqlwhere;
	if(id){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&relatedid="+id+"&operateitem="+operateitem+"&sqlwhere="+sqlwhere;
		if(operateitem==418||operateitem==419||operateitem==420){
			dialog.Title = "<%=SystemEnv.getHtmlLabelNames("25484,83",user.getLanguage())%>";
		}
	}
	dialog.Width = jQuery(window).width();
	dialog.Height = 610;
	dialog.Drag = true;
	dialog.checkDataChange = false;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}


function check_form(thiswins,items)
{
	/* added by cyril on 2008-08-14 for td:8521 */
	var isconn = false;
	try {
		var xmlhttp;
	    if (window.XMLHttpRequest) {
	    	xmlhttp = new XMLHttpRequest();
	    }  
	    else if (window.ActiveXObject) {
	    	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
	    }
	    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getUID()%>&time="+new Date()+"&f_weaver_belongto_userid=<%=user.getUID()%>&f_weaver_belongto_usertype=<%=user.getType()%>";
	    xmlhttp.open("GET",URL, false);
	    xmlhttp.send(null);
	    var result = xmlhttp.status;
	    if(result==200) {
		    isconn = true;
	    	var response_flag = xmlhttp.responseText;
	    	if(response_flag!='0') {
	    		var flag_msg = '';
	    		if(response_flag=='1') {
	    			var diag = new Dialog();
					diag.Width = 300;
					diag.Height = 180;
					diag.ShowCloseButton=false;
					diag.Title = "<%=SystemEnv.getHtmlLabelName(26263,user.getLanguage())%>";
					//diag.InvokeElementId="pageOverlay"
					diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=URLEncoder.encode(user.getLoginid())%>";
					diag.show();
			        return false;
	    		}
	    		else if(response_flag=='2') {
	    			flag_msg = '<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>';
	    		}
	    		//主从帐户特殊处理 by alan for TD10156
	    		if(response_flag=='3') {
	    			flag_msg = '<%=SystemEnv.getHtmlLabelName(23670,user.getLanguage())%>';
	   
	    			return false;
	    		}
	    		flag_msg += '\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>';
	        	//alert(xmlhttp.responseText);
	        	return confirm(flag_msg);
	        }
	    }
	    xmlhttp = null;

	  	//检查多行文本框 oracle下检查HTML不能超过4000个字符
	    <%if(new weaver.conn.RecordSet().getDBType().equals("oracle")){%>
	    try {
		    var lenck = true;
		    var tempfieldvlaue = document.getElementById("htmlfieldids").value;
		    while(true) {
			    var tempfield = tempfieldvlaue.substring(0, tempfieldvlaue.indexOf(","));
			    tempfieldvlaue = tempfieldvlaue.substring(tempfieldvlaue.indexOf(",")+1);
			    var fieldid = tempfield.substring(0, tempfield.indexOf(";"));
			    var fieldname = tempfield.substring(tempfield.indexOf(";")+1);
			    if(fieldname=='') break;
			    if(!checkLengthOnly(fieldid,'4000',fieldname,'<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(124962,user.getLanguage())%>')) {
				    lenck = false;
				    break;
			    }
		    }
		    if(lenck==false) return false;
	    }
	    catch(e) {}
	    <%}%>
	}
	catch(e) {
		return check_conn();
	}
	if(!isconn)
		return check_conn();
    /* end by cyril on 2008-08-14 for td:8521 */
	
	thiswin = thiswins
	items = ","+items + ",";
	
	var tempfieldvlaue1 = "";
	try{
		tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
	}catch (e) {
	}

	for(i=1;i<=thiswin.length;i++){
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
	    if(tmpvalue==null){
	        continue;
	    }

		if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){		
			var __fieldhtmltype = jQuery("input[name=" + tmpname + "]").attr("__fieldhtmltype");
		    if (__fieldhtmltype == '9') {
		        continue;
		    }
		
			var href = location.href;
			if(href && href.indexOf("Ext.jsp")!=-1){
				window.__oriAlert__ = true;
			}
			if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
				while(tmpvalue.indexOf(" ") >= 0){
					tmpvalue = tmpvalue.replace(" ", "");
				}
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}

				if(tmpvalue == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						}else{
							var tempElement = thiswin.elements[i-1];
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>", function () {
						    formElementFocus(tempElement);						
							});
						}
						return false;
					}else{
						if(window.__oriAlert__){
							try{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							}catch(e){
								Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							}
						}else{
							try{
								window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							}catch(e){
								Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							}
						}
						return false;
					}
				}
			} else {
				var divttt=document.createElement("div");
				divttt.innerHTML = tmpvalue;
				var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
				if(tmpvaluettt == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						if(window.__oriAlert__){
							window.top.Dialog.alert("\";"+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						}else{
							var tempElement = thiswin.elements[i-1];
							
							//ueditor必填验证
							if (checkueditorContent(tempElement)) {
								continue;
							}
							
							window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>", function () {
								formElementFocus(tempElement);
							});
							
						}
						return false;
					}else{
						if(window.__oriAlert__){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						}else{
							window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						}
						return false;
					}
				}
			}
		}
	}
	return true;
}

function isdel(){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   if(!confirm(str)){
       return false;
   }
       return true;
 } 

function issubmit(){
	var str = "<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>";
   if(!confirm(str)){
       return false;
   }
       return true;
   } 

///*流程里面使用，主要是因为流程内容放到iframe里面，通过response返回的时候，要返回的到其父窗口*/
function wfforward(wfurl){
	parent.location.href = wfurl;
}

function myescapecode(str)
{
	return encodeURIComponent(str);
}
</script>



<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
<script language=JavaScript> 
  var companyname = "<%=companyNametools%>";
  var str1 = "<%=SystemEnv.getHtmlLabelName(23714,user.getLanguage())%>";

  if(companyname.length >0 ){
  	window.status = str1+companyname;
  }
</script>
<!-- 删除 -->
</head></html>

<!--USB 验证 -->
<%
  if(!fromlogin.equals("yes")&&needusb0==1&&"1".equals(usbtype0)){
%>
<script language=javascript>
ubsfirmcode0 = <%=firmcode0%>;
usbusercode0 = <%=usercode0%>;
usbserial0 = "<%=serial0%>";
usblanguage = "<%=user.getLanguage()%>";
doCheckusb();
</script>
<%}%>

<!--WUI -->
<%@ include file="/wui/common/page/initWui.jsp" %>

<!--For wui-->
<%

String curTheme = "ecology7";
//当前皮肤
String curskin = "";
String cutoverWay = "";
String transitionTime = "";
String transitionWay = "";

HrmUserSettingComInfo instance = new HrmUserSettingComInfo();

String huscifId = String.valueOf(instance.getId(String.valueOf(user.getUID())));

curTheme = getCurrWuiConfig(session, user, "theme");
curskin = getCurrWuiConfig(session, user, "skin");

cutoverWay = instance.getCutoverWay(huscifId);
transitionTime = instance.getTransitionTime(huscifId);
transitionWay = instance.getTransitionWays(huscifId);
%>
<%
String ely6flg = "";
if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}
%>
<!--For wui-->
<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curskin %>/wui_wev8.css'/>
<%
curTheme = "ecology8";//后台配置页面均为E8主题，如使用其他主题时，会导致样式混乱。所以此处主题强制赋值ecology8
if("ecology8".equals(curTheme)) curskin="default";
session.setAttribute("SESSION_TEMP_CURRENT_THEME", curTheme);
session.setAttribute("SESSION_TEMP_CURRENT_SKIN", curskin);
%>


<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<!--
添加至init_wev8.css 
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
 -->
<script language="javascript"> 
/*
if (jQuery.client.version< 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont_wev8.css";
}
*/
</script> 
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 End -->

<!-- 页面切换效果Start -->
<%
    if (transitionTime != null && !transitionTime.equals("") && !transitionTime.equals("0")) {
%>
<meta http-equiv="<%=cutoverWay %>" content="revealTrans(duration=<%=transitionTime %>,transition=<%=transitionWay %>)">
<%
    }
%>
<!-- 页面切换效果End -->


<script language="javascript">

//------------------------------
// the folder of current skins 
//------------------------------
//当前使用的主题
var GLOBAL_CURRENT_THEME = "<%=curTheme %>";
//当前主题使用的皮肤
var GLOBAL_SKINS_FOLDER = "<%=curskin %>";
</script>

<!--For wuiForm-->
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
</script>
<%if(!"1".equals(session.getAttribute("istest"))){//流程测试%>
<jsp:include page="/synergy/showSynergy.jsp">
     <jsp:param name="requestid" value='<%=Util.getIntValue(request.getParameter("requestid"),-1)%>'/>
</jsp:include>
<%}%>
