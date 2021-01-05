<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="java.io.File"%>
<%@page import="weaver.general.GCONST"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String tmpfile = GCONST.getRootPath()+"matrixmanage"+File.separator+"pages"+File.separator+"tmpfile";
	File f = new  File(tmpfile);
	File[] files = f.listFiles();
	for(int i = 0; i < files.length;i++){
		File file = files[i];
		if(file.renameTo(file)){
			file.delete();
		}	
	}
	out.print(files.length);
%>