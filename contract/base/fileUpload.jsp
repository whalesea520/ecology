<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<%
        JSONArray arr = fileHandle.uploadFile(request).getJSONArray("fileItem");
        String fileId = fileService.save(arr,"comment",null,0);
        out.print(fileId);
%>

