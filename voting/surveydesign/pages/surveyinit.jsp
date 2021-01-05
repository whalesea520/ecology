<!DOCTYPE HTML>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<html>
<head>
<style type="text/css">
	html{height:100%;}
</style>
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

//问题1
TestWorkflowCheck twc=new TestWorkflowCheck();
if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
    response.sendRedirect("/login/Logout.jsp");
    return;
}
if(user == null)  return ;
String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
	session.setAttribute("browser_isie", "true");
}

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
Licenseinit_1.CkHrmnum();
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

  RemindSettings settings0=(RemindSettings)application.getAttribute("hrmsettings");
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


String layoutStyle = (String)request.getSession(true).getAttribute("layoutStyle");
if(layoutStyle==null) layoutStyle ="";

String rtxFromLogintmp = (String)session.getAttribute("RtxFromLogin");


if(!relogin0.equals("1")&&!fromlogin.equals("yes")&&!frommain.equals("yes")&&!s_logmessage.equals(a_logmessage) && !"true".equals(rtxFromLogintmp)){
	if(layoutStyle.equals("") || !layoutStyle.equals("1")){	//如果是小窗口登录，则不判断是否为当前工作窗口

%>


<script language=javascript>;
alert("<%=SystemEnv.getHtmlLabelName(23274,user.getLanguage())%>");
window.top.location="/login/Login.jsp";
</script>
<%return;}}%>

<!DOCTYPE HTML>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject_wev8.js"></script>
<!-- IE下专用vbs（临时） -->
<script language="vbs" src="/js/string2VbArray.vbs"></script>

<!-- js 整合到 init_wev8.js -->
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script language="javascript"  src="/js/wbusb_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/wTooltip/wTooltip_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/wTooltip/wTooltip_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />		
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<link type="text/css" href="/js/dragBox/ereportstyle_wev8.css" rel=stylesheet>
<script src="/js/jquery.ba-resize.min_wev8.js" type="text/javascript"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
	<script src="/js/tabs/expandCollapse_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<link rel="stylesheet" href="/js/select/style/selectForK13_wev8.css">
	<script type="text/javascript" src="/js/select/script/selectForK13_wev8.js"></script>

<!--radio美化框-->
 <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=stylesheet>
 <script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
  <script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>


<!-- 下拉框美化组件-->
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

<!-- 移除 -->

<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
		
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script language=javascript>
var ieVersion = 6;//ie版本

jQuery(document).ready(function(){
	jQuery(".addbtn").hover(function(){
		jQuery(this).addClass("addbtn2");
	},function(){
		jQuery(this).removeClass("addbtn2");
	});
	
	jQuery(".delbtn").hover(function(){
		jQuery(this).addClass("delbtn2");
	},function(){
		jQuery(this).removeClass("delbtn2");
	});
	
	jQuery(".downloadbtn").hover(function(){
		jQuery(this).addClass("downloadbtn2");
	},function(){
		jQuery(this).removeClass("downloadbtn2");
	});
	var isNewPlugisSelect = jQuery("#isNewPlugisSelect");
	if(isNewPlugisSelect.length>0&&isNewPlugisSelect.val()!="1"){
		// do nothing
	}else{
		beautySelect();
	}
	
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
	
	jQuery(window).resize(function(){
		resizeDialog();
	});
	
});


/**
*清空搜索条件
*/
function resetCondtion(selector){
	resetCondition(selector);
}

function resetCondition(selector){
	if(!selector)selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	jQuery(selector).find("select").selectbox("detach");
	jQuery(selector).find("select").val("");
	jQuery(selector).find("select").trigger("change");
	beautySelect(jQuery(selector).find("select"));
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		changeCheckboxStatus(this,false);
	});
}

function resizeDialog(_document){
	if(!_document)_document = document;
	var bodyheight = jQuery(window).height();//_document.body.offsetHeight;
	var bottomheight = jQuery(".zDialog_div_bottom").css("height");
	var paddingBottom = jQuery(".zDialog_div_bottom").css("padding-bottom");
	var paddingTop = jQuery(".zDialog_div_bottom").css("padding-top");
	var headHeight = 0;
	var e8Box = jQuery(".zDialog_div_content").closest(".e8_box");
	if(e8Box.length>0){
		headHeight = e8Box.children(".e8_boxhead").height();
	}
	if(!!bottomheight && bottomheight.indexOf("px")>0){
		bottomheight = bottomheight.substring(0,bottomheight.indexOf("px"));
	}
	if(!!paddingBottom && paddingBottom.indexOf("px")>0){
		paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf("px"));
	}
	if(!!paddingTop && paddingTop.indexOf("px")>0){
		paddingTop = paddingTop.substring(0,paddingTop.indexOf("px"));
	}
	if(isNaN(bottomheight)){
		bottomheight = 0;
	}else{
		bottomheight = parseInt(bottomheight);
	}
	if(isNaN(paddingBottom)){
		paddingBottom = 0;
	}else{
		paddingBottom = parseInt(paddingBottom);
	}
	if(isNaN(paddingTop)){
		paddingTop = 0;
	}else{
		paddingTop = parseInt(paddingTop);
	}
	//alert(jQuery(window).height());
	if(document.documentMode!=5){
		jQuery(".zDialog_div_content").css("height",bodyheight-bottomheight-paddingTop-headHeight-7);
	}else{
		jQuery(".zDialog_div_content").css("height",bodyheight-bottomheight-paddingBottom-paddingTop-headHeight-7);
	}
	/*jQuery(".zDialog_div_bottom").css("top",jQuery(".zDialog_div_content").height()-1);
	var tabMenuHeight = jQuery("ul.tabMenu",parent.document).height();
	var bodyHeight = jQuery(".zDialog_div_content").height()+bottomheight+paddingBottom+paddingTop;
	jQuery("body").css("height",bodyHeight);
	jQuery("div[id^=_Container_]",parent.document).height(bodyHeight+tabMenuHeight);*/
}

function check_conn() {
	return confirm('<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>');
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
	    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getUID()%>&time="+new Date();
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
					diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=user.getLoginid()%>";
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
			    if(!checkLengthOnly(fieldid,'4000',fieldname,'<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')) {
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
			if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
				while(tmpvalue.indexOf(" ") >= 0){
					tmpvalue = tmpvalue.replace(" ", "");
				}
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}

				if(tmpvalue == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						return false;
					}else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
						return false;
					}
				}
			} else {
				var divttt=document.createElement("div");
				divttt.innerHTML = tmpvalue;
				var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
				if(tmpvaluettt == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null && thiswin.elements[i-1].getAttribute("temptitle")!=""){
						window.top.Dialog.alert("&quot;"+thiswin.elements[i-1].getAttribute("temptitle")+"&quot;"+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						return false;
					}else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
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

/*流程里面使用，主要是因为流程内容放到iframe里面，通过response返回的时候，要返回的到其父窗口*/
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
curTheme = "ecology8";
session.setAttribute("SESSION_TEMP_CURRENT_THEME", curTheme);
session.setAttribute("SESSION_TEMP_CURRENT_SKIN", curskin);
%>
<!--For wui-->
<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curskin %>/wui_wev8.css'/>

<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<script language="javascript"> 
if (jQuery.client.version< 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont_wev8.css";
}
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
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
</script>
<jsp:include page="/synergy/showSynergy.jsp"></jsp:include>