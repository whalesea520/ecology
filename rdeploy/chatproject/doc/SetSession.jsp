<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="weaver.general.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String docid = Util.null2String(request.getParameter("docid"));
	String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
	session.setAttribute("right_view_"+sessionPara,"1");
	Map<String,String> result = new HashMap<String,String>();
	result.put("error", "1");
    JSONObject jsonObject = JSONObject.fromObject(result);
    out.println(jsonObject.toString());
%>