

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLDecoder"%><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	int id=user.getUID();
	String cityName=request.getParameter("cityName");
	if(cityName==null){
		response.getWriter().print("{\"code\":-1}");
		return;
	}
	cityName=URLDecoder.decode(cityName,"UTF-8");
	String sql="select weatherCity from HrmUserSetting where ResourceId='"+id+"'";
	try{
	rs.execute(sql);
	String sql2="";
	if(rs.getCounts()!=0){
		sql2="update HrmUserSetting set weatherCity='"+cityName+"' where resourceId='"+id+"'";
	}else{
		sql2="insert into HrmUserSetting(resourceId,weatherCity) values('"+id+"','"+cityName+"')";
	}
	rs.execute(sql2);
	}catch(Exception e){
		response.getWriter().print("{\"code\":-1}");
	}
	response.getWriter().print("{\"code\":1}");
%>