
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="weaver.general.Util" %>
<%
String fcolor = Util.null2String(request.getParameter("fcolor"));
fcolor = "".equals(fcolor)?"1":fcolor;
if(isConnect("http://tianqi.2345.com")){
 %>
 <iframe id="weather" allowtransparency="true" frameborder="0" width="300" height="23" scrolling="no" style="float:left;" src="http://tianqi.2345.com/plugin/widget/index.htm?s=3&v=0&f=<%=fcolor %>&b=&k=&t=0&a=1&c=54511&d=1&e=1"></iframe>
 <%}
  %>
<%!
  private boolean isConnect(String url){
      boolean flag = false;
      int counts = 0;
      if(null==url || url.length()<=0){
          return flag;
      }
      while(counts<5){
          try{
              HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
              int state = connection.getResponseCode();
              if(state == 200){
                  flag = true;
              }
              break;
          }catch(Exception e){
              counts++;
              continue;
          }
      }
      return flag;
  }
   
 %>