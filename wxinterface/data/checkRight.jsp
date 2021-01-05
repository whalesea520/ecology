<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="org.json.JSONObject"%>
<%
User user = HrmUserVarify.getUser(request, response);
JSONObject result = new JSONObject();
request.setCharacterEncoding("UTF-8");
int status = 1;String msg = "";
if (user == null) {
	msg = "登录信息已过期,请重新登录";
}else{
	if(user.getUID()==1||HrmUserVarify.checkUserRight("WX_SENDMSG_HJT_RIGHT", user)){
		status = 0;
	}else{
		msg = "请确认您是否具备发送权限，建议关闭页面重试。";
	}
}
result.put("status", status);
result.put("msg", msg);
out.println(result.toString());
%>