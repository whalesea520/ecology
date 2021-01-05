<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<%
String action = request.getParameter("action");
String fileid = request.getParameter("fileid");
if("down".equals(action)){
    String isOnline = request.getParameter("isOnline");
    fileHandle.downLoad(fileid, response, isOnline);
}else if("def".equals(action)){
    out.print(fileHandle.deleteFile(fileid));
}else {
    fileHandle.downLoad(fileid, response, "1");
}


%>

