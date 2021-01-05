<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.networkdisk.server.NetWorkDiskFileOperateServer" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser(request,response);
	
	int targetCategoryId = Util.getIntValue(request.getParameter("categoryid"),0);
	String folderids = Util.null2String(request.getParameter("folderid"));
	String fileIds = Util.null2String(request.getParameter("fileid"));
	if(targetCategoryId>0){
		NetWorkDiskFileOperateServer ndfo= new NetWorkDiskFileOperateServer();
		ndfo.saveToNetwork( user, folderIds, fileIds, targetCategoryId)
	}
	
%>