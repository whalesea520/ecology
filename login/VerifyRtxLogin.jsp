<%@ page import="weaver.general.Util,
				weaver.general.GCONST,
                 java.util.Map,
                 java.util.HashMap,
				 java.util.List,
                 weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyRtxLogin" scope="page" /> 
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="RtxLdaplog" class="weaver.rtx.RtxLdapLog" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
String urlfrom = Util.null2String(request.getParameter("urlfrom")) ;
String para = Util.null2String(request.getParameter("para")) ;
String linkurltmp = para;
if(urlfrom.equals("expfile")){ //档案系统归档导出
	verifylogin.setIsfromwftodoc(1);
	String para1= Util.null2String(request.getParameter("para1"));
	para1 = para1.replaceAll("@","&");
	//System.out.println("para1==="+para1);
	para = para1 + "#" + Util.null2String(request.getParameter("para2")) + "#" + Util.null2String(request.getParameter("para3"));
	String requestid = "-1";
	int index = para1.indexOf("requestid=");
	if(index>0) requestid = para1.substring(index+10);
	session.setAttribute("urlfrom_workflowtodoc_"+requestid,"true");
	para = para.replace("ViewRequest.jsp","ExportRequest.jsp");
} else if(urlfrom.equals("workflowtodoc")){//针对流程存为文档
	verifylogin.setIsfromwftodoc(1);
	para = Util.null2String(request.getParameter("para1")) + "#" + PoppupRemindInfoUtil.decrypt(Util.null2String(request.getParameter("para2"))) + "#" + Util.null2String(request.getParameter("para3"));
	String para1 = Util.null2String(request.getParameter("para1"));
	String requestid = "-1";
	int index = para1.indexOf("requestid=");
	if(index>0) requestid = para1.substring(index+10);
	session.setAttribute("urlfrom_workflowtodoc_"+requestid,"true");
}else{
	para = PoppupRemindInfoUtil.decrypt(para);
}

String str[] = Util.TokenizerString2(para,"#");

String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(str[1]);
String userpassword = "";
if(str.length==3){
	userpassword = Util.null2String(str[2]);
}
if(logintype.equals("")) logintype = "1";

//解决rtx消息提醒是ldap登录验证(ldap是没有loginid和password)td13185
if(!"1".equals(session.getAttribute("istest"))){//流程测试不验证rtx
boolean rtxladptmp = RtxLdaplog.checkRtxLadp(loginid,linkurltmp);
if(rtxladptmp && !urlfrom.equals("workflowtodoc")) {
	response.sendRedirect("/login/Login.jsp?logintype=1&message=19");
	return;
}
}

String serial=Util.null2String(request.getParameter("serial"));
String username = Util.null2String(request.getParameter("username"));
String rnd=Util.null2String(request.getParameter("rnd"));
String loginPDA=Util.null2String(request.getParameter("loginPDA"));
session.setAttribute("loginPAD",loginPDA);
String RedirectFile = Util.null2String(str[0]);
if(RedirectFile.indexOf("/main.jsp")>-1&&"1".equals(session.getAttribute("istest"))){
    session.removeAttribute("istest");
}
if (loginPDA.equals("1"))
{
RedirectFile= "/mainPDA.jsp";
}

String validatecode=Util.null2String(request.getParameter("validatecode"));


String gopage=Util.null2String(request.getParameter("gopage"));
if(gopage.length()>0){
    RedirectFile = "/main.jsp?gopage="+gopage ;
}
if (loginfile.equals("")) loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;

Cookie[] ck = request.getCookies();
int ckLength = 0 ;
try {
	ckLength = ck.length;
} catch (NullPointerException ex) {//流程存为文档，读不到cookie
	//response.sendRedirect("/login/Login.jsp?logintype="+logintype+"&noAllowIe=yes") ;
	//return ;
}

String isIE = Util.null2String(request.getParameter("isie"));
if(isIE.equals("false")){
	isIE = "true";
}
session.setAttribute("browser_isie",isIE);


if (logintype.equals("2")) RedirectFile = "/portal/main.jsp" ;

if((loginid.equals("")) && !"1".equals(session.getAttribute("istest"))) response.sendRedirect(loginfile + "&message=18") ;//QC271940解决AD域用户使用流程存为文档功能
else  { RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
    String needusb=settings.getNeedusb();
	String usercheck ;
	if(needusb!=null&&needusb.equals("1")&& false){//屏蔽usbkey
			usercheck= verifylogin.getUserCheck(request,response,loginid,userpassword,serial,username,rnd,logintype,loginfile,validatecode);
	}else{
		usercheck= verifylogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode);
	}

	try {
	   request.getSession(true).removeAttribute("validateRand");
	}catch (Exception e) {

  }		
	if(usercheck.equals("15") || usercheck.equals("16") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("52")|| usercheck.equals("55"))
    {
        String tmploginid=(String)session.getAttribute("tmploginid");
        if(tmploginid!=null&&loginid.equals(tmploginid))
           session.setAttribute("tmploginid1",loginid);
        else
           session.removeAttribute("tmploginid");
        response.sendRedirect(loginfile + "&message="+usercheck) ;
	}
	else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp") ;
	} else if (usercheck.equals("26")) {
		response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck);
	}else if(usercheck.equals("101")){
        session.setAttribute("tmploginid",loginid);
        session.setAttribute("tmploginid1",loginid);
        if (!loginPDA.equals("1")) {
        response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck) ;
		}
		else
		{
		response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message="+usercheck) ;
		}
    }
	else {
            User user = HrmUserVarify.getUser (request , response) ;

            if(user == null) { response.sendRedirect(loginfile ) ; return;}
            session.setAttribute("password",userpassword);
	        session.setAttribute("fromlogin","yes");
            session.removeAttribute("tmploginid");
            session.setAttribute("RtxFromLogin","true");
			boolean MOREACCOUNTLANDING = GCONST.getMOREACCOUNTLANDING();
			if(MOREACCOUNTLANDING){
                //多帐号登陆
                if (user.getUID() != 1) {  //is not sysadmin
					weaver.login.VerifyLogin VerifyLogin = new weaver.login.VerifyLogin();
                    List accounts = VerifyLogin.getAccountsById(user.getUID());
                    request.getSession(true).setAttribute("accounts", accounts);
				}
				Util.setCookie(response, "loginfileweaver", loginfile, 172800);
				Util.setCookie(response, "loginidweaver", loginid, 172800);
             }
            DocCheckInOutUtil.docCheckInWhenVerifyLogin(user,request);

		if(request.getSession(true).getAttribute("layoutStyle")!=null && request.getSession(true).getAttribute("layoutStyle").equals("1")){
			session.setAttribute("istimeout","no");
%>
			<SCRIPT LANGUAGE=VBS>
				window.parent.returnvalue = "1"
				window.parent.close
			</script>
<%
		}else{
			if("2".equals(logintype)){
				response.sendRedirect(RedirectFile) ;
				return;
			} else {
				UserTemplate  ut=new UserTemplate();
				
				ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
				int templateId=ut.getTemplateId();
				int extendTempletid=ut.getExtendtempletid();
				int extendtempletvalueid=ut.getExtendtempletvalueid();

				if(extendTempletid!=0){
					rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
					if(rsExtend.next()){
						int id=Util.getIntValue(rsExtend.getString("id"));
						String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
						if(para.length()>0){
							response.sendRedirect(RedirectFile);
						}else{
							response.sendRedirect(extendurl+"/index.jsp") ;
						}
						return;				  
					}
				} else {
					response.sendRedirect(RedirectFile) ;
					return;
				}
			}
		}
	}
}
%>