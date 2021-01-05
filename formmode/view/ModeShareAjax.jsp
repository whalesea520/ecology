<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.net.*" %>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}

String method = Util.null2String(request.getParameter("method"));
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);//数据id

if(method.equals("checkRoleCondition")){//检测前台添加角色限制时，是否有人员满足条件
	String roleid =  Util.null2String(request.getParameter("role"));
	String rolefieldtype =  Util.null2String(request.getParameter("rolefieldtype"));
	String rolefield =  Util.null2String(request.getParameter("rolefield"));
	String rolelevel =  Util.null2String(request.getParameter("rolelevel"));
	String showlevel =  Util.null2String(request.getParameter("showlevel"));
	String showlevel2 =  Util.null2String(request.getParameter("showlevel2"));
	Map map = new HashMap();
	map.put("roleid",roleid);
	map.put("rolefieldtype",rolefieldtype);
	map.put("rolefield",rolefield);
	map.put("rolelevel",rolelevel);
	map.put("showlevel",showlevel);
	map.put("showlevel2",showlevel2);
	boolean flag = ModeRightInfo.checkRoleCondition(modeId,billid,map);
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("canadd",flag);
	response.getWriter().write(jsonObject.toString());
	return;
	
}
%>