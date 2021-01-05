<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.mobile.webservices.common.ChatResourceShareManager"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%
FileUpload fu = new FileUpload(request);
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int requestid = Util.getIntValue(Util.null2String(fu.getParameter("requestid")));
List<Integer> participantlist = ChatResourceShareManager.getRequestParticipants(user, requestid);
Map<String, List<Integer>> result = new HashMap<String, List<Integer>>();
result.put("participants", participantlist);

JSONObject jo = JSONObject.fromObject(result);
response.getWriter().write(jo.toString());
%>

