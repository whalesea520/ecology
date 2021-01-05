<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.net.*,weaver.file.Prop" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.social.im.SocialImLogin" %>
<%@ page import="weaver.mobile.plugin.ecology.service.HrmResourceService" %>
<%
    //System.out.println("request.getHeader(user-agent) = " + request.getHeader("user-agent"));
    String agent = Util.null2String(request.getHeader("user-agent"));
    session.setAttribute("browser_isie","false");
    request.getSession(true).setAttribute("weaver_login_type", "emessage");
    String browserName = "";
	int browserVersion = 0;
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	BaseBean log = new BaseBean();
	Cookie[] cookies = request.getCookies();
	String loginId = null;
	if(cookies!=null){
		for(Cookie c : cookies){
			if(c.getName().equals("loginidweaver")){
				loginId = c.getValue();
				break;
			}
		}
	}
	if( user == null ){
		log.writeLog("epcforword log：user is null: " +loginId);
		// 修复user为空的问题，导致跳转到登录页
		HrmResourceService hrs = new HrmResourceService();  
		int userId = -1;
		String _sessionkey = request.getParameter("sessionkey");
		log.writeLog("epcforword _sessionkey="+_sessionkey);
		userId = SocialImLogin.isExistSeesionKey(_sessionkey);
		if(userId != -1) {
			user = hrs.getUserById(userId);
			request.getSession(true).setAttribute("weaver_user@bean", user);
		}
	}else{
		log.writeLog("epcforword log：loginidweaver: "+loginId+" addr:"+request.getLocalAddr()+"   userid: "+user.getUID());
	}
	//	集成添加 password 属性
    String pwd = (String)request.getSession(true).getAttribute("password");
	if(pwd ==null || pwd.isEmpty()){
		Object pwdObject = StaticObj.getInstance().getObject("socialUserpwdCache");
		if(pwdObject !=null){
			HashMap<Integer,String>  socialUserpwdCache = (HashMap<Integer,String>)pwdObject;
            request.getSession(true).setAttribute("password",socialUserpwdCache.get(user.getUID()));
		}
	}
    if(agent.indexOf("MSIE")!=-1){
    	session.setAttribute("browser_isie","true");
    	browserName = "IE";
    	StringTokenizer st = new StringTokenizer(agent,";"); 
    	try{
    		st.nextToken();
    		//得到用户的浏览器名 
    		String userbrowser = st.nextToken();
    		String versinString = userbrowser.substring(userbrowser.indexOf("MSIE")+4,userbrowser.indexOf(".")).trim();
    		//System.out.println("~~~~~~~~~~~~"+versinString);
    		browserVersion = Integer.parseInt(versinString);
    	}catch(Exception e){
    		//session.setAttribute("browser_isie","false");
    	}
    }else if(agent.indexOf("Firefox")!=-1){
    	String[] temp = agent.split(" ");
    	browserName = "FF";
    	for(int i=0;i<temp.length;i++){
    		String userbrowser = temp[i];
    		if(userbrowser.indexOf("Firefox")!=-1){
    			String versinString = userbrowser.substring(userbrowser.indexOf("Firefox/")+8,userbrowser.indexOf(".")).trim();
    			//System.out.println("~~~~~~~~~~~~"+versinString);
    			browserVersion = Integer.parseInt(versinString);
    		}
    	}
    }else if(agent.indexOf("Chrome")!=-1){
    	String[] temp = agent.split(" ");
    	browserName = "Chrome";
    	for(int i=0;i<temp.length;i++){
    		String userbrowser = temp[i];
    		if(userbrowser.indexOf("Chrome")!=-1){
    			String versinString = userbrowser.substring(userbrowser.indexOf("Chrome/")+7,userbrowser.indexOf(".")).trim();
    			//System.out.println("~~~~~~~~~~~~"+versinString);
    			browserVersion = Integer.parseInt(versinString);
    		}
    	}
    }else if(agent.indexOf("Safari")!=-1){
    	String[] temp = agent.split(" ");
    	browserName = "Safari";
    	for(int i=0;i<temp.length;i++){
    		String userbrowser = temp[i];
    		if(userbrowser.indexOf("Version")!=-1){
    			String versinString = userbrowser.substring(userbrowser.indexOf("Version/")+8,userbrowser.indexOf(".")).trim();
    			//System.out.println("~~~~~~~~~~~~"+versinString);
    			browserVersion = Integer.parseInt(versinString);
    		}
    	}
    }
    String isIE = (String)session.getAttribute("browser_isie");
    if(!"true".equals(isIE)){
    	if (agent != null && agent.indexOf("rv:11") != -1) {
    	    isIE = "true";
    	    browserVersion = 11;
    	    browserName = "IE";
    	    session.setAttribute("browser_isie", "true");
    	}
    }
    boolean IsUseIE6 = Prop.getPropValue("sdlsyh","IsUseIE6").equalsIgnoreCase("1");
    if(IsUseIE6){
    	if((browserName == "IE"&&browserVersion<6)||(browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5)){
    	    response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+browserVersion);
    		return;
     	}
    }else{
    	if((browserName == "IE"&&browserVersion<7)||(browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5)){
    		 response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+browserVersion);
    		 return;
    	 }
    }
    
    //System.out.println("isIE = " + isIE);
    //String url = URLDecoder.decode(Util.null2String(request.getParameter("url")), "UTF-8");
    //System.out.println("url===== = " + Util.null2String(request.getParameter("url")));
	//weaver.hrm.HrmUserVarify.invalidateCookie(request,response);
	try{
    		response.addHeader("Set-Cookie","xzutyzw="+Util.getCookie(request,"xzutyzw")+";expires=Thu, 01-Dec-1994 16:00:00 GMT;Path=/;HttpOnly");
    		response.addHeader("Set-Cookie","rutixcd="+Util.getCookie(request,"rutixcd")+";expires=Thu, 01-Dec-1994 16:00:00 GMT;Path=/;HttpOnly");
    	}catch(Exception e){
			new weaver.general.BaseBean().writeLog(e);
		}
    response.sendRedirect(Util.null2String(request.getParameter("url")));
    
%>