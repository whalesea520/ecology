
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*"%>
<%@ page import="weaver.file.*"%> 
<%@ page import="java.io.*"%> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.MouldStatusCominfo" %>


<%
if (user.getUID() != 1) {
	response.sendRedirect("/notice/noright.jsp");
	return;
} 

Properties prop = new Properties() ;

for (Enumeration e = request.getParameterNames() ; e.hasMoreElements() ;) {
	 String key=e.nextElement().toString();
	 prop.setProperty(key,request.getParameter(key));
}


File f = new File(GCONST.getPropertyPath() + "module.properties");
FileOutputStream fos=new FileOutputStream(f);
prop.store(fos,"Module Show Setting [Hunk]");
fos.close();

MouldStatusCominfo msc=new MouldStatusCominfo();
msc.remove();

response.sendRedirect("ModuleMaint.jsp");
%>