<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%><%@ page import="weaver.systeminfo.*" %><%@ page import="weaver.hrm.*" %><%@ page import="java.io.File" %><%
//qc:271653日志监测
User user = HrmUserVarify.getUser (request , response) ;
String module = request.getParameter("module");
if(!HrmUserVarify.checkUserRight("tail:log",user) || 
		(HrmUserVarify.checkUserRight("tail:log",user)  && !"sysadmin".equals(user.getLoginid().toLowerCase())) ||
		("".equals(module) || null == module)
		) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String seldate = request.getParameter("seldate");
String basePath = request.getRealPath("/");//取得当前目录的路径

String path = (basePath+"/log/"+module+ ("".equals(seldate)?"":"_"+seldate+".log")).replace("\\","/").replace("\\\\","/").replace("//","/");

File f = new File(path);
String existStr = "";
if (f.exists())
{
	existStr="exist";
} else
{
	existStr= SystemEnv.getHtmlLabelName(18493,user.getLanguage())+path+SystemEnv.getHtmlLabelName(23084,user.getLanguage()) ;
}
%><%=existStr%>