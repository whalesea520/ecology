<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%
String[] classnames = request.getParameterValues("classname");
String execStatus = request.getParameter("execStatus");
//System.out.println("classnames:"+classnames.length);
String propfile = GCONST.getRootPath()+"WEB-INF"+File.separator+"prop"+File.separator+"SolveKBQuestion.properties";
OrderProperties prop = new OrderProperties();
prop.load(propfile);
//先删
List<String> keys = prop.getKeys();
Iterator ite = keys.iterator();
ArrayList<String> removelist = new ArrayList<String>();
while(ite.hasNext()) {
	String key = (String)ite.next();
	removelist.add(key);
}
for(int i = 0; i < removelist.size();i++) {
	prop.remove(removelist.get(i));
}

//System.out.println("execStatus:"+execStatus);
if(!"1".equals(execStatus)) {
	execStatus = "0";
}
prop.put("execStatus",execStatus);
for(int i = 0; i < classnames.length;i++) {
	//System.out.println("classnames[i]:"+classnames[i]);
	prop.put("execute_"+i,classnames[i]);
}
prop.store(prop,propfile);
response.sendRedirect("execute.jsp");
%>