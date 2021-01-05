
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.Map,java.util.HashMap,weaver.general.StaticObj,weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyLogin" scope="page" /> 
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
	
<jsp:useBean id="dactylogramCompare" class="weaver.login.dactylogramCompare" scope="page" /> 
<jsp:useBean id="verifyLogin" class="weaver.login.VerifyLogin" scope="page" />
<jsp:useBean id="verifyLoginDomain" class="weaver.login.VerifyLoginDomain" scope="page" />
<%
try{
	String windowsUser = Util.null2String(request.getRemoteUser()).trim();

	String[] names = windowsUser.split("\\\\");
	names[0] = Util.null2String(names[0]).trim();
	names[1] = Util.null2String(names[1]).trim();


	String loginfile = Util.null2String(request.getParameter("loginfile"));
	String logintype = "1";//该值只能是员工，不能是客户
	String forwardpage = Util.null2String(request.getParameter("forwardpage"));
	String message = Util.null2String(request.getParameter("message"));
	String gopage=Util.null2String(request.getParameter("gopage"));
	String RedirectFile ="/main.jsp";
	int  islanguid = 7;//系统使用语言,未使用多语言的用户默认为中文。
	String languid= "7";
	boolean ismutilangua = false;
	StaticObj staticobj = null;
	staticobj = StaticObj.getInstance();
	String multilanguage = (String)staticobj.getObject("multilanguage") ;
	if(multilanguage == null) {
		verifyLogin.checkLicenseInfo();
		multilanguage = (String)staticobj.getObject("multilanguage") ;
	}
	if(multilanguage.equals("y")){
		ismutilangua = true;
	}
	boolean isSyadmin=true;
	//判断分权管理员
 	String Sysmanager = "select loginid from hrmresourcemanager where loginid = '"+names[1].replaceAll("\u0000","")+"'";
	RecordSet1.executeSql(Sysmanager);
	if(RecordSet1.next()){
		isSyadmin = false;
	}
	if(names[1].equalsIgnoreCase("sysadmin")){
		isSyadmin = false;
	}
	if(isSyadmin){
		if(ismutilangua){
				islanguid = Util.getIntValue(request.getParameter("islanguid"),0);
					if(islanguid == 0){//如何未选择，取该用户默认系统使用语言
					//单点登录时取该用户默认系统使用语言
					RecordSet1.executeSql("select systemlanguage from HrmResource where loginid='"+names[1].replaceAll("\u0000","")+"'");
					if(RecordSet1.next()){
						islanguid = Util.getIntValue(RecordSet1.getString("systemlanguage"),0);
					
					}
					//log.writeLog("LoginSSO.jsp: islanguid3="+islanguid);
					if(islanguid == 0){
						islanguid = 7;
					}
				}
			languid = String.valueOf(islanguid); 
			Cookie syslanid = new Cookie("Systemlanguid",languid);
			syslanid.setMaxAge(-1);
			syslanid.setPath("/");
			response.addCookie(syslanid);
		}
	}
	if(!"".equals(forwardpage)){
		RedirectFile = forwardpage;
	}
	if(gopage.length()>0){
		RedirectFile = "/main.jsp?gopage="+gopage ;
	}
	if (loginfile.equals("")){
		loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;
	}
	Cookie[] ck = request.getCookies();
	int ckLength = 0 ;
	try {
		ckLength = ck.length;
	} catch (NullPointerException ex) {
		response.sendRedirect("/login/Login.jsp?logintype="+logintype+"&noAllowIe=yes&formmethod=get") ;
		return ;
	}

	String usercheck = verifyLoginDomain.getUserCheck(request, response, names[0], names[1], logintype, loginfile, message, languid, ismutilangua);
	out.println("usercheck = " + usercheck);
	if(usercheck.equals("15") || usercheck.equals("16")|| usercheck.equals("57") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("52")|| usercheck.equals("55") || usercheck.equals("60") || usercheck.equals("61")){
		String tmploginid = (String)session.getAttribute("tmploginid");
		if(tmploginid!=null&&names[0].equals(tmploginid)){
			session.setAttribute("tmploginid1",names[0]);
		}else{
			session.removeAttribute("tmploginid");
		}

		response.sendRedirect(loginfile + "&message="+usercheck+"&formmethod=get");
		return;
	}else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp");
		return;
	} else if (usercheck.equals("26")) {
	   response.sendRedirect("/login/Login.jsp?logintype=1&formmethod=get&message="+usercheck);
	   return;
	}else {
            User user = HrmUserVarify.getUser (request , response) ;
            if(user == null) { response.sendRedirect(loginfile ) ; return;}

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

            DocCheckInOutUtil.docCheckInWhenVerifyLogin(user,request);

		//小窗口登录 (TD 2227)
		//hubo,050707
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
				String tourl = "";
				ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
				int templateId=ut.getTemplateId();
				int extendTempletid=ut.getExtendtempletid();
				int extendtempletvalueid=ut.getExtendtempletvalueid();
				String defaultHp = ut.getDefaultHp();
				session.setAttribute("defaultHp",defaultHp);
				if(extendTempletid!=0){
					rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
					if(rsExtend.next()){
						int id=Util.getIntValue(rsExtend.getString("id"));
						//String extendname=Util.null2String(rsExtend.getString("extendname"));	
						String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
						rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
						String defaultshow ="";
						if(rs.next()){
							defaultshow = Util.null2String(rs.getString("defaultshow"));
						}
						String param = "";
						if(!defaultshow.equals("")){
							param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
						}
						if(gopage.length()>0){
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param+"&gopage="+gopage;
						}else{			
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
						}
						//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
						response.sendRedirect(tourl) ;
						return;				  
					}
				} else {
					//tourl = RedirectFile;
					tourl = "/login/RemindLogin.jsp?RedirectFile="+RedirectFile;
					response.sendRedirect(tourl) ;
					return;
				}
			}
		}
	}

}catch(Exception e){
	out.println("yanzhongcuowu");
	//e.printStackTrace();
	response.sendRedirect("/login/Login.jsp?logintype=1&message=60&formmethod=get");
	return;
}
%>
