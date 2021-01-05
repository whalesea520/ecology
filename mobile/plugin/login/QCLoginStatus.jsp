
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.template.UserTemplate"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.util.List"%>



<jsp:useBean id="qrCode" class="weaver.mobile.plugin.ecology.QRCodeComInfo" scope="page"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String loginkey = request.getParameter("loginkey");

if (loginkey != null && !"".equals(loginkey)) {
	
	Object obj =  new weaver.login.VerifyLogin4QCode().getUserCheck(application,request,response);

	
	if(obj == null){	//兼容微信端老版本扫码
		obj = application.getAttribute(loginkey);
	}
	if (obj != null) {
		User user = (User)obj;
		
		String langid = Util.null2String(request.getParameter("langid"));
		if(!langid.equals("")&&!langid.equals("undefined")){
			user.setLanguage(Util.getIntValue(langid,7));
		}
		
		UserTemplate  ut=new UserTemplate();
		
		ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
		int templateId=ut.getTemplateId();
		int extendTempletid=ut.getExtendtempletid();
		int extendtempletvalueid=ut.getExtendtempletvalueid();
		String defaultHp = ut.getDefaultHp();
		session.setAttribute("defaultHp",defaultHp);
		RecordSet rsExtend = new RecordSet();
		RecordSet rs = new RecordSet();
		String tourl = "";
		String RedirectFile="/wui/main.jsp"; 
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
				
				tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param+"&loginid="+user.getLoginid();
				//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
				//response.sendRedirect(extendurl+"/index.jsp?templateId="+templateId+param) ;
				//return;		
			}
		}else {
			tourl = "/login/RemindLogin.jsp?RedirectFile="+RedirectFile;
		} 
		
		response.getWriter().write(tourl);
	} else {
		String logout = (String)application.getAttribute(loginkey + ":logout");
		if (logout != null && !"".equals(logout)) {
			request.getSession(true).removeAttribute("weaver_user@bean");
			application.removeAttribute(loginkey + ":logout");
			logout = "9";
		} else {
			logout = "0";
		}
		response.getWriter().write(logout+"");
	}
	
	//登录成功后，只登录一次
	application.removeAttribute(loginkey);
} else {
	response.getWriter().write("0");	
}
%>
