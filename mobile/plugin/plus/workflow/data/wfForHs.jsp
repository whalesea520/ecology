<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.interfaces.workflow.action.RefreshOATodoList"%>
<jsp:useBean id="HuiSengSSOInterface" class="weaver.interfaces.HuiSengSSOInterface" scope="page"/>
<%
String operation = Util.null2String(request.getParameter("operation"));
int status = 1;String msg = "";
JSONObject result = new JSONObject();
if("refeshWFForHS".equals(operation)){
	try{
		RefreshOATodoList rotl = new RefreshOATodoList();
		rotl.refresh(user.getLoginid()) ;
		status = 0;
	}catch(Exception e){
		msg = "刷新代码异常:"+e.getMessage();
	}
}else if("getLoginCode".equals(operation)){
	try{
		String url="http://pm.wison.com/portal/WebService/AuthenticationWebService.asmx";
		String urlhrm="http://hrms.wison.com/WebService.asmx";
	
		//String loginCode = HuiSengSSOInterface.getlogincode(url,user.getLoginid());
		String loginCode = HuiSengSSOInterface.getlogincode(url,"xuren");
		//String hrmsSessionID = HuiSengSSOInterface.gethrmsession(urlhrm,user.getLoginid());
		result.put("loginid", user.getLoginid());
		result.put("loginCode", loginCode);
		//result.put("hrmsSessionID", hrmsSessionID);
		status = 0;
	}catch(Exception e){
		msg = "单点登录获取用户信息失败:"+e.getMessage();
	}
}
result.put("status", status);
result.put("msg", msg);
out.print(result.toString());
%>