<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%

    try{

        String filename = Util.null2String(request.getParameter("filename"));
%>