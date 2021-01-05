<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.hrm.*" %>


<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
		
	int secCategoryId = Util.getIntValue(request.getParameter("secCategoryId"));
	String sql = "select id,categoryname,maxUploadFileSize from DocSecCategory where id = "+secCategoryId;
	JSONObject obj = new JSONObject();
	    rs.executeSql(sql);
	    if (rs.next()) {
	        obj.put("maxUploadFileSize",rs.getString("maxUploadFileSize"));
	    }			  
	out.println(obj.toString());
	
%>





