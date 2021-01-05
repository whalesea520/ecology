<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
<%@page import="weaver.social.*"%>
<%@page import="weaver.social.im.*"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@ page import="weaver.login.VerifyLogin"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.login.Account"%>

<%!
HrmResourceService hrs = new HrmResourceService();
public JSONObject switchAccount(HttpSession session, String currentHost, 
		String fromUserId, String toUserId, String language) throws Exception {
	JSONObject result = new JSONObject();
	
	//重置session
	User newUser = hrs.getUserById(Util.getIntValue(toUserId));
	newUser.setLanguage(Util.getIntValue(language, 7));
	session.setAttribute("weaver_user@bean",newUser);
	String loginId = newUser.getLoginid();
	String loginTime = System.currentTimeMillis()+"";
	String toUserName = newUser.getLastname();
	String toUserHead = SocialUtil.getUserHeadImage(toUserId);
	String toUserDeptName = SocialUtil.getUserDepCompany(toUserId);
	String toJobtitle = SocialUtil.getUserJobTitle(toUserId);
	toJobtitle = toJobtitle.replaceAll("\n","").replaceAll("\r", "");
	String sessionKey = null;
	boolean STATUS = true;
	
	
	
	
	//更新登录状态, 获取sessionKey
	RecordSet rs = new RecordSet();
	rs.execute("select sessionkey from social_IMSessionkey where userid = '"+fromUserId+"'");
	if(rs.next()){
		sessionKey = rs.getString(1);
		rs.execute("update social_IMSessionkey set userid = '"+toUserId+"' where sessionkey = '"+sessionKey+"'");
		rs.execute("delete from social_IMSessionkey where userid = '"+toUserId+"' and sessionkey <> '"+sessionKey+"'");
		// SocialImLogin.recordSocialIMSessionkey(Util.getIntValue(fromUserId), "", SocialImLogin.CLIENT_TYPE_PC);
		SocialImLogin.addSession(toUserId, sessionKey);
		SocialImLogin.removeSession(fromUserId);
	}
	
	//封装userInfo
	JSONObject userInfo = new JSONObject();

	userInfo.put("loginId", loginId);
	userInfo.put("userName", toUserName);
	userInfo.put("sessionKey", sessionKey);
	userInfo.put("language", language);
	userInfo.put("loginTime", loginTime);
	userInfo.put("currentHost", currentHost);
	userInfo.put("jobtitle", toJobtitle);
	userInfo.put("deptName", toUserDeptName);
	userInfo.put("userHead", toUserHead);

	result.put("userInfo", userInfo);
	result.put("STATUS", STATUS);
	
	return result;
}
%>

<%
String fromUserId = Util.null2String(request.getParameter("fromUserId"));
String toUserId = Util.null2String(request.getParameter("toUserId"));
String language = Util.null2String(request.getParameter("language"));
String currentHost = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();

JSONObject result = new JSONObject();
boolean STATUS = true;
String isAccountFail = "0";
String message = "";
boolean isForbitLogin = SocialImLogin.checkForbitLogin(toUserId);
boolean isAllowNewWin = SocialImLogin.checkAllowWindowDepart(toUserId);
int isAllowNewWinNum = (isAllowNewWin==true?1:0);
if(!isForbitLogin){
	message = "当前账号已被禁止登录e-message";
	STATUS = false;
}
if(STATUS){
	STATUS = false;
 	VerifyLogin  login = new VerifyLogin();
	List accounts =(List)login.getAccountsById(Integer.parseInt(fromUserId));
	if(accounts!=null&&accounts.size()>1){
	      Iterator iter=accounts.iterator();
	   		 while(iter.hasNext()){
	  			Account a=(Account)iter.next();
	  			 if((""+a.getId()).equals(toUserId)){		  				
		  			 	STATUS = true;
		  			 	break;
		  			 }
	  			}
	    }
	if(!STATUS){
		message = "您选择的次账号已经失效！";
		isAccountFail = "1";
	}
 }
try{
	if(STATUS){
	result = switchAccount(session, currentHost, fromUserId, toUserId, language);
	STATUS = result.getBoolean("STATUS");}
}catch(Exception e){
	e.printStackTrace();
	try{
		result = switchAccount(session, currentHost, toUserId, fromUserId, language);
	}finally{
		STATUS = false;
	}
}
	result.put("STATUS", STATUS);
	result.put("message", message);
	result.put("isAccountFail", isAccountFail);
	result.put("isAllowNewWin", isAllowNewWin);
	out.print(result.toString());

%>
