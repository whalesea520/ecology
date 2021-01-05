<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <%
 	  String filefullpath = Util.null2String(request.getParameter("file"));
      response.setContentType("application/x-download");//设置为下载application/x-download
      String filedownload = filefullpath;//即将下载的文件的相对路径
      if(filefullpath.indexOf("/")>-1){
      	filefullpath = filefullpath.substring(filefullpath.lastIndexOf("/"));
      }
      String filedisplay = filefullpath;//下载文件时显示的文件保存名称
      filedisplay = URLEncoder.encode(filedisplay,"UTF-8");
      response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
    
      try
      {
          RequestDispatcher dis = request.getRequestDispatcher(filedownload);
          if(dis!= null)
          {
              dis.forward(request,response);
          }
          response.flushBuffer();
      }
      catch(Exception e)
      {
          e.printStackTrace();
      }
      finally
      {
    
      }
%>