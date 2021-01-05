<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="org.apache.axis.encoding.Base64" %>
<%@ page import="weaver.docs.networkdisk.server.SyncFileServer" %>
<%@ page import="weaver.docs.networkdisk.server.impl.SyncFileServerImpl" %>
<%

	String folderid = request.getHeader("folderid");
	String filepath = request.getHeader("filepath");
	byte[] decoded_filepath = Base64.decode(filepath);
	filepath = new String(decoded_filepath, "utf8");
	String rootPath = request.getHeader("rootPath");
	byte[] decoded_rootPath = Base64.decode(rootPath);
	rootPath = new String(decoded_rootPath, "utf8");
	
	
	SyncFileServer SyncFileServer = new SyncFileServerImpl();
	
	List<Map<String, String>> result = new ArrayList<Map<String, String>>();
	
	
	
	JSONArray jo = JSONArray.fromObject(result);
	System.out.println(jo.toString());
	response.setHeader("checkresult", jo.toString());
%>