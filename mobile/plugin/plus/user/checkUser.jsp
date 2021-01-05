<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>

<%
int status = 1;String msg = "";
JSONObject json = new JSONObject();
request.setCharacterEncoding("UTF-8");
try{
	int userid = user.getUID();
	String loginid = user.getLoginid();
	String lastname = user.getLastname();
	
	
	json.put("userid",userid);
	json.put("loginid",loginid);
	json.put("lastname",lastname);
	String ips = "";
	List<String> list = WxInterfaceInit.getRealIp();
	for(String ip:list){
		ips+=","+ip;
	}
	if(!ips.equals("")){
		ips = ips.substring(1);
	}
	json.put("ips",ips);
	status = 0;
}catch(Exception e){
	msg = "获取用户信息失败:"+e.getMessage();
}
json.put("status",status);
json.put("msg",msg);
//System.out.println(json.toString());
out.println(json.toString());
%>