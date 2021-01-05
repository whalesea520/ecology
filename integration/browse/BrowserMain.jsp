<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date"%>
<%@page import="weaver.general.TimeUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>


<%
String url = Util.null2String(request.getParameter("url"));
%>
      <% 
          Enumeration enu=request.getParameterNames(); 
          while(enu.hasMoreElements()) { 
              String name=(String)enu.nextElement(); 
              if(!name.startsWith("**")&&!"url".equals(name)) { 
              		//如果不是数组参数，直接打印 
    			url+="&"+name+"="+request.getParameter(name);
              } 
          } 
          url+="&time="+TimeUtil.getTimeString(new Date());
            //http://back-888888.iteye.com/blog/988916
            new BaseBean().writeLog("url"+url);
      %> 
    
 <html> 
 <frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize >
  <frame name="main" id="main" marginwidth="0" marginheight="0" scrolling="auto" src="<%=url%>">
  <noframes>
  <body>
  <p>此网页使用了框架，但您的浏览器不支持框架。</p>

  </body>
  </noframes>
</frameset> 


</html>

