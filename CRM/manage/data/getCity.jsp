
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.Writer"%>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page"/>

<%
        String city=Util.null2String(request.getParameter("cityid"));
        String pid=CitytwoComInfo.getCitypid(city);
        String cityname=CityComInfo.getCityname(pid);
		System.out.print(pid+"----"+cityname);
		out.print(pid+"----"+cityname);
		return;
		%>