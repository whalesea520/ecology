<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%> 
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@page import="weaver.mobile.rong.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="java.net.*"%>
<%@page import="weaver.social.SocialUtil"%>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="SocialManageService" class="weaver.social.manager.SocialManageService" scope="page" />	
<%
User user = HrmUserVarify.getUser (request , response) ;
FileUpload fu = new FileUpload(request,"utf-8");
if(user == null){
	return;
}
String method = Util.null2String(fu.getParameter("method"));
RecordSetTrans.setAutoCommit(false);
if(method.equals("savefieldbatch0")){   //批量保存 顶部快捷按钮
	boolean isSuccess = SocialManageService.savefieldbatch(fu, 0);
	out.print(isSuccess?1:0);
	response.sendRedirect("/social/manager/SocialTopButtonsInner.jsp");
	return;
}else if(method.equals("savefieldbatch1")){   //批量保存 自定义应用管理
	boolean isSuccess = SocialManageService.savefieldbatch(fu, 1);
	out.print(isSuccess?1:0);
	response.sendRedirect("/social/manager/SocialCustomAppsInner.jsp");
	return;
}else if(method.equals("basesetting")){   //保存客户端功能设置/应用设置
	String fromtype = Util.null2String(fu.getParameter("fromtype"));
	boolean isSuccess = SocialManageService.saveClientSettings(fu, Util.getIntValue(fromtype));
	out.print(isSuccess?1:0);
	if(fromtype.equals("0")){
		response.sendRedirect("/social/manager/SocialClientFunctionCommon.jsp");
	}else if(fromtype.equals("1")){
		response.sendRedirect("/social/manager/SocialAppSettingCommon.jsp");
	}
	
	return;
}else if(method.equals("transferGroupsData")){   //迁移公有云数据到私有云上
	JSONObject result = SocialManageService.transferGroupInfo();
	out.print(result);
}else if(method.equals("transferGroups")){   //迁移群组信息
	JSONArray result = SocialManageService.transferHistoryGroupInfo();
	out.print(result);
}else if(method.equals("writeTransStatus")){   //回写处理状态迁移群组的状态
	String successRooms = Util.null2String(fu.getParameter("successRoomNames"));
	//System.err.print("successRooms:"+successRooms);
	boolean isSuccess = SocialManageService.writeTransStatus(successRooms);
	out.print(isSuccess?1:0);
}else if(method.equals("checkPort")){//检查端口
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
}else if(method.equals("checkFilter")){//检查过滤器是否配置
    boolean isSuccess = SocialManageService.checkFilter();
    out.print(isSuccess?1:0);
}else if(method.equals("checkToken")){//检查token获取是否成功
    String username = "" + user.getLastname();
    String userid = user.getUID()+"";
    String messageUrl = SocialUtil.getUserHeadImage(userid);
    String host = Util.null2String(request.getParameter("host"));
    boolean reFreshToken = Util.null2String(request.getParameter("reFreshToken")).equals("1")?true:false;
    String udid = RongService.getRongConfig().getAppUDIDNew().toLowerCase();
    String token = SocialOpenfireUtil.getInstanse().getToken(userid + "|" + udid, username, messageUrl,reFreshToken,host);
    out.print(token);
}else if(method.equals("isBaseFilterConfigured")){
    boolean isBaseFilterConfigured = SocialUtil.isFilterConfigured("SocialIMFilter");
    out.print(isBaseFilterConfigured);
}else if(method.equals("isServletFilterConfigured")){
    boolean isServletFilterConfigured = SocialUtil.isFilterConfigured("SocialIMServlet");
    out.print(isServletFilterConfigured);
}else if(method.equals("isLoginCheckOpen")){
    boolean isLoginCheckOpen = SocialUtil.isLoginCheckOpen();
    out.print(isLoginCheckOpen);
}else if(method.equals("getMobileRong")){
    JSONObject result = SocialManageService.checkMobileRong();
    out.print(result);
}
%>
