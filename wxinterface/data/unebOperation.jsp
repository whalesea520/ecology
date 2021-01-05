<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	JSONObject result = new JSONObject();
	int status = 1;String msg = "";
	try{
		String operation = Util.null2String(request.getParameter("operation"));
		if(operation.equals("uninstall")){
			if(user.getUID()==1){
				rs.executeSql("delete from WX_MsgRuleSetting");
				rs.executeSql("update wx_basesetting set wxsysurl='',accesstoken='',outsysid='',userkeytype='',uuid=''");
				WxInterfaceInit.initData();
				status = 0;
			}else{
				msg = "您没有权限操作";
			}
		}
	}catch(Exception e){
		msg = "执行卸载程序失败:"+e.getMessage();
	}
	result.put("status", status);
	result.put("msg", msg);
	out.println(result.toString());
%>
