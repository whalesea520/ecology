
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
  String title = "";
  String s = null;
  String gbk = "<meta http-equiv='Content-Type' contect='text/html;charset=UTF-8'>";
  //s = request.getParameter("txt_excel_content");
  try{
  s = Util.null2String(request.getParameter("txt_excel_content"));
  title = java.net.URLEncoder.encode(SystemEnv.getHtmlLabelName(24115,user.getLanguage())+".xls","UTF-8");
  if("".equals(title) || title ==null){
    title = "data";
  }
  //if(s==null){s="null";}
  //s= new String(s.getBytes("ISO-8859-1"),"GBK");
  //System.out.println(s);title
  }catch(Exception e){s=e+"";}
  if(s==null){s="null";}

  //s = s.replaceAll("\\s","");
  //s = s.replaceAll("\n","");
  //System.out.println(s);
  //s=s.replaceAll("border=0","border=1");
  //s=s.replaceAll("BORDER=0","border=1");
  
 //System.out.println(s);
  s=gbk+s;
  
  s = s.replaceAll("","");
  
//response.addHeader("Content-Disposition","attachment;filename=data.xls"); 
response.addHeader("Content-Disposition","attachment;filename="+title);
//response.setContentType("ms-excel/msword");
  response.setContentType("application/vnd.ms-excel;charset=UTF-8");
  response.getOutputStream().write(s.getBytes());
  %>
  
  <%
  response.getOutputStream().close();
  
 
%>
