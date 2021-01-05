<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.io.*,java.sql.*,weaver.general.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String code = Util.null2String(request.getParameter("passwordold"));
String newcode= Util.null2String(request.getParameter("passwordnew")).trim();
char[]  c_code=new char[16];
new FileReader(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"code.key").read(c_code);
String realcode=new String(c_code).trim();
if(!realcode.equals(code)){
 response.sendRedirect("/system/ModifyCode.jsp?message=1");
    return;
} else{
  FileWriter fw=new FileWriter(GCONST.getRootPath()+File.separator+"WEB-INF"+File.separator+"code.key");
  fw.write(newcode);
  fw.close();
  out.print("<script>alert('变更成功!');window.location='/system/ModifyCode.jsp';</script>");
}
%>
