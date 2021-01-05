<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%
int isIncludeToptitle = 0;
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
Log logger= LogFactory.getLog(this.getClass());
String pagepath = request.getServletPath();
if(pagepath.indexOf("HrmResourceOperation.jsp")<0&&pagepath.indexOf("RemindLogin.jsp")<0&&pagepath.indexOf("HrmResourcePassword.jsp")<0){
	String changepwd = (String)request.getSession().getAttribute("changepwd");
	if("n".equals(changepwd)){
		response.sendRedirect("/login/Login.jsp");
		return;
	}else if("y".equals(changepwd)){
		request.getSession().removeAttribute("changepwd");
	}
}
//String companyNametools="";
//License Licenseinit_1 = new License();
//Licenseinit_1.CkHrmnum();
//companyNametools = Licenseinit_1.getCompanyname();

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

<%String fromlogin=(String)session.getAttribute("fromlogin");
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
//System.out.println("application1"+a_logmessage);
//System.out.println("session1"+s_logmessage);
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
