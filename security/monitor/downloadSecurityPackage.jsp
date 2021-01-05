<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="java.util.*,net.sf.json.JSONObject,weaver.hrm.*,weaver.security.classLoader.*" %><jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean><%
User user = HrmUserVarify.getUser (request , response) ;
JSONObject json = new JSONObject();
if(user==null){
	json.put("result", "false");
	json.put("msg","无权限下载，下载失败。");
	out.println(json.toString());
	return;
}



int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);

if (user.getUID() != UID){
	json.put("result", "false");
	json.put("msg","无权限下载，下载失败。");
	out.println(json.toString());
	return;
}
xssUtil.getRule().remove("csui_isChecked");
ReflectMethodCall rmc = new ReflectMethodCall();
Boolean result = (Boolean)rmc.call(
				"weaver.security.msg.CheckSecurityUpdateInfoUtil",
				"checkUpdate",
				new Class[]{boolean.class}, true);
if(result!=null && result){
	json.put("result","true");
}else{
	json.put("result", "false");
}
out.println(json.toString());

%>