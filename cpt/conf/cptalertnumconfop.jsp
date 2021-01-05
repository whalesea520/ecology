<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
if(!HrmUserVarify.checkUserRight("CptCapital:modify", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
JSONObject obj=new JSONObject();
String method = Util.null2String (request.getParameter("method"));

if("dosave".equalsIgnoreCase(method)){
	String cptalertinfo=Util.null2String (request.getParameter("cptalertinfo"));
	JSONArray arr= JSONArray.fromObject(cptalertinfo);
	if(arr!=null&&arr.size()>0){
		for(int i=0;i<arr.size();i++){
			JSONObject jsonObject=(JSONObject)arr.get(i);
			String sql="update cptcapital set alertnum="+Util.getDoubleValue(jsonObject.getString("alertnum"),0.0 )+" where id="+Util.getIntValue( jsonObject.getString("cptid"),0);
			rs.executeSql(sql);
		}
	}
}else if("alertnumbatchset".equalsIgnoreCase(method)){
	double alertnum=Util.getDoubleValue(request.getParameter("alertnum"),0.0);
	String ids=Util.null2String (request.getParameter("ids"));
	if(!"".equals( ids)){
		if(ids.startsWith(",")){
			ids=ids.substring(1);
		}
		if(ids.endsWith(",")){
			ids=ids.substring(0,ids.length()-1);
		}
		String sql="update cptcapital set alertnum="+alertnum+" where id in ("+ids+") ";
		rs.executeSql(sql);
	}
}


out.println(obj.toString());
%>