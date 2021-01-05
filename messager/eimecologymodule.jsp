
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String modules = "";
	if(Prop.getPropValue("module","workflow.status").equals("1")){
		modules+="workflow,";
	}
	if(Prop.getPropValue("module","doc.status").equals("1")){
		modules+="doc,";
	}
	if(Prop.getPropValue("module","hrm.status").equals("1")){
		modules+="hrm,";
	}
	if(Prop.getPropValue("module","cwork.status").equals("1")){
		modules+="cwork,";
	}
	if(Prop.getPropValue("module","crm.status").equals("1")){
		modules+="crm,";
	}
	if(Prop.getPropValue("module","proj.status").equals("1")){
		modules+="proj,";
	}
	if(Prop.getPropValue("module","cpt.status").equals("1")){
		modules+="cpt,";
	}
	if(Prop.getPropValue("module","finance.status").equals("1")){
		modules+="finance,";
	}
	if(Prop.getPropValue("module","meeting.status").equals("1")){
		modules+="meeting,";
	}
	if(Prop.getPropValue("module","message.status").equals("1")){
		modules+="message,";
	}
	if(Prop.getPropValue("module","scheme.status").equals("1")){
		modules+="scheme,";
	}
	if(Prop.getPropValue("module","car.status").equals("1")){
		modules+="car,";
	}
	if(Prop.getPropValue("module","photo.status").equals("1")){
		modules+="photo,";
	}
	rs.execute("select id from LeftMenuInfo where id=392");
	if(rs.next())  modules+="blog,";
	out.print(modules);			
%>

	

