<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.mobile.plugin.ecology.service.PluginServiceImpl"%>
<%@ page import="weaver.mobile.plugin.ecology.service.AuthService"%>
<%
String loginkey = Util.null2String(request.getParameter("loginkey"));
String gopage = Util.null2String(request.getParameter("gopage"));
User user = (User) request.getSession(true).getAttribute("weaver_user@bean");

try{
	String isIE = "false";
	String useragent = Util.null2String(request.getHeader("User-Agent")).toLowerCase();
	if(useragent.indexOf("msie")>-1 || (useragent.indexOf("gecko")>-1 && useragent.indexOf("rv:11")>-1)) isIE = "true";
	//System.out.println("useragent========="+useragent);
	//System.out.println("isIE========="+isIE);
	request.getSession(true).setAttribute("browser_isie", isIE);
}catch(Exception e){

}

try{
	if(!loginkey.equals("")){
		PluginServiceImpl ps = new PluginServiceImpl();
		if(ps.verify(loginkey)){
			AuthService as = new AuthService();
			User user2 = as.getCurrUser(loginkey);
			if(user==null||(user!=null&&user2!=null&&user.getUID()!=user2.getUID())) {
				user = user2;
				request.getSession(true).setAttribute("weaver_user@bean",user2);
			}
		}
	}
	if(user!=null){
		if(gopage.equals("")){
			user.setLanguage(7);
			Map logmessages=(Map)application.getAttribute("logmessages");
	        if(logmessages==null){
	         	logmessages =  new HashMap();
	         	logmessages.put(""+user.getUID(),"");
	         	application.setAttribute("logmessages",logmessages);
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
					gopage = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
				}
			} 
		}
	}else{
		gopage = "/login/login.jsp?message=19";
	}
}catch(Exception e){
	gopage = "/login/login.jsp?message=19";
}
if(gopage.equals("")){
	gopage = "/wui/main.jsp";
}
%>
<script>
	window.location.href="<%=gopage%>";
</script>