<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.Hashtable"%>
<%@page import="weaver.formmode.field.FileElement"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.checkUser(request,response);
if(user == null){
	return;
}
String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
int billid = Util.getIntValue(Util.null2String(request.getParameter("billid")),0);
int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
int derecorderindex = Util.getIntValue(Util.null2String(request.getParameter("derecorderindex")),0);
int ismand = Util.getIntValue(Util.null2String(request.getParameter("ismand")),0);
int type = Util.getIntValue(Util.null2String(request.getParameter("type")),0);
int linknum = Util.getIntValue(Util.null2String(request.getParameter("linknum")),0);
String sql = "";
if(!fieldvalue.equals("")){
	String inputStr = "";
	FileElement fileElement = new FileElement();
    Hashtable ret_hs = fileElement.getHtmlElementNewString(modeid,billid,fieldid,derecorderindex,ismand,type,fieldvalue,user,linknum);
    inputStr = Util.null2String(ret_hs.get("inputStr"));  
    out.print(inputStr);
}
		
%>