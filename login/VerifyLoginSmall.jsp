<%@ page import="weaver.general.Util,weaver.general.TimeUtil,
                 java.util.Map,
                 java.util.HashMap,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings,
                 weaver.general.GCONST" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="java.net.*,java.io.*,java.io.File" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
	
<jsp:useBean id="dactylogramCompare" class="weaver.login.dactylogramCompare" scope="page" /> 
<jsp:useBean id="VerifyLogin" class="weaver.login.VerifyLogin" scope="page" /> 
<jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String message = "";
//message说明：
//name_psw_n：表示用户名或密码不正确
//success ：表示成功
//19：表示License问题
//dactylogram_n：表示指纹登录问题
//45: 表示需要插入USBKEY
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String forwardpage = Util.null2String(request.getParameter("forwardpage")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));
//String message = Util.null2String(request.getParameter("message"));

//xiaofeng
int  islanguid = 7;//系统使用语言,未使用多语言的用户默认为中文。
String languid= "7";
boolean ismutilangua = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
	VerifyLogin.checkLicenseInfo();
	multilanguage = (String)staticobj.getObject("multilanguage") ;
}
if(multilanguage.equals("y")){
	ismutilangua = true;
}
boolean isSyadmin=true;
//判断分权管理员
//String Sysmanager = "select loginid from hrmresourcemanager where loginid = '"+loginid+"'";
String Sysmanager = "select loginid from hrmresourcemanager where loginid = ?";
RecordSet1.executeQuery(Sysmanager,loginid);
if(RecordSet1.next()){
	isSyadmin = false;
}
if(loginid.equalsIgnoreCase("sysadmin")){
	isSyadmin = false;
}
if(isSyadmin){
	if(ismutilangua){
			islanguid = Util.getIntValue(request.getParameter("islanguid"),0);
				if(islanguid == 0){//如何未选择，则默认系统使用语言为简体中文
					islanguid = 7;
				}
		languid = String.valueOf(islanguid); 
		Cookie syslanid = new Cookie("Systemlanguid",languid);
		syslanid.setMaxAge(-1);
		syslanid.setPath("/");
		response.addCookie(syslanid);
	}
}/*else{
	Cookie syslanid = new Cookie("Systemlanguid",languid);
	syslanid.setMaxAge(-1);
	syslanid.setPath("/");
	response.addCookie(syslanid);
}*/
String serial=Util.null2String(request.getParameter("serial"));
String username = Util.null2String(request.getParameter("username"));
String rnd=Util.null2String(request.getParameter("rnd"));
String loginPDA=Util.null2String(request.getParameter("loginPDA"));
session.setAttribute("loginPAD",loginPDA);
//String RedirectFile ="/main.jsp";
String RedirectFile="/wui/page/main.jsp";


//add by sean.yang 2006-02-09 for TD3609
String validatecode=Util.null2String(request.getParameter("validatecode"));

//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
if(gopage.length()>0){
    RedirectFile = "/main.jsp?gopage="+gopage ;
}
if (loginfile.equals("")) loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;
//end by mackjoe
// modify by dongping for TD1340 in 2004.11.05
// 用户登陆时要对cookies是否开放作判断，如果没有，则会给出提示!
String testcookie = "";

String dactylogram = Util.null2String(request.getParameter("dactylogram"));//指纹特征
boolean compareFlag = false;
if(!dactylogram.equals("")){
  compareFlag = dactylogramCompare.executeCompare(dactylogram);
	if(compareFlag){
		loginid = dactylogramCompare.getLoginId();
		userpassword = dactylogramCompare.getPassword();
		logintype = "1";
	}else{
		//response.sendRedirect("/login/Login.jsp?&message=nomatch") ;//2011/5/19
		message = "dactylogram_n";//2011/5/19
		
	}
}

if (logintype.equals("2")){
	if(!gopage.equals("")){
 		RedirectFile = "/portal/main.jsp?gopage="+gopage ;
	}else{
		RedirectFile = "/portal/main.jsp" ;
	}
}

String tourl = "";
if(loginid.equals("") || userpassword.equals("") ){ 
	//response.sendRedirect(loginfile + "&message=18") ;//2011/5/19
	message = "18";//2011/5/19
	
}else  { RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
    String needusb=settings.getNeedusb();
	String usercheck ;
	if(compareFlag){
		usercheck= VerifyLogin.getUserCheckByDactylogram(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
	}else{
		boolean canpass = VerifyPasswdCheck.getUserCheck(loginid,"",1);
		if(!canpass){
			if(needusb!=null&&needusb.equals("1")){
				usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,serial,username,rnd,logintype,loginfile,validatecode,message,languid,ismutilangua);
				//System.out.println(loginid+"=="+userpassword+"=="+serial+"=="+username+"=="+rnd+"=="+logintype+"=="+loginfile+"=="+validatecode+"=="+message+"=="+languid+"=="+ismutilangua);
			}else{
				usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
			}
		}else{
			usercheck = "110";
		}
	}
	VerifyPasswdCheck.getUserCheck(loginid,usercheck,2);
	try {
	   request.getSession(true).removeAttribute("validateRand");
	}catch (Exception e) {

  }		
	if(usercheck.equals("15")|| usercheck.equals("57") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("52")|| usercheck.equals("55"))
    {
        String tmploginid=(String)session.getAttribute("tmploginid");
        if(tmploginid!=null&&loginid.equals(tmploginid))
           session.setAttribute("tmploginid1",loginid);
        else
           session.removeAttribute("tmploginid");
        //response.sendRedirect(loginfile + "&message="+usercheck) ;2011/5/19
		   message = usercheck ; //2011/5/19
		   
	}else if(usercheck.equals("16")){
		session.setAttribute("tmploginid1",loginid);
		//response.sendRedirect(loginfile + "&message="+usercheck) ;
		message = usercheck ; //2011/5/19
	}else if(usercheck.equals("19")){
		//response.sendRedirect("/system/InLicense.jsp") ;2011/5/19 inlicense 问题
		message = usercheck ; //2011/5/19
		
	} else if (usercheck.equals("26")) {
		if (!loginPDA.equals("1")) {
			//response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck);
			message = usercheck ; //2011/5/19
			
		} 
	}else if(usercheck.equals("101")){
        session.setAttribute("tmploginid",loginid);
        session.setAttribute("tmploginid1",loginid);
        if (!loginPDA.equals("1")) {
          //response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck) ;
		  message = usercheck ; //2011/5/19
		  
		}
		else
		{
		  //response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message="+usercheck) ;
		  message = usercheck ; //2011/5/19
		  
		}
    }
    else if(usercheck.equals("110"))
	{
		if (!loginPDA.equals("1"))
		{
			//response.sendRedirect("/login/Login.jsp?logintype=1&message=" + usercheck);
			message = usercheck ; //2011/5/19
		}
		else
		{
			//response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message=" + usercheck);
			message = usercheck ; //2011/5/19
			
		}
	}
	else {
            User user = HrmUserVarify.getUser (request , response) ;
            if(user == null) { 
				//response.sendRedirect(loginfile ) ; 
				message = "name_psw_n" ; //2011/5/19//表示用户名或密码不正确
			}

            session.setAttribute("password",userpassword);
            if("1".equals(logintype)){
            session.setAttribute("moniter", new OnLineMonitor("" + user.getUID(),user.getLoginip(),application));
            }
            Map logmessages=(Map)application.getAttribute("logmessages");
                if(logmessages==null){
                logmessages=new HashMap();
                logmessages.put(""+user.getUID(),"");
                application.setAttribute("logmessages",logmessages);
                }
	        session.setAttribute("logmessage",usercheck);
	        session.setAttribute("fromlogin","yes");
            session.removeAttribute("tmploginid");

            //DocCheckInOutUtil.docCheckInWhenVerifyLogin(user,request);

		//小窗口登录 (TD 2227)
		//hubo,050707
		if(request.getSession(true).getAttribute("layoutStyle")!=null &&         request.getSession(true).getAttribute("layoutStyle").equals("1")){
			session.setAttribute("istimeout","no");
		}else{
			
			if("2".equals(logintype)){
				//response.sendRedirect(RedirectFile) ;
				message = "" ; //2011/5/19
				
			} else {
				message = "success";//表示登录成功!
			}
		}
	}
}
   out.print(Util.null2String(message));
%>