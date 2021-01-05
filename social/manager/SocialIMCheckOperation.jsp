<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.mobile.rong.*"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<jsp:useBean id="SocialIMCheckService" class="weaver.social.service.SocialIMCheckService" scope="page" /> 
<%
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ;
    String userid =""+user.getUID();
    FileUpload fu = new FileUpload(request);
    String operation=Util.null2String(fu.getParameter("operation"));
    
    if(operation.equals("checkPort")){
        Socket client = null;
        String hostname = Util.null2String(fu.getParameter("hostname"));
        String port = Util.null2String(fu.getParameter("port"));
        int flag = 0;
        try{
          client = new Socket();
          client.connect(new InetSocketAddress(hostname, Integer.valueOf(port)), 5000);
          client.close();
          flag = 1;
        }catch(Exception e){
          e.printStackTrace();
          flag = 0;
        }
        out.print(flag);
    }else if(operation.equals("checkToken")) {
        String username = "" + user.getLastname();
        String messageUrl = SocialUtil.getUserHeadImage(userid);
        String host = Util.null2String(request.getParameter("host"),"");
        boolean reFreshToken = Util.null2String(request.getParameter("reFreshToken")).equals("1")?true:false;
        String udid = RongService.getRongConfig().getAppUDIDNew().toLowerCase();
        String token = "";
        if(host==""||host.equals("")){
            token = SocialOpenfireUtil.getInstanse().getToken(userid + "|" + udid, username, messageUrl,reFreshToken);
        }else{
            token = SocialIMCheckService.getToken(userid + "|" + udid, username, messageUrl,reFreshToken,host);
        }
        out.print(token);
    }else if(operation.equals("checkMobileRong")){
        JSONObject json = new JSONObject();
        String file=GCONST.getRootPath()+"WEB-INF" + File.separator + "prop" + File.separator + "EMobileRong.properties";
        try{
            File emPropFile = new File(file);
            if(emPropFile.exists()){
                OrderProperties emProp = new OrderProperties();
                if(emPropFile.exists()){
                    emProp.load(file);
                    List<String> it=emProp.getKeys();
                    for(String key  : it){
                        String value = Util.null2String(emProp.get(key));
                        json.put(key,value);
                    }
                }
                json.put("isExist", "true");
            }else{
                json.put("isExist", "false");
            }
        }catch(Exception e){}
        out.print(json);
    }else if(operation.equals("checkFilter")){
        boolean isSuccess = SocialIMCheckService.checkFilter();
        out.print(isSuccess?1:0);
    }else if(operation.equals("isServletFilterConfigured")){
        boolean isServletFilterConfigured = SocialIMCheckService.isFilterConfigured("SocialIMServlet");
        out.print(isServletFilterConfigured);
    }else if(operation.equals("isBaseFilterConfigured")){
        boolean isBaseFilterConfigured = SocialIMCheckService.isFilterConfigured("SocialIMFilter");
        out.print(isBaseFilterConfigured);
    }else if(operation.equals("isLoginCheckOpen")){
        boolean isLoginCheckOpen = SocialIMCheckService.isLoginCheckOpen();
        out.print(isLoginCheckOpen);
    }else if(operation.equals("checkALLFilter")){
        JSONObject result = SocialIMCheckService.checkALLFilter();
        out.print(result);
    }
%>
