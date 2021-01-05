<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%
if(isConnect("http://tianqi.2345.com")){
 %>
 
<iframe allowtransparency="true" frameborder="0" width="575" height="96" scrolling="no" src="http://tianqi.2345.com/plugin/widget/index.htm?s=2&z=3&t=0&v=0&d=5&bd=0&k=&f=000000&q=1&e=0&a=1&c=58362&w=575&h=96&align=center"></iframe>
 <%}else{
%>
<script type="text/javascript">
	if(window.name&&window.name!=''){
		alert(window.name);
   		parent.document.getElementsByName(window.name)[0].height=0;
   	}
</script>
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