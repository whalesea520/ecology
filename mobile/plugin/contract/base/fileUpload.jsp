<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<%
        JSONArray array = fileHandle.uploadFile(request);
        String flag = fileService.save(array,"comment");
        if("1".equals(flag)){
           out.print(fileHandle.getFileName(array));
        }
%>

