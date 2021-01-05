<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil" %>
<%@ page import="net.sf.json.JSONArray" %>
<%
	String folderids = request.getHeader("folderids");

	List<Map<String, String>> result = ImageFileUtil.getAllFileByFolder(folderids,true);
	
	JSONArray jo = JSONArray.fromObject(result);
	System.out.println(jo.toString());
	response.setHeader("files", jo.toString());
%>