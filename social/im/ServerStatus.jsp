<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.resource.ResourceComInfo" %>
<%-- 
     p：
        1、n，客户端正常监测服务器是否正常。
        2、logout,客户端退出。
--%>
<%
    String p = request.getParameter("p");
    String pcReLogin = request.getParameter("pcReLogin");
    // 正常监测状态并更新最后操作时间
    if("n".equals(p)) {
        // System.out.println("更新状态");
        User user = HrmUserVarify.checkUser(request, response);
        if(user != null) {
            //更新PC或WEB端登陆时间
            int loginStatus = "pc".equals(request.getParameter("from")) ? SocialImLogin.CLIENT_TYPE_PC : SocialImLogin.CLIENT_TYPE_WEB;
            // System.out.println("loginStatus = " + loginStatus + "   data = " + new Date().toLocaleString());
            SocialImLogin.updateLoginTime(user.getUID(), loginStatus);
        }
    } 
    // 退出登陆
    else if("logout".equals(p)) {
        User user = HrmUserVarify.checkUser(request, response);
        if(user != null) { 
            String sessionkey = "pc".equals(request.getParameter("from"))?request.getParameter("sessionkey"):request.getParameter("websessionkey");
           // if(SocialImLogin.isExistSeesionKey(sessionkey)==user.getUID()){
                SocialImLogin.pcLogout(sessionkey);
            //}    
        }
    }else if("socketstatus".equals(p)){
        User user = HrmUserVarify.checkUser(request, response);
        if(user != null) { 
            String sessionkey = "pc".equals(request.getParameter("from"))?request.getParameter("sessionkey"):request.getParameter("websessionkey");
            String socketstatus  = request.getParameter("socketstatus");
            //if(SocialImLogin.isExistSeesionKey(sessionkey)==user.getUID()){
                RecordSet recordSet = new RecordSet();
                recordSet.execute("update social_IMSessionkey set socketstatus ="+socketstatus+" where sessionkey ='"+sessionkey+"'");
            //}    
        }
    } 
    // 获得当前服务端版本
    else if("getVersion".equals(p)) {
        JSONObject jObject = JSONObject.fromObject(SocialImLogin.getBuildVersion());
        out.write(jObject.toString());
    }
    
    // web开启聊天时变更登录状态
    else if ("webLogin".equals(p)) {
        User user = HrmUserVarify.checkUser(request, response);
        if (user != null) {
            String websessionkey = request.getParameter("websessionkey");
            SocialImLogin.recordSocialIMSessionkey(user.getUID(), websessionkey, SocialImLogin.CLIENT_TYPE_WEB);
        }
    }
    // 获取系统支持的语言
    else if("getLanguage".equals(p)){
    	RecordSet recordSet = new RecordSet();
    	recordSet.execute("select language, id from syslanguage where activable = 1");
    	JSONArray lanAry = new JSONArray();
    	JSONObject lanObj = null;
    	while(recordSet.next()){
    		lanObj = new JSONObject();
    		lanObj.put("value",recordSet.getString("id"));
    		lanObj.put("text",recordSet.getString("language"));
    		lanAry.add(lanObj);
    	}
    	out.write(lanAry.toString());
    }else if(pcReLogin!=null&&pcReLogin.equals("true")){
        int userId = Integer.parseInt(request.getParameter("userid"));
        String sessionkey = request.getParameter("sessionkey");	
        SocialImLogin.updateSessionKeyByUserid(userId, sessionkey);
    }else if("CheckpcOnline".equals(p)){
    	User user = HrmUserVarify.checkUser(request, response);
    	String userid = user.getUID()+"";
		ResourceComInfo rci = new ResourceComInfo();
		String username = rci.getLastname(userid);
		String messageUrl = rci.getMessagerUrls(userid);
    	boolean isonline = SocialImLogin.CheckpcOnline(userid, username, messageUrl);
    	out.write(isonline?"1":"0");
    }
%>
